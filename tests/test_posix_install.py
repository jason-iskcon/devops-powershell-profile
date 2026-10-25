"""posix/install.sh: idempotent, reversible, and careful with files that are not ours."""

import os
import re
import shutil
import stat
import subprocess
import tempfile
import unittest
from pathlib import Path

import shell_support as sh

INSTALL = sh.POSIX / "install.sh"
BEGIN = "# >>> devops-k-aliases >>>"
END = "# <<< devops-k-aliases <<<"
# Every interpreter the script may meet: it is plain POSIX sh.
INTERPRETERS = sorted({os.path.realpath(p) for p in map(shutil.which, ("sh", "dash", "bash")) if p})


def block(init: str, prefix_ref: str = "$HOME/.local/share/devops-k-aliases") -> str:
    return (f'{BEGIN}\n'
            '# Managed by posix/install.sh; "install.sh uninstall" removes this block.\n'
            f'[ -r "{prefix_ref}/{init}" ] && . "{prefix_ref}/{init}"\n'
            f'{END}\n')


class InstallerCase(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.home = Path(self.tmp.name) / "home"
        self.home.mkdir()
        self.bashrc = self.home / ".bashrc"
        self.zshrc = self.home / ".zshrc"
        self.prefix = self.home / ".local/share/devops-k-aliases"
        self.bin = Path(self.tmp.name) / "bin"
        sh.write_executable(self.bin / "kubectl", sh.STUB_KUBECTL)

    def run_installer(self, *args: str, interpreter: str = "sh", env: dict | None = None,
                      script: Path = INSTALL) -> subprocess.CompletedProcess:
        full_env = {"HOME": str(self.home), "PATH": f"{self.bin}:{sh.SAFE_PATH}", "SHELL": "/bin/bash",
                    "LANG": "C.UTF-8", **(env or {})}
        return subprocess.run([shutil.which(interpreter) or interpreter, str(script), *args],
                              capture_output=True, text=True, env=full_env, timeout=60, encoding="utf-8")

    def ok(self, *args, **kwargs) -> subprocess.CompletedProcess:
        result = self.run_installer(*args, **kwargs)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def backups(self, rc: Path) -> list[Path]:
        return sorted(rc.parent.glob(rc.name + ".k-aliases-backup-*"))

    def snapshot(self) -> dict[str, bytes]:
        """Every file under the home directory, for 'nothing changed' assertions."""
        return {str(p.relative_to(self.home)): p.read_bytes()
                for p in sorted(self.home.rglob("*")) if p.is_file() and not p.is_symlink()}


class InstallAndUninstall(InstallerCase):
    def test_install_appends_one_block_and_copies_the_files(self):
        self.bashrc.write_text("export FOO=1\n")
        self.ok("--shell", "bash")
        self.assertEqual(self.bashrc.read_text(), "export FOO=1\n\n" + block("k-init.bash"))
        for name in ("k-aliases.sh", "k-completion-data.sh", "k-completion.bash",
                     "k-completion.zsh", "k-init.bash", "k-init.zsh"):
            self.assertEqual((self.prefix / name).read_bytes(), (sh.POSIX / name).read_bytes())
        self.assertFalse(self.zshrc.exists(), "only the chosen shell's rc file is touched")

    def test_installing_twice_changes_nothing_the_second_time(self):
        self.bashrc.write_text("export FOO=1\n")
        self.zshrc.write_text("alias ll=ls\n")
        self.ok("--shell", "both")
        before = self.snapshot()
        second = self.ok("--shell", "both")
        self.assertEqual(self.snapshot(), before)
        self.assertIn("unchanged:", second.stdout)
        self.assertNotIn("backup:", second.stdout)
        self.assertEqual(len(self.backups(self.bashrc)), 1)

    def test_uninstall_restores_the_rc_files_exactly_under_every_interpreter(self):
        for interpreter in INTERPRETERS:
            with self.subTest(interpreter=interpreter):
                self.bashrc.write_text("# top\nexport FOO=1\n\nalias a=b\n")
                self.zshrc.write_text("alias ll=ls\n")
                original = self.snapshot()
                self.ok("install", "--shell", "both", interpreter=interpreter)
                self.assertIn(BEGIN, self.bashrc.read_text())
                self.ok("uninstall", interpreter=interpreter)
                self.assertEqual(self.bashrc.read_text(), "# top\nexport FOO=1\n\nalias a=b\n")
                self.assertEqual(self.zshrc.read_text(), "alias ll=ls\n")
                self.assertFalse(self.prefix.exists())
                shutil.rmtree(self.home / ".local", ignore_errors=True)
                for backup in self.home.glob("*.k-aliases-backup-*"):
                    backup.unlink()
                self.assertEqual(self.snapshot(), original)

    def test_the_original_file_is_kept_in_a_backup_even_after_uninstall(self):
        self.bashrc.write_text("ORIGINAL\n")
        self.ok("--shell", "bash")
        self.ok("uninstall", "--shell", "bash")  # may happen within the same second
        contents = [b.read_text() for b in self.backups(self.bashrc)]
        self.assertEqual(len(contents), 2)
        self.assertIn("ORIGINAL\n", contents)  # pre-install copy survived, not overwritten

    def test_content_the_user_adds_around_the_block_survives_update_and_uninstall(self):
        self.bashrc.write_text("before\n")
        self.ok("--shell", "bash")
        self.bashrc.write_text(self.bashrc.read_text() + "after\n")
        other = self.home / "elsewhere" / "k"
        self.ok("--shell", "bash", "--prefix", str(other))  # updates the block in place
        text = self.bashrc.read_text()
        self.assertEqual(text, "before\n\n" + block("k-init.bash", "$HOME/elsewhere/k") + "after\n")
        self.assertEqual(text.count(BEGIN), 1)
        self.ok("uninstall", "--shell", "bash", "--prefix", str(other))
        self.assertEqual(self.bashrc.read_text(), "before\nafter\n")

    def test_a_missing_rc_file_is_created_and_left_empty_by_uninstall(self):
        self.ok("--shell", "zsh")
        self.assertEqual(self.zshrc.read_text(), block("k-init.zsh"))
        self.ok("uninstall", "--shell", "zsh")
        self.assertEqual(self.zshrc.read_text(), "")

    def test_an_rc_file_without_a_trailing_newline_is_not_corrupted(self):
        self.bashrc.write_bytes(b"export FOO=1")
        self.ok("--shell", "bash")
        self.assertTrue(self.bashrc.read_text().startswith("export FOO=1\n\n" + BEGIN))
        self.ok("uninstall", "--shell", "bash")
        self.assertEqual(self.bashrc.read_text(), "export FOO=1\n")  # gains the newline it lacked

    def test_a_symlinked_rc_file_is_edited_through_the_link(self):
        dotfiles = self.home / "dotfiles"
        dotfiles.mkdir()
        (dotfiles / "bashrc").write_text("export FOO=1\n")
        self.bashrc.symlink_to(dotfiles / "bashrc")
        self.ok("--shell", "bash")
        self.assertTrue(self.bashrc.is_symlink())
        self.assertIn(BEGIN, (dotfiles / "bashrc").read_text())
        self.ok("uninstall", "--shell", "bash")
        self.assertTrue(self.bashrc.is_symlink())
        self.assertEqual((dotfiles / "bashrc").read_text(), "export FOO=1\n")

    def test_file_permissions_are_kept(self):
        self.bashrc.write_text("export FOO=1\n")
        self.bashrc.chmod(0o640)
        self.ok("--shell", "bash")
        self.assertEqual(stat.S_IMODE(self.bashrc.stat().st_mode), 0o640)

    def test_uninstall_without_install_does_nothing(self):
        self.bashrc.write_text("export FOO=1\n")
        before = self.snapshot()
        result = self.ok("uninstall")
        self.assertEqual(self.snapshot(), before)
        self.assertIn("no block in", result.stdout)

    def test_uninstall_only_removes_what_it_installed(self):
        self.ok("--shell", "bash")
        (self.prefix / "my-own-file").write_text("keep me\n")
        self.ok("uninstall", "--shell", "bash")
        self.assertEqual([p.name for p in self.prefix.iterdir()], ["my-own-file"])


class PartialUninstall(InstallerCase):
    """The shell files are shared by bash and zsh: removing one shell must not break the other."""

    SHARED = ("k-aliases.sh", "k-completion-data.sh", "k-completion.bash",
              "k-completion.zsh", "k-init.bash", "k-init.zsh")

    def works(self, shell: str, rc: Path) -> bool:
        result = sh.run_shell(shell, f". '{rc}'; kzgpw -A", path_prefix=self.bin,
                              env={"HOME": str(self.home)})
        return result.stdout.split("\n")[:-1] == [
            "A --namespace=kube-system", "A get", "A pods", "A --watch", "A -A"]

    def shared_files_present(self) -> bool:
        return all((self.prefix / name).exists() for name in self.SHARED)

    def setUp(self):
        super().setUp()
        self.bashrc.write_text("export B=1\n")
        self.zshrc.write_text("export Z=1\n")

    @unittest.skipUnless("zsh" in sh.SHELLS, "zsh not installed")
    def test_uninstalling_bash_only_keeps_zsh_working_until_zsh_is_uninstalled(self):
        self.ok("--shell", "both")
        result = self.ok("uninstall", "--shell", "bash")
        self.assertEqual(self.bashrc.read_text(), "export B=1\n")
        self.assertIn(BEGIN, self.zshrc.read_text())
        self.assertTrue(self.shared_files_present(), result.stdout)
        self.assertIn("still used", result.stdout)
        self.assertTrue(self.works("zsh", self.zshrc), "zsh broke after uninstalling bash")
        self.ok("uninstall", "--shell", "zsh")
        self.assertEqual(self.zshrc.read_text(), "export Z=1\n")
        self.assertFalse(self.prefix.exists())

    @unittest.skipUnless("bash" in sh.SHELLS, "bash not installed")
    def test_uninstalling_zsh_only_keeps_bash_working_until_bash_is_uninstalled(self):
        self.ok("--shell", "both")
        self.ok("uninstall", "--shell", "zsh")
        self.assertEqual(self.zshrc.read_text(), "export Z=1\n")
        self.assertTrue(self.shared_files_present())
        self.assertTrue(self.works("bash", self.bashrc), "bash broke after uninstalling zsh")
        self.ok("uninstall", "--shell", "bash")
        self.assertFalse(self.prefix.exists())

    def test_uninstalling_a_shell_that_was_never_installed_keeps_the_other_one(self):
        self.ok("--shell", "bash")
        before = self.snapshot()
        result = self.ok("uninstall", "--shell", "zsh")
        self.assertEqual(self.snapshot(), before)
        self.assertTrue(self.shared_files_present())
        self.assertIn("no block in", result.stdout)

    def test_a_dry_run_of_a_partial_uninstall_does_not_claim_to_remove_shared_files(self):
        self.ok("--shell", "both")
        result = self.ok("uninstall", "--shell", "bash", "--dry-run")
        self.assertNotIn("would remove the installed files", result.stdout)
        self.assertIn("still used", result.stdout)

    def test_a_default_uninstall_still_removes_everything(self):
        self.ok("--shell", "both")
        self.ok("uninstall")
        self.assertFalse(self.prefix.exists())
        self.assertEqual(self.bashrc.read_text(), "export B=1\n")
        self.assertEqual(self.zshrc.read_text(), "export Z=1\n")

    def test_another_installation_in_a_different_prefix_does_not_keep_these_files(self):
        other = self.home / "other-prefix"
        self.ok("--shell", "bash")
        self.ok("--shell", "zsh", "--prefix", str(other))
        self.ok("uninstall", "--shell", "bash")
        self.assertFalse(self.prefix.exists(), "zsh uses a different prefix; nothing here is shared")
        self.assertTrue((other / "k-init.zsh").exists())


class Refusals(InstallerCase):
    def test_damaged_markers_stop_everything_before_any_change(self):
        for label, text in (("begin only", f"x\n{BEGIN}\ny\n"),
                            ("two blocks", block("k-init.bash") + block("k-init.bash"))):
            with self.subTest(case=label):
                self.bashrc.write_text(text)
                self.zshrc.write_text("alias ll=ls\n")
                before = self.snapshot()
                result = self.run_installer("--shell", "both")
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("damaged", result.stderr)
                self.assertEqual(self.snapshot(), before)
                self.assertFalse(self.prefix.exists())
                self.assertNotEqual(self.run_installer("uninstall").returncode, 0)

    def test_markers_in_the_wrong_order_are_rejected_without_touching_anything(self):
        # One begin and one end marker pass a count check, but with the end first the awk
        # "replace until the end marker" would swallow everything after the begin marker.
        cases = {
            "end then begin": f"top\n{END}\nmiddle\n{BEGIN}\nbottom\nmore\n",
            "end then begin, adjacent": f"{END}\n{BEGIN}\nkeep me\n",
            "reversed copy of a real block": f"before\n{END}\nstale\n{BEGIN}\nafter\n",
        }
        for label, text in cases.items():
            for action in (("--shell", "both"), ("uninstall",)):
                with self.subTest(case=label, action=action[0]):
                    self.bashrc.write_text(text)
                    self.zshrc.write_text("alias ll=ls\n")
                    before = self.snapshot()
                    result = self.run_installer(*action)
                    self.assertNotEqual(result.returncode, 0, result.stdout)
                    self.assertIn("out of order", result.stderr)
                    self.assertEqual(self.snapshot(), before, "nothing may change")
                    self.assertEqual(self.bashrc.read_text(), text)
                    self.assertFalse(self.prefix.exists())

    def test_a_reversed_pair_in_the_other_shells_file_also_stops_the_run(self):
        # Checked for every selected file before the first write, so no half-finished install.
        self.bashrc.write_text("export B=1\n")
        self.zshrc.write_text(f"{END}\n{BEGIN}\nkeep\n")
        before = self.snapshot()
        result = self.run_installer("--shell", "both")
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.snapshot(), before)
        self.assertFalse(self.prefix.exists())

    def test_a_directory_not_created_by_the_installer_is_never_used_or_removed(self):
        self.prefix.mkdir(parents=True)
        (self.prefix / "precious").write_text("mine\n")
        self.bashrc.write_text("export FOO=1\n")
        before = self.snapshot()
        result = self.run_installer("--shell", "bash")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("was not created by this installer", result.stderr)
        self.assertEqual(self.snapshot(), before)
        # uninstall leaves it alone too
        self.bashrc.write_text("export FOO=1\n\n" + block("k-init.bash"))
        self.ok("uninstall", "--shell", "bash")
        self.assertEqual((self.prefix / "precious").read_text(), "mine\n")

    def test_prefixes_that_would_be_interpreted_by_the_shell_are_rejected(self):
        for bad in ('/tmp/a"b', "/tmp/a$b", "/tmp/a`b", "/tmp/a\\b", "/tmp/a\nb", "relative/dir"):
            with self.subTest(prefix=bad):
                result = self.run_installer("--shell", "bash", "--prefix", bad)
                self.assertNotEqual(result.returncode, 0)
                self.assertFalse(self.bashrc.exists())

    def test_an_unknown_shell_needs_an_explicit_choice(self):
        result = self.run_installer(env={"SHELL": "/usr/bin/fish"})
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("pass --shell", result.stderr)
        self.assertEqual(self.snapshot(), {})

    def test_missing_generated_files_say_how_to_make_them(self):
        lonely = Path(self.tmp.name) / "lonely"
        lonely.mkdir()
        shutil.copy(INSTALL, lonely / "install.sh")
        result = self.run_installer("--shell", "bash", script=lonely / "install.sh")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("python3 tools/generate_aliases.py", result.stderr)

    def test_unknown_arguments_are_rejected(self):
        self.assertNotEqual(self.run_installer("--shel", "bash").returncode, 0)


class Options(InstallerCase):
    def test_shell_is_chosen_from_SHELL_by_default(self):
        self.ok(env={"SHELL": "/usr/bin/zsh"})
        self.assertTrue(self.zshrc.exists())
        self.assertFalse(self.bashrc.exists())

    def test_shell_auto_picks_the_shell_named_by_SHELL(self):
        for shell_env, rc, other in (("/bin/bash", self.bashrc, self.zshrc),
                                     ("/usr/bin/zsh", self.zshrc, self.bashrc)):
            with self.subTest(SHELL=shell_env):
                self.ok("--shell", "auto", env={"SHELL": shell_env})
                self.assertIn(BEGIN, rc.read_text())
                self.assertFalse(other.exists(), "only the detected shell's rc file is touched")
                self.ok("uninstall", "--shell", "auto", env={"SHELL": shell_env})
                self.assertNotIn(BEGIN, rc.read_text())
                rc.unlink()

    def test_shell_auto_with_an_unknown_shell_asks_for_an_explicit_choice(self):
        result = self.run_installer("--shell", "auto", env={"SHELL": "/usr/bin/fish"})
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("pass --shell", result.stderr)
        self.assertEqual(self.snapshot(), {})

    def test_uninstall_auto_only_touches_the_detected_shell(self):
        self.ok("--shell", "both")
        self.ok("uninstall", "--shell", "auto", env={"SHELL": "/bin/zsh"})
        self.assertIn(BEGIN, self.bashrc.read_text())
        self.assertNotIn(BEGIN, self.zshrc.read_text())
        self.assertTrue((self.prefix / "k-init.bash").exists(), "bash still uses the shared files")

    def test_the_documented_defaults_are_what_happens(self):
        # install: auto; uninstall: both
        self.ok(env={"SHELL": "/bin/zsh"})
        self.assertTrue(self.zshrc.exists() and not self.bashrc.exists())
        self.ok("--shell", "bash")
        self.ok("uninstall", env={"SHELL": "/bin/zsh"})
        self.assertNotIn(BEGIN, self.bashrc.read_text())
        self.assertNotIn(BEGIN, self.zshrc.read_text())

    def test_every_value_the_help_text_advertises_is_accepted(self):
        usage = self.ok("--help").stdout
        advertised = re.search(r"--shell ((?:\w+\|)+\w+)", usage)
        self.assertIsNotNone(advertised, usage)
        for value in advertised.group(1).split("|"):
            with self.subTest(value=value):
                result = self.run_installer("--shell", value, "--dry-run", env={"SHELL": "/bin/bash"})
                self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("auto", usage)

    def test_zdotdir_and_explicit_rc_paths_are_honoured(self):
        zdot = self.home / "zdot"
        zdot.mkdir()
        self.ok("--shell", "zsh", env={"ZDOTDIR": str(zdot)})
        self.assertIn(BEGIN, (zdot / ".zshrc").read_text())
        bash_profile = self.home / ".bash_profile"
        self.ok("--shell", "bash", "--bashrc", str(bash_profile))
        self.assertIn(BEGIN, bash_profile.read_text())

    def test_dry_run_changes_nothing(self):
        self.bashrc.write_text("export FOO=1\n")
        before = self.snapshot()
        result = self.ok("--shell", "bash", "--dry-run")
        self.assertEqual(self.snapshot(), before)
        self.assertIn("would", result.stdout)
        self.ok("--shell", "bash")
        before = self.snapshot()
        self.ok("uninstall", "--shell", "bash", "--dry-run")
        self.assertEqual(self.snapshot(), before)

    def test_a_prefix_under_home_is_written_with_the_HOME_variable(self):
        self.ok("--shell", "bash")
        self.assertIn('"$HOME/.local/share/devops-k-aliases/k-init.bash"', self.bashrc.read_text())
        self.assertNotIn(str(self.home), self.bashrc.read_text())

    def test_warns_about_names_that_already_exist_as_commands(self):
        sh.write_executable(self.bin / "kgp", "#!/bin/sh\n")
        result = self.ok("--shell", "bash")
        self.assertIn("already exist as commands", result.stdout)
        self.assertRegex(result.stdout, r"\bkgp\b")


@unittest.skipUnless(sh.SHELLS, "neither bash nor zsh is installed")
class InstalledFilesWork(InstallerCase):
    """The installed rc block must really load the aliases, wherever they were installed."""

    def test_installed_aliases_run_kubectl_in_each_shell(self):
        prefix = self.home / "dir with spaces" / "k"
        self.ok("--shell", "both", "--prefix", str(prefix))
        for shell, rc in (("bash", ".bashrc"), ("zsh", ".zshrc")):
            if shell not in sh.SHELLS:
                continue
            with self.subTest(shell=shell):
                result = sh.run_shell(shell, f". '{self.home / rc}'; kzgpw -A", path_prefix=self.bin,
                                      env={"HOME": str(self.home)})
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout.split("\n")[:-1],
                                 ["A --namespace=kube-system", "A get", "A pods", "A --watch", "A -A"])


@unittest.skipUnless(sh.SHELLS and sh.KUBECTL, "needs bash or zsh, and kubectl")
class InstalledCompletionWorks(InstallerCase):
    """Installer -> rc file -> live shell -> Tab, with the real kubectl: the whole path once."""

    def test_tab_completion_works_in_a_shell_started_from_the_installed_rc_file(self):
        sh.write_executable(self.bin / "kubectl", f'#!/bin/sh\nexec "{sh.KUBECTL}" "$@"\n')
        self.ok("--shell", "both")
        env = {"PATH": f"{self.bin}:{sh.SAFE_PATH}", "HOME": str(self.home),
               "KUBECONFIG": str(self.home / "no-cluster"), "TERM": "dumb", "LANG": "C.UTF-8",
               "PS1": "PROMPT> "}
        for name in sh.SHELLS:
            if name == "bash" and not sh.BASH_COMPLETION:
                continue
            with self.subTest(shell=name):
                setup = ([f". {sh.BASH_COMPLETION}", ". ~/.bashrc"] if name == "bash" else
                         ["PROMPT='PROMPT> '", "source ~/.zshrc",
                          f"autoload -Uz compinit && compinit -u -d {self.home}/zcompdump"])
                shell = sh.InteractiveShell(name, env, setup)
                self.addCleanup(shell.close)
                self.assertEqual(shell.complete("kg --show-l"), ["kg", "--show-labels"])


if __name__ == "__main__":
    unittest.main()
