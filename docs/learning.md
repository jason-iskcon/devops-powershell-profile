# Learning the aliases

## Why Learn This System?

**The Problem:** Typing long commands is slow and error-prone.

**The Solution:** Short, memorable aliases that cut most of the typing.

**Real Impact:**

| Command | Before | After | Reduction |
|---------|--------|-------|-----------|
| `kubectl get pods --all-namespaces -o yaml` | 41 chars | `kgpaay` (6 chars) | **85%** |
| `git commit -m "message"` | 23 chars | `gcmsg "message"` (15 chars) | **35%** |
| `terraform apply --auto-approve` | 30 chars | `ta` (2 chars) | **93%** |

**Learning Curve:** Master the Tier 1 commands in Week 1, and you'll see immediate productivity gains.

## Common Workflow Cards 🎴

The Git and Terraform steps need the PowerShell profile; the kubectl steps work in every supported shell.

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

(PowerShell only. In bash or zsh, start with Week 2.)

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

Export aliases to Anki for spaced repetition learning (needs PowerShell):

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

### Review Schedule

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

PowerShell only. When enabled, the profile logs each use of **`kgp`**; no other alias is
tracked yet. The log is `%USERPROFILE%\.alias-usage.log`, so this works on Windows only.

**Enable tracking:**
```powershell
$env:TRACK_ALIAS_USAGE = "true"
. $PROFILE  # Reload profile
```

**View usage stats:**
```powershell
# View log file
Get-Content $env:USERPROFILE\.alias-usage.log | Select-Object -Last 20

# Count most used aliases
Get-Content $env:USERPROFILE\.alias-usage.log | ForEach-Object { ($_ -split '\|')[1] } | Group-Object | Sort-Object Count -Descending | Select-Object -First 10
```

**Disable tracking:**
```powershell
$env:TRACK_ALIAS_USAGE = "false"
. $PROFILE
```

> **Note:** Tracking is disabled by default for privacy. Data is stored locally in `%USERPROFILE%\.alias-usage.log`.
