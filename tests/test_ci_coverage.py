"""Every test module must be run by CI, and CI must not let tests skip silently.

The workflow runs the Python tests in groups (`unittest discover -s tests -p '<pattern>'`). A new
test file that matches no group is never executed in CI, however good its tests are: this is how
test_release_metadata.py and test_encoding.py were added in a release candidate without being run.
"""

import fnmatch
import re
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


if __name__ == "__main__":
    unittest.main()
