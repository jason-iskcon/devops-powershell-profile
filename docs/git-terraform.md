# Git and Terraform aliases

**PowerShell only.** These aliases are not available in bash or zsh (see [Shell differences](shells.md)).
The Git aliases come from the [`git-aliases`](https://github.com/gluons/powershell-git-aliases) module, which the profile imports; the
Terraform aliases are defined in `Microsoft.Powershell_profile.ps1`.

> **⚠️ Important:** These aliases use a **layered learning approach**. Start with Tier 1, master those, then move to Tier 2. Don't try to memorize everything at once!

## Git - The "G" System 📝

**Base Rule:** All git aliases start with `g` (for **G**it)

**Abbreviation Strategy:** First letter of command + distinctive consonant when needed

### Tier 1: Essential Daily Commands (Memorize These First!)

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
<summary><strong>▶ Tier 3: Diff & Stash</strong> (Click to expand)</summary>

```
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

## Git Conflict Resolution Rules

When abbreviations collide, we use these rules:

1. **First letter wins** for most common command
   - `gp` = push (more common than pull)
   - `gl` = pull (uses last letter to avoid conflict)

2. **Add distinctive consonant** for less common
   - `glog` = log (adds 'og' to distinguish from pull)

3. **Double letters** for "all" modifier
   - `gaa` = add all (double A pattern)

## Git Quick Reference

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

## Terraform - The "T" System 🏗️

**Pattern:** Terraform + first letter of action

**The Workflow Story:** "**I**nitialize, **P**lan ahead, **A**pply changes, **D**estroy when done"

### Essential Commands

```
ti      - terraform init             (Terraform Init)
tp      - terraform plan             (Terraform Plan)
ta      - terraform apply            (Terraform Apply --auto-approve)
td      - terraform destroy          (Terraform Destroy)
tv      - terraform validate         (Terraform Validate)
tfmt    - terraform fmt              (Terraform ForMaT)
```

### With Target Flags

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

## Other PowerShell helpers

The profile also defines a few helpers that are not part of the mnemonic system:

| Name | What it does |
|---|---|
| `tf` | alias for `terraform` |
| `cd..` | `cd ..` |
| `grep` | filters piped input with `Select-String` |
| `touch` | creates an empty file |
| `export NAME=value` | sets a user environment variable permanently (Windows user scope; not the current session) |
| `focus`, `relax` | open a Spotify playlist in the browser |

At the end of loading, the profile also changes directory to `~/Workspace`.
