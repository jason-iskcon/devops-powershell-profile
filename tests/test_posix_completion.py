"""Tab completion for the bash and zsh functions.

Two layers, because they catch different failures:

* Wrapper tests call the completion function with a stand-in for kubectl's own completion
  and check exactly what it was handed. They are deterministic and need nothing but the
  shells, so they pin the rewriting logic (cursor position, leading spaces, unknown names).
* Interactive tests drive a real shell on a pty with the real kubectl and press Tab. They
  catch what the stand-ins cannot: that kubectl's completion script really accepts the
  rewritten command line, and that compdef / complete registration works in a live shell.
  They need kubectl (set KUBECTL or put it on PATH) and, for bash, bash-completion.
"""

import tempfile
import unittest
from pathlib import Path

import shell_support as sh

BASH_STUB = f"""
. '{sh.POSIX}/k-aliases.sh'
. '{sh.POSIX}/k-completion-data.sh'
__start_kubectl() {{
    printf 'WORDS:%s\\n' "${{COMP_WORDS[*]}}"
    printf 'CWORD:%s\\n' "$COMP_CWORD"
    printf 'LINE:%s\\n' "$COMP_LINE"
    printf 'POINT:%s\\n' "$COMP_POINT"
}}
. '{sh.POSIX}/k-completion.bash'
"""

ZSH_STUB = f"""
. '{sh.POSIX}/k-aliases.sh'
. '{sh.POSIX}/k-completion-data.sh'
_kubectl() {{
    print -r -- "WORDS:${{words[*]}}"
    print -r -- "CURRENT:$CURRENT"
}}
compdef() {{ print -r -- "COMPDEF $*" }}
"""


def parse(stdout: str) -> dict[str, str]:
    return dict(line.split(":", 1) for line in stdout.splitlines() if ":" in line)


@unittest.skipUnless("bash" in sh.SHELLS, "bash not installed")
class BashWrapper(unittest.TestCase):
    def call(self, words: list[str], cword: int, line: str, point: int | None = None, name_script="") -> dict:
        point = len(line) if point is None else point
        quoted = " ".join(f"'{w}'" for w in words)
        script = (f"{BASH_STUB}\n{name_script}\nCOMP_WORDS=({quoted}); COMP_CWORD={cword}\n"
                  f"COMP_LINE='{line}'; COMP_POINT={point}\n__k_complete\n")
        result = sh.run_shell("bash", script)
        self.assertEqual(result.returncode, 0, result.stderr)
        return parse(result.stdout)

    def test_implicit_subcommand_resource_and_namespace_are_put_in_front(self):
        got = self.call(["kzgpw", "--wa"], 1, "kzgpw --wa")
        self.assertEqual(got["WORDS"], "kubectl --namespace=kube-system get pods --watch --wa")
        self.assertEqual(got["CWORD"], "5")
        self.assertEqual(got["LINE"], "kubectl --namespace=kube-system get pods --watch --wa")
        self.assertEqual(got["POINT"], str(len(got["LINE"])))

    def test_a_function_with_no_implicit_arguments_just_becomes_kubectl(self):
        got = self.call(["k", "ge"], 1, "k ge")
        self.assertEqual((got["WORDS"], got["CWORD"], got["LINE"]), ("kubectl ge", "1", "kubectl ge"))

    def test_implicit_arguments_that_are_flags_stay_in_order(self):
        # kgpl is "get pods -l": the next word is the value of -l.
        got = self.call(["kgpl", "app="], 1, "kgpl app=")
        self.assertEqual(got["WORDS"], "kubectl get pods -l app=")

    def test_leading_whitespace_and_a_cursor_in_the_middle_are_kept(self):
        got = self.call(["kgp", "-o", "json"], 1, "  kgp -o json", point=8)  # cursor after "-o"
        self.assertEqual(got["LINE"], "  kubectl get pods -o json")
        self.assertEqual(got["POINT"], str(8 - len("kgp") + len("kubectl get pods")))
        self.assertEqual(got["LINE"][:int(got["POINT"])], "  kubectl get pods -o")

    def test_unknown_names_are_ignored(self):
        got = self.call(["kfoo", "x"], 1, "kfoo x")
        self.assertEqual(got, {})

    def test_does_nothing_quietly_when_kubectl_is_not_installed(self):
        script = BASH_STUB.replace("__start_kubectl()", "__unused()")  # force the lazy-load path
        script += "COMP_WORDS=(kgp x); COMP_CWORD=1; COMP_LINE='kgp x'; COMP_POINT=5\n__k_complete; echo rc=$?\n"
        empty = tempfile.TemporaryDirectory()  # a PATH with no kubectl, wherever the runner put it
        self.addCleanup(empty.cleanup)
        result = sh.run_shell("bash", script, path=empty.name)
        self.assertEqual((result.stdout, result.stderr), ("rc=0\n", ""))

    def test_stays_silent_when_bash_completion_is_not_loaded(self):
        # kubectl's completion calls bash-completion helpers; without them Tab must not print
        # "command not found" on every press. A fake kubectl whose script needs a missing helper.
        bin_dir = tempfile.TemporaryDirectory()
        self.addCleanup(bin_dir.cleanup)
        sh.write_executable(Path(bin_dir.name) / "kubectl", (
            "#!/bin/sh\n"
            'if [ "$1 $2" = "completion bash" ]; then\n'
            "  echo '__start_kubectl() { _get_comp_words_by_ref cur prev words cword; }'\n"
            "fi\n"))
        script = BASH_STUB.replace("__start_kubectl()", "__unused()")
        script += "COMP_WORDS=(kgp x); COMP_CWORD=1; COMP_LINE='kgp x'; COMP_POINT=5\n__k_complete\n"
        result = sh.run_shell("bash", script, path_prefix=Path(bin_dir.name))
        self.assertEqual((result.stdout, result.stderr), ("", ""))

    def test_every_name_is_registered(self):
        result = sh.run_shell("bash", f"{BASH_STUB}\ncomplete -p | grep -c ' -F __k_complete '")
        self.assertEqual(int(result.stdout), len(sh.manifest_aliases()))


@unittest.skipUnless("zsh" in sh.SHELLS, "zsh not installed")
class ZshWrapper(unittest.TestCase):
    def call(self, words: str, current: int, extra="") -> dict:
        script = (f"{ZSH_STUB}\n{extra}\nsource '{sh.POSIX}/k-completion.zsh'\n"
                  f"words=({words}); CURRENT={current}\n_k_complete\n")
        result = sh.run_shell("zsh", script)
        self.assertEqual(result.returncode, 0, result.stderr)
        return parse(result.stdout)

    def test_implicit_subcommand_resource_and_namespace_are_put_in_front(self):
        got = self.call("kzgpw --wa", 2)
        self.assertEqual(got["WORDS"], "kubectl --namespace=kube-system get pods --watch --wa")
        self.assertEqual(got["CURRENT"], "6")

    def test_a_function_with_no_implicit_arguments_just_becomes_kubectl(self):
        got = self.call("k ge", 2)
        self.assertEqual((got["WORDS"], got["CURRENT"]), ("kubectl ge", "2"))

    def test_words_after_the_cursor_are_kept(self):
        got = self.call("kgpl app= extra", 2)
        self.assertEqual((got["WORDS"], got["CURRENT"]), ("kubectl get pods -l app= extra", "5"))

    def test_unknown_names_are_ignored(self):
        self.assertEqual(self.call("kfoo x", 2), {})

    def test_registers_every_name_when_compinit_has_already_run(self):
        result = sh.run_shell("zsh", f"{ZSH_STUB}\nsource '{sh.POSIX}/k-completion.zsh'")
        line = next(l for l in result.stdout.splitlines() if l.startswith("COMPDEF"))
        registered = line.split()[2:]
        self.assertEqual(line.split()[1], "_k_complete")
        self.assertEqual(set(registered), set(sh.manifest_aliases()))

    def test_waits_for_compinit_instead_of_running_it(self):
        # compdef is not defined yet (the rc file calls compinit later): register on first prompt.
        script = (f". '{sh.POSIX}/k-aliases.sh'; . '{sh.POSIX}/k-completion-data.sh'\n"
                  f"source '{sh.POSIX}/k-completion.zsh'\n"
                  "print -r -- \"HOOKS:${precmd_functions[*]}\"\n"
                  "print -r -- \"COMPINIT_RAN:$+functions[compdef]\"\n")
        result = sh.run_shell("zsh", script)
        got = parse(result.stdout)
        self.assertIn("__k_register_completion_once", got["HOOKS"])
        self.assertEqual(got["COMPINIT_RAN"], "0")


@unittest.skipUnless(sh.SHELLS and sh.KUBECTL, "needs bash or zsh, and kubectl")
class InteractiveWithRealKubectl(unittest.TestCase):
    """Press Tab in a real shell, with the real kubectl answering."""

    shells: dict = {}

    @classmethod
    def setUpClass(cls):
        cls.shells = {}
        cls.tmp = tempfile.TemporaryDirectory()
        cls.home = Path(cls.tmp.name)
        cls.log = cls.home / "kubectl.log"
        # Pass-through that records the arguments kubectl's completion asks for.
        sh.write_executable(
            cls.home / "bin" / "kubectl",
            f'#!/bin/sh\nprintf "%s\\n" "$*" >> "{cls.log}"\nexec "{sh.KUBECTL}" "$@"\n')

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    @classmethod
    def start_shell(cls, name: str) -> sh.InteractiveShell:
        env = {"PATH": f"{cls.home / 'bin'}:{sh.SAFE_PATH}", "HOME": str(cls.home),
               "KUBECONFIG": str(cls.home / "no-cluster"), "TERM": "dumb", "LANG": "C.UTF-8",
               "PS1": "PROMPT> "}
        if name == "bash":
            setup = [f". {sh.BASH_COMPLETION}", f". {sh.POSIX}/k-init.bash"]
        else:
            # The rc file runs before compinit here, as it commonly does.
            setup = ["PROMPT='PROMPT> '", f"source {sh.POSIX}/k-init.zsh",
                     f"autoload -Uz compinit && compinit -u -d {cls.home}/zcompdump"]
        shell = sh.InteractiveShell(name, env, setup)
        cls.addClassCleanup(shell.close)
        return shell

    def each_shell(self):
        """One live shell per kind, shared by the tests (each completion leaves a clean prompt)."""
        for name in sh.SHELLS:
            if name == "bash" and not sh.BASH_COMPLETION:
                continue
            if name not in self.shells:
                self.shells[name] = self.start_shell(name)
            yield name, self.shells[name]

    def test_flag_that_only_exists_for_the_implicit_subcommand_completes(self):
        # --show-labels belongs to "get": kg is "kubectl get".
        for name, shell in self.each_shell():
            with self.subTest(shell=name):
                self.assertEqual(shell.complete("kg --show-l"), ["kg", "--show-labels"])

    def test_the_same_prefix_does_not_complete_under_another_subcommand(self):
        # kd is "kubectl describe", which has no --show-labels: completion must follow the alias.
        for name, shell in self.each_shell():
            with self.subTest(shell=name):
                self.assertEqual(shell.complete("kd --show-l"), ["kd", "--show-l"])

    def test_kubectl_is_asked_about_the_full_command_including_resource_and_namespace(self):
        for name, shell in self.each_shell():
            with self.subTest(shell=name):
                self.log.write_text("")
                shell.complete("kzgpw --wat")
                asked = [l for l in self.log.read_text().splitlines() if l.startswith("__complete")]
                self.assertIn("__complete --namespace=kube-system get pods --watch --wat", asked)

    def test_flag_values_complete(self):
        for name, shell in self.each_shell():
            with self.subTest(shell=name):
                self.assertEqual(shell.complete("kgp -o jsonpath-as"), ["kgp", "-o", "jsonpath-as-json"])

    def test_the_plain_k_function_completes_like_kubectl(self):
        for name, shell in self.each_shell():
            with self.subTest(shell=name):
                self.assertEqual(shell.complete("k ver"), ["k", "version"])


if __name__ == "__main__":
    unittest.main()
