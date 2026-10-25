# Troubleshooting

- [An alias is not found](#an-alias-is-not-found)
- [An alias does something else](#an-alias-does-something-else)
- [Finding an alias](#finding-an-alias)
- [Tab completion does not work (Bash and Zsh)](#tab-completion-does-not-work-bash-and-zsh)
- [The profile does not load (PowerShell)](#the-profile-does-not-load-powershell)
- [Module not found (PowerShell)](#module-not-found-powershell)

## An alias is not found

First check that the aliases are loaded, then reload your shell.

**PowerShell**

```powershell
Get-Command kgp            # is it defined?
. $PROFILE                 # reload the profile
```

If `ti` works but `kgp` does not, or you see "k-aliases.ps1 was not found", the kubectl
aliases are missing: `k-aliases.ps1` must sit in the same folder as the profile. Re-run
`.\Install-Profile.ps1 -SkipModules -Force`, or copy `k-aliases.ps1` next to `$PROFILE`.

Git and Terraform aliases exist in PowerShell only.

**Bash / Zsh**

```sh
type kgp                                     # is it defined?
grep -n 'devops-k-aliases' ~/.bashrc         # or ~/.zshrc: is the installer's block there?
exec "$SHELL"                                # reload
```

If the block is missing, run `sh posix/install.sh` again. If your terminal starts login shells
(macOS Terminal does), bash reads `~/.bash_profile` rather than `~/.bashrc`: install with
`sh posix/install.sh --shell bash --bashrc ~/.bash_profile`.

## An alias does something else

Another alias, function or command with the same name may be taking precedence.

**PowerShell**

```powershell
Get-Command gp -All         # every definition of gp, in precedence order
```

**Bash / Zsh**

```sh
type -a kgp                 # every definition of kgp, in precedence order
```

In Bash and Zsh, loading the aliases removes existing *aliases* with the same names (for
example from the oh-my-zsh `kubectl` plugin) for the session. A *function* with the same name defined later in your rc file replaces
ours, so source anything that defines `k*` functions before the installer's block. The
installer warns when an alias name is already a command on `PATH`.

## Finding an alias

Use the quick references in [Kubectl aliases](kubectl.md#quick-reference) and
[Git and Terraform aliases](git-terraform.md), or list what is loaded:

**PowerShell**

```powershell
Get-Command k* -CommandType Function | Select-Object Name, Definition
Get-Command g*
```

**Bash / Zsh**

```sh
compgen -A function | grep '^k'          # bash
print -l ${(ok)functions} | grep '^k'    # zsh
type kgpaay                              # what one alias runs
```

## Tab completion does not work (Bash and Zsh)

- `kubectl` must be on your `PATH`: `command -v kubectl`.
- Bash needs version 4.1 or later (`echo $BASH_VERSION`) and the bash-completion package (v2).
  macOS's system bash 3.2 cannot complete these aliases.
- Zsh needs `autoload -Uz compinit && compinit` somewhere in your `~/.zshrc`, before or after
  the installer's block (if it comes after, completion is registered at the first prompt).
- Resource names (for example pod names) come from kubectl and need a reachable cluster.

## The profile does not load (PowerShell)

```powershell
$PROFILE                    # where PowerShell looks for the profile
Test-Path $PROFILE          # does the file exist?
Get-ExecutionPolicy         # should be RemoteSigned or Unrestricted
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

The profile changes directory to `~/Workspace` at the end; if that folder doesn't exist you
will see an error from `Set-Location`, and everything before it has still loaded.

## Module not found (PowerShell)

```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module git-aliases -Scope CurrentUser
Install-Module PSKubectlCompletion -Scope CurrentUser
```
