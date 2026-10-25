# Git and Terraform aliases

**PowerShell only.** Bash and Zsh get the kubectl aliases only (see
[Shell differences](shells.md)). The Git aliases come from the
[`git-aliases`](https://github.com/gluons/powershell-git-aliases) module, which the profile
imports; the Terraform aliases are defined in `Microsoft.Powershell_profile.ps1`.

## Git - The "G" System

Every Git alias starts with `g`, followed by the first letter of the command and, where two
commands clash, a distinguishing letter or two.

```text
Daily workflow
ga      - git add
gaa     - git add --all              aa = "all"
gcmsg   - git commit -m              commit + message
gp      - git push
gl      - git pull                   pu-l-l: p was taken by push

Branches
gco     - git checkout
gcb     - git checkout -b            checkout + branch
gbr     - git branch
gbd     - git branch -d              branch + delete

Diff and stash
gd      - git diff
gds     - git diff --staged
gst     - git stash
gsta    - git stash apply
gstd    - git stash drop

Other
gcl     - git clone
glog    - git log                    the whole word, because gl is pull
gsh     - git show
```

A typical change:

```powershell
gcb fix-login           # new branch
ga .                    # stage everything
gcmsg "Fix login"       # commit
gp                      # push
```

The `git-aliases` module defines many more; `Get-Command g*` lists them. Only the 17 above
are documented and tested here.

## Terraform - The "T" System

`t` plus the first letter of the command.

```text
ti      terraform init
tp      terraform plan
ta      terraform apply --auto-approve
td      terraform destroy
tv      terraform validate
tfmt    terraform fmt
tpt     terraform plan -target=<address>
tat     terraform apply -target=<address> --auto-approve
```

> **Warning:** `ta` and `tat` apply **without asking for confirmation**. Type
> `terraform apply` when you want the prompt. `td` destroys infrastructure (Terraform still
> asks you to confirm).

`ti`, `tp`, `ta`, `td`, `tv` and `tfmt` take no arguments: anything typed after them is
ignored. Use the full command (or `tf`, below) when you need flags. `tpt` and `tat` take the
target address: `tpt module.web`.

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
