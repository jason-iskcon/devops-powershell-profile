"""The bash and zsh functions: parity with the manifests, argument forwarding, safety.

The manifests (tests/k-aliases.tsv, tests/k-additions.tsv) are the cross-shell contract:
PowerShell is checked against them by Test-Profile.ps1, and these tests check bash and zsh
against the same files by running every function against a stub kubectl.
"""

import re
import tempfile
import unittest
from pathlib import Path

import shell_support as sh

# Awkward arguments every function must pass through untouched, as separate words.
AWKWARD = ["a b", "$(echo pwned)", "*", ";x", "'q'", '"dq"']


def awkward_args_shell_text() -> str:
    return " ".join("'" + a.replace("'", "'\\''") + "'" for a in AWKWARD)


@unittest.skipUnless(sh.SHELLS, "neither bash nor zsh is installed")
class FunctionsMatchTheManifest(unittest.TestCase):
    """Every name, its fixed arguments, and its completion arguments, in each shell."""

    @classmethod
    def setUpClass(cls):
        cls.tmp = tempfile.TemporaryDirectory()
        cls.bin = Path(cls.tmp.name) / "bin"
        sh.write_executable(cls.bin / "kubectl", sh.STUB_KUBECTL)
        cls.manifest = sh.manifest_aliases()
        names = Path(cls.tmp.name) / "names.txt"
        names.write_text("".join(f"{n}\n" for n in cls.manifest), encoding="utf-8")
        cls.names_file = names

    @classmethod
    def tearDownClass(cls):
        cls.tmp.cleanup()

    def run_all(self, shell: str) -> list[str]:
        script = f"""
. '{sh.POSIX}/k-aliases.sh'
. '{sh.POSIX}/k-completion-data.sh'
while IFS= read -r n; do
    printf 'N %s\\n' "$n"
    "$n" {awkward_args_shell_text()}
    __k_implicit=()
    __k_implicit_args "$n"
    printf 'I'
    for t in "${{__k_implicit[@]}}"; do printf ' %s' "$t"; done
    printf '\\n'
done < '{self.names_file}'
"""
        result = sh.run_shell(shell, script, path_prefix=self.bin)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stderr, "")
        return result.stdout.split("\n")

    def check(self, shell: str):
        lines = self.run_all(shell)
        expected = []
        for name, args in self.manifest.items():
            expected.append(f"N {name}")
            expected += [f"A {a}" for a in (*args, *AWKWARD)]
            expected.append(("I " + " ".join(args)).rstrip() if args else "I")
        self.assertEqual(lines[:-1], expected)  # last element is the empty string after \n

    def test_bash(self):
        if "bash" not in sh.SHELLS:
            self.skipTest("bash not installed")
        self.check("bash")

    def test_zsh(self):
        if "zsh" not in sh.SHELLS:
            self.skipTest("zsh not installed")
        self.check("zsh")

    def test_defined_functions_are_exactly_the_manifest_names(self):
        for shell in sh.SHELLS:
            with self.subTest(shell=shell):
                list_functions = ("compgen -A function" if shell == "bash"
                                  else "print -rl -- ${(k)functions}")
                result = sh.run_shell(shell, f". '{sh.POSIX}/k-aliases.sh'; {list_functions}",
                                      path_prefix=self.bin)
                defined = {n for n in result.stdout.split() if re.fullmatch(r"k[a-z]*", n)}
                self.assertEqual(defined, set(self.manifest))
                names = sh.run_shell(shell, f". '{sh.POSIX}/k-aliases.sh'; printf '%s\\n' \"${{__k_names[@]}}\"",
                                     path_prefix=self.bin)
                self.assertEqual(set(names.stdout.split()), set(self.manifest))

    def test_destructive_delete_all_aliases_keep_their_meaning(self):
        delete_all = {n: a for n, a in self.manifest.items() if "delete" in a and "--all" in a}
        self.assertGreater(len(delete_all), 10)
        for shell in sh.SHELLS:
            with self.subTest(shell=shell):
                result = sh.run_shell(shell, f". '{sh.POSIX}/k-aliases.sh'; kxpaa; kzxdeaa",
                                      path_prefix=self.bin)
                self.assertEqual(
                    result.stdout.split("\n")[:-1],
                    ["A delete", "A pods", "A --all",
                     "A --namespace=kube-system", "A delete", "A deployment", "A --all"])


@unittest.skipUnless(sh.SHELLS, "neither bash nor zsh is installed")
class SafetyAndRobustness(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.bin = Path(self.tmp.name) / "bin"
        sh.write_executable(self.bin / "kubectl", sh.STUB_KUBECTL)

    def test_functions_do_not_evaluate_their_arguments(self):
        marker = Path(self.tmp.name) / "pwned"
        for shell in sh.SHELLS:
            with self.subTest(shell=shell):
                result = sh.run_shell(
                    shell, f". '{sh.POSIX}/k-aliases.sh'; kgp '$(touch {marker})' '`touch {marker}`'",
                    path_prefix=self.bin)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertFalse(marker.exists())
                self.assertIn(f"A $(touch {marker})", result.stdout)

    def test_no_eval_in_our_shell_code(self):
        for path in sorted(sh.POSIX.iterdir()):
            code = [line for line in path.read_text(encoding="utf-8").splitlines()
                    if not line.lstrip().startswith("#")]
            with self.subTest(file=path.name):
                self.assertFalse([line for line in code if re.search(r"\beval\b", line)])

    def test_a_user_alias_with_the_same_name_does_not_break_loading(self):
        # e.g. the oh-my-zsh kubectl plugin defines kgp, kdp, ...: defining a function over an
        # alias is a syntax error in bash and "defining function based on alias" in zsh.
        scripts = {
            "bash": "shopt -s expand_aliases; alias kgp='echo SHADOWED'; alias k='echo SHADOWED'",
            "zsh": "alias kgp='echo SHADOWED'; alias k='echo SHADOWED'",
        }
        for shell in sh.SHELLS:
            with self.subTest(shell=shell):
                result = sh.run_shell(
                    shell, f"{scripts[shell]}\n. '{sh.POSIX}/k-aliases.sh'\nkgp -A\nk version",
                    path_prefix=self.bin)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stderr, "")
                self.assertEqual(result.stdout.split("\n")[:-1],
                                 ["A get", "A pods", "A -A", "A version"])

    def test_functions_call_kubectl_not_a_user_function_or_alias_of_that_name(self):
        scripts = {
            "bash": "shopt -s expand_aliases; alias kubectl='echo WRONG'; kubectl() { echo WRONG; }",
            "zsh": "alias kubectl='echo WRONG'; kubectl() { echo WRONG; }",
        }
        for shell in sh.SHELLS:
            with self.subTest(shell=shell):
                result = sh.run_shell(shell, f"{scripts[shell]}\n. '{sh.POSIX}/k-aliases.sh'\nkgp",
                                      path_prefix=self.bin)
                self.assertEqual(result.stdout.split("\n")[:-1], ["A get", "A pods"])

    def test_renderer_quotes_arguments_even_if_validation_were_bypassed(self):
        # Validation rejects such tokens; the renderer must still never let them split or expand.
        weird = sh.gen.Alias("kweird", ("get", "a b", "$(echo x)", "it's", "*"))
        text = sh.gen.render_posix_aliases([weird])
        path = Path(self.tmp.name) / "weird.sh"
        path.write_text(text, encoding="utf-8")
        for shell in sh.SHELLS:
            with self.subTest(shell=shell):
                result = sh.run_shell(shell, f". '{path}'; kweird tail", path_prefix=self.bin)
                self.assertEqual(result.stdout.split("\n")[:-1],
                                 ["A get", "A a b", "A $(echo x)", "A it's", "A *", "A tail"])


class GeneratedPosixFilesAreCurrent(unittest.TestCase):
    def test_committed_files_match_the_grammar(self):
        aliases = sh.gen.expand(sh.gen.load_grammar(sh.gen.DEFAULT_GRAMMAR))
        for path, text in sh.gen.generated_files(aliases, sh.gen.DEFAULT_POWERSHELL, sh.POSIX).items():
            with self.subTest(file=path.name):
                self.assertEqual(path.read_text(encoding="utf-8"), text,
                                 "run: python3 tools/generate_aliases.py")


if __name__ == "__main__":
    unittest.main()
