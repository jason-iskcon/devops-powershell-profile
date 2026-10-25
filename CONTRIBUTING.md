# Contributing

We welcome contributions! Here's how to add new aliases or improve existing ones.

## Adding New Aliases

1. **Follow the mnemonic system:**
   - Use consistent prefix patterns (G for Git, T for Terraform, K for Kubectl)
   - Document the mnemonic rationale
   - Check for conflicts: `Get-Alias <proposed-name>` (PowerShell) or `type <proposed-name>` (bash/zsh)

2. **Kubectl (the K system):**
   - Do **not** edit `k-aliases.ps1` or the files in `posix/`; they are generated. Edit
     `k-grammar.toml`, then run `python3 tools/generate_aliases.py` (Python 3.11+) and commit
     the grammar and the generated files together.
   - `tests/k-aliases.tsv` is the frozen list of the original 788 aliases and a test pins its
     hash. Never edit it. Mark new `[[commands]]`/`[[aliases]]` entries with
     `added = "x.y.z"` (the release that adds them) and list them in
     `tests/k-additions.tsv` (`name<TAB>kubectl args`). `Test-Profile.ps1` and the bash/zsh
     tests check every alias in both files, so no other test change is needed.
   - The generator rejects malformed entries, unknown keys, unsafe argument tokens and
     duplicate names, so run it before committing.

3. **Terraform:** add the function to `Microsoft.Powershell_profile.ps1` and to the Terraform
   list in `Test-Profile.ps1`:
   ```powershell
   # <alias> - <full command> (<mnemonic explanation>)
   function <alias> { <full command> $args }
   ```

4. **Git:** the Git aliases come from the `git-aliases` module, not from this repository. To
   document another one the module provides, add it to the Git section of
   [docs/git-terraform.md](docs/git-terraform.md), to the Git list in `Test-Profile.ps1` and to
   `GIT_ALIASES` in `tests/test_test_profile.py`; a test keeps the three in step.

5. **Update documentation:** add the alias to the right tier in [docs/kubectl.md](docs/kubectl.md)
   or [docs/git-terraform.md](docs/git-terraform.md), with its mnemonic explanation.

## Testing Your Changes

1. Run the test suites (see [docs/testing.md](docs/testing.md) for details):
   ```powershell
   .\Test-Profile.ps1
   ```
   ```bash
   python3 -m unittest discover -s tests -v          # grammar vs the manifests, quiz, validation
   python3 tools/generate_aliases.py --check         # the generated files are up to date
   pwsh -NoProfile -File tests/Smoke-Install.ps1     # installs into a temp dir and tests the result
   ```
   Tests that need PowerShell 7 (`pwsh`, or set `PWSH`), kubectl, bash or zsh are skipped when
   the tool is missing. CI runs everything on Linux and runs the installer smoke test on Windows.

2. Test manually:
   ```powershell
   . $PROFILE
   <your-alias> --help  # Test execution
   ```

3. Check for conflicts:
   ```powershell
   Get-Alias <your-alias>
   Get-Command <your-alias>
   ```

## Pull Request Checklist

- [ ] Alias follows mnemonic system
- [ ] No conflicts with existing aliases
- [ ] Added to appropriate tier in the docs
- [ ] Listed in `tests/k-additions.tsv` (kubectl) or `Test-Profile.ps1` (Git, Terraform)
- [ ] Tested locally

## Questions?

Open an issue or discussion for:
- Proposing new alias systems (e.g., Docker, Helm)
- Suggesting improvements to mnemonics
- Reporting conflicts or bugs
