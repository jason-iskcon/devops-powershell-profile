# Release Checklist — v3.0.0

`[x]` means it was done **and the evidence is named**. `[ ]` means it is open: either an owner
action, or something that has **not** been verified. Nothing here is ticked on assumption.

Evidence was gathered on release-candidate code commit `cd15814` (branch `release/rc-prep`, based on
`main` at merge commit `11341d1`); later commits change documentation only. Local tool versions: bash 5.2.21, zsh 5.9, PowerShell 7.4.6,
kubectl v1.37.1 (checksum verified), ShellCheck 0.11.0, Python 3.13. CI: [run 40152676325](https://github.com/jason-iskcon/devops-powershell-profile/actions/runs/40152676325), all four jobs green.

## 1. Version and metadata

- [x] Version is identical in the README banner, the profile's first line and the newest CHANGELOG
      section — `python3 -m unittest discover -s tests -p test_release_metadata.py`.
- [x] Release notes exist for this version: `release-notes/v3.0.0.md` (same test).
- [x] Version assessment done: **major (3.0.0)** — see "Why 3.0.0" below.
- [ ] Owner confirms 3.0.0 (the only places that change if not: README banner, profile line 1,
      CHANGELOG heading, `release-notes/` file name, the tag commands below — the metadata test
      fails until they agree).
- [ ] Fill in the release date in the CHANGELOG heading (`## [3.0.0] - YYYY-MM-DD`).
- [ ] Decide whether to tag the original commit `7256473` as `v2.0.0`. The repository has **no tags
      and no GitHub releases**, although the CHANGELOG describes 1.0.0 and 2.0.0 (and dates 2.0.0 as
      "2024"; the only commit is dated 2025-11-14 — owner to confirm). Tagging it makes
      `v2.0.0...v3.0.0` comparisons work; skipping it is also fine.

### Why 3.0.0

The CHANGELOG commits the project to Semantic Versioning, and a backward-incompatible change to the
documented interface is a major bump. This release has three:

1. `dy` and `f` are removed. They never worked through the K aliases, but they did work when
   handed to the native command (`kubectl delete pod x (f)` — verified by loading the 2.0.0
   profile), so removing them breaks that use.
2. `kgn`, `kdn`, `kxn` changed behaviour (2.0.0 effectively ran `… --namespace`; they now run
   `… namespaces`, as documented). Verified by loading both profiles in PowerShell and comparing
   all 788 function bodies: **785 identical, 3 different**.
3. The kubectl aliases moved to `k-aliases.ps1`, so a hand-copied profile loses them.

A minor release (2.1.0) would be defensible only if `dy`/`f` were kept and the three aliases left
broken, which defeats the purpose. Everything else (Bash/Zsh, generator, tests, CI) is additive.

## 2. Compatibility

- [x] The 788 original expansions are unchanged — the grammar reproduces the frozen manifest
      exactly (`tests/test_generate_aliases.py`: `GrammarMatchesManifests`), PowerShell checks
      "Checked 788 kubectl aliases" (`Test-Profile.ps1`), and Bash and Zsh run every function
      against a stub kubectl (`tests/test_posix_functions.py`).
- [x] The manifest is frozen: `tests/k-aliases.tsv` is pinned by SHA-256
      (`ManifestIsFrozen`); it has 788 entries.
- [x] New aliases must use the additions mechanism (`added = "x.y.z"` + `tests/k-additions.tsv`,
      currently empty); an added alias that reuses an existing name is rejected.
- [x] Behaviour versus the real 2.0.0 profile: 785 of 788 identical, 3 corrected (section 1).
- [x] Breaking changes are documented in the CHANGELOG, the README ("Upgrading from 2.0.0") and the
      release notes.
- [x] Bash/Zsh and PowerShell differences are documented in the README table (`\kubectl` versus
      `& kubectl`, alias handling, what is not ported).

## 3. Installation

- [x] Windows PowerShell 7: install, reinstall over an existing profile (backup made exactly once),
      fresh-shell load, 788 expansions — CI job "Installer and generated functions (Windows)",
      `tests/Smoke-Install.ps1`, plus the full `Test-Profile.ps1` against the real modules.
- [x] Windows PowerShell 5.1 (`powershell.exe`) with **stand-in modules**: install, reinstall (one
      backup), fresh-shell load, 788 expansions (`Test-Profile.ps1 -KubectlOnly`, 814 of 814) — CI job
      "Installer and profile under Windows PowerShell 5.1 (stand-in modules)".
- [ ] Windows PowerShell 5.1 with the **real** PowerShell Gallery modules — **not verified**: that CI
      job hung while installing them (twice; cause not determined), so the job uses stand-ins.
- [x] The scripts parse under 5.1: `Install-Profile.ps1`, `Test-Profile.ps1` and `Export-Anki.ps1`
      failed to parse there until a UTF-8 BOM was added (found by this CI job);
      `tests/test_encoding.py` keeps it that way.
- [x] Upgrade by copying only the profile file: reproduced; now gives a clear warning
      (`tests/test_test_profile.py`: `ProfileNeedsItsGeneratedAliasFile`).
- [x] Bash and Zsh install, `--shell auto|bash|zsh|both`, idempotence (second run changes
      nothing), `uninstall` restores rc files byte for byte, `--dry-run` — `tests/test_posix_install.py`
      (37 tests; the byte-for-byte restore test runs the script under `sh`, `dash` and `bash`).
- [x] Partial uninstall keeps the other shell working (install both → uninstall bash → zsh runs →
      uninstall zsh; and the reverse) — `PartialUninstall`.
- [x] Damaged or out-of-order markers are refused before any change, for install and uninstall —
      `Refusals`.
- [x] Existing configuration preserved: content around the block survives, symlinked rc files are
      edited through the link, permissions kept, backups never overwritten.
- [ ] Installers on macOS — **not tested**.
- [ ] Bash/Zsh installer on a clean machine other than the CI runner — not done by hand.

## 4. Testing

- [x] Full suite with every external tool present: **114 tests, OK, none skipped**
      (`python3 -m unittest discover -s tests`).
- [x] Generator consistency: `python3 tools/generate_aliases.py --check` — all generated files
      current (also a CI step).
- [x] ShellCheck 0.11.0 clean on `posix/install.sh` (sh) and the bash files (also a CI step).
- [x] Tests that depend on something external were identified. With `pwsh` and `kubectl` hidden,
      **15 of 114 skip**: 9 need PowerShell 7 (`PWSH`), 6 need the real kubectl
      (`KUBECTL`; the bash ones also need bash-completion). The Bash/Zsh tests need a POSIX system
      and do not run on Windows. CI asserts the tools are present so nothing skips silently there.
- [x] CI covers Linux (grammar, PowerShell, Bash, Zsh) and Windows (PowerShell 7; 5.1 see section 3).
      Main at merge commit `11341d1`: run 40150961485, all jobs green. RC: [run 40152676325](https://github.com/jason-iskcon/devops-powershell-profile/actions/runs/40152676325) (four jobs green).
- [ ] Live resource-name completion (pod names etc.) — **not tested**: no cluster was available.
      What is tested: kubectl receives the right implicit arguments, and flags and flag values
      complete.
- [ ] Python tests on Windows or macOS — not run.

## 5. Security and safety

- [x] No `eval` in the project's shell code (`test_no_eval_in_our_shell_code`; grep of `posix/`).
      The only dynamic loads are `source <(kubectl completion bash|zsh)`, which run the output of
      whichever `kubectl` is first on `PATH` (documented).
- [x] Arguments forwarded verbatim and not evaluated (`"$@"`; tests with spaces, globs, `$(…)`,
      quotes) in Bash and Zsh.
- [x] A user's `kubectl` shell function is honoured, called exactly once per alias, no recursion;
      an `alias kubectl=…` is not expanded — `SafetyAndRobustness`.
- [x] Grammar rejects tokens that would not be inert in the unquoted PowerShell output.
- [x] Destructive aliases are documented: `kx…` delete, `aa` meaning `--all` with delete (`kxpaa`),
      `ta` (`terraform apply --auto-approve`), `td`. Their expansions are unchanged.
- [x] No privilege escalation or destructive installer behaviour: no `sudo`, `curl`, `chmod` or
      `rm -r` in `posix/install.sh`; `Install-Profile.ps1` installs modules with
      `-Scope CurrentUser`. The POSIX uninstall removes only the files it installed.
- [ ] Independent security review — not done.

## 6. Documentation

- [x] `CHANGELOG.md` — 3.0.0 section: breaking changes, added, changed, fixed, removed.
- [x] `README.md` — version, accurate feature counts, requirements and supported-platform table
      (tested / not tested), upgrade notes, Bash/Zsh section, test commands.
- [x] `QUICKSTART.md` — minimal install for PowerShell and Bash/Zsh, upgrade pointer, the
      missing-`k-aliases.ps1` fix.
- [x] `release-notes/v3.0.0.md` — standalone GitHub Release draft.
- [x] No unsupported alias expectation remains: `gs` removed (README, tests, Anki export); the full
      suite passes against the real modules in Windows CI.
- [x] Anki export runs: `Export-Anki.ps1` under PowerShell 7.4.6 writes `aliases-anki.csv` (28 lines,
      no `gs` card).

## 7. Publishing (owner actions — nothing below has been done)

1. Merge `release/rc-prep` into `main` after review.
2. Optional release candidate:
   ```sh
   git tag -a v3.0.0-rc.1 -m "v3.0.0 release candidate 1"
   git push origin v3.0.0-rc.1        # then publish a *pre-release* from release-notes/v3.0.0.md
   ```
3. Final release: set the date in the CHANGELOG, then
   ```sh
   git tag -a v3.0.0 -m "v3.0.0: K-system aliases generated from one grammar; Bash/Zsh support"
   git push origin v3.0.0
   ```
   and create the GitHub Release from `release-notes/v3.0.0.md` (refresh the verification links).
4. Confirm CI is green on the tagged commit.

## Known limitations

- Usage tracking only tracks `kgp` as an example.
- Only the kubectl K system is ported to Bash/Zsh; Git and Terraform aliases and the PowerShell
  helpers are not.
- Fish and macOS are unsupported/untested; bash completion needs bash 4.1+ and bash-completion.
- Uninstall leaves an empty shell file if the installer created it.
