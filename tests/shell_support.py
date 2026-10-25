"""Helpers shared by the bash/zsh tests: finding shells, a stub kubectl, a pty driver."""

import os
import pty
import re
import select
import shutil
import signal
import stat
import subprocess
import sys
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
POSIX = ROOT / "posix"
sys.path.insert(0, str(ROOT / "tools"))

import generate_aliases as gen  # noqa: E402

BASH = shutil.which("bash")
ZSH = shutil.which("zsh")
SHELLS = {name: path for name, path in (("bash", BASH), ("zsh", ZSH)) if path}
KUBECTL = os.environ.get("KUBECTL") or shutil.which("kubectl")
BASH_COMPLETION = next(
    (p for p in ("/usr/share/bash-completion/bash_completion",
                 "/etc/bash_completion",
                 "/opt/homebrew/etc/profile.d/bash_completion.sh",
                 "/usr/local/etc/profile.d/bash_completion.sh") if Path(p).exists()),
    None,
)

# What the stub kubectl prints: one "A <argument>" line per argument it receives.
STUB_KUBECTL = '#!/bin/sh\nfor a in "$@"; do printf "A %s\\n" "$a"; done\n'

SAFE_PATH = "/usr/local/bin:/usr/bin:/bin"


def write_executable(path: Path, text: str) -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")
    path.chmod(path.stat().st_mode | stat.S_IXUSR)
    return path


def shell_argv(shell: str, *args: str) -> list[str]:
    """Run a shell without reading the user's startup files."""
    flags = ["--noprofile", "--norc"] if shell == "bash" else ["-f"]
    return [SHELLS[shell], *flags, *args]


def run_shell(shell: str, script: str, *, env: dict | None = None, path_prefix: Path | None = None,
              timeout: int = 120) -> subprocess.CompletedProcess:
    path = SAFE_PATH if path_prefix is None else f"{path_prefix}:{SAFE_PATH}"
    full_env = {"PATH": path, "HOME": "/nonexistent", "LANG": "C.UTF-8", **(env or {})}
    return subprocess.run(shell_argv(shell, "-c", script), capture_output=True, text=True,
                          env=full_env, timeout=timeout, encoding="utf-8")


def manifest_aliases() -> dict[str, tuple[str, ...]]:
    """Every alias the project promises: the frozen 788 plus anything added since."""
    merged = {}
    for name in ("k-aliases.tsv", "k-additions.tsv"):
        for line in (ROOT / "tests" / name).read_text(encoding="utf-8").splitlines():
            if line and not line.startswith("#"):
                alias, _, args = line.partition("\t")
                merged[alias] = tuple(args.split())
    return merged


_ANSI = re.compile(r"\x1b\[[0-9;?]*[ -/]*[@-~]|\x1b[()][A-Z0-9]|\x1b[=>]|\x07")


class InteractiveShell:
    """An interactive shell on a pty, so Tab really goes through readline / zle."""

    def __init__(self, shell: str, env: dict, setup: list[str]):
        argv = shell_argv(shell, "-i")
        self.buffer = b""
        pid, self.fd = pty.fork()
        if pid == 0:  # child
            os.execvpe(argv[0], argv, env)
        self.pid = pid
        self._pump(1.5)
        for line in setup:
            self.send(line + "\n", 1.0)
        self.send("\n", 0.8)  # one prompt, so zsh's precmd hook can register completions

    def _pump(self, quiet: float) -> None:
        end = time.time() + quiet
        while time.time() < end:
            ready, _, _ = select.select([self.fd], [], [], 0.1)
            if ready:
                try:
                    data = os.read(self.fd, 65536)
                except OSError:
                    return
                if not data:
                    return
                self.buffer += data
                end = time.time() + quiet

    def send(self, text: str, quiet: float = 1.0) -> None:
        os.write(self.fd, text.encode())
        self._pump(quiet)

    def complete(self, typed: str) -> list[str]:
        """Type `typed`, press Tab, and return the words of the line the shell ended up with.

        The line is read back by running it as arguments to printf, so it does not depend on
        how readline or zle redraw the screen.
        """
        mark = len(self.buffer)
        self.send(typed, 0.2)
        self.send("\t", 0.8)  # kubectl's completion takes a fraction of a second
        self.send("\x01printf '<<%s>>' ", 0.2)  # Ctrl-A, then a command in front of the line
        self.send("\n", 0.5)
        out = _ANSI.sub("", self.buffer[mark:].decode("utf-8", "replace")).replace("\r", "")
        for line in out.split("\n"):
            if line.startswith("<<"):
                return re.findall(r"<<(.*?)>>", line)
        raise AssertionError(f"no result line in shell output: {out[-300:]!r}")

    def close(self) -> None:
        try:
            os.kill(self.pid, signal.SIGKILL)
            os.waitpid(self.pid, 0)
        except OSError:
            pass
        try:
            os.close(self.fd)
        except OSError:
            pass
