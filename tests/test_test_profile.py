"""Regression test for Test-Profile.ps1 -Quiz.

An unconditional `exit` before the quiz block once made -Quiz unreachable, and nothing
noticed because the suite had never been able to fail. This runs the real script under
PowerShell with the quiz answers on stdin, so it catches that class of mistake directly.

Needs PowerShell 7 (`pwsh` on PATH, or set PWSH); skipped otherwise.
"""

import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PWSH = os.environ.get("PWSH") or shutil.which("pwsh")

# Answers to the eight questions in Test-Profile.ps1, in order.
QUIZ_ANSWERS = ["gl", "kgp", "ta", "kxp", "gcmsg", "kgpaay", "kzgp", "td"]

GIT_ALIASES = ["ga", "gaa", "gcmsg", "gp", "gl", "gco", "gcb", "gbr", "gbd", "gs", "gd", "gds",
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
        modules = {**STUB_MODULES, "git-aliases": git_aliases_module(missing=("gs",))}
        result = self.run_test_profile(stub_modules=modules)
        self.assertIn("Failed: 1", result.stdout, result.stderr)
        self.assertIn("gs (Git): Command not found", result.stdout)
        self.assertNotEqual(result.returncode, 0)

    def test_kubectl_only_ignores_the_git_and_terraform_aliases(self):
        # Git aliases come from a third-party module; the installer smoke test must not depend on it.
        result = self.run_test_profile("-KubectlOnly")  # the stubs define no git aliases
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Checked 788 kubectl aliases", result.stdout)
        self.assertNotIn("Testing Git Aliases", result.stdout)
        self.assertNotIn("Testing Terraform Aliases", result.stdout)


if __name__ == "__main__":
    unittest.main()
