# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- `kgn`, `kdn`, `kxn` were defined twice; the later `--namespace` definitions silently
  overrode the documented `get/describe/delete namespaces`. The duplicates are removed.
- `Test-Profile.ps1` could never fail: results were appended to function-local copies, so it
  always reported 0 tests and "All tests passed".
- README example `ka -f deploy.yaml` expanded to `apply --recursive -f -f deploy.yaml`;
  it is now `ka deploy.yaml`.

### Removed
- `dy` and `f` helper functions. They emit strings, so as trailing words kubectl received the
  literal text `dy`/`f` instead of the flags.

### Added
- `tests/k-aliases.tsv`: the 788 `k*` names and their kubectl arguments. `Test-Profile.ps1`
  checks every function body against it and fails on duplicate or unlisted definitions.
- README/profile notes on `aa` meaning `--all` for delete (`kxpaa`), long-form synonyms
  (`oyaml`, `owide`, `ojson`, `all`) and the `n` resource-vs-flag ambiguity (`kgnso`).

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

