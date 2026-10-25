"""Every test module must be run by CI, and CI must not let tests skip silently.

The workflow runs the Python tests in groups (`unittest discover -s tests -p '<pattern>'`). A new
test file that matches no group is never executed in CI, however good its tests are: this is how
test_release_metadata.py and test_encoding.py were added in a release candidate without being run.
"""

import fnmatch
import re
import subprocess
import tempfile
import textwrap
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WORKFLOW = (ROOT / ".github" / "workflows" / "ci.yml").read_text(encoding="utf-8")


def discover_patterns() -> list[str]:
    """The -p pattern of every `unittest discover -s tests` command in the workflow."""
    patterns = []
    for command in re.findall(r"unittest discover[^\n]*", WORKFLOW):
        if "-s tests" not in command:
            continue
        match = re.search(r"-p\s+(?:'([^']+)'|\"([^\"]+)\"|(\S+))", command)
        patterns.append(next(g for g in match.groups() if g) if match else "test*.py")
    return patterns


class EveryTestModuleRunsInCI(unittest.TestCase):
    def test_each_test_module_matches_a_discover_pattern(self):
        patterns = discover_patterns()
        self.assertTrue(patterns, "no `unittest discover -s tests` command found in ci.yml")
        modules = sorted(p.name for p in (ROOT / "tests").glob("test_*.py"))
        unrun = [m for m in modules if not any(fnmatch.fnmatchcase(m, pat) for pat in patterns)]
        self.assertEqual(unrun, [], f"not run by CI (patterns: {patterns})")

    def test_the_pattern_reader_understands_the_forms_used(self):
        # Guards the guard: a reader that found nothing would make the check above vacuous.
        self.assertGreaterEqual(len(discover_patterns()), 4)


class CIDoesNotSkipSilently(unittest.TestCase):
    """PowerShell-dependent tests skip when `pwsh` is missing; on Linux CI that must be an error."""

    def test_the_linux_python_job_checks_that_pwsh_exists(self):
        self.assertRegex(WORKFLOW, r"command -v pwsh")

    def test_skipped_tests_fail_the_ci_steps_that_run_powershell_tests(self):
        self.assertRegex(WORKFLOW, r"\\\.\\\.\\\. skipped")  # grep for unittest's "... skipped" lines


def tee_steps() -> list[tuple[str, str, bool]]:
    """(name, run script, declares `shell: bash`) for each workflow step that pipes into `tee`."""
    steps = []
    for chunk in re.split(r"(?m)^\s+- (?=name:|uses:)", WORKFLOW)[1:]:
        run = re.search(r"(?ms)^\s+run: \|\n(.*?)(?=^\s{0,8}\S|\Z)", chunk)
        if run is None or "| tee" not in run.group(1):
            continue
        name = re.search(r"name:\s*(.+)", chunk).group(1).strip()
        steps.append((name, textwrap.dedent(run.group(1)), bool(re.search(r"(?m)^\s+shell: bash\s*$", chunk))))
    return steps


class FailuresAreNotMaskedByTee(unittest.TestCase):
    """`python -m unittest ... | tee log` is only as strict as the shell's `pipefail`.

    GitHub runs a step with no `shell:` as `bash -e`, which reports tee's exit status and so hides a
    failing test run; `shell: bash` runs `bash -eo pipefail`. The steps below also grep the log for
    skipped tests, so without pipefail a test run that crashed (or failed) would still pass the step.
    """

    def test_the_steps_that_tee_test_output_were_found(self):
        self.assertGreaterEqual(len(tee_steps()), 2)  # guards the guard: the PowerShell and Bash/zsh steps

    def test_a_failing_test_command_fails_the_step_as_github_runs_it(self):
        for name, script, declares_bash in tee_steps():
            with self.subTest(step=name):
                # The same script with the test command replaced by one that prints and fails.
                failing, count = re.subn(r"python -m unittest[^|\n]*?(?= 2>&1 \| tee)",
                                         "python3 -c 'import sys; print(\"FAILED (failures=1)\"); sys.exit(1)'",
                                         script)
                self.assertEqual(count, 1, "expected one `python -m unittest ... 2>&1 | tee` command")
                flags = ["-eo", "pipefail"] if declares_bash else ["-e"]  # what the runner uses
                with tempfile.TemporaryDirectory() as cwd:
                    result = subprocess.run(["bash", "--noprofile", "--norc", *flags, "-c", failing],
                                            cwd=cwd, capture_output=True, text=True)
                self.assertNotEqual(result.returncode, 0,
                                    f"a failing test run passed this step (flags {flags}); "
                                    "add `shell: bash` so the step runs with pipefail")


if __name__ == "__main__":
    unittest.main()
