# Troubleshooting

## "Alias not found"

**Check if aliases are loaded:**
```powershell
Get-Command g*              # See all git aliases
Get-Command k*               # See all kubectl aliases
```

**If empty, reload profile:**
```powershell
. $profile                   # Reload profile
```

## "Ambiguous command"

Some aliases may conflict with existing commands. Check:

```powershell
Get-Alias gp                 # See what 'gp' maps to
Get-Command kg               # See what 'kg' maps to
```

## Forgot an alias?

**Use the quick reference in [Kubectl aliases](kubectl.md#kubectl-quick-reference) or [Git and Terraform aliases](git-terraform.md#git-quick-reference), or run:**

```powershell
Get-Command g* | Select-Object Name, Definition
Get-Command k* | Select-Object Name, Definition
```

## Profile not loading?

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
