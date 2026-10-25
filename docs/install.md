# Installation

- [Requirements and supported platforms](#requirements-and-supported-platforms)
- [PowerShell](#powershell)
- [Bash and Zsh](#bash-and-zsh)
- [Upgrading from 2.0.0](#upgrading-from-200)

## Requirements and supported platforms

| Platform | Status | Evidence |
|---|---|---|
| Windows, PowerShell 7 | **Tested** | CI (`windows-latest`): installs, reinstalls, loads in a fresh shell, and the full `Test-Profile.ps1` passes against the real modules |
| Windows PowerShell 5.1 | **Tested with stand-in modules** | CI: installs, reinstalls, loads in a fresh `powershell.exe` and passes the kubectl checks. Installing the real PowerShell Gallery modules under 5.1 hung in CI and is **not verified**. Before 3.0.0 the installer did not even parse on 5.1 |
| Linux, PowerShell 7 | Profile and test suite tested | CI (`ubuntu-latest`) runs the profile and `Test-Profile.ps1` with stand-in modules; the installer smoke test was run on Linux by hand only |
| Linux, Bash 5 and Zsh 5.9 | **Tested** | CI (`ubuntu-latest`): every function, completion (including interactive Tab in real shells with the real kubectl) and the installer |
| macOS (any shell, including its bash 3.2) | **Not tested** | Nothing has been run on macOS |
| Fish and other shells | Not supported | |

All three shells get the 788 kubectl aliases. The Git and Terraform aliases and the other
helpers are PowerShell only; see [Shell differences](shells.md).

What you need:

- **kubectl**, in every shell.
- **PowerShell:** the PowerShell modules `posh-git`, `git-aliases` and `PSKubectlCompletion` (`Install-Profile.ps1` installs them for the current user).
- **Bash and Zsh:** nothing else to use the aliases. Bash tab completion also needs bash 4.1 or later and the bash-completion package (v2); Zsh completion needs `compinit`.
- **Python 3.11 or later** is only needed to regenerate the alias files or run the tests, not to use the aliases.
- Live resource-name completion (for example pod names) comes from kubectl and needs a reachable cluster; the tests do not cover it.

## PowerShell

### Install with the script

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
3. Copy the profile file and `k-aliases.ps1` (the generated kubectl aliases it loads) to the correct location
4. Back up an existing profile when run with `-Force`; without it, ask before overwriting

### Install by hand

1. **Install the PowerShell modules** (as admin, or with `-Scope CurrentUser` as here):

```powershell
Install-Module posh-git -Scope CurrentUser
Install-Module git-aliases -Scope CurrentUser
Install-Module PSKubectlCompletion -Scope CurrentUser
```

2. **Copy the profile and `k-aliases.ps1`:**

```powershell
# Find your profile path
$profile

# Copy the profile and the generated kubectl aliases it loads (adjust source path as needed)
Copy-Item Microsoft.Powershell_profile.ps1 $PROFILE
Copy-Item k-aliases.ps1 (Split-Path $PROFILE -Parent)
```

3. **Reload the profile:**

```powershell
. $PROFILE
```

### Verify the installation

```powershell
.\Test-Profile.ps1
```

All tests should pass. See [Testing](testing.md) for the other options.

## Bash and Zsh

```sh
python3 tools/generate_aliases.py     # only if posix/ is missing or you changed k-grammar.toml
sh posix/install.sh                   # same as --shell auto: bash or zsh, from $SHELL
sh posix/install.sh --shell both      # or: bash, zsh
sh posix/install.sh --dry-run         # show what would change
sh posix/install.sh uninstall         # both shells (default); or --shell bash|zsh|auto
```

Then open a new terminal (or run `exec "$SHELL"`) and try `kgp` (`kubectl get pods`).

The installer copies the shell files to `${XDG_DATA_HOME:-~/.local/share}/devops-k-aliases`
and adds one marked block to `~/.bashrc` and/or `~/.zshrc` that sources them. It changes
nothing else, backs up an rc file before editing it (backups are never overwritten), writes
through symlinks, does nothing when run again, and `uninstall` puts the rc files back exactly
as they were (a file that did not end in a newline gains one). bash and zsh share one copy of
the files, so `uninstall --shell bash` removes only bash's block and keeps the files while zsh's
rc file still uses them; they go when the last shell is uninstalled. An rc file whose markers
are damaged or out of order is refused before anything is changed. Use `--bashrc ~/.bash_profile`
if your terminal starts login shells, as macOS Terminal does. `ZDOTDIR` is honoured.

The installer warns if an alias name already exists as a command on `PATH`; the function takes
precedence. For tab completion and how the shells differ, see [Shell differences](shells.md).

## Upgrading from 2.0.0

2.0.0 was PowerShell only. Re-run `Install-Profile.ps1` (add `-Force` to back up and replace your current profile), then open a new shell. Three things differ from 2.0.0:

1. **`dy` and `f` are gone.** Write `--dry-run=client -o=yaml` and `--force --grace-period=0`.
2. **`kgn`, `kdn` and `kxn` now mean `get|describe|delete namespaces`**, as documented. In 2.0.0 a duplicate definition made them `... --namespace`.
3. **The kubectl aliases live in `k-aliases.ps1`.** If you copied only the profile file by hand, you now get a warning at start-up and no kubectl aliases until `k-aliases.ps1` sits next to the profile.

The other 785 kubectl aliases behave exactly as before.
