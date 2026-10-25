# Learning the aliases

The aliases are built from a few letters that combine, so you learn a pattern rather than a
list. Start small: a handful of verbs, then resources, then modifiers.

| Command | Characters | Alias | Characters saved |
|---|---|---|---|
| `kubectl get pods --all-namespaces -o yaml` | 41 | `kgpaay` (6) | 85% |
| `git commit -m "message"` | 23 | `gcmsg "message"` (15) | 35% |
| `terraform apply --auto-approve` | 30 | `ta` (2) | 93% |

- [Workflow examples](#workflow-examples)
- [A four-week plan](#a-four-week-plan)
- [Quiz, Anki and review](#quiz-anki-and-review)
- [When not to use aliases](#when-not-to-use-aliases)
- [Usage tracking](#usage-tracking)

## Workflow examples

**Debug a failing pod** (any shell). Work down from the cheapest look to the most detail:

```sh
kgp                         # 1. find the pod
kd pod/failing-pod          # 2. describe it: events, restarts, image
kl pod/failing-pod          # 3. follow its logs
klp pod/failing-pod         # 4. logs of the previous container, if it restarted
kgpy pod/failing-pod        # 5. the full YAML
```

**Check cluster health** (any shell):

```sh
kgno                        # nodes
kgpaa                       # pods in every namespace
kgsv                        # services
kgi                         # ingress
```

**Ship a change** (PowerShell, because it uses the Git and Terraform aliases):

```powershell
gcb feature-xyz             # 1. create a branch
ga .                        # 2. stage changes
gcmsg "Add feature xyz"     # 3. commit
tp                          # 4. plan Terraform
ta                          # 5. apply Terraform (no confirmation prompt)
ka deploy.yaml              # 6. apply the manifest (ka includes --recursive -f)
kgpw                        # 7. watch the pods roll out
gp                          # 8. push
```

## A four-week plan

Each week, use the new aliases in your real work until you stop reaching for the full
command.

| Week | Learn | Practise | You're ready to move on when |
|---|---|---|---|
| 1 | Git: `ga`, `gcmsg`, `gp`, `gl` (PowerShell; in Bash/Zsh start at week 2) | five add → commit → push cycles | you can push without looking anything up |
| 2 | Verbs: `kg`, `kd`, `kl` | `kg pods`, `kd pod/name`, `kl pod/name` | you check a pod's state without thinking |
| 3 | Formats: `y`, `o`, `w` | `kgpy`, `kgpo`, `kgpw` | YAML output is a reflex |
| 4 | Modifiers: `aa`, `sl`, `z` | `kgpaa`, `kgpsl`, `kzgp`, `kgpaawy` | you can build an alias you've never used from the [pattern](kubectl.md#the-pattern) |

## Quiz, Anki and review

**Quiz** (PowerShell):

```powershell
.\Test-Profile.ps1 -Quiz
```

**Anki flashcards.** `Export-Anki.ps1` writes `aliases-anki.csv` with 27 cards covering the
core Git, Terraform and kubectl aliases. It needs PowerShell (`pwsh` works on Linux and macOS
too), and the CSV is useful whichever shell you use the aliases in.

```powershell
.\Export-Anki.ps1
```

Each card has a Front (the full command, e.g. `git pull`), a Back (the alias, `gl`), a
Category (system and tier) and a Mnemonic. To import: in Anki choose **File → Import**, select
`aliases-anki.csv`, set the field separator to comma and map Front and Back. A custom note
type with Category and Mnemonic fields keeps the extra columns.

**Review schedule.** If you are not using Anki, review on day 1, 3, 7, 14 and 30 after first
learning a tier.

## When not to use aliases

Use aliases in your own interactive terminal. Write the full command anywhere someone else
(or a machine) will read or run it: documentation, scripts, runbooks and CI pipelines. Other
people and CI runners won't have these aliases, and full commands give clearer errors.

```sh
kubectl get pods | grep Running     # in a script or a doc
kgp | grep Running                  # at your own prompt
```

## Usage tracking

PowerShell on Windows only, and off by default. When enabled, the profile logs each use of
**`kgp`** (no other alias is tracked yet) to `%USERPROFILE%\.alias-usage.log`. Nothing leaves
your machine.

```powershell
$env:TRACK_ALIAS_USAGE = "true"; . $PROFILE       # enable
Get-Content $env:USERPROFILE\.alias-usage.log | Select-Object -Last 20
$env:TRACK_ALIAS_USAGE = "false"; . $PROFILE      # disable
```
