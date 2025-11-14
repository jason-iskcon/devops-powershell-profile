# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

