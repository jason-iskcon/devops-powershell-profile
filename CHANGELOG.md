# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- `Test-Profile.ps1 -Quiz` was unreachable because the summary exited first; the exit code is
  now deferred until after the quiz (regression test in `tests/test_test_profile.py`).
- `Install-Profile.ps1` called a Windows-only API unconditionally and failed on PowerShell 7
  for Linux/macOS.
- `kgn`, `kdn`, `kxn` were defined twice; the later `--namespace` definitions silently
  overrode the documented `get/describe/delete namespaces`. The duplicates are removed.
- `Test-Profile.ps1` could never fail: results were appended to function-local copies, so it
  always reported 0 tests and "All tests passed".
- README example `ka -f deploy.yaml` expanded to `apply --recursive -f -f deploy.yaml`;
  it is now `ka deploy.yaml`.

### Removed
- `dy` and `f` helper functions. They emit strings, so as trailing words kubectl received the
  literal text `dy`/`f` instead of the flags.

### Added (Bash and Zsh)
- `posix/`: the 788 K-system aliases as bash/zsh functions generated from `k-grammar.toml`
  (`k-aliases.sh`), with fixed arguments shell-quoted and `"$@"` forwarding; no `eval`.
- kubectl-aware tab completion for bash and zsh: each alias completes as the `kubectl`
  command it stands for, using kubectl's own completion (`k-completion.bash`, `.zsh`).
- `posix/install.sh`: idempotent, reversible, non-destructive installer for `~/.bashrc` and
  `~/.zshrc` (one marked block, backups that are never overwritten, writes through symlinks).
- Tests: parity of every function with the manifests in bash and zsh, argument-forwarding and
  injection checks, completion wrapper tests, interactive Tab tests against the real kubectl,
  and installer tests.

### Changed (Bash and Zsh)
- The functions now call `\kubectl` instead of `command kubectl`, so a user's `kubectl` shell
  function (a wrapper that adds a context, logs, ...) is honoured, as in PowerShell, while an
  `alias kubectl=...` is still not expanded. All 788 expansions are unchanged.

### Removed
- `gs` (git status) from the README, `Test-Profile.ps1`, the Anki export and the checklist
  count. The real `git-aliases` module does not define it (found on a Windows CI runner), and
  defining it in the profile would shadow Ghostscript's `gs`. The Windows CI job now runs the
  full `Test-Profile.ps1` against the real modules, and a test keeps the documented and tested
  Git aliases identical.

### Fixed (Bash and Zsh installer)
- `uninstall --shell bash` deleted the shared files while `~/.zshrc` still sourced them (and
  vice versa, and also when the other shell was never installed). The shared files are now kept
  until no remaining rc file uses them.
- An rc file with the end marker before the begin marker passed the marker-count check, and
  the installer then deleted everything after the begin marker. Marker order is checked, for
  every selected file, before any change.
- `--shell auto`, listed in the usage text, was rejected; it now picks the shell from `$SHELL`
  (the default for install; uninstall defaults to both).

### Changed
- The 788 kubectl functions are now generated from `k-grammar.toml` by
  `tools/generate_aliases.py` into `k-aliases.ps1`, which the profile dot-sources. The
  generated functions are byte-for-byte the ones the profile used to contain.
  `Install-Profile.ps1` copies `k-aliases.ps1` next to the profile; a manual install must too.
  Editing the aliases now means editing the grammar (see Contribution Guidelines).

### Added
- GitHub Actions workflow: grammar/generator/PowerShell tests on Linux, and an installer
  smoke test on Windows (`tests/Smoke-Install.ps1`, which installs into a temporary
  directory).
- Aliases added after the original 788 are marked `added = "x.y.z"` in `k-grammar.toml` and
  listed in `tests/k-additions.tsv`; `tests/k-aliases.tsv` is frozen and its hash is tested.
- The generator now rejects unknown keys, bad references, unused blocks, malformed or
  repeated modifier sequences, reserved or unsafe names, and argument tokens that would not
  be inert in the unquoted PowerShell output.
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

