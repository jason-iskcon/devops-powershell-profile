# Quick Start Guide

Get up and running in 5 minutes!

## 1. Install (2 minutes)

**Windows (PowerShell):**

```powershell
.\Install-Profile.ps1
. $PROFILE              # or open a new PowerShell window
.\Test-Profile.ps1      # all tests should pass
```

The script installs the modules, then copies the profile **and** `k-aliases.ps1` (the generated
kubectl aliases) into your profile folder. If you copy files by hand, copy both.

**Linux (Bash or Zsh), kubectl aliases only:**

```sh
sh posix/install.sh     # picks bash or zsh from $SHELL; or add --shell bash|zsh|both
exec "$SHELL"           # or open a new terminal
kgp                     # kubectl get pods
```

It adds one marked block to `~/.bashrc` or `~/.zshrc` and backs the file up first. Remove it any
time with `sh posix/install.sh uninstall`. Tab completion (`kzgp <TAB>`) needs `kubectl` on your
`PATH`; in bash it also needs bash 4.1+ and the bash-completion package. macOS has not been tested.

Upgrading from 2.0.0? See "Upgrading from 2.0.0" in the [README](README.md#upgrading-from-200):
`dy` and `f` were removed and `kgn`/`kdn`/`kxn` now mean namespaces.

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

**"k-aliases.ps1 was not found" warning, or `kgp` missing but `ti` works**

The kubectl aliases live in `k-aliases.ps1`, which must sit in the same folder as the profile.
Re-run `.\Install-Profile.ps1 -SkipModules -Force`, or copy `k-aliases.ps1` next to `$PROFILE`.

**"Module not found"**
```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module git-aliases -Scope CurrentUser
Install-Module PSKubectlCompletion -Scope CurrentUser
```

**Need help?** Check the [Troubleshooting](README.md#troubleshooting) section.

---

**Pro Tip:** Start with Tier 1 commands only. Master those before moving to advanced tiers!

