# Quick Start Guide

Get up and running in 5 minutes!

## 1. Install (2 minutes)

```powershell
.\Install-Profile.ps1
```

That's it! The script handles everything.

On Linux or macOS with bash or zsh, the kubectl aliases are available too:
`sh posix/install.sh` (see the README, "Bash and Zsh").

## 2. Learn the Essentials (3 minutes)

### Git - The Daily Workflow

Remember: **"Add ingredients, Cook meal, Plate it, Pour drinks for Lunch"**

```powershell
ga .                    # Add files
gcmsg "fix bug"         # Commit with message  
gp                      # Push changes
gl                      # Pull latest
```

### Terraform - The Workflow

Remember: **"Initialize, Plan ahead, Apply changes"**

```powershell
ti                      # Initialize
tp                      # Plan changes
ta                      # Apply (⚠️ auto-approve!)
```

### Kubectl - The Basics

Remember: **"Get info, Describe details, Look at logs"**

```powershell
kg pods                 # Get pods
kd pod/my-pod           # Describe pod
kl pod/my-pod           # Logs from pod
```

## 3. Test Your Knowledge

```powershell
.\Test-Profile.ps1 -Quiz
```

## 4. Learn More

- **Full documentation:** See [README.md](README.md)
- **All aliases:** Run `Get-Command g*`, `Get-Command k*`, `Get-Command t*`
- **Practice:** Use the [Learning Path](README.md#learning-path-with-checkpoints)

## Common Issues

**"Alias not found"**
```powershell
. $PROFILE  # Reload profile
```

**"Module not found"**
```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module git-aliases -Scope CurrentUser
Install-Module PSKubectlCompletion -Scope CurrentUser
```

**Need help?** Check the [Troubleshooting](README.md#troubleshooting) section.

---

**Pro Tip:** Start with Tier 1 commands only. Master those before moving to advanced tiers!

