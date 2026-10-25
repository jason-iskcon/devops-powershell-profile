# Testing

There are two test suites. `Test-Profile.ps1` checks an installed (or local) PowerShell
profile. The Python `unittest` suite covers everything else: the grammar and generator, the
Bash and Zsh functions, completion and installer, and it also drives `Test-Profile.ps1`.

## Check your installation

**PowerShell**

```powershell
.\Test-Profile.ps1                  # every documented alias, and all 788 kubectl expansions
.\Test-Profile.ps1 -KubectlOnly     # skip the Git and Terraform aliases (third-party modules)
.\Test-Profile.ps1 -Verbose         # show where each command comes from
```

Run from the repository folder it tests the profile there; run from anywhere else it tests
your installed profile. It exits with 0 when everything passes and 1 otherwise. The checks:

- the 17 Git and 8 Terraform aliases exist;
- 26 core kubectl aliases exist (base verbs, common resources, output formats);
- every `k*` function's body matches `tests/k-aliases.tsv` and `tests/k-additions.tsv`
  exactly, and no `k*` function is defined twice or missing from those lists.

A passing run ends like this:

```text
--- Testing Kubectl Expansions (tests/k-aliases.tsv, tests/k-additions.tsv) ---
  Checked 788 kubectl aliases

=== Test Summary ===
Total Tests: 839
Passed: 839
Failed: 0

✓ All tests passed!
```

**Bash / Zsh**

```sh
type kgp            # should print a function running \kubectl get pods "$@"
kgp --help          # runs kubectl, without touching the cluster
```

The full Bash and Zsh checks are part of the Python suite below.

## Run the full suite

```sh
python3 -m unittest discover -s tests -v                       # everything
python3 -m unittest discover -s tests -p 'test_posix_*.py' -v  # Bash and Zsh only
python3 tools/generate_aliases.py --check                      # generated files are up to date
pwsh -NoProfile -File tests/Smoke-Install.ps1                  # PowerShell installer, in a temp dir
```

It needs Python 3.11 or later. Tests that need a tool you don't have are skipped:

- PowerShell 7 (`pwsh`, or set `PWSH`) for the profile and quiz tests;
- `bash` and `zsh` for the shell tests, which need a POSIX system and do not run on Windows;
- the real `kubectl` (on `PATH`, or set `KUBECTL`) and bash-completion for the interactive
  Tab-completion tests.

## Continuous integration

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
