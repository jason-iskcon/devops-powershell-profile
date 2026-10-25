# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - Unreleased

The kubectl "K system" is now generated from one grammar and also works in Bash and Zsh.
785 of the 788 K-system aliases behave exactly as in 2.0.0, three were corrected (below), and
two helper functions were removed. See "Upgrading from 2.0.0" in the README.

### Breaking changes
- **`dy` and `f` are removed.** They never worked through the K aliases: the documented
  `k create deploy nginx --image=nginx dy` passes the literal word `dy`, and `(dy)` passes one
  mangled argument. They did work when handed straight to the native command, for example
  `kubectl delete pod x (f)`; that no longer works. Write `--dry-run=client -o=yaml` or
  `--force --grace-period=0` instead.
- **`kgn`, `kdn` and `kxn` now do what the README always said** (`kubectl get|describe|delete
  namespaces`). In 2.0.0 each was defined twice and the later, undocumented definition
  (`... --namespace $args`) was the one in effect. They are the only three of the 788 aliases
  whose behaviour differs from 2.0.0; this was checked by loading both profiles in PowerShell
  and comparing every function body.
- **The kubectl aliases now live in `k-aliases.ps1`, which the profile loads from its own
  folder.** `Install-Profile.ps1` copies both files. A manual install that copies only
  `Microsoft.Powershell_profile.ps1` now shows a warning at start-up and has no kubectl aliases
  until `k-aliases.ps1` is copied beside it.

### Added
- **Bash and Zsh support** (`posix/`): the 788 aliases as shell functions generated from the
  same grammar, with fixed arguments shell-quoted and `"$@"` forwarding; no `eval`.
- **kubectl-aware tab completion** for Bash and Zsh: `kzgp <TAB>` completes as
  `kubectl --namespace=kube-system get pods <TAB>`, using kubectl's own completion.
- **`posix/install.sh`**: idempotent, reversible installer for `~/.bashrc` and `~/.zshrc`
  (one marked block, backups that are never overwritten, writes through symlinks, `--dry-run`,
  `--shell auto|bash|zsh|both`). Uninstalling one shell keeps the files the other still uses.
- **One source of truth**: `k-grammar.toml` expanded by `tools/generate_aliases.py` into
  `k-aliases.ps1` and `posix/*.sh`, with `--check` to detect drift. The grammar is validated
  (unknown keys, bad references, unused blocks, malformed sequences, reserved names, and
  argument tokens that would not be inert in unquoted PowerShell).
- **Compatibility contract**: `tests/k-aliases.tsv` lists the 788 original aliases and is
  frozen (its hash is tested). New aliases carry `added = "x.y.z"` in the grammar and are listed
  in `tests/k-additions.tsv`.
- **Continuous integration** (GitHub Actions): grammar and PowerShell tests on Linux; Bash and
  Zsh tests with ShellCheck on Linux; installer smoke test and the full `Test-Profile.ps1`
  against the real PowerShell modules on Windows PowerShell 7, and with stand-in modules on
  Windows PowerShell 5.1.
- `Test-Profile.ps1 -KubectlOnly` checks just the kubectl functions.
- A clear start-up warning when `k-aliases.ps1` is missing next to the profile.
- `tests/test_release_metadata.py` keeps the version identical in the README, the profile
  header, this changelog and the release notes.

### Changed
- The 788 kubectl functions are generated rather than hand-written; the generated functions are
  byte-for-byte the ones the profile used to contain, apart from the three corrected above.
- `Test-Profile.ps1` compares every `k*` function with the manifests and fails on duplicate or
  unlisted definitions.
- README and profile comments document that `aa` means `--all` with delete (`kxpaa` deletes every
  pod in the current namespace), the long-form synonyms (`oyaml`, `owide`, `ojson`, `all`) and
  the `n` resource-versus-flag ambiguity (`kgnso`).
- The profile no longer calls `Clear-Host` when output is redirected.
- The README example `ka -f deploy.yaml` is now `ka deploy.yaml`: `ka` already includes `-f`.

### Fixed
- `Test-Profile.ps1` could never fail: results were appended to function-local copies, so it
  always reported 0 tests and "All tests passed".
- `Test-Profile.ps1 -Quiz` was unreachable because the summary exited first.
- A single failing check was reported as "Failed: 5" (the key count of one hashtable).
- `Install-Profile.ps1` called a Windows-only API unconditionally and failed on PowerShell 7
  for Linux and macOS.
- Loading the profile threw "The handle is invalid" when there was no console (`Clear-Host`).
- **`Install-Profile.ps1`, `Test-Profile.ps1` and `Export-Anki.ps1` did not parse under Windows
  PowerShell 5.1** ("The string is missing the terminator"). They are UTF-8 without a byte-order
  mark and contain characters such as `✓`; 5.1 reads such a file as Windows-1252, where a byte of
  `✓` is a curly double quote that PowerShell treats as a string delimiter. They now start with a
  UTF-8 BOM (no change on PowerShell 7), and `tests/test_encoding.py` keeps it that way. Earlier
  releases claimed 5.1 support without it ever being run.

### Removed
- The `gs` (git status) alias from the README, `Test-Profile.ps1`, the Anki export and the
  checklist. The real `git-aliases` module does not define it, so nothing worked differently;
  defining it in the profile would shadow Ghostscript's `gs`.
- The `dy` and `f` helper functions (see Breaking changes).

## [2.0.0] - 2024

### Added
- **Interactive Quiz Mode** - Test your knowledge with `.\Test-Profile.ps1 -Quiz`
- **Anki Export** - Generate flashcards for spaced repetition learning (`.\Export-Anki.ps1`)
- **Usage Tracking** - Optional alias usage tracking (enable with `$env:TRACK_ALIAS_USAGE = "true"`)
- **Comprehensive Test Suite** - Validates all 54+ documented aliases
- **Enhanced Documentation**:
  - Collapsible sections for advanced tiers
  - Prominent safety warnings for destructive commands
  - Contribution guidelines
  - Usage tracking documentation
- **Terraform Aliases** - Added `td`, `tv`, `tfmt`, `tpt`, `tat`
- **Kubectl Shortcuts** - Added `kgpaay` and other output format combinations

### Changed
- **Terse Aliases** - All aliases shortened for maximum efficiency:
  - Terraform: `tfi` → `ti`, `tfp` → `tp`, `tfa` → `ta`
  - Kubectl: `kc` → `k`, `sys` → `z`, `rm` → `x`, `oyaml` → `y`, `ojson` → `j`
- **Improved Mnemonics** - Enhanced mnemonic system with:
  - Tiered learning approach
  - Workflow stories
  - Conflict resolution rules
  - Visual memory aids
- **Documentation Structure** - Reorganized with table of contents and progressive disclosure

### Fixed
- Profile compatibility with README documentation
- Helper functions (`dy`, `f`) implementation
- Kubectl resource alias conflicts

### Security
- Added prominent warnings for destructive commands (`ta`, `td`, `kx`)
- Usage tracking disabled by default for privacy

## [1.0.0] - Initial Release

### Added
- Git aliases (via git-aliases module)
- Terraform aliases
- Kubectl aliases
- Basic PowerShell profile setup

