"""Regression test for Test-Profile.ps1 -Quiz.

An unconditional `exit` before the quiz block once made -Quiz unreachable, and nothing
noticed because the suite had never been able to fail. This runs the real script under
PowerShell with the quiz answers on stdin, so it catches that class of mistake directly.

Needs PowerShell 7 (`pwsh` on PATH, or set PWSH); skipped otherwise.
"""

import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PWSH = os.environ.get("PWSH") or shutil.which("pwsh")

# Answers to the eight questions in Test-Profile.ps1, in order.
QUIZ_ANSWERS = ["gl", "kgp", "ta", "kxp", "gcmsg", "kgpaay", "kzgp", "td"]

GIT_ALIASES = ["ga", "gaa", "gcmsg", "gp", "gl", "gco", "gcb", "gbr", "gbd", "gd", "gds",
               "gst", "gsta", "gstd", "gcl", "glog", "gsh"]


def git_aliases_module(missing: tuple[str, ...] = ()) -> str:
    names = ", ".join(f"'{n}'" for n in GIT_ALIASES if n not in missing)
    return f"foreach ($n in {names}) {{ Set-Item -Path \"function:global:$n\" -Value {{ git $args }} }}"


# The profile imports these modules; stand-ins let it load without the PowerShell Gallery. The
# git aliases are absent by default, so the Git checks fail and the exit code is non-zero.
STUB_MODULES = {
    "posh-git": "",
    "git-aliases": "",
    "PSKubectlCompletion": "function Register-KubectlCompletion {}",
}


@unittest.skipUnless(PWSH, "PowerShell 7 (pwsh) not available")
class QuizIsReachable(unittest.TestCase):
    def run_test_profile(self, *args: str, stdin: str = "",
                         stub_modules: dict | None = None) -> subprocess.CompletedProcess:
        with tempfile.TemporaryDirectory() as tmp:
            home = Path(tmp) / "home"
            (home / "Workspace").mkdir(parents=True)  # the profile ends with Set-Location ~/Workspace
            modules = Path(tmp) / "modules"
            for name, body in (stub_modules or STUB_MODULES).items():
                (modules / name).mkdir(parents=True)
                (modules / name / f"{name}.psm1").write_text(body, encoding="utf-8")
            env = dict(
                os.environ,
                PSModulePath=str(modules),
                HOME=str(home),
                USERPROFILE=str(home),
                DOTNET_SYSTEM_GLOBALIZATION_INVARIANT="1",
            )
            return subprocess.run(
                [PWSH, "-NoProfile", "-File", str(ROOT / "Test-Profile.ps1"), *args],
                input=stdin, capture_output=True, text=True, env=env, timeout=300,
                encoding="utf-8",
            )

    def test_quiz_runs_after_the_summary(self):
        result = self.run_test_profile("-Quiz", stdin="\n".join(QUIZ_ANSWERS) + "\n")
        self.assertIn("=== Test Summary ===", result.stdout, result.stderr)
        self.assertIn("=== Quiz Results ===", result.stdout)
        self.assertIn("Score: 8 / 8 (100%)", result.stdout)

    def test_quiz_does_not_run_without_the_switch(self):
        result = self.run_test_profile()
        self.assertIn("=== Test Summary ===", result.stdout, result.stderr)
        self.assertNotIn("Quiz", result.stdout)

    def test_loading_the_profile_does_not_clear_a_redirected_screen(self):
        # Clear-Host throws "The handle is invalid" without a console (found on a Windows CI
        # runner); with output captured, as here, the profile must not call it at all.
        result = self.run_test_profile()
        self.assertIn("Profile loaded successfully", result.stdout, result.stderr)
        self.assertNotIn("\x1b[H", result.stdout)

    def test_failing_checks_still_set_the_exit_code_when_the_quiz_runs(self):
        # The profile only loads with the stub modules above, which define no git aliases,
        # so the git checks fail: the exit code must report that even after a perfect quiz.
        result = self.run_test_profile("-Quiz", stdin="\n".join(QUIZ_ANSWERS) + "\n")
        self.assertNotEqual(result.returncode, 0)

    def test_one_failing_check_is_counted_as_one(self):
        # .Count of a single hashtable is its number of keys (5), which once made a lone
        # failure print "Failed: 5" (seen on the Windows CI runner).
        modules = {**STUB_MODULES, "git-aliases": git_aliases_module(missing=("gcl",))}
        result = self.run_test_profile(stub_modules=modules)
        self.assertIn("Failed: 1", result.stdout, result.stderr)
        self.assertIn("gcl (Git): Command not found", result.stdout)
        self.assertNotEqual(result.returncode, 0)

    def test_kubectl_only_ignores_the_git_and_terraform_aliases(self):
        # Git aliases come from a third-party module; the installer smoke test must not depend on it.
        result = self.run_test_profile("-KubectlOnly")  # the stubs define no git aliases
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Checked 788 kubectl aliases", result.stdout)
        self.assertNotIn("Testing Git Aliases", result.stdout)
        self.assertNotIn("Testing Terraform Aliases", result.stdout)


@unittest.skipUnless(PWSH, "PowerShell 7 (pwsh) not available")
class ProfileNeedsItsGeneratedAliasFile(unittest.TestCase):
    """The profile loads the kubectl aliases from k-aliases.ps1 next to it.

    Until 3.0 a manual install was "copy the profile file". Doing only that now leaves no
    kubectl aliases, so the profile must say why instead of a bare "term is not recognized".
    """

    def load_profile(self, with_aliases: bool) -> str:
        with tempfile.TemporaryDirectory() as tmp:
            folder = Path(tmp) / "profile"
            folder.mkdir()
            shutil.copy(ROOT / "Microsoft.Powershell_profile.ps1", folder)
            if with_aliases:
                shutil.copy(ROOT / "k-aliases.ps1", folder)
            (Path(tmp) / "home" / "Workspace").mkdir(parents=True)
            modules = Path(tmp) / "modules"
            for name, body in STUB_MODULES.items():
                (modules / name).mkdir(parents=True)
                (modules / name / f"{name}.psm1").write_text(body, encoding="utf-8")
            env = dict(os.environ, PSModulePath=str(modules), HOME=str(Path(tmp) / "home"),
                       USERPROFILE=str(Path(tmp) / "home"), DOTNET_SYSTEM_GLOBALIZATION_INVARIANT="1")
            command = (f". '{folder / 'Microsoft.Powershell_profile.ps1'}'; "
                       "'KGP=' + [bool](Get-Command kgp -ErrorAction SilentlyContinue); "
                       "'TI=' + [bool](Get-Command ti -ErrorAction SilentlyContinue)")
            result = subprocess.run([PWSH, "-NoProfile", "-Command", command], capture_output=True,
                                    text=True, env=env, timeout=120, encoding="utf-8")
            return result.stdout + result.stderr

    def test_a_missing_file_gives_a_clear_warning_and_the_rest_of_the_profile_still_loads(self):
        output = self.load_profile(with_aliases=False)
        self.assertIn("k-aliases.ps1 was not found", output)
        self.assertIn("Install-Profile.ps1", output)  # says how to fix it
        self.assertIn("KGP=False", output)
        self.assertIn("TI=True", output)  # terraform aliases from the same profile are unaffected

    def test_with_the_file_present_there_is_no_warning(self):
        output = self.load_profile(with_aliases=True)
        self.assertNotIn("was not found", output)
        self.assertIn("KGP=True", output)


class DocumentedGitAliasesAreExactlyTheTestedOnes(unittest.TestCase):
    """The README, Test-Profile.ps1 and the stand-in module must list the same Git aliases.

    `gs` was documented and tested but the real git-aliases module does not define it (found
    on the Windows runner), and defining it would shadow Ghostscript, so it was removed.
    Nothing may be expected of the module that the documentation does not promise, and the
    other way round. This needs no PowerShell.
    """

    def documented_aliases(self) -> set[str]:
        readme = (ROOT / "README.md").read_text(encoding="utf-8")
        git = readme[readme.index('### Git - The "G" System'):readme.index('### Terraform - The "T" System')]
        return set(re.findall(r"(?m)^(g[a-z]+)\s+- git ", git))

    def aliases_checked_by_test_profile(self) -> set[str]:
        text = (ROOT / "Test-Profile.ps1").read_text(encoding="utf-8")
        return set(re.findall(r'@\{Name="(g[a-z]+)"; Desc="git ', text))

    def test_readme_and_test_profile_list_the_same_git_aliases(self):
        self.assertEqual(self.documented_aliases(), self.aliases_checked_by_test_profile())

    def test_the_stand_in_module_defines_exactly_those_aliases(self):
        self.assertEqual(set(GIT_ALIASES), self.aliases_checked_by_test_profile())

    def test_gs_is_not_expected_anywhere(self):
        for name in ("README.md", "Test-Profile.ps1", "Export-Anki.ps1"):
            with self.subTest(file=name):
                text = (ROOT / name).read_text(encoding="utf-8")
                self.assertIsNone(re.search(r'(?m)^gs\s+- |Name="gs"|Back="gs"', text))

    def test_the_anki_cards_only_cover_documented_aliases(self):
        cards = set(re.findall(r'Back="(g[a-z]+)"; Category="Git',
                               (ROOT / "Export-Anki.ps1").read_text(encoding="utf-8")))
        self.assertLessEqual(cards, self.documented_aliases())

    @unittest.skipUnless(PWSH, "PowerShell 7 (pwsh) not available")
    def test_the_full_suite_passes_when_the_module_defines_what_is_documented(self):
        stubs = {**STUB_MODULES, "git-aliases": git_aliases_module()}
        result = QuizIsReachable("run_test_profile").run_test_profile(stub_modules=stubs)
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Failed: 0", result.stdout)
        self.assertIn("Testing Git Aliases", result.stdout)  # the full suite, not -KubectlOnly


if __name__ == "__main__":
    unittest.main()


class DeliberateFailure(unittest.TestCase):
    def test_fails_on_purpose(self):
        self.fail("deliberate failure to show that the PowerShell step fails")
