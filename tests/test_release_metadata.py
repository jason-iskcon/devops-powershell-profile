"""The version must be the same everywhere it is written.

A release goes out with the version in the README banner, the profile's first line, the top
CHANGELOG section and the release notes. Nothing else would notice if one of them was missed.
"""

import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def read(name: str) -> str:
    return (ROOT / name).read_text(encoding="utf-8")


class VersionIsConsistent(unittest.TestCase):
    def readme_version(self) -> str:
        match = re.search(r"\*\*Version:\*\*\s*(\d+\.\d+\.\d+)", read("README.md"))
        self.assertIsNotNone(match, "README.md banner has no '**Version:** x.y.z'")
        return match.group(1)

    def profile_version(self) -> str:
        match = re.match(r"# PowerShell Profile v(\d+\.\d+\.\d+)", read("Microsoft.Powershell_profile.ps1"))
        self.assertIsNotNone(match, "profile line 1 is not '# PowerShell Profile vX.Y.Z'")
        return match.group(1)

    def changelog_version(self) -> str:
        match = re.search(r"(?m)^## \[(\d+\.\d+\.\d+)\]", read("CHANGELOG.md"))
        self.assertIsNotNone(match, "CHANGELOG.md has no '## [x.y.z]' section")
        return match.group(1)

    def test_readme_profile_and_changelog_agree(self):
        versions = {"README.md": self.readme_version(),
                    "Microsoft.Powershell_profile.ps1": self.profile_version(),
                    "CHANGELOG.md (newest section)": self.changelog_version()}
        self.assertEqual(len(set(versions.values())), 1, versions)

    def test_release_notes_exist_for_this_version(self):
        notes = ROOT / "release-notes" / f"v{self.changelog_version()}.md"
        self.assertTrue(notes.exists(), f"missing {notes.relative_to(ROOT)}")
        self.assertIn(f"v{self.changelog_version()}", notes.read_text(encoding="utf-8").splitlines()[0])

    def test_the_checklist_tags_this_version_not_an_old_one(self):
        version = self.changelog_version()
        checklist = read("RELEASE_CHECKLIST.md")
        tag_commands = re.findall(r"git tag [^\n]*?(v\d+\.\d+\.\d+(?:-[0-9A-Za-z.]+)?)", checklist)
        self.assertTrue(tag_commands, "RELEASE_CHECKLIST.md has no 'git tag' command")
        for tag in tag_commands:
            self.assertTrue(tag.startswith(f"v{version}"), f"checklist tags {tag}, release is v{version}")


if __name__ == "__main__":
    unittest.main()
