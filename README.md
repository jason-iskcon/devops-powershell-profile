# powershell-profile

> **Last updated:** 2024 | **Version:** 2.0.0

A DevOps-focused PowerShell profile with a comprehensive mnemonic system for Git, Terraform, and Kubectl commands.

**Features:**
- 🚀 **54+ terse aliases** - Reduce typing by 80-90%
- 🧠 **Mnemonic system** - Easy to remember with tiered learning
- ✅ **Test suite** - Validate all aliases work correctly
- 📚 **Interactive quiz** - Test your knowledge
- 📊 **Usage tracking** - Optional analytics
- 🎴 **Anki export** - Spaced repetition flashcards

**Quick Install:**
```powershell
.\Install-Profile.ps1
```

📖 **New to this?** Start with the [Quick Start Guide](QUICKSTART.md) (5 minutes)

See [How to use](#how-to-use) for detailed installation instructions.

## Table of Contents

- [How to use](#how-to-use)
- [Why Learn This System?](#why-learn-this-system)
- [Command Aliases](#command-aliases)
  - [Git - The "G" System](#git---the-g-system-)
  - [Terraform - The "T" System](#terraform---the-t-system-)
  - [Kubectl - The "K" System](#kubectl---the-k-system-)
- [Testing](#testing)
- [Usage Tracking (Optional)](#usage-tracking-optional)
- [Contribution Guidelines](#contribution-guidelines)
- [Common Workflow Cards](#common-workflow-cards-)
- [Learning Path with Checkpoints](#learning-path-with-checkpoints)
- [Memory Reinforcement](#memory-reinforcement)
- [Visual Memory Aids](#visual-memory-aids)
- [When NOT to Use Aliases](#when-not-to-use-aliases)
- [Troubleshooting](#troubleshooting)

## How to use

### Quick Install (Recommended)

Run the automated installation script:

```powershell
# From the profile directory
.\Install-Profile.ps1

# Or skip module installation (if already installed)
.\Install-Profile.ps1 -SkipModules

# Force overwrite existing profile
.\Install-Profile.ps1 -Force
```

The script will:
1. Install required PowerShell modules (posh-git, git-aliases, PSKubectlCompletion)
2. Create your profile directory if needed
3. Copy the profile file to the correct location
4. Create a backup of existing profile (if present)

### Manual Install

1. **Install PowerShell modules** (requires admin or use `-Scope CurrentUser`):

```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module git-aliases -Scope CurrentUser
Install-Module PSKubectlCompletion -Scope CurrentUser
```

2. **Copy the profile file:**

```powershell
# Find your profile path
$profile

# Copy the profile (adjust source path as needed)
Copy-Item Microsoft.Powershell_profile.ps1 $PROFILE
```

3. **Reload your profile:**

```powershell
. $PROFILE
```

### Verify Installation

Test that everything works:

```powershell
.\Test-Profile.ps1
```

All tests should pass! ✅

## Why Learn This System?

**The Problem:** Typing long commands is slow and error-prone.

**The Solution:** Short, memorable aliases that reduce typing by 80-90%.

**Real Impact:**

| Command | Before | After | Reduction |
|---------|--------|-------|-----------|
| `kubectl get pods --all-namespaces -o yaml` | 43 chars | `kgpaay` (6 chars) | **86%** |
| `git commit -m "message"` | 20 chars | `gcmsg "message"` (16 chars) | **20%** |
| `terraform apply --auto-approve` | 29 chars | `ta` (2 chars) | **93%** |

**Time Saved:** For daily DevOps work, this saves **100+ hours per year** in typing time alone, plus reduces mental fatigue and typos.

**Learning Curve:** Master the Tier 1 commands in Week 1, and you'll see immediate productivity gains.

## Command Aliases

> **⚠️ Important:** These aliases use a **layered learning approach**. Start with Tier 1 (Essential 10), master those, then move to Tier 2. Don't try to memorize everything at once!

### Git - The "G" System 📝

**Base Rule:** All git aliases start with `g` (for **G**it)

**Abbreviation Strategy:** First letter of command + distinctive consonant when needed

#### Tier 1: Essential Daily Commands (Memorize These First!)

**The Daily Workflow Story:** "**A**dd ingredients, **C**ook meal, **P**late it, **P**our drinks for **L**unch"

```
ga      - git add                    (G + A = Add)
gaa     - git add --all              (double A = "all")
gcmsg   - git commit -m              (G + Commit + MeSsaGe)
gp      - git push                   (G + P = Push)
gl      - git pull                   (G + L = puLl - last letter to avoid conflict)
```

**⚠️ Note:** `gl` means **pull** (not log). Think "pu**L**l" uses the last letter. For log, use `glog` (full word to avoid confusion).

**Daily Practice Drill:**
```powershell
ga .                    # Add files
gcmsg "fix bug"         # Commit with message
gp                      # Push changes
gl                      # Pull latest
```

<details>
<summary><strong>▶ Tier 2: Branching & Navigation</strong> (Click to expand)</summary>

**Pattern:** Action + Object initial letters

```
gco     - git checkout               (G + CheckOut)
gcb     - git checkout -b            (G + Checkout Branch)
gbr     - git branch                 (G + BRanch)
gbd     - git branch -d              (G + Branch Delete)
```

</details>

<details>
<summary><strong>▶ Tier 3: Status, Diff & Stash</strong> (Click to expand)</summary>

```
gs      - git status                 (G + Status)
gd      - git diff                   (G + Diff)
gds     - git diff --staged          (G + Diff Staged)
gst     - git stash                  (G + STash)
gsta    - git stash apply            (G + STash Apply)
gstd    - git stash drop             (G + STash Drop)
```

</details>

<details>
<summary><strong>▶ Tier 4: Advanced Commands</strong> (Click to expand)</summary>

```
gcl     - git clone                  (G + CLone)
glog    - git log                    (G + LOG - full word to avoid confusion with pull)
gsh     - git show                   (G + SHow)
```

</details>

**⚠️ Why `glog` not `glo`?** Since `gl` = pull (last letter), we use the full word `glog` to clearly distinguish log from pull.

### Git Conflict Resolution Rules

When abbreviations collide, we use these rules:

1. **First letter wins** for most common command
   - `gp` = push (more common than pull)
   - `gl` = pull (uses last letter to avoid conflict)

2. **Add distinctive consonant** for less common
   - `glog` = log (adds 'og' to distinguish from pull)

3. **Double letters** for "all" modifier
   - `gaa` = add all (double A pattern)

### Git Quick Reference

```
┌─────────────────────────────────────────┐
│ ESSENTIAL DAILY WORKFLOW                │
├─────────────────────────────────────────┤
│ ga .          → Add files               │
│ gcmsg "msg"   → Commit with message     │
│ gp            → Push changes            │
│ gl            → Pull latest             │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ BRANCHING                               │
├─────────────────────────────────────────┤
│ gcb name     → Create & checkout branch │
│ gco name     → Checkout existing branch │
│ gbr          → List branches            │
│ gbd name     → Delete branch            │
└─────────────────────────────────────────┘
```

> **Note:** The `git-aliases` module provides many more aliases. Run `Get-Command g*` to see all available git aliases.

### Terraform - The "T" System 🏗️

**Pattern:** Terraform + first letter of action

**The Workflow Story:** "**I**nitialize, **P**lan ahead, **A**pply changes, **D**estroy when done"

#### Essential Commands

```
ti      - terraform init             (Terraform Init)
tp      - terraform plan             (Terraform Plan)
ta      - terraform apply            (Terraform Apply --auto-approve)
td      - terraform destroy          (Terraform Destroy)
tv      - terraform validate         (Terraform Validate)
tfmt    - terraform fmt              (Terraform ForMaT)
```

#### With Target Flags

```
tpt     - terraform plan -target=   (Plan with Target)
tat     - terraform apply -target= --auto-approve  (Apply with Target)
```

**Daily Practice Drill:**
```powershell
ti                          # Initialize
tp                          # Plan changes
ta                          # Apply (with auto-approve)
```

**⚠️ ⚠️ ⚠️ SAFETY WARNING ⚠️ ⚠️ ⚠️**

> **`ta` includes `--auto-approve`** - This will apply changes WITHOUT confirmation!
> 
> **Use `terraform apply` (full command) when you need confirmation prompts.**
> 
> **`td` (terraform destroy) is also destructive - use with extreme caution!**

### Kubectl - The "K" System 🎯

**Base:** `k` = kubectl (first letter)

**⚠️ Important Notes:**
- Some aliases use arbitrary choices (like `z` for system, `x` for delete) - these are documented exceptions
- Resource abbreviations vary: some use first letter (`p`), some use first two (`de`), some use middle letters (`sv`)
- Learn the pattern, not every combination

#### Tier 1: Essential Verbs (Memorize These First!)

**The K8s Workflow Story:** "**G**et info, **D**escribe details, **A**pply fixes, **L**ook at logs"

```
kg      - kubectl get                (K + Get)
kd      - kubectl describe           (K + Describe)
kx      - kubectl delete             (K + eXterminate - exception!)
ka      - kubectl apply --recursive -f   (K + Apply; pass a path: ka deploy.yaml)
kl      - kubectl logs -f            (K + Logs; always follows)
ke      - kubectl exec -i -t         (K + Exec)
```

**⚠️ ⚠️ ⚠️ DESTRUCTIVE COMMAND ⚠️ ⚠️ ⚠️**

> **`kx` = delete (not `d` because `d` is describe). Think "e**X**terminate".**
> 
> **This permanently deletes resources! Always double-check before using.**

<details>
<summary><strong>▶ Tier 2: Common Resources</strong> (Click to expand)</summary>

**Pattern:** Mixed strategies (first letter OR first two letters OR distinctive pattern)

```
p       - pods                       (first letter)
de      - deployment                (first two - avoids conflict with describe)
i       - ingress                   (first letter)
sv      - service                   (S + V = serVice - distinctive consonants)
c       - configmap                 (first letter)
se      - secret                    (S + E = sEcret - first letter + second vowel)
n       - namespace                 (first letter)
no      - node                      (first two: NOde)
```

**⚠️ Why the inconsistency?** 
- `d` is already used for "describe", so deployment uses `de` (first two letters)
- `s` would conflict with "secret", so service uses `sv` (S + V = distinctive consonants)
- Most others use first letter(s) when no conflict exists

</details>

<details>
<summary><strong>▶ Tier 3: Output Formats & Flags</strong> (Click to expand)</summary>

```
y       - yaml output               (Y = Yaml)
j       - json output               (J = Json)
o       - wide output               (O = Output-wide)
aa      - all-namespaces (delete: --all)  (double A = "all")
w       - watch                     (W = Watch)
sl      - show-labels               (Show Labels)
```

</details>

<details>
<summary><strong>▶ Tier 4: System Namespace</strong> (Click to expand)</summary>

```
z       - kube-system namespace      (Z = "zone zero" - the system zone where k8s lives)
```

**⚠️ Exception:** `z` is a mnemonic for "zone zero" - think of kube-system as the special system zone. This is a documented exception to the normal abbreviation rules.

</details>

### Kubectl Pattern Formula

**Pattern:** `k + [system] + verb + resource + [format] + [flags]`

**Structure:**
```
k + [z] + verb + resource + [y|j|o] + [w|aa|sl]
└─ required ─┘ └────────── optional ──────────┘
```

**Examples:**
```
k  + g  + p        = kgp          (get pods)
k  + z + g  + p    = kzgp         (get pods in kube-system)
k  + g  + p  + y   = kgpy         (get pods as yaml)
k  + g  + p  + w   = kgpw         (get pods watch)
k  + g  + p  + aa  = kgpaa        (get pods all namespaces)
k  + d  + p        = kdp          (describe pods)
k  + x  + p        = kxp          (delete pods)
k  + g  + de + y   = kgdey        (get deployment yaml)
```

### Kubectl Conflict Resolution Rules

1. **First letter wins** for most common
   - `d` = describe (more common than delete)
   - `x` = delete (exception: uses X for "exterminate")

2. **Add letters** when conflict exists
   - `de` = deployment (avoids conflict with describe)
   - `sv` = service (avoids conflict with secret)

3. **Double letters** for "all" modifier
   - `aa` = `--all-namespaces` with `get`/`describe`
   - `aa` = `--all` with `x` (delete): `kxpaa` = `kubectl delete pods --all`, which deletes every pod in the **current** namespace. Treat any `kx…aa` alias as destructive.

4. **Long forms** are synonyms: `kgpaaoyaml` = `kgpaay`, and likewise `owide`/`ojson` and `all` (for `aa`)

5. **`n` means two things**: as a resource, `n` is namespaces (`kgn`); as a trailing flag it is `--namespace` (`kgpn`). `kgno` is nodes, so namespaces with wide output is `kgnso`/`kgnsoall`.

### Kubectl Quick Reference

```
┌─────────────────────────────────────────┐
│ ESSENTIAL DAILY COMMANDS                │
├─────────────────────────────────────────┤
│ kg pods          → Get pods             │
│ kd pod/name      → Describe pod         │
│ kl pod/name      → Logs from pod        │
│ ke pod/name      → Exec into pod        │
│ kx pod name      → Delete pod           │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ COMMON RESOURCES                        │
├─────────────────────────────────────────┤
│ kgp      - get pods                     │
│ kgde     - get deployments              │
│ kgsv     - get services                 │
│ kgi      - get ingress                  │
│ kgc      - get configmaps               │
│ kgse     - get secrets                  │
│ kgn      - get namespaces               │
│ kgno     - get nodes                    │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ OUTPUT FORMATS                          │
├─────────────────────────────────────────┤
│ kgpy     - get pods yaml                │
│ kgpj     - get pods json                │
│ kgpo     - get pods wide                │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ MODIFIERS                               │
├─────────────────────────────────────────┤
│ kgpw     - get pods watch               │
│ kgpaa    - get pods all namespaces      │
│ kgpsl    - get pods show-labels         │
│ kzgp     - get pods (kube-system)       │
└─────────────────────────────────────────┘
```

### Anti-Patterns ⚠️

**❌ DON'T:**
- Chain random letters hoping they work
- Mix verb and resource order (it's always verb then resource)
- Use `d` for delete (use `x` instead)

**✅ DO:**
- Build from verb + resource pattern
- Start with Tier 1 commands, master those first
- Use `k` + verb + resource as the base pattern
- Add modifiers (output, flags) after the resource

## Testing

### Run the Test Suite

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

### What Gets Tested

The test suite validates:

- ✅ **Git Aliases** - All 18 documented git aliases
- ✅ **Terraform Aliases** - All 8 terraform commands
- ✅ **Kubectl Base Commands** - All 8 base verbs (k, kg, kd, kx, etc.)
- ✅ **Kubectl Resource Commands** - All 11 common resource combinations
- ✅ **Kubectl Output Formats** - All 7 output format combinations
- ✅ **Kubectl expansions** - every `k*` function's body is compared with `tests/k-aliases.tsv`

### Test Output

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

=== Test Summary ===
Total Tests: 54
Passed: 54
Failed: 0

✓ All tests passed!
```

### Continuous Integration

You can integrate this into CI/CD pipelines:

```yaml
# Example GitHub Actions
- name: Test PowerShell Profile
  run: pwsh -File ./Test-Profile.ps1
```

### Manual Testing

To manually verify a specific alias:

```powershell
# Check if alias exists
Get-Command kgp

# Test execution (be careful with destructive commands!)
kg pods --help  # Safe test
```

## Common Workflow Cards 🎴

### 🔧 Debug a Failing Pod

```powershell
kgp                         # 1. Find the pod
kd pod/failing-pod          # 2. Describe it
kl pod/failing-pod          # 3. Check logs
kgpy pod/failing-pod        # 4. Get full YAML config
```

### 🚀 Deploy New Feature

```powershell
gcb feature-xyz             # 1. Create branch
ga .                        # 2. Add changes
gcmsg "Add feature xyz"     # 3. Commit
tp                          # 4. Plan terraform
ta                          # 5. Apply terraform
ka deploy.yaml              # 6. Apply k8s manifest (ka already includes --recursive -f)
kgpw                        # 7. Watch pods deploy
gp                          # 8. Push code
```

### 🔍 Check Cluster Health

```powershell
kgno                        # Check nodes
kgpaa                       # Check all pods
kgsv                        # Check services
kgi                         # Check ingress
```

## Learning Path with Checkpoints

### Week 1: Git Basics ✓

**Goals:**
- [ ] Type `ga`, `gcmsg`, `gp`, `gl` without looking (50 times)
- [ ] Complete 5 full workflows: add → commit → push
- [ ] **Checkpoint:** Can you push changes without referencing docs?

**Practice:**
```powershell
ga .                        # Add files
gcmsg "practice commit"     # Commit
gp                          # Push
gl                          # Pull
```

### Week 2: Kubectl Foundations ✓

**Goals:**
- [ ] Type `kg pods`, `kd pod/name`, `kl pod/name` 30 times each
- [ ] Practice switching between get/describe/logs
- [ ] **Checkpoint:** Can you check pod status without thinking?

**Practice:**
```powershell
kg pods                     # Get pods
kd pod/my-pod               # Describe pod
kl pod/my-pod               # Logs from pod
```

### Week 3: Output Formats ✓

**Goals:**
- [ ] Add `y`, `o`, `w` to your existing commands
- [ ] Practice `kgpy`, `kgpw`, `kgpo` 20 times
- [ ] **Checkpoint:** Can you get YAML output reflexively?

**Practice:**
```powershell
kgpy pod/my-pod             # Get pod yaml
kgpw                        # Watch pods
kgpo                        # Get pods wide
```

### Week 4: Advanced Combinations ✓

**Goals:**
- [ ] Learn `aa`, `sl`, `z` modifiers
- [ ] Practice complex chains: `kzgpaay`
- [ ] **Checkpoint:** Can you construct any command from memory?

**Practice:**
```powershell
kgpaa                       # Get pods all namespaces
kgpsl                       # Get pods show-labels
kzgp                        # Get pods in kube-system
```

## Memory Reinforcement

### Spaced Repetition with Anki

Export aliases to Anki for spaced repetition learning:

```powershell
.\Export-Anki.ps1
```

This generates `aliases-anki.csv` that you can import into Anki. The export includes:
- Front: Full command (e.g., "git pull")
- Back: Alias (e.g., "gl")
- Category: Tier/System
- Mnemonic: Memory aid

**Import into Anki:**
1. Open Anki → File → Import
2. Select `aliases-anki.csv`
3. Field separator: Comma
4. Map Front → Front, Back → Back
5. Import!

**Pro tip:** Create a custom note type with Category and Mnemonic fields for better organization.

### Memory Reinforcement

**Spaced Repetition Schedule:**

Set calendar reminders to review:

- **Day 1:** After first learning session
- **Day 3:** Review Tier 1 commands
- **Day 7:** Review Tier 1 + 2
- **Day 14:** Review all tiers
- **Day 30:** Final review + advanced patterns

**Pro tip:** Create a text file with random commands and practice typing them daily:

```powershell
# daily-practice.txt
kgp
kd pod/
kgpy
gcmsg ""
ga .
gp
```

## Visual Memory Aids

### Git Flow Diagram

```
  ga → gcmsg → gp → gl
  📥    💬      ⬆️    ⬇️
 Add   Commit  Push  Pull
```

### Kubectl Verb Hierarchy

```
     kg (get) ────→ Most common, start here
      ↓
     kd (describe) → Need details? Describe
      ↓
     kl (logs) ────→ Still broken? Check logs
      ↓
     kx (delete) ──→ Last resort: delete
```

## When NOT to Use Aliases

**❌ In documentation/scripts shared with others**

```powershell
# Bad (others may not have your aliases)
kgp | grep Running

# Good (explicit, portable)
kubectl get pods | grep Running
```

**❌ In CI/CD pipelines**

- Aliases may not exist in CI environment
- Explicit commands are more maintainable
- Better error messages with full commands

**✅ In interactive terminal sessions**

- Perfect for daily work
- Speed up your workflow
- Reduce typing fatigue
- Increase productivity

## Usage Tracking (Optional)

Track which aliases you use most to identify learning opportunities and measure productivity gains.

**Enable tracking:**
```powershell
$env:TRACK_ALIAS_USAGE = "true"
. $PROFILE  # Reload profile
```

**View usage stats:**
```powershell
# View log file
Get-Content ~/.alias-usage.log | Select-Object -Last 20

# Count most used aliases
Get-Content ~/.alias-usage.log | ForEach-Object { ($_ -split '\|')[1] } | Group-Object | Sort-Object Count -Descending | Select-Object -First 10
```

**Disable tracking:**
```powershell
$env:TRACK_ALIAS_USAGE = "false"
. $PROFILE
```

> **Note:** Tracking is disabled by default for privacy. Data is stored locally in `~/.alias-usage.log`.

## Contribution Guidelines

We welcome contributions! Here's how to add new aliases or improve existing ones.

### Adding New Aliases

1. **Follow the mnemonic system:**
   - Use consistent prefix patterns (G for Git, T for Terraform, K for Kubectl)
   - Document the mnemonic rationale
   - Check for conflicts: `Get-Alias <proposed-name>`

2. **Include in profile:**
   - Add function to `Microsoft.Powershell_profile.ps1`
   - Place in appropriate section (Git, Terraform, or Kubectl)

3. **Update documentation:**
   - Add to README in appropriate tier
   - Include mnemonic explanation
   - Add to test suite (`Test-Profile.ps1`)

4. **Template for new alias:**
   ```powershell
   # <alias> - <full command> (<mnemonic explanation>)
   function <alias> { <full command> $args }
   ```

### Example Contribution

**Before:**
```powershell
function kgp { & kubectl get pods $args }
```

**After (with documentation):**
```powershell
# kgp - kubectl get pods (K + Get + Pods)
function kgp { & kubectl get pods $args }
```

### Testing Your Changes

1. Run the test suite:
   ```powershell
   .\Test-Profile.ps1
   ```

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

### Pull Request Checklist

- [ ] Alias follows mnemonic system
- [ ] No conflicts with existing aliases
- [ ] Added to appropriate tier in README
- [ ] Added to test suite
- [ ] Tested locally
- [ ] Updated Table of Contents if adding new section

### Questions?

Open an issue or discussion for:
- Proposing new alias systems (e.g., Docker, Helm)
- Suggesting improvements to mnemonics
- Reporting conflicts or bugs

## Troubleshooting

### "Alias not found"

**Check if aliases are loaded:**
```powershell
Get-Command g*              # See all git aliases
Get-Command k*               # See all kubectl aliases
```

**If empty, reload profile:**
```powershell
. $profile                   # Reload profile
```

### "Ambiguous command"

Some aliases may conflict with existing commands. Check:

```powershell
Get-Alias gp                 # See what 'gp' maps to
Get-Command kg               # See what 'kg' maps to
```

### Forgot an alias?

**Use the Quick Reference cards above, or run:**

```powershell
Get-Command g* | Select-Object Name, Definition
Get-Command k* | Select-Object Name, Definition
```

### Profile not loading?

**Check profile path:**
```powershell
$profile                     # Shows profile path
Test-Path $profile          # Check if file exists
```

**Check execution policy:**
```powershell
Get-ExecutionPolicy          # Should be RemoteSigned or Unrestricted
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```