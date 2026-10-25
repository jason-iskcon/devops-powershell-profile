# powershell-profile

> **Last updated:** 2026-10 | **Version:** 3.0.0

A DevOps-focused PowerShell profile with a comprehensive mnemonic system for Git, Terraform, and Kubectl commands. The kubectl "K system" also works in Bash and Zsh.

**Features:**
- 🚀 **788 kubectl aliases** (plus 17 Git and 8 Terraform)
- 🐧 **Bash and Zsh** - the same kubectl aliases, with kubectl-aware tab completion
- 🔒 **Safe, reversible installers** - idempotent, backups never overwritten, one marked block per shell file
- 🧠 **Mnemonic system** - Easy to remember with tiered learning
- ✅ **Test suite** - Validate all aliases work correctly
- 📚 **Interactive quiz** - Test your knowledge (PowerShell)
- 🎴 **Anki export** - Spaced repetition flashcards (PowerShell)

**Quick Install:**
```powershell
.\Install-Profile.ps1        # PowerShell (Windows)
```
```sh
sh posix/install.sh           # Bash / Zsh (Linux)
```

📖 **New to this?** Start with the [Quick Start Guide](QUICKSTART.md) (5 minutes)

## What works where

| | PowerShell | Bash / Zsh |
|---|---|---|
| Kubectl "K system" (788 aliases) | yes | yes |
| Git and Terraform aliases | yes | no |
| Quiz and Anki export | yes | no |
| Usage tracking (`kgp` only) | Windows only | no |

Tested on Windows and Linux; macOS is not tested. Details in [Installation](docs/install.md#requirements-and-supported-platforms).

## The pattern in 30 seconds

```text
k + [z] + verb + resource + [format] + [flags]

kgp      kubectl get pods
kzgp     kubectl get pods in kube-system
kgpy     kubectl get pods as yaml
kgpaa    kubectl get pods in all namespaces
kxp      kubectl delete pods            (x = delete; d is describe)
```

## Documentation

| Page | What's in it |
|---|---|
| [Installation](docs/install.md) | Requirements, supported platforms, PowerShell and Bash/Zsh installs, upgrading from 2.0.0 |
| [Kubectl aliases](docs/kubectl.md) | The K system: tiers, the pattern formula, conflict rules, quick reference |
| [Git and Terraform aliases](docs/git-terraform.md) | The G and T systems and the other PowerShell helpers |
| [Shell differences](docs/shells.md) | How PowerShell and Bash/Zsh differ, tab completion |
| [Learning the aliases](docs/learning.md) | Workflow cards, a 4-week learning path, Anki, when not to use aliases, usage tracking |
| [Troubleshooting](docs/troubleshooting.md) | Aliases missing, conflicts, profile not loading |
| [Testing](docs/testing.md) | `Test-Profile.ps1`, the Python test suite, what CI runs |
| [Contributing](CONTRIBUTING.md) | Adding aliases, the generated files, the pull request checklist |
| [Changelog](CHANGELOG.md) | Release history |
