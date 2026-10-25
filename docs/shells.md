# Shell differences

The kubectl "K" system works in PowerShell, bash and zsh. Only the K system is ported; the Git
and Terraform aliases and the PowerShell helpers are not. All 788 names and their expansions are
the same, including the destructive ones (`kxpaa` is still `kubectl delete pods --all`).

## Tab completion in Bash and Zsh

Tab completion understands what each alias stands for: `kzgp <TAB>` completes like
`kubectl --namespace=kube-system get pods <TAB>`, so flags, flag values and (with a reachable
cluster) resource names come from kubectl itself and are scoped the same way. It needs
`kubectl` on `PATH`; bash also needs bash 4.1+ and the bash-completion package (v2), as
kubectl's own bash completion does. kubectl's completion is loaded on first use, so shell
start-up stays fast. In zsh, completion is registered at the first prompt if `compinit` has
not run yet.

## PowerShell compared with Bash and Zsh

| | PowerShell | Bash / zsh |
|---|---|---|
| Definition | functions calling `& kubectl ... $args` | functions calling `\kubectl ... "$@"` |
| `kubectl` lookup | honours a user alias or function named `kubectl` | honours a user `kubectl` **function** (a wrapper); an **alias** named `kubectl` is not expanded (`\kubectl` suppresses alias expansion, so it is neither baked in when the file loads nor used when the aliases run) |
| Arguments | splatted with `$args` | forwarded verbatim; nothing is evaluated |
| Existing aliases with the same name | n/a | removed for the session when the file is loaded (e.g. the oh-my-zsh `kubectl` plugin defines `kgp`, `kdp`, ...) |
| Completion | PSKubectlCompletion | kubectl's own completion, with each alias' fixed arguments filled in |
| Git, Terraform, `dy`/`f` | yes / removed | not ported |

A `kubectl` wrapper function must call the real binary (`command kubectl "$@"`), not one of
these aliases, or it would call itself. Not supported: fish. Not tested: macOS (the tests ran
on Linux), including its system bash 3.2, whose completion cannot work anyway without bash 4.1+
and bash-completion.
