"""PowerShell script encoding.

Windows PowerShell 5.1 reads a .ps1 without a byte-order mark as Windows-1252, not UTF-8. The
check mark in "✓" (E2 9C 93) then contains 0x93, a curly double quote, which PowerShell treats
as a string delimiter, so the script fails to parse ("The string is missing the terminator").
This was found by running Install-Profile.ps1 under 5.1 in CI; it had never been run there.

PowerShell 7 reads either form, so a script with any non-ASCII text needs a UTF-8 BOM, and the
files that are loaded on every shell start (the profile, k-aliases.ps1) should stay pure ASCII.
"""

import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BOM = b"\xef\xbb\xbf"


def powershell_scripts() -> list[Path]:
    return sorted(p for p in ROOT.rglob("*.ps1") if ".git" not in p.relative_to(ROOT).parts)


class PowerShellScriptEncoding(unittest.TestCase):
    def test_scripts_with_non_ascii_text_start_with_a_utf8_bom(self):
        missing = [p.relative_to(ROOT).as_posix() for p in powershell_scripts()
                   if any(byte > 127 for byte in p.read_bytes()) and not p.read_bytes().startswith(BOM)]
        self.assertEqual(missing, [], "non-ASCII .ps1 files need a UTF-8 BOM for Windows PowerShell 5.1")

    def test_files_loaded_at_every_shell_start_are_pure_ascii(self):
        for name in ("Microsoft.Powershell_profile.ps1", "k-aliases.ps1"):
            with self.subTest(file=name):
                data = (ROOT / name).read_bytes()
                self.assertFalse(data.startswith(BOM))
                self.assertFalse(any(byte > 127 for byte in data))

    def test_there_are_scripts_to_check(self):
        self.assertGreaterEqual(len(powershell_scripts()), 5)


if __name__ == "__main__":
    unittest.main()
