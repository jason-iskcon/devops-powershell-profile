# Kubectl aliases (the K system)

The 788 kubectl aliases work the same in PowerShell, Bash and Zsh: same names, same
expansions. Each one runs kubectl with fixed arguments followed by whatever you type, so
`kgp my-pod -o=name` is `kubectl get pods my-pod -o=name`. They are generated from
[`k-grammar.toml`](../k-grammar.toml). For how the shells differ, see
[Shell differences](shells.md).

Learn the pattern rather than the list: start with the verbs, add a resource, then add
modifiers as you need them.

- [The pattern](#the-pattern)
- [Verbs](#verbs)
- [Resources](#resources)
- [Modifiers](#modifiers)
- [Other kubectl aliases](#other-kubectl-aliases)
- [Conflict rules](#conflict-rules)
- [Quick reference](#quick-reference)

## The pattern

```text
k + [z] + verb + [resource] + [modifiers]

k  + g + p              = kgp       kubectl get pods
k  + z + g + p          = kzgp      kubectl --namespace=kube-system get pods
k  + g + p + y          = kgpy      kubectl get pods -o=yaml
k  + g + p + w          = kgpw      kubectl get pods --watch
k  + g + p + aa         = kgpaa     kubectl get pods --all-namespaces
k  + g + p + aa + w + y = kgpaawy   kubectl get pods --all-namespaces --watch -o=yaml
k  + d + p              = kdp       kubectl describe pods
k  + x + p              = kxp       kubectl delete pods
k  + g + de + y         = kgdey     kubectl get deployment -o=yaml
```

The order is always verb, then resource, then modifiers. Not every combination exists: the
grammar records the aliases that grew over time rather than every possible mix, and
modifiers have a fixed order (see [Modifiers](#modifiers)). With no resource, the verb
applies to whatever you pass: `kg pods`, `kd pod/my-pod`.

## Verbs

```text
kg      kubectl get
kd      kubectl describe
kx      kubectl delete              x for "exterminate", because d is describe
ka      kubectl apply --recursive -f     pass a path: ka deploy.yaml
kl      kubectl logs -f             always follows
ke      kubectl exec -i -t
```

Only `g`, `d` and `x` combine with resources and modifiers. `ka`, `kl` and `ke` are
standalone; see [Other kubectl aliases](#other-kubectl-aliases) for their variants.

> **Warning:** every alias that starts with `kx` deletes. `kx…aa` deletes *all* resources of
> that type in the current namespace (`kxpaa` is `kubectl delete pods --all`).

## Resources

```text
p       pods                first letter
de      deployment          first two letters, because d is describe
sv      service             s + v, because se is secret
i       ingress
c       configmap
se      secret
no      nodes               get and describe only
n, ns   namespaces          kgn; ns is used where n would clash (kgnso, below)
```

`z` before the verb runs the command in `kube-system`: `kzgp`, `kzdp`, `kzxp`. Think "zone
zero", where the system lives.

## Modifiers

```text
aa      --all-namespaces    with delete: --all (destructive)
w       --watch
y       -o=yaml
j       -o=json
o       -o=wide
sl      --show-labels
l       -l                  selector: kgpl app=web
n       --namespace         kgpn my-namespace
f       --recursive -f      get, describe and delete with no resource: kgf manifests/
```

Modifiers go in this order: `aa`, then `w`, then a format (`y`, `j` or `o`), then `l` or `n`.
So `kgpwy` exists and `kgpyw` does not. `sl` can sit in most positions (`kgposl` and
`kgpslo` both exist), and `l`, `n` and `f` always come last because they take a value.

Long forms are synonyms: `oyaml`, `owide` and `ojson` for the formats (after `aa`, as in
`kgpaaoyaml`), and `all` for `aa`, placed after `w` or a format (`kgpwall`, `kgpoall`).

## Other kubectl aliases

These do not follow the pattern:

```text
k       kubectl
kak     kubectl apply -k
kk      kubectl kustomize
kln     kubectl logs -f --namespace
klp     kubectl logs -f -p            previous container
ken     kubectl exec -i -t --namespace
kp      kubectl proxy
kpf     kubectl port-forward
kpfn    kubectl port-forward --namespace
krun    kubectl run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t
kz      kubectl --namespace=kube-system
kza, kze, kzl, kzlp, kzrun       the same as ka, ke, kl, klp and krun, in kube-system
```

## Conflict rules

1. **The most common command gets the first letter.** `d` is describe, so delete is `x`.
2. **Add letters when two names clash.** `de` is deployment (not `d`), `sv` is service (not
   `s`, next to secret).
3. **`aa` means "all".** With `get` and `describe` it is `--all-namespaces`; with delete it is
   `--all`, which deletes every resource of that type in the **current** namespace. Treat any
   `kx…aa` alias as destructive.
4. **`n` means two things.** As a resource it is namespaces (`kgn`); as a trailing modifier it
   is `--namespace` (`kgpn`). `kgno` is nodes, so namespaces with wide output is `kgnso` (and
   `kgnsoall`).

## Quick reference

```text
Daily
  kg pods            get pods
  kd pod/name        describe a pod
  kl pod/name        follow a pod's logs
  ke pod/name -- sh  exec into a pod
  kx pod name        delete a pod

Resources                       Output and modifiers
  kgp    get pods                 kgpy    pods as yaml
  kgde   get deployments          kgpj    pods as json
  kgsv   get services             kgpo    pods, wide
  kgi    get ingress              kgpw    watch pods
  kgc    get configmaps           kgpaa   pods in all namespaces
  kgse   get secrets              kgpsl   pods with labels
  kgn    get namespaces           kzgp    pods in kube-system
  kgno   get nodes
```
