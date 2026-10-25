# Kubectl - The "K" System 🎯

The K system works the same in PowerShell, bash and zsh (see [Shell differences](shells.md)).

> **⚠️ Important:** These aliases use a **layered learning approach**. Start with Tier 1, master those, then move to Tier 2. Don't try to memorize everything at once!

**Base:** `k` = kubectl (first letter)

**⚠️ Important Notes:**
- Some aliases use arbitrary choices (like `z` for system, `x` for delete) - these are documented exceptions
- Resource abbreviations vary: some use first letter (`p`), some use first two (`de`), some use middle letters (`sv`)
- Learn the pattern, not every combination

### Tier 1: Essential Verbs (Memorize These First!)

**The K8s Workflow Story:** "**G**et info, **D**escribe details, **A**pply fixes, **L**ook at logs"

```
kg      - kubectl get                (K + Get)
kd      - kubectl describe           (K + Describe)
kx      - kubectl delete             (K + eXterminate - exception!)
ka      - kubectl apply --recursive -f   (K + Apply; pass a path: ka deploy.yaml)
kl      - kubectl logs -f            (K + Logs; always follows)
ke      - kubectl exec -i -t         (K + Exec)
```

**⚠️ ⚠️ ⚠️ DESTRUCTIVE COMMAND ⚠️ ⚠️ ⚠️**

> **`kx` = delete (not `d` because `d` is describe). Think "e**X**terminate".**
> 
> **This permanently deletes resources! Always double-check before using.**

<details>
<summary><strong>▶ Tier 2: Common Resources</strong> (Click to expand)</summary>

**Pattern:** Mixed strategies (first letter OR first two letters OR distinctive pattern)

```
p       - pods                       (first letter)
de      - deployment                (first two - avoids conflict with describe)
i       - ingress                   (first letter)
sv      - service                   (S + V = serVice - distinctive consonants)
c       - configmap                 (first letter)
se      - secret                    (S + E = sEcret - first letter + second vowel)
n       - namespace                 (first letter)
no      - node                      (first two: NOde)
```

**⚠️ Why the inconsistency?** 
- `d` is already used for "describe", so deployment uses `de` (first two letters)
- `s` would conflict with "secret", so service uses `sv` (S + V = distinctive consonants)
- Most others use first letter(s) when no conflict exists

</details>

<details>
<summary><strong>▶ Tier 3: Output Formats & Flags</strong> (Click to expand)</summary>

```
y       - yaml output               (Y = Yaml)
j       - json output               (J = Json)
o       - wide output               (O = Output-wide)
aa      - all-namespaces (delete: --all)  (double A = "all")
w       - watch                     (W = Watch)
sl      - show-labels               (Show Labels)
```

</details>

<details>
<summary><strong>▶ Tier 4: System Namespace</strong> (Click to expand)</summary>

```
z       - kube-system namespace      (Z = "zone zero" - the system zone where k8s lives)
```

**⚠️ Exception:** `z` is a mnemonic for "zone zero" - think of kube-system as the special system zone. This is a documented exception to the normal abbreviation rules.

</details>

## Kubectl Pattern Formula

**Pattern:** `k + [system] + verb + resource + [format] + [flags]`

**Structure:**
```
k + [z] + verb + resource + [y|j|o] + [w|aa|sl]
└─ required ─┘ └────────── optional ──────────┘
```

**Examples:**
```
k  + g  + p        = kgp          (get pods)
k  + z + g  + p    = kzgp         (get pods in kube-system)
k  + g  + p  + y   = kgpy         (get pods as yaml)
k  + g  + p  + w   = kgpw         (get pods watch)
k  + g  + p  + aa  = kgpaa        (get pods all namespaces)
k  + d  + p        = kdp          (describe pods)
k  + x  + p        = kxp          (delete pods)
k  + g  + de + y   = kgdey        (get deployment yaml)
```

## Kubectl Conflict Resolution Rules

1. **First letter wins** for most common
   - `d` = describe (more common than delete)
   - `x` = delete (exception: uses X for "exterminate")

2. **Add letters** when conflict exists
   - `de` = deployment (avoids conflict with describe)
   - `sv` = service (avoids conflict with secret)

3. **Double letters** for "all" modifier
   - `aa` = `--all-namespaces` with `get`/`describe`
   - `aa` = `--all` with `x` (delete): `kxpaa` = `kubectl delete pods --all`, which deletes every pod in the **current** namespace. Treat any `kx…aa` alias as destructive.

4. **Long forms** are synonyms: `kgpaaoyaml` = `kgpaay`, and likewise `owide`/`ojson` and `all` (for `aa`)

5. **`n` means two things**: as a resource, `n` is namespaces (`kgn`); as a trailing flag it is `--namespace` (`kgpn`). `kgno` is nodes, so namespaces with wide output is `kgnso`/`kgnsoall`.

## Kubectl Quick Reference

```
┌─────────────────────────────────────────┐
│ ESSENTIAL DAILY COMMANDS                │
├─────────────────────────────────────────┤
│ kg pods          → Get pods             │
│ kd pod/name      → Describe pod         │
│ kl pod/name      → Logs from pod        │
│ ke pod/name      → Exec into pod        │
│ kx pod name      → Delete pod           │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ COMMON RESOURCES                        │
├─────────────────────────────────────────┤
│ kgp      - get pods                     │
│ kgde     - get deployments              │
│ kgsv     - get services                 │
│ kgi      - get ingress                  │
│ kgc      - get configmaps               │
│ kgse     - get secrets                  │
│ kgn      - get namespaces               │
│ kgno     - get nodes                    │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ OUTPUT FORMATS                          │
├─────────────────────────────────────────┤
│ kgpy     - get pods yaml                │
│ kgpj     - get pods json                │
│ kgpo     - get pods wide                │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│ MODIFIERS                               │
├─────────────────────────────────────────┤
│ kgpw     - get pods watch               │
│ kgpaa    - get pods all namespaces      │
│ kgpsl    - get pods show-labels         │
│ kzgp     - get pods (kube-system)       │
└─────────────────────────────────────────┘
```

## Anti-Patterns ⚠️

**❌ DON'T:**
- Chain random letters hoping they work
- Mix verb and resource order (it's always verb then resource)
- Use `d` for delete (use `x` instead)

**✅ DO:**
- Build from verb + resource pattern
- Start with Tier 1 commands, master those first
- Use `k` + verb + resource as the base pattern
- Add modifiers (output, flags) after the resource
