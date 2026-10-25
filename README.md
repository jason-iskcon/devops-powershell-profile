# DevOps shell aliases

> **Last updated:** 2026-10 | **Version:** 3.0.0

Short, mnemonic aliases for kubectl, Git and Terraform. `kgp` is `kubectl get pods`, `kzgpy`
is `kubectl --namespace=kube-system get pods -o=yaml`, and the other 786 kubectl aliases follow
the same pattern.

- **788 kubectl aliases** in PowerShell, Bash and Zsh, generated from one grammar, with
  kubectl-aware tab completion
- **17 Git and 8 Terraform aliases** in PowerShell
- **Safe installers:** idempotent, with backups and a clean uninstall
- **Tests** for every alias in every shell, plus a quiz and Anki flashcards for learning them

## What works where

| | PowerShell | Bash / Zsh |
|---|---|---|
| Kubectl "K system" (788 aliases) | yes | yes |
| Git and Terraform aliases | yes | no |
| Quiz and Anki export | yes | no |
| Usage tracking (`kgp` only) | Windows only | no |

Tested on Windows and Linux; macOS is not tested. See
[Installation](docs/install.md#requirements-and-supported-platforms) for the full support table.

## Install

**PowerShell**

```powershell
.\Install-Profile.ps1
. $PROFILE              # or open a new PowerShell window
.\Test-Profile.ps1      # all tests should pass
```

The installer adds the modules the profile needs, then copies the profile **and**
`k-aliases.ps1` (the generated kubectl aliases) into your profile folder.

**Bash or Zsh**

```sh
sh posix/install.sh     # picks bash or zsh from $SHELL; or add --shell bash|zsh|both
exec "$SHELL"           # or open a new terminal
```

The installer adds one marked block to `~/.bashrc` or `~/.zshrc` and backs the file up first.
Remove it with `sh posix/install.sh uninstall`.

Options, manual installs, requirements and upgrading from 2.0.0 are in
[Installation](docs/install.md).

## The kubectl pattern

```text
k + [z] + verb + resource + [format] + [flags]

kgp      kubectl get pods
kdp      kubectl describe pods
kxp      kubectl delete pods             x = delete, because d is describe
kzgp     kubectl get pods in kube-system
kgpy     kubectl get pods -o=yaml
kgpaa    kubectl get pods --all-namespaces
```

Start with the verbs `kg`, `kd` and `kl` (logs), then add resources and modifiers as you need
them. The full system is in [Kubectl aliases](docs/kubectl.md).

## Documentation

| Page | What's in it |
|---|---|
| [Installation](docs/install.md) | Requirements, supported platforms, both installers, upgrading from 2.0.0 |
| [Kubectl aliases](docs/kubectl.md) | The K system: verbs, resources, modifiers, conflict rules, quick reference |
| [Git and Terraform aliases](docs/git-terraform.md) | The G and T systems and the other PowerShell helpers |
| [Shell differences](docs/shells.md) | How PowerShell and Bash/Zsh differ, tab completion |
| [Learning the aliases](docs/learning.md) | Workflow examples, a 4-week plan, quiz, Anki, when not to use aliases |
| [Troubleshooting](docs/troubleshooting.md) | Missing aliases, name clashes, shell start-up problems |
| [Testing](docs/testing.md) | `Test-Profile.ps1`, the Python test suite, what CI runs |
| [Contributing](CONTRIBUTING.md) | Adding aliases, the generated files, the pull request checklist |
| [Changelog](CHANGELOG.md) | Release history |
