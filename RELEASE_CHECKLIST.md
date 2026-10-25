# Pre-Release Checklist

Use this checklist before tagging a release.

## Documentation ✅

- [x] README.md updated with all features
- [x] QUICKSTART.md created for new users
- [x] CHANGELOG.md created with version history
- [x] Table of Contents in README is complete
- [x] All aliases documented with mnemonics
- [x] Safety warnings prominently displayed
- [x] Contribution guidelines included

## Code Quality ✅

- [x] All scripts pass linting (`read_lints`)
- [x] Test suite passes: `.\Test-Profile.ps1`
- [x] Quiz mode works: `.\Test-Profile.ps1 -Quiz`
- [x] Anki export works: `.\Export-Anki.ps1`
- [x] Installation script tested: `.\Install-Profile.ps1`
- [x] Profile loads without errors
- [x] All documented aliases exist and work

## Files & Structure ✅

- [x] LICENSE file (MIT)
- [x] .gitignore configured
- [x] Version number in README (2.0.0)
- [x] Version number in profile header
- [x] CHANGELOG.md created
- [x] QUICKSTART.md created
- [x] Install-Profile.ps1 created

## Testing ✅

- [x] Test suite covers all documented aliases (54+)
- [x] Git aliases tested (17)
- [x] Terraform aliases tested (8)
- [x] Kubectl base commands tested (8)
- [x] Kubectl resources tested (11)
- [x] Kubectl outputs tested (7)
- [x] All kubectl expansions tested against tests/k-aliases.tsv (788)

## Features ✅

- [x] Interactive quiz mode
- [x] Usage tracking (optional)
- [x] Anki export
- [x] Collapsible documentation sections
- [x] Safety warnings
- [x] Contribution guidelines

## Pre-Release Steps

1. **Final Testing:**
   ```powershell
   .\Test-Profile.ps1
   .\Test-Profile.ps1 -Quiz
   .\Export-Anki.ps1
   ```

2. **Verify Installation:**
   ```powershell
   # Test on clean system
   .\Install-Profile.ps1 -SkipModules
   ```

3. **Update Version:**
   - [ ] Update version in README.md
   - [ ] Update version in profile header
   - [ ] Update CHANGELOG.md with release date

4. **Git Tag:**
   ```powershell
   git tag -a v2.0.0 -m "Release v2.0.0: Comprehensive mnemonic system with testing and learning tools"
   git push origin v2.0.0
   ```

5. **Release Notes:**
   - [ ] Create GitHub release with CHANGELOG highlights
   - [ ] Include installation instructions
   - [ ] Link to QUICKSTART.md

## Known Limitations

- Usage tracking is simplified (only tracks kgp as example)
- Some modules may not be available in all environments
- Profile requires PowerShell 5.1+ or PowerShell Core 7+

## Future Enhancements (v2.1+)

- [ ] Full usage tracking for all aliases
- [ ] Adaptive learning path based on usage
- [ ] More visual diagrams (Mermaid)
- [ ] Docker/Helm alias systems
- [ ] Profile modularization (separate files)
- [ ] CI/CD integration examples

