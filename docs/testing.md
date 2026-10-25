# Testing

## Run the Test Suite

We've included a comprehensive test script to verify all documented aliases work correctly.

**Quick Test:**
```powershell
# From the profile directory
.\Test-Profile.ps1

# Or from anywhere (if profile is installed)
pwsh -File .\Test-Profile.ps1
```

**Note:** The test script will automatically find the profile file if run from the workspace directory, or use your installed profile if run from elsewhere.

**Skip Execution Tests (faster, only checks if commands exist):**
```powershell
.\Test-Profile.ps1 -SkipExecutionTests
```

**Interactive Quiz Mode (test your knowledge!):**
```powershell
.\Test-Profile.ps1 -Quiz
```

**Verbose Output:**
```powershell
.\Test-Profile.ps1 -Verbose
```

**Only the kubectl functions** (skips the Git and Terraform aliases, which come from third-party modules):
```powershell
.\Test-Profile.ps1 -KubectlOnly
```

**The wider suite** (grammar, generator, Bash and Zsh, installers) is Python's `unittest`:
```sh
python3 -m unittest discover -s tests -v
```
Tests that need an external tool skip when it is missing: PowerShell 7 (`pwsh`, or set `PWSH`) for the profile and quiz tests, and the real `kubectl` (on `PATH`, or set `KUBECTL`) plus bash-completion for the interactive Tab-completion tests. The Bash/Zsh tests need a POSIX system with `bash` and `zsh`; they do not run on Windows.

## What Gets Tested

The test suite validates:

- ✅ **Git Aliases** - All 17 documented git aliases
- ✅ **Terraform Aliases** - All 8 terraform commands
- ✅ **Kubectl Base Commands** - All 8 base verbs (k, kg, kd, kx, etc.)
- ✅ **Kubectl Resource Commands** - All 11 common resource combinations
- ✅ **Kubectl Output Formats** - All 7 output format combinations
- ✅ **Kubectl expansions** - every `k*` function's body is compared with `tests/k-aliases.tsv` and `tests/k-additions.tsv`

## Test Output

The script provides:
- ✓ Green checkmarks for passing tests
- ✗ Red X marks for failing tests
- Summary report with pass/fail counts
- Exit code 0 on success, 1 on failure (useful for CI/CD)

**Example Output:**
```
=== PowerShell Profile Test Suite ===
Testing all documented aliases...

Loading profile...
✓ Profile loaded successfully

--- Testing Git Aliases ---
  ✓ ga - git add
  ✓ gaa - git add --all
  ✓ gcmsg - git commit -m
  ...

--- Testing Kubectl Expansions (tests/k-aliases.tsv, tests/k-additions.tsv) ---
  Checked 788 kubectl aliases

=== Test Summary ===
Total Tests: 839
Passed: 839
Failed: 0

✓ All tests passed!
```

## Continuous Integration

`.github/workflows/ci.yml` runs four jobs:

- **Linux:** the generator check (`python3 tools/generate_aliases.py --check`), the grammar,
  generator and release-metadata tests, and the `Test-Profile.ps1` tests under PowerShell 7.
- **Linux, bash and zsh:** ShellCheck and the bash/zsh tests
  (`python3 -m unittest discover -s tests -p 'test_posix_*.py'`) with the real kubectl and
  bash-completion. In CI none of these may be skipped.
- **Windows, PowerShell 7:** the installer smoke test and the full `Test-Profile.ps1` against
  the real modules.
- **Windows PowerShell 5.1:** the installer smoke test and `Test-Profile.ps1 -KubectlOnly` with
  stand-in modules.

## Manual Testing

To manually verify a specific alias:

```powershell
# Check if alias exists
Get-Command kgp

# Test execution (be careful with destructive commands!)
kg pods --help  # Safe test
```
