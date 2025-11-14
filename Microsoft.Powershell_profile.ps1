# PowerShell Profile v2.0.0
# DevOps-focused profile with mnemonic aliases for Git, Terraform, and Kubectl
# See README.md for documentation

function cd.. { cd .. }

# Enable command line prompt for git branch and status
Import-Module posh-git

# Enable git aliases if so inclined
Import-Module git-aliases -DisableNameChecking
# https://github.com/gluons/powershell-git-aliases/blob/master/src/aliases.ps1

# e.g.
# gco "foo-feature"
# gcb "bar-new-feature"
# ga .
# gcmsg "this is my commit message"
# gp
# gl

# Tab auto-completion for kubectl command
Import-Module PSKubectlCompletion
Register-KubectlCompletion

# terraform aliases for the main command loop
New-Alias -Name "tf" -Value "terraform"

function ti { terraform init }
function tp { terraform plan }
function ta { terraform apply --auto-approve }
function td { terraform destroy }
function tv { terraform validate }
function tfmt { terraform fmt }
function tpt { terraform plan -target=$args }
function tat { terraform apply -target=$args --auto-approve }

# Powershell, give me grep!
function grep {
    $input | out-string -stream | select-string $args
}
# Powershell, give me export!
function export {
    $pos = $args[0].IndexOf("=")
    $leftPart  = $args[0].Substring(0, $pos)
    $rightPart = $args[0].Substring($pos+1)
    [System.Environment]::SetEnvironmentVariable($leftPart, $rightPart, [System.EnvironmentVariableTarget]::User)
}

# Powershell, give me touch!
function touch {
    New-Item -ItemType File -Name ($args[0])
}

# Powershell, I want to focus. Give me control of Spotify!
function focus {
    start 'https://open.spotify.com/user/spotify/playlist/37i9dQZF1DWX9ZIH7jslKG?si=I4EcN0cnQFy0tdyk_meqqA'
}

# Powershell, I want to relax. Give me control of Spotify!
function relax {
    start 'https://open.spotify.com/user/calmingmusicacademy/playlist/5ePKan7UdZQYLda19zLx2L?si=gUyqCHaPScqtm8uE9CkY7A'
}

# kubectl aliases - syntax 
#
# k = kubectl
#    z = --namespace kube-system
#
# sub-commands:
# g = get, d = describe, x = delete, a = apply -f, e = exec -i -t, l = logs -f
#
# resources:
# p = pod, de = deployment, i = ingress, sv = service, c = configmap, se = secret, n = namespace, no = node
# 
# flags:
# output = y (yaml), j (json), o (wide)
# aa = --all or --all-namespaces
# sl = --show-labels
# w = -w/--watch
# 
# value flags: (should be at the very end):
# f = -f/--filename
# l = -l/--selector

function k() { & kubectl $args }
function kz() { & kubectl --namespace=kube-system $args }
function ka() { & kubectl apply --recursive -f $args }
function kza() { & kubectl --namespace=kube-system apply --recursive -f $args }
function kak() { & kubectl apply -k $args }
function kk() { & kubectl kustomize $args }
function ke() { & kubectl exec -i -t $args }
function kze() { & kubectl --namespace=kube-system exec -i -t $args }
function kl() { & kubectl logs -f $args }
function kzl() { & kubectl --namespace=kube-system logs -f $args }
function klp() { & kubectl logs -f -p $args }
function kzlp() { & kubectl --namespace=kube-system logs -f -p $args }
function kp() { & kubectl proxy $args }
function kpf() { & kubectl port-forward $args }
function kg() { & kubectl get $args }
function kzg() { & kubectl --namespace=kube-system get $args }
function kd() { & kubectl describe $args }
function kzd() { & kubectl --namespace=kube-system describe $args }
function kx() { & kubectl delete $args }
function kzx() { & kubectl --namespace=kube-system delete $args }
function krun() { & kubectl run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t $args }
function kzrun() { & kubectl --namespace=kube-system run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t $args }
function kgp() { & kubectl get pods $args }
function kzgp() { & kubectl --namespace=kube-system get pods $args }
function kdp() { & kubectl describe pods $args }
function kzdp() { & kubectl --namespace=kube-system describe pods $args }
function kxp() { & kubectl delete pods $args }
function kzxp() { & kubectl --namespace=kube-system delete pods $args }
function kgde() { & kubectl get deployment $args }
function kzgde() { & kubectl --namespace=kube-system get deployment $args }
function kdde() { & kubectl describe deployment $args }
function kzdde() { & kubectl --namespace=kube-system describe deployment $args }
function kxde() { & kubectl delete deployment $args }
function kzxde() { & kubectl --namespace=kube-system delete deployment $args }
function kgsv() { & kubectl get service $args }
function kzgsv() { & kubectl --namespace=kube-system get service $args }
function kdsv() { & kubectl describe service $args }
function kzdsv() { & kubectl --namespace=kube-system describe service $args }
function kxsv() { & kubectl delete service $args }
function kzxsv() { & kubectl --namespace=kube-system delete service $args }
function kgi() { & kubectl get ingress $args }
function kzgi() { & kubectl --namespace=kube-system get ingress $args }
function kdi() { & kubectl describe ingress $args }
function kzdi() { & kubectl --namespace=kube-system describe ingress $args }
function kxi() { & kubectl delete ingress $args }
function kzxi() { & kubectl --namespace=kube-system delete ingress $args }
function kgc() { & kubectl get configmap $args }
function kzgc() { & kubectl --namespace=kube-system get configmap $args }
function kdc() { & kubectl describe configmap $args }
function kzdc() { & kubectl --namespace=kube-system describe configmap $args }
function kxc() { & kubectl delete configmap $args }
function kzxc() { & kubectl --namespace=kube-system delete configmap $args }
function kgse() { & kubectl get secret $args }
function kzgse() { & kubectl --namespace=kube-system get secret $args }
function kdse() { & kubectl describe secret $args }
function kzdse() { & kubectl --namespace=kube-system describe secret $args }
function kxse() { & kubectl delete secret $args }
function kzxse() { & kubectl --namespace=kube-system delete secret $args }
function kgno() { & kubectl get nodes $args }
function kdno() { & kubectl describe nodes $args }
function kgn() { & kubectl get namespaces $args }
function kdn() { & kubectl describe namespaces $args }
function kxn() { & kubectl delete namespaces $args }
function kgy() { & kubectl get -o=yaml $args }
function kzgy() { & kubectl --namespace=kube-system get -o=yaml $args }
function kgpy() { & kubectl get pods -o=yaml $args }
function kzgpy() { & kubectl --namespace=kube-system get pods -o=yaml $args }
function kgdey() { & kubectl get deployment -o=yaml $args }
function kzgdey() { & kubectl --namespace=kube-system get deployment -o=yaml $args }
function kgsvy() { & kubectl get service -o=yaml $args }
function kzgsvy() { & kubectl --namespace=kube-system get service -o=yaml $args }
function kgiy() { & kubectl get ingress -o=yaml $args }
function kzgiy() { & kubectl --namespace=kube-system get ingress -o=yaml $args }
function kgcy() { & kubectl get configmap -o=yaml $args }
function kzgcy() { & kubectl --namespace=kube-system get configmap -o=yaml $args }
function kgsey() { & kubectl get secret -o=yaml $args }
function kzgsey() { & kubectl --namespace=kube-system get secret -o=yaml $args }
function kgnoy() { & kubectl get nodes -o=yaml $args }
function kgny() { & kubectl get namespaces -o=yaml $args }
function kgo() { & kubectl get -o=wide $args }
function kzgo() { & kubectl --namespace=kube-system get -o=wide $args }
function kgpo() { & kubectl get pods -o=wide $args }
function kzgpo() { & kubectl --namespace=kube-system get pods -o=wide $args }
function kgdeo() { & kubectl get deployment -o=wide $args }
function kzgdeo() { & kubectl --namespace=kube-system get deployment -o=wide $args }
function kgsvo() { & kubectl get service -o=wide $args }
function kzgsvo() { & kubectl --namespace=kube-system get service -o=wide $args }
function kgio() { & kubectl get ingress -o=wide $args }
function kzgio() { & kubectl --namespace=kube-system get ingress -o=wide $args }
function kgco() { & kubectl get configmap -o=wide $args }
function kzgco() { & kubectl --namespace=kube-system get configmap -o=wide $args }
function kgseo() { & kubectl get secret -o=wide $args }
function kzgseo() { & kubectl --namespace=kube-system get secret -o=wide $args }
function kgnoo() { & kubectl get nodes -o=wide $args }
function kgnso() { & kubectl get namespaces -o=wide $args }
function kgj() { & kubectl get -o=json $args }
function kzgj() { & kubectl --namespace=kube-system get -o=json $args }
function kgpj() { & kubectl get pods -o=json $args }
function kzgpj() { & kubectl --namespace=kube-system get pods -o=json $args }
function kgdej() { & kubectl get deployment -o=json $args }
function kzgdej() { & kubectl --namespace=kube-system get deployment -o=json $args }
function kgsvj() { & kubectl get service -o=json $args }
function kzgsvj() { & kubectl --namespace=kube-system get service -o=json $args }
function kgij() { & kubectl get ingress -o=json $args }
function kzgij() { & kubectl --namespace=kube-system get ingress -o=json $args }
function kgcj() { & kubectl get configmap -o=json $args }
function kzgcj() { & kubectl --namespace=kube-system get configmap -o=json $args }
function kgsej() { & kubectl get secret -o=json $args }
function kzgsej() { & kubectl --namespace=kube-system get secret -o=json $args }
function kgnoj() { & kubectl get nodes -o=json $args }
function kgnj() { & kubectl get namespaces -o=json $args }
function kgaa() { & kubectl get --all-namespaces $args }
function kdaa() { & kubectl describe --all-namespaces $args }
function kgpaa() { & kubectl get pods --all-namespaces $args }
function kdpaa() { & kubectl describe pods --all-namespaces $args }
function kgdeaa() { & kubectl get deployment --all-namespaces $args }
function kddeaa() { & kubectl describe deployment --all-namespaces $args }
function kgsvaa() { & kubectl get service --all-namespaces $args }
function kdsvaa() { & kubectl describe service --all-namespaces $args }
function kgiaa() { & kubectl get ingress --all-namespaces $args }
function kdiaa() { & kubectl describe ingress --all-namespaces $args }
function kgcaa() { & kubectl get configmap --all-namespaces $args }
function kdcaa() { & kubectl describe configmap --all-namespaces $args }
function kgseaa() { & kubectl get secret --all-namespaces $args }
function kdseaa() { & kubectl describe secret --all-namespaces $args }
function kgnaa() { & kubectl get namespaces --all-namespaces $args }
function kdnaa() { & kubectl describe namespaces --all-namespaces $args }
function kgsl() { & kubectl get --show-labels $args }
function kzgsl() { & kubectl --namespace=kube-system get --show-labels $args }
function kgpsl() { & kubectl get pods --show-labels $args }
function kzgpsl() { & kubectl --namespace=kube-system get pods --show-labels $args }
function kgdesl() { & kubectl get deployment --show-labels $args }
function kzgdesl() { & kubectl --namespace=kube-system get deployment --show-labels $args }
function kxaa() { & kubectl delete --all $args }
function kzxaa() { & kubectl --namespace=kube-system delete --all $args }
function kxpaa() { & kubectl delete pods --all $args }
function kzxpaa() { & kubectl --namespace=kube-system delete pods --all $args }
function kxdeaa() { & kubectl delete deployment --all $args }
function kzxdeaa() { & kubectl --namespace=kube-system delete deployment --all $args }
function kxsvaa() { & kubectl delete service --all $args }
function kzxsvaa() { & kubectl --namespace=kube-system delete service --all $args }
function kxiaa() { & kubectl delete ingress --all $args }
function kzxiaa() { & kubectl --namespace=kube-system delete ingress --all $args }
function kxcaa() { & kubectl delete configmap --all $args }
function kzxcaa() { & kubectl --namespace=kube-system delete configmap --all $args }
function kxseaa() { & kubectl delete secret --all $args }
function kzxseaa() { & kubectl --namespace=kube-system delete secret --all $args }
function kxnaa() { & kubectl delete namespaces --all $args }
function kgw() { & kubectl get --watch $args }
function kzgw() { & kubectl --namespace=kube-system get --watch $args }
function kgpw() { & kubectl get pods --watch $args }
function kzgpw() { & kubectl --namespace=kube-system get pods --watch $args }
function kgdew() { & kubectl get deployment --watch $args }
function kzgdew() { & kubectl --namespace=kube-system get deployment --watch $args }
function kgsvw() { & kubectl get service --watch $args }
function kzgsvw() { & kubectl --namespace=kube-system get service --watch $args }
function kgiw() { & kubectl get ingress --watch $args }
function kzgiw() { & kubectl --namespace=kube-system get ingress --watch $args }
function kgcw() { & kubectl get configmap --watch $args }
function kzgcw() { & kubectl --namespace=kube-system get configmap --watch $args }
function kgsew() { & kubectl get secret --watch $args }
function kzgsew() { & kubectl --namespace=kube-system get secret --watch $args }
function kgnow() { & kubectl get nodes --watch $args }
function kgnw() { & kubectl get namespaces --watch $args }
function kgyall() { & kubectl get -o=yaml --all-namespaces $args }
function kgpyall() { & kubectl get pods -o=yaml --all-namespaces $args }
function kgdeyall() { & kubectl get deployment -o=yaml --all-namespaces $args }
function kgsvyall() { & kubectl get service -o=yaml --all-namespaces $args }
function kgiyall() { & kubectl get ingress -o=yaml --all-namespaces $args }
function kgcyall() { & kubectl get configmap -o=yaml --all-namespaces $args }
function kgseyall() { & kubectl get secret -o=yaml --all-namespaces $args }
function kgnyall() { & kubectl get namespaces -o=yaml --all-namespaces $args }
function kgaaoyaml() { & kubectl get --all-namespaces -o=yaml $args }
function kgpaaoyaml() { & kubectl get pods --all-namespaces -o=yaml $args }
function kgpaay() { & kubectl get pods --all-namespaces -o=yaml $args }
function kgdeaaoyaml() { & kubectl get deployment --all-namespaces -o=yaml $args }
function kgsvaaoyaml() { & kubectl get service --all-namespaces -o=yaml $args }
function kgiaaoyaml() { & kubectl get ingress --all-namespaces -o=yaml $args }
function kgcaaoyaml() { & kubectl get configmap --all-namespaces -o=yaml $args }
function kgseaaoyaml() { & kubectl get secret --all-namespaces -o=yaml $args }
function kgnaaoyaml() { & kubectl get namespaces --all-namespaces -o=yaml $args }
function kgwy() { & kubectl get --watch -o=yaml $args }
function kzgwy() { & kubectl --namespace=kube-system get --watch -o=yaml $args }
function kgpwy() { & kubectl get pods --watch -o=yaml $args }
function kzgpwy() { & kubectl --namespace=kube-system get pods --watch -o=yaml $args }
function kgdewy() { & kubectl get deployment --watch -o=yaml $args }
function kzgdewy() { & kubectl --namespace=kube-system get deployment --watch -o=yaml $args }
function kgsvwy() { & kubectl get service --watch -o=yaml $args }
function kzgsvwy() { & kubectl --namespace=kube-system get service --watch -o=yaml $args }
function kgiwy() { & kubectl get ingress --watch -o=yaml $args }
function kzgiwy() { & kubectl --namespace=kube-system get ingress --watch -o=yaml $args }
function kgcwy() { & kubectl get configmap --watch -o=yaml $args }
function kzgcwy() { & kubectl --namespace=kube-system get configmap --watch -o=yaml $args }
function kgsewy() { & kubectl get secret --watch -o=yaml $args }
function kzgsewy() { & kubectl --namespace=kube-system get secret --watch -o=yaml $args }
function kgnowy() { & kubectl get nodes --watch -o=yaml $args }
function kgnwy() { & kubectl get namespaces --watch -o=yaml $args }
function kgoall() { & kubectl get -o=wide --all-namespaces $args }
function kgpoall() { & kubectl get pods -o=wide --all-namespaces $args }
function kgdeoall() { & kubectl get deployment -o=wide --all-namespaces $args }
function kgsvoall() { & kubectl get service -o=wide --all-namespaces $args }
function kgioall() { & kubectl get ingress -o=wide --all-namespaces $args }
function kgcoall() { & kubectl get configmap -o=wide --all-namespaces $args }
function kgseoall() { & kubectl get secret -o=wide --all-namespaces $args }
function kgnsoall() { & kubectl get namespaces -o=wide --all-namespaces $args }
function kgaaowide() { & kubectl get --all-namespaces -o=wide $args }
function kgpaaowide() { & kubectl get pods --all-namespaces -o=wide $args }
function kgdeaaowide() { & kubectl get deployment --all-namespaces -o=wide $args }
function kgsvaaowide() { & kubectl get service --all-namespaces -o=wide $args }
function kgiaaowide() { & kubectl get ingress --all-namespaces -o=wide $args }
function kgcaaowide() { & kubectl get configmap --all-namespaces -o=wide $args }
function kgseaaowide() { & kubectl get secret --all-namespaces -o=wide $args }
function kgnaaowide() { & kubectl get namespaces --all-namespaces -o=wide $args }
function kgosl() { & kubectl get -o=wide --show-labels $args }
function kzgosl() { & kubectl --namespace=kube-system get -o=wide --show-labels $args }
function kgposl() { & kubectl get pods -o=wide --show-labels $args }
function kzgposl() { & kubectl --namespace=kube-system get pods -o=wide --show-labels $args }
function kgdeosl() { & kubectl get deployment -o=wide --show-labels $args }
function kzgdeosl() { & kubectl --namespace=kube-system get deployment -o=wide --show-labels $args }
function kgslo() { & kubectl get --show-labels -o=wide $args }
function kzgslo() { & kubectl --namespace=kube-system get --show-labels -o=wide $args }
function kgpslo() { & kubectl get pods --show-labels -o=wide $args }
function kzgpslo() { & kubectl --namespace=kube-system get pods --show-labels -o=wide $args }
function kgdeslo() { & kubectl get deployment --show-labels -o=wide $args }
function kzgdeslo() { & kubectl --namespace=kube-system get deployment --show-labels -o=wide $args }
function kgwo() { & kubectl get --watch -o=wide $args }
function kzgwo() { & kubectl --namespace=kube-system get --watch -o=wide $args }
function kgpwo() { & kubectl get pods --watch -o=wide $args }
function kzgpwo() { & kubectl --namespace=kube-system get pods --watch -o=wide $args }
function kgdewo() { & kubectl get deployment --watch -o=wide $args }
function kzgdewo() { & kubectl --namespace=kube-system get deployment --watch -o=wide $args }
function kgsvwo() { & kubectl get service --watch -o=wide $args }
function kzgsvwo() { & kubectl --namespace=kube-system get service --watch -o=wide $args }
function kgiwo() { & kubectl get ingress --watch -o=wide $args }
function kzgiwo() { & kubectl --namespace=kube-system get ingress --watch -o=wide $args }
function kgcwo() { & kubectl get configmap --watch -o=wide $args }
function kzgcwo() { & kubectl --namespace=kube-system get configmap --watch -o=wide $args }
function kgsewo() { & kubectl get secret --watch -o=wide $args }
function kzgsewo() { & kubectl --namespace=kube-system get secret --watch -o=wide $args }
function kgnowo() { & kubectl get nodes --watch -o=wide $args }
function kgnwo() { & kubectl get namespaces --watch -o=wide $args }
function kgjall() { & kubectl get -o=json --all-namespaces $args }
function kgpjall() { & kubectl get pods -o=json --all-namespaces $args }
function kgdejall() { & kubectl get deployment -o=json --all-namespaces $args }
function kgsvjall() { & kubectl get service -o=json --all-namespaces $args }
function kgijall() { & kubectl get ingress -o=json --all-namespaces $args }
function kgcjall() { & kubectl get configmap -o=json --all-namespaces $args }
function kgsejall() { & kubectl get secret -o=json --all-namespaces $args }
function kgnjall() { & kubectl get namespaces -o=json --all-namespaces $args }
function kgaaojson() { & kubectl get --all-namespaces -o=json $args }
function kgpaaojson() { & kubectl get pods --all-namespaces -o=json $args }
function kgdeaaojson() { & kubectl get deployment --all-namespaces -o=json $args }
function kgsvaaojson() { & kubectl get service --all-namespaces -o=json $args }
function kgiaaojson() { & kubectl get ingress --all-namespaces -o=json $args }
function kgcaaojson() { & kubectl get configmap --all-namespaces -o=json $args }
function kgseaaojson() { & kubectl get secret --all-namespaces -o=json $args }
function kgnaaojson() { & kubectl get namespaces --all-namespaces -o=json $args }
function kgwj() { & kubectl get --watch -o=json $args }
function kzgwj() { & kubectl --namespace=kube-system get --watch -o=json $args }
function kgpwj() { & kubectl get pods --watch -o=json $args }
function kzgpwj() { & kubectl --namespace=kube-system get pods --watch -o=json $args }
function kgdewj() { & kubectl get deployment --watch -o=json $args }
function kzgdewj() { & kubectl --namespace=kube-system get deployment --watch -o=json $args }
function kgsvwj() { & kubectl get service --watch -o=json $args }
function kzgsvwj() { & kubectl --namespace=kube-system get service --watch -o=json $args }
function kgiwj() { & kubectl get ingress --watch -o=json $args }
function kzgiwj() { & kubectl --namespace=kube-system get ingress --watch -o=json $args }
function kgcwj() { & kubectl get configmap --watch -o=json $args }
function kzgcwj() { & kubectl --namespace=kube-system get configmap --watch -o=json $args }
function kgsewj() { & kubectl get secret --watch -o=json $args }
function kzgsewj() { & kubectl --namespace=kube-system get secret --watch -o=json $args }
function kgnowj() { & kubectl get nodes --watch -o=json $args }
function kgnwj() { & kubectl get namespaces --watch -o=json $args }
function kgaasl() { & kubectl get --all-namespaces --show-labels $args }
function kgpaasl() { & kubectl get pods --all-namespaces --show-labels $args }
function kgdeaasl() { & kubectl get deployment --all-namespaces --show-labels $args }
function kgslall() { & kubectl get --show-labels --all-namespaces $args }
function kgpslall() { & kubectl get pods --show-labels --all-namespaces $args }
function kgdeslall() { & kubectl get deployment --show-labels --all-namespaces $args }
function kgaaw() { & kubectl get --all-namespaces --watch $args }
function kgpaaw() { & kubectl get pods --all-namespaces --watch $args }
function kgdeaaw() { & kubectl get deployment --all-namespaces --watch $args }
function kgsvaaw() { & kubectl get service --all-namespaces --watch $args }
function kgiaaw() { & kubectl get ingress --all-namespaces --watch $args }
function kgcaaw() { & kubectl get configmap --all-namespaces --watch $args }
function kgseaaw() { & kubectl get secret --all-namespaces --watch $args }
function kgnaaw() { & kubectl get namespaces --all-namespaces --watch $args }
function kgwall() { & kubectl get --watch --all-namespaces $args }
function kgpwall() { & kubectl get pods --watch --all-namespaces $args }
function kgdewall() { & kubectl get deployment --watch --all-namespaces $args }
function kgsvwall() { & kubectl get service --watch --all-namespaces $args }
function kgiwall() { & kubectl get ingress --watch --all-namespaces $args }
function kgcwall() { & kubectl get configmap --watch --all-namespaces $args }
function kgsewall() { & kubectl get secret --watch --all-namespaces $args }
function kgnwall() { & kubectl get namespaces --watch --all-namespaces $args }
function kgslw() { & kubectl get --show-labels --watch $args }
function kzgslw() { & kubectl --namespace=kube-system get --show-labels --watch $args }
function kgpslw() { & kubectl get pods --show-labels --watch $args }
function kzgpslw() { & kubectl --namespace=kube-system get pods --show-labels --watch $args }
function kgdeslw() { & kubectl get deployment --show-labels --watch $args }
function kzgdeslw() { & kubectl --namespace=kube-system get deployment --show-labels --watch $args }
function kgwsl() { & kubectl get --watch --show-labels $args }
function kzgwsl() { & kubectl --namespace=kube-system get --watch --show-labels $args }
function kgpwsl() { & kubectl get pods --watch --show-labels $args }
function kzgpwsl() { & kubectl --namespace=kube-system get pods --watch --show-labels $args }
function kgdewsl() { & kubectl get deployment --watch --show-labels $args }
function kzgdewsl() { & kubectl --namespace=kube-system get deployment --watch --show-labels $args }
function kgaawy() { & kubectl get --all-namespaces --watch -o=yaml $args }
function kgpaawy() { & kubectl get pods --all-namespaces --watch -o=yaml $args }
function kgdeaawy() { & kubectl get deployment --all-namespaces --watch -o=yaml $args }
function kgsvaawy() { & kubectl get service --all-namespaces --watch -o=yaml $args }
function kgiaawy() { & kubectl get ingress --all-namespaces --watch -o=yaml $args }
function kgcaawy() { & kubectl get configmap --all-namespaces --watch -o=yaml $args }
function kgseaawy() { & kubectl get secret --all-namespaces --watch -o=yaml $args }
function kgnaawy() { & kubectl get namespaces --all-namespaces --watch -o=yaml $args }
function kgwyall() { & kubectl get --watch -o=yaml --all-namespaces $args }
function kgpwyall() { & kubectl get pods --watch -o=yaml --all-namespaces $args }
function kgdewyall() { & kubectl get deployment --watch -o=yaml --all-namespaces $args }
function kgsvwyall() { & kubectl get service --watch -o=yaml --all-namespaces $args }
function kgiwyall() { & kubectl get ingress --watch -o=yaml --all-namespaces $args }
function kgcwyall() { & kubectl get configmap --watch -o=yaml --all-namespaces $args }
function kgsewyall() { & kubectl get secret --watch -o=yaml --all-namespaces $args }
function kgnwyall() { & kubectl get namespaces --watch -o=yaml --all-namespaces $args }
function kgwaay() { & kubectl get --watch --all-namespaces -o=yaml $args }
function kgpwaay() { & kubectl get pods --watch --all-namespaces -o=yaml $args }
function kgdewaay() { & kubectl get deployment --watch --all-namespaces -o=yaml $args }
function kgsvwaay() { & kubectl get service --watch --all-namespaces -o=yaml $args }
function kgiwaay() { & kubectl get ingress --watch --all-namespaces -o=yaml $args }
function kgcwaay() { & kubectl get configmap --watch --all-namespaces -o=yaml $args }
function kgsewaay() { & kubectl get secret --watch --all-namespaces -o=yaml $args }
function kgnwaay() { & kubectl get namespaces --watch --all-namespaces -o=yaml $args }
function kgoallsl() { & kubectl get -o=wide --all-namespaces --show-labels $args }
function kgpoallsl() { & kubectl get pods -o=wide --all-namespaces --show-labels $args }
function kgdeoallsl() { & kubectl get deployment -o=wide --all-namespaces --show-labels $args }
function kgoslall() { & kubectl get -o=wide --show-labels --all-namespaces $args }
function kgposlall() { & kubectl get pods -o=wide --show-labels --all-namespaces $args }
function kgdeoslall() { & kubectl get deployment -o=wide --show-labels --all-namespaces $args }
function kgaaosl() { & kubectl get --all-namespaces -o=wide --show-labels $args }
function kgpaaosl() { & kubectl get pods --all-namespaces -o=wide --show-labels $args }
function kgdeaaosl() { & kubectl get deployment --all-namespaces -o=wide --show-labels $args }
function kgaaslo() { & kubectl get --all-namespaces --show-labels -o=wide $args }
function kgpaaslo() { & kubectl get pods --all-namespaces --show-labels -o=wide $args }
function kgdeaaslo() { & kubectl get deployment --all-namespaces --show-labels -o=wide $args }
function kgsloaa() { & kubectl get --show-labels -o=wide --all-namespaces $args }
function kgpsloaa() { & kubectl get pods --show-labels -o=wide --all-namespaces $args }
function kgdesloaa() { & kubectl get deployment --show-labels -o=wide --all-namespaces $args }
function kgslaao() { & kubectl get --show-labels --all-namespaces -o=wide $args }
function kgpslaao() { & kubectl get pods --show-labels --all-namespaces -o=wide $args }
function kgdeslaao() { & kubectl get deployment --show-labels --all-namespaces -o=wide $args }
function kgaawo() { & kubectl get --all-namespaces --watch -o=wide $args }
function kgpaawo() { & kubectl get pods --all-namespaces --watch -o=wide $args }
function kgdeaawo() { & kubectl get deployment --all-namespaces --watch -o=wide $args }
function kgsvaawo() { & kubectl get service --all-namespaces --watch -o=wide $args }
function kgiaawo() { & kubectl get ingress --all-namespaces --watch -o=wide $args }
function kgcaawo() { & kubectl get configmap --all-namespaces --watch -o=wide $args }
function kgseaawo() { & kubectl get secret --all-namespaces --watch -o=wide $args }
function kgnaawo() { & kubectl get namespaces --all-namespaces --watch -o=wide $args }
function kgwoall() { & kubectl get --watch -o=wide --all-namespaces $args }
function kgpwoall() { & kubectl get pods --watch -o=wide --all-namespaces $args }
function kgdewoall() { & kubectl get deployment --watch -o=wide --all-namespaces $args }
function kgsvwoall() { & kubectl get service --watch -o=wide --all-namespaces $args }
function kgiwoall() { & kubectl get ingress --watch -o=wide --all-namespaces $args }
function kgcwoall() { & kubectl get configmap --watch -o=wide --all-namespaces $args }
function kgsewoall() { & kubectl get secret --watch -o=wide --all-namespaces $args }
function kgnwoall() { & kubectl get namespaces --watch -o=wide --all-namespaces $args }
function kgwaao() { & kubectl get --watch --all-namespaces -o=wide $args }
function kgpwaao() { & kubectl get pods --watch --all-namespaces -o=wide $args }
function kgdewaao() { & kubectl get deployment --watch --all-namespaces -o=wide $args }
function kgsvwaao() { & kubectl get service --watch --all-namespaces -o=wide $args }
function kgiwaao() { & kubectl get ingress --watch --all-namespaces -o=wide $args }
function kgcwaao() { & kubectl get configmap --watch --all-namespaces -o=wide $args }
function kgsewaao() { & kubectl get secret --watch --all-namespaces -o=wide $args }
function kgnwaao() { & kubectl get namespaces --watch --all-namespaces -o=wide $args }
function kgslwo() { & kubectl get --show-labels --watch -o=wide $args }
function kzgslwo() { & kubectl --namespace=kube-system get --show-labels --watch -o=wide $args }
function kgpslwo() { & kubectl get pods --show-labels --watch -o=wide $args }
function kzgpslwo() { & kubectl --namespace=kube-system get pods --show-labels --watch -o=wide $args }
function kgdeslwo() { & kubectl get deployment --show-labels --watch -o=wide $args }
function kzgdeslwo() { & kubectl --namespace=kube-system get deployment --show-labels --watch -o=wide $args }
function kgwosl() { & kubectl get --watch -o=wide --show-labels $args }
function kzgwosl() { & kubectl --namespace=kube-system get --watch -o=wide --show-labels $args }
function kgpwosl() { & kubectl get pods --watch -o=wide --show-labels $args }
function kzgpwosl() { & kubectl --namespace=kube-system get pods --watch -o=wide --show-labels $args }
function kgdewosl() { & kubectl get deployment --watch -o=wide --show-labels $args }
function kzgdewosl() { & kubectl --namespace=kube-system get deployment --watch -o=wide --show-labels $args }
function kgwslo() { & kubectl get --watch --show-labels -o=wide $args }
function kzgwslo() { & kubectl --namespace=kube-system get --watch --show-labels -o=wide $args }
function kgpwslo() { & kubectl get pods --watch --show-labels -o=wide $args }
function kzgpwslo() { & kubectl --namespace=kube-system get pods --watch --show-labels -o=wide $args }
function kgdewslo() { & kubectl get deployment --watch --show-labels -o=wide $args }
function kzgdewslo() { & kubectl --namespace=kube-system get deployment --watch --show-labels -o=wide $args }
function kgaawj() { & kubectl get --all-namespaces --watch -o=json $args }
function kgpaawj() { & kubectl get pods --all-namespaces --watch -o=json $args }
function kgdeaawj() { & kubectl get deployment --all-namespaces --watch -o=json $args }
function kgsvaawj() { & kubectl get service --all-namespaces --watch -o=json $args }
function kgiaawj() { & kubectl get ingress --all-namespaces --watch -o=json $args }
function kgcaawj() { & kubectl get configmap --all-namespaces --watch -o=json $args }
function kgseaawj() { & kubectl get secret --all-namespaces --watch -o=json $args }
function kgnaawj() { & kubectl get namespaces --all-namespaces --watch -o=json $args }
function kgwjall() { & kubectl get --watch -o=json --all-namespaces $args }
function kgpwjall() { & kubectl get pods --watch -o=json --all-namespaces $args }
function kgdewjall() { & kubectl get deployment --watch -o=json --all-namespaces $args }
function kgsvwjall() { & kubectl get service --watch -o=json --all-namespaces $args }
function kgiwjall() { & kubectl get ingress --watch -o=json --all-namespaces $args }
function kgcwjall() { & kubectl get configmap --watch -o=json --all-namespaces $args }
function kgsewjall() { & kubectl get secret --watch -o=json --all-namespaces $args }
function kgnwjall() { & kubectl get namespaces --watch -o=json --all-namespaces $args }
function kgwaaj() { & kubectl get --watch --all-namespaces -o=json $args }
function kgpwaaj() { & kubectl get pods --watch --all-namespaces -o=json $args }
function kgdewaaj() { & kubectl get deployment --watch --all-namespaces -o=json $args }
function kgsvwaaj() { & kubectl get service --watch --all-namespaces -o=json $args }
function kgiwaaj() { & kubectl get ingress --watch --all-namespaces -o=json $args }
function kgcwaaj() { & kubectl get configmap --watch --all-namespaces -o=json $args }
function kgsewaaj() { & kubectl get secret --watch --all-namespaces -o=json $args }
function kgnwaaj() { & kubectl get namespaces --watch --all-namespaces -o=json $args }
function kgaaslw() { & kubectl get --all-namespaces --show-labels --watch $args }
function kgpaaslw() { & kubectl get pods --all-namespaces --show-labels --watch $args }
function kgdeaaslw() { & kubectl get deployment --all-namespaces --show-labels --watch $args }
function kgaawsl() { & kubectl get --all-namespaces --watch --show-labels $args }
function kgpaawsl() { & kubectl get pods --all-namespaces --watch --show-labels $args }
function kgdeaawsl() { & kubectl get deployment --all-namespaces --watch --show-labels $args }
function kgslallw() { & kubectl get --show-labels --all-namespaces --watch $args }
function kgpslallw() { & kubectl get pods --show-labels --all-namespaces --watch $args }
function kgdeslallw() { & kubectl get deployment --show-labels --all-namespaces --watch $args }
function kgslwall() { & kubectl get --show-labels --watch --all-namespaces $args }
function kgpslwall() { & kubectl get pods --show-labels --watch --all-namespaces $args }
function kgdeslwall() { & kubectl get deployment --show-labels --watch --all-namespaces $args }
function kgwallsl() { & kubectl get --watch --all-namespaces --show-labels $args }
function kgpwallsl() { & kubectl get pods --watch --all-namespaces --show-labels $args }
function kgdewallsl() { & kubectl get deployment --watch --all-namespaces --show-labels $args }
function kgwslall() { & kubectl get --watch --show-labels --all-namespaces $args }
function kgpwslall() { & kubectl get pods --watch --show-labels --all-namespaces $args }
function kgdewslall() { & kubectl get deployment --watch --show-labels --all-namespaces $args }
function kgaaslwo() { & kubectl get --all-namespaces --show-labels --watch -o=wide $args }
function kgpaaslwo() { & kubectl get pods --all-namespaces --show-labels --watch -o=wide $args }
function kgdeaaslwo() { & kubectl get deployment --all-namespaces --show-labels --watch -o=wide $args }
function kgaawosl() { & kubectl get --all-namespaces --watch -o=wide --show-labels $args }
function kgpaawosl() { & kubectl get pods --all-namespaces --watch -o=wide --show-labels $args }
function kgdeaawosl() { & kubectl get deployment --all-namespaces --watch -o=wide --show-labels $args }
function kgaawslo() { & kubectl get --all-namespaces --watch --show-labels -o=wide $args }
function kgpaawslo() { & kubectl get pods --all-namespaces --watch --show-labels -o=wide $args }
function kgdeaawslo() { & kubectl get deployment --all-namespaces --watch --show-labels -o=wide $args }
function kgslallwo() { & kubectl get --show-labels --all-namespaces --watch -o=wide $args }
function kgpslallwo() { & kubectl get pods --show-labels --all-namespaces --watch -o=wide $args }
function kgdeslallwo() { & kubectl get deployment --show-labels --all-namespaces --watch -o=wide $args }
function kgslwoall() { & kubectl get --show-labels --watch -o=wide --all-namespaces $args }
function kgpslwoall() { & kubectl get pods --show-labels --watch -o=wide --all-namespaces $args }
function kgdeslwoall() { & kubectl get deployment --show-labels --watch -o=wide --all-namespaces $args }
function kgslwaao() { & kubectl get --show-labels --watch --all-namespaces -o=wide $args }
function kgpslwaao() { & kubectl get pods --show-labels --watch --all-namespaces -o=wide $args }
function kgdeslwaao() { & kubectl get deployment --show-labels --watch --all-namespaces -o=wide $args }
function kgwoallsl() { & kubectl get --watch -o=wide --all-namespaces --show-labels $args }
function kgpwoallsl() { & kubectl get pods --watch -o=wide --all-namespaces --show-labels $args }
function kgdewoallsl() { & kubectl get deployment --watch -o=wide --all-namespaces --show-labels $args }
function kgwoslall() { & kubectl get --watch -o=wide --show-labels --all-namespaces $args }
function kgpwoslall() { & kubectl get pods --watch -o=wide --show-labels --all-namespaces $args }
function kgdewoslall() { & kubectl get deployment --watch -o=wide --show-labels --all-namespaces $args }
function kgwaaosl() { & kubectl get --watch --all-namespaces -o=wide --show-labels $args }
function kgpwaaosl() { & kubectl get pods --watch --all-namespaces -o=wide --show-labels $args }
function kgdewaaosl() { & kubectl get deployment --watch --all-namespaces -o=wide --show-labels $args }
function kgwallslo() { & kubectl get --watch --all-namespaces --show-labels -o=wide $args }
function kgpwallslo() { & kubectl get pods --watch --all-namespaces --show-labels -o=wide $args }
function kgdewallslo() { & kubectl get deployment --watch --all-namespaces --show-labels -o=wide $args }
function kgwsloaa() { & kubectl get --watch --show-labels -o=wide --all-namespaces $args }
function kgpwsloaa() { & kubectl get pods --watch --show-labels -o=wide --all-namespaces $args }
function kgdewsloaa() { & kubectl get deployment --watch --show-labels -o=wide --all-namespaces $args }
function kgwslaao() { & kubectl get --watch --show-labels --all-namespaces -o=wide $args }
function kgpwslaao() { & kubectl get pods --watch --show-labels --all-namespaces -o=wide $args }
function kgdewslaao() { & kubectl get deployment --watch --show-labels --all-namespaces -o=wide $args }
function kgf() { & kubectl get --recursive -f $args }
function kdf() { & kubectl describe --recursive -f $args }
function kxf() { & kubectl delete --recursive -f $args }
function kgyf() { & kubectl get -o=yaml --recursive -f $args }
function kgof() { & kubectl get -o=wide --recursive -f $args }
function kgjf() { & kubectl get -o=json --recursive -f $args }
function kgslf() { & kubectl get --show-labels --recursive -f $args }
function kgwf() { & kubectl get --watch --recursive -f $args }
function kgwyf() { & kubectl get --watch -o=yaml --recursive -f $args }
function kgoslf() { & kubectl get -o=wide --show-labels --recursive -f $args }
function kgslof() { & kubectl get --show-labels -o=wide --recursive -f $args }
function kgwof() { & kubectl get --watch -o=wide --recursive -f $args }
function kgwjf() { & kubectl get --watch -o=json --recursive -f $args }
function kgslwf() { & kubectl get --show-labels --watch --recursive -f $args }
function kgwslf() { & kubectl get --watch --show-labels --recursive -f $args }
function kgslwof() { & kubectl get --show-labels --watch -o=wide --recursive -f $args }
function kgwoslf() { & kubectl get --watch -o=wide --show-labels --recursive -f $args }
function kgwslof() { & kubectl get --watch --show-labels -o=wide --recursive -f $args }
function kgl() { & kubectl get -l $args }
function kzgl() { & kubectl --namespace=kube-system get -l $args }
function kdl() { & kubectl describe -l $args }
function kzdl() { & kubectl --namespace=kube-system describe -l $args }
function kxl() { & kubectl delete -l $args }
function kzxl() { & kubectl --namespace=kube-system delete -l $args }
function kgpl() { & kubectl get pods -l $args }
function kzgpl() { & kubectl --namespace=kube-system get pods -l $args }
function kdpl() { & kubectl describe pods -l $args }
function kzdpl() { & kubectl --namespace=kube-system describe pods -l $args }
function kxpl() { & kubectl delete pods -l $args }
function kzxpl() { & kubectl --namespace=kube-system delete pods -l $args }
function kgdel() { & kubectl get deployment -l $args }
function kzgdel() { & kubectl --namespace=kube-system get deployment -l $args }
function kddel() { & kubectl describe deployment -l $args }
function kzddel() { & kubectl --namespace=kube-system describe deployment -l $args }
function kxdel() { & kubectl delete deployment -l $args }
function kzxdel() { & kubectl --namespace=kube-system delete deployment -l $args }
function kgsvl() { & kubectl get service -l $args }
function kzgsvl() { & kubectl --namespace=kube-system get service -l $args }
function kdsvl() { & kubectl describe service -l $args }
function kzdsvl() { & kubectl --namespace=kube-system describe service -l $args }
function kxsvl() { & kubectl delete service -l $args }
function kzxsvl() { & kubectl --namespace=kube-system delete service -l $args }
function kgil() { & kubectl get ingress -l $args }
function kzgil() { & kubectl --namespace=kube-system get ingress -l $args }
function kdil() { & kubectl describe ingress -l $args }
function kzdil() { & kubectl --namespace=kube-system describe ingress -l $args }
function kxil() { & kubectl delete ingress -l $args }
function kzxil() { & kubectl --namespace=kube-system delete ingress -l $args }
function kgcl() { & kubectl get configmap -l $args }
function kzgcl() { & kubectl --namespace=kube-system get configmap -l $args }
function kdcl() { & kubectl describe configmap -l $args }
function kzdcl() { & kubectl --namespace=kube-system describe configmap -l $args }
function kxcl() { & kubectl delete configmap -l $args }
function kzxcl() { & kubectl --namespace=kube-system delete configmap -l $args }
function kgsel() { & kubectl get secret -l $args }
function kzgsel() { & kubectl --namespace=kube-system get secret -l $args }
function kdsel() { & kubectl describe secret -l $args }
function kzdsel() { & kubectl --namespace=kube-system describe secret -l $args }
function kxsel() { & kubectl delete secret -l $args }
function kzxsel() { & kubectl --namespace=kube-system delete secret -l $args }
function kgnol() { & kubectl get nodes -l $args }
function kdnol() { & kubectl describe nodes -l $args }
function kgnl() { & kubectl get namespaces -l $args }
function kdnl() { & kubectl describe namespaces -l $args }
function kxnl() { & kubectl delete namespaces -l $args }
function kgyl() { & kubectl get -o=yaml -l $args }
function kzgyl() { & kubectl --namespace=kube-system get -o=yaml -l $args }
function kgpyl() { & kubectl get pods -o=yaml -l $args }
function kzgpyl() { & kubectl --namespace=kube-system get pods -o=yaml -l $args }
function kgdeyl() { & kubectl get deployment -o=yaml -l $args }
function kzgdeyl() { & kubectl --namespace=kube-system get deployment -o=yaml -l $args }
function kgsvyl() { & kubectl get service -o=yaml -l $args }
function kzgsvyl() { & kubectl --namespace=kube-system get service -o=yaml -l $args }
function kgiyl() { & kubectl get ingress -o=yaml -l $args }
function kzgiyl() { & kubectl --namespace=kube-system get ingress -o=yaml -l $args }
function kgcyl() { & kubectl get configmap -o=yaml -l $args }
function kzgcyl() { & kubectl --namespace=kube-system get configmap -o=yaml -l $args }
function kgseyl() { & kubectl get secret -o=yaml -l $args }
function kzgseyl() { & kubectl --namespace=kube-system get secret -o=yaml -l $args }
function kgnoyl() { & kubectl get nodes -o=yaml -l $args }
function kgnyl() { & kubectl get namespaces -o=yaml -l $args }
function kgol() { & kubectl get -o=wide -l $args }
function kzgol() { & kubectl --namespace=kube-system get -o=wide -l $args }
function kgpol() { & kubectl get pods -o=wide -l $args }
function kzgpol() { & kubectl --namespace=kube-system get pods -o=wide -l $args }
function kgdeol() { & kubectl get deployment -o=wide -l $args }
function kzgdeol() { & kubectl --namespace=kube-system get deployment -o=wide -l $args }
function kgsvol() { & kubectl get service -o=wide -l $args }
function kzgsvol() { & kubectl --namespace=kube-system get service -o=wide -l $args }
function kgiol() { & kubectl get ingress -o=wide -l $args }
function kzgiol() { & kubectl --namespace=kube-system get ingress -o=wide -l $args }
function kgcol() { & kubectl get configmap -o=wide -l $args }
function kzgcol() { & kubectl --namespace=kube-system get configmap -o=wide -l $args }
function kgseol() { & kubectl get secret -o=wide -l $args }
function kzgseol() { & kubectl --namespace=kube-system get secret -o=wide -l $args }
function kgnool() { & kubectl get nodes -o=wide -l $args }
function kgnsol() { & kubectl get namespaces -o=wide -l $args }
function kgjl() { & kubectl get -o=json -l $args }
function kzgjl() { & kubectl --namespace=kube-system get -o=json -l $args }
function kgpjl() { & kubectl get pods -o=json -l $args }
function kzgpjl() { & kubectl --namespace=kube-system get pods -o=json -l $args }
function kgdejl() { & kubectl get deployment -o=json -l $args }
function kzgdejl() { & kubectl --namespace=kube-system get deployment -o=json -l $args }
function kgsvjl() { & kubectl get service -o=json -l $args }
function kzgsvjl() { & kubectl --namespace=kube-system get service -o=json -l $args }
function kgijl() { & kubectl get ingress -o=json -l $args }
function kzgijl() { & kubectl --namespace=kube-system get ingress -o=json -l $args }
function kgcjl() { & kubectl get configmap -o=json -l $args }
function kzgcjl() { & kubectl --namespace=kube-system get configmap -o=json -l $args }
function kgsejl() { & kubectl get secret -o=json -l $args }
function kzgsejl() { & kubectl --namespace=kube-system get secret -o=json -l $args }
function kgnojl() { & kubectl get nodes -o=json -l $args }
function kgnjl() { & kubectl get namespaces -o=json -l $args }
function kgsll() { & kubectl get --show-labels -l $args }
function kzgsll() { & kubectl --namespace=kube-system get --show-labels -l $args }
function kgpsll() { & kubectl get pods --show-labels -l $args }
function kzgpsll() { & kubectl --namespace=kube-system get pods --show-labels -l $args }
function kgdesll() { & kubectl get deployment --show-labels -l $args }
function kzgdesll() { & kubectl --namespace=kube-system get deployment --show-labels -l $args }
function kgwl() { & kubectl get --watch -l $args }
function kzgwl() { & kubectl --namespace=kube-system get --watch -l $args }
function kgpwl() { & kubectl get pods --watch -l $args }
function kzgpwl() { & kubectl --namespace=kube-system get pods --watch -l $args }
function kgdewl() { & kubectl get deployment --watch -l $args }
function kzgdewl() { & kubectl --namespace=kube-system get deployment --watch -l $args }
function kgsvwl() { & kubectl get service --watch -l $args }
function kzgsvwl() { & kubectl --namespace=kube-system get service --watch -l $args }
function kgiwl() { & kubectl get ingress --watch -l $args }
function kzgiwl() { & kubectl --namespace=kube-system get ingress --watch -l $args }
function kgcwl() { & kubectl get configmap --watch -l $args }
function kzgcwl() { & kubectl --namespace=kube-system get configmap --watch -l $args }
function kgsewl() { & kubectl get secret --watch -l $args }
function kzgsewl() { & kubectl --namespace=kube-system get secret --watch -l $args }
function kgnowl() { & kubectl get nodes --watch -l $args }
function kgnwl() { & kubectl get namespaces --watch -l $args }
function kgwyl() { & kubectl get --watch -o=yaml -l $args }
function kzgwyl() { & kubectl --namespace=kube-system get --watch -o=yaml -l $args }
function kgpwyl() { & kubectl get pods --watch -o=yaml -l $args }
function kzgpwyl() { & kubectl --namespace=kube-system get pods --watch -o=yaml -l $args }
function kgdewyl() { & kubectl get deployment --watch -o=yaml -l $args }
function kzgdewyl() { & kubectl --namespace=kube-system get deployment --watch -o=yaml -l $args }
function kgsvwyl() { & kubectl get service --watch -o=yaml -l $args }
function kzgsvwyl() { & kubectl --namespace=kube-system get service --watch -o=yaml -l $args }
function kgiwyl() { & kubectl get ingress --watch -o=yaml -l $args }
function kzgiwyl() { & kubectl --namespace=kube-system get ingress --watch -o=yaml -l $args }
function kgcwyl() { & kubectl get configmap --watch -o=yaml -l $args }
function kzgcwyl() { & kubectl --namespace=kube-system get configmap --watch -o=yaml -l $args }
function kgsewyl() { & kubectl get secret --watch -o=yaml -l $args }
function kzgsewyl() { & kubectl --namespace=kube-system get secret --watch -o=yaml -l $args }
function kgnowyl() { & kubectl get nodes --watch -o=yaml -l $args }
function kgnwyl() { & kubectl get namespaces --watch -o=yaml -l $args }
function kgosll() { & kubectl get -o=wide --show-labels -l $args }
function kzgosll() { & kubectl --namespace=kube-system get -o=wide --show-labels -l $args }
function kgposll() { & kubectl get pods -o=wide --show-labels -l $args }
function kzgposll() { & kubectl --namespace=kube-system get pods -o=wide --show-labels -l $args }
function kgdeosll() { & kubectl get deployment -o=wide --show-labels -l $args }
function kzgdeosll() { & kubectl --namespace=kube-system get deployment -o=wide --show-labels -l $args }
function kgslol() { & kubectl get --show-labels -o=wide -l $args }
function kzgslol() { & kubectl --namespace=kube-system get --show-labels -o=wide -l $args }
function kgpslol() { & kubectl get pods --show-labels -o=wide -l $args }
function kzgpslol() { & kubectl --namespace=kube-system get pods --show-labels -o=wide -l $args }
function kgdeslol() { & kubectl get deployment --show-labels -o=wide -l $args }
function kzgdeslol() { & kubectl --namespace=kube-system get deployment --show-labels -o=wide -l $args }
function kgwol() { & kubectl get --watch -o=wide -l $args }
function kzgwol() { & kubectl --namespace=kube-system get --watch -o=wide -l $args }
function kgpwol() { & kubectl get pods --watch -o=wide -l $args }
function kzgpwol() { & kubectl --namespace=kube-system get pods --watch -o=wide -l $args }
function kgdewol() { & kubectl get deployment --watch -o=wide -l $args }
function kzgdewol() { & kubectl --namespace=kube-system get deployment --watch -o=wide -l $args }
function kgsvwol() { & kubectl get service --watch -o=wide -l $args }
function kzgsvwol() { & kubectl --namespace=kube-system get service --watch -o=wide -l $args }
function kgiwol() { & kubectl get ingress --watch -o=wide -l $args }
function kzgiwol() { & kubectl --namespace=kube-system get ingress --watch -o=wide -l $args }
function kgcwol() { & kubectl get configmap --watch -o=wide -l $args }
function kzgcwol() { & kubectl --namespace=kube-system get configmap --watch -o=wide -l $args }
function kgsewol() { & kubectl get secret --watch -o=wide -l $args }
function kzgsewol() { & kubectl --namespace=kube-system get secret --watch -o=wide -l $args }
function kgnowol() { & kubectl get nodes --watch -o=wide -l $args }
function kgnwol() { & kubectl get namespaces --watch -o=wide -l $args }
function kgwjl() { & kubectl get --watch -o=json -l $args }
function kzgwjl() { & kubectl --namespace=kube-system get --watch -o=json -l $args }
function kgpwjl() { & kubectl get pods --watch -o=json -l $args }
function kzgpwjl() { & kubectl --namespace=kube-system get pods --watch -o=json -l $args }
function kgdewjl() { & kubectl get deployment --watch -o=json -l $args }
function kzgdewjl() { & kubectl --namespace=kube-system get deployment --watch -o=json -l $args }
function kgsvwjl() { & kubectl get service --watch -o=json -l $args }
function kzgsvwjl() { & kubectl --namespace=kube-system get service --watch -o=json -l $args }
function kgiwjl() { & kubectl get ingress --watch -o=json -l $args }
function kzgiwjl() { & kubectl --namespace=kube-system get ingress --watch -o=json -l $args }
function kgcwjl() { & kubectl get configmap --watch -o=json -l $args }
function kzgcwjl() { & kubectl --namespace=kube-system get configmap --watch -o=json -l $args }
function kgsewjl() { & kubectl get secret --watch -o=json -l $args }
function kzgsewjl() { & kubectl --namespace=kube-system get secret --watch -o=json -l $args }
function kgnowjl() { & kubectl get nodes --watch -o=json -l $args }
function kgnwjl() { & kubectl get namespaces --watch -o=json -l $args }
function kgslwl() { & kubectl get --show-labels --watch -l $args }
function kzgslwl() { & kubectl --namespace=kube-system get --show-labels --watch -l $args }
function kgpslwl() { & kubectl get pods --show-labels --watch -l $args }
function kzgpslwl() { & kubectl --namespace=kube-system get pods --show-labels --watch -l $args }
function kgdeslwl() { & kubectl get deployment --show-labels --watch -l $args }
function kzgdeslwl() { & kubectl --namespace=kube-system get deployment --show-labels --watch -l $args }
function kgwsll() { & kubectl get --watch --show-labels -l $args }
function kzgwsll() { & kubectl --namespace=kube-system get --watch --show-labels -l $args }
function kgpwsll() { & kubectl get pods --watch --show-labels -l $args }
function kzgpwsll() { & kubectl --namespace=kube-system get pods --watch --show-labels -l $args }
function kgdewsll() { & kubectl get deployment --watch --show-labels -l $args }
function kzgdewsll() { & kubectl --namespace=kube-system get deployment --watch --show-labels -l $args }
function kgslwol() { & kubectl get --show-labels --watch -o=wide -l $args }
function kzgslwol() { & kubectl --namespace=kube-system get --show-labels --watch -o=wide -l $args }
function kgpslwol() { & kubectl get pods --show-labels --watch -o=wide -l $args }
function kzgpslwol() { & kubectl --namespace=kube-system get pods --show-labels --watch -o=wide -l $args }
function kgdeslwol() { & kubectl get deployment --show-labels --watch -o=wide -l $args }
function kzgdeslwol() { & kubectl --namespace=kube-system get deployment --show-labels --watch -o=wide -l $args }
function kgwosll() { & kubectl get --watch -o=wide --show-labels -l $args }
function kzgwosll() { & kubectl --namespace=kube-system get --watch -o=wide --show-labels -l $args }
function kgpwosll() { & kubectl get pods --watch -o=wide --show-labels -l $args }
function kzgpwosll() { & kubectl --namespace=kube-system get pods --watch -o=wide --show-labels -l $args }
function kgdewosll() { & kubectl get deployment --watch -o=wide --show-labels -l $args }
function kzgdewosll() { & kubectl --namespace=kube-system get deployment --watch -o=wide --show-labels -l $args }
function kgwslol() { & kubectl get --watch --show-labels -o=wide -l $args }
function kzgwslol() { & kubectl --namespace=kube-system get --watch --show-labels -o=wide -l $args }
function kgpwslol() { & kubectl get pods --watch --show-labels -o=wide -l $args }
function kzgpwslol() { & kubectl --namespace=kube-system get pods --watch --show-labels -o=wide -l $args }
function kgdewslol() { & kubectl get deployment --watch --show-labels -o=wide -l $args }
function kzgdewslol() { & kubectl --namespace=kube-system get deployment --watch --show-labels -o=wide -l $args }
function ken() { & kubectl exec -i -t --namespace $args }
function kln() { & kubectl logs -f --namespace $args }
function kpfn() { & kubectl port-forward --namespace $args }
function kgn() { & kubectl get --namespace $args }
function kdn() { & kubectl describe --namespace $args }
function kxn() { & kubectl delete --namespace $args }
function kgpn() { & kubectl get pods --namespace $args }
function kdpn() { & kubectl describe pods --namespace $args }
function kxpn() { & kubectl delete pods --namespace $args }
function kgden() { & kubectl get deployment --namespace $args }
function kdden() { & kubectl describe deployment --namespace $args }
function kxden() { & kubectl delete deployment --namespace $args }
function kgsvn() { & kubectl get service --namespace $args }
function kdsvn() { & kubectl describe service --namespace $args }
function kxsvn() { & kubectl delete service --namespace $args }
function kgin() { & kubectl get ingress --namespace $args }
function kdin() { & kubectl describe ingress --namespace $args }
function kxin() { & kubectl delete ingress --namespace $args }
function kgcn() { & kubectl get configmap --namespace $args }
function kdcn() { & kubectl describe configmap --namespace $args }
function kxcn() { & kubectl delete configmap --namespace $args }
function kgsen() { & kubectl get secret --namespace $args }
function kdsen() { & kubectl describe secret --namespace $args }
function kxsen() { & kubectl delete secret --namespace $args }
function kgyn() { & kubectl get -o=yaml --namespace $args }
function kgpyn() { & kubectl get pods -o=yaml --namespace $args }
function kgdeyn() { & kubectl get deployment -o=yaml --namespace $args }
function kgsvyn() { & kubectl get service -o=yaml --namespace $args }
function kgiyn() { & kubectl get ingress -o=yaml --namespace $args }
function kgcyn() { & kubectl get configmap -o=yaml --namespace $args }
function kgseyn() { & kubectl get secret -o=yaml --namespace $args }
function kgon() { & kubectl get -o=wide --namespace $args }
function kgpon() { & kubectl get pods -o=wide --namespace $args }
function kgdeon() { & kubectl get deployment -o=wide --namespace $args }
function kgsvon() { & kubectl get service -o=wide --namespace $args }
function kgion() { & kubectl get ingress -o=wide --namespace $args }
function kgcon() { & kubectl get configmap -o=wide --namespace $args }
function kgseon() { & kubectl get secret -o=wide --namespace $args }
function kgjn() { & kubectl get -o=json --namespace $args }
function kgpjn() { & kubectl get pods -o=json --namespace $args }
function kgdejn() { & kubectl get deployment -o=json --namespace $args }
function kgsvjn() { & kubectl get service -o=json --namespace $args }
function kgijn() { & kubectl get ingress -o=json --namespace $args }
function kgcjn() { & kubectl get configmap -o=json --namespace $args }
function kgsejn() { & kubectl get secret -o=json --namespace $args }
function kgsln() { & kubectl get --show-labels --namespace $args }
function kgpsln() { & kubectl get pods --show-labels --namespace $args }
function kgdesln() { & kubectl get deployment --show-labels --namespace $args }
function kgwn() { & kubectl get --watch --namespace $args }
function kgpwn() { & kubectl get pods --watch --namespace $args }
function kgdewn() { & kubectl get deployment --watch --namespace $args }
function kgsvwn() { & kubectl get service --watch --namespace $args }
function kgiwn() { & kubectl get ingress --watch --namespace $args }
function kgcwn() { & kubectl get configmap --watch --namespace $args }
function kgsewn() { & kubectl get secret --watch --namespace $args }
function kgwyn() { & kubectl get --watch -o=yaml --namespace $args }
function kgpwyn() { & kubectl get pods --watch -o=yaml --namespace $args }
function kgdewyn() { & kubectl get deployment --watch -o=yaml --namespace $args }
function kgsvwyn() { & kubectl get service --watch -o=yaml --namespace $args }
function kgiwyn() { & kubectl get ingress --watch -o=yaml --namespace $args }
function kgcwyn() { & kubectl get configmap --watch -o=yaml --namespace $args }
function kgsewyn() { & kubectl get secret --watch -o=yaml --namespace $args }
function kgosln() { & kubectl get -o=wide --show-labels --namespace $args }
function kgposln() { & kubectl get pods -o=wide --show-labels --namespace $args }
function kgdeosln() { & kubectl get deployment -o=wide --show-labels --namespace $args }
function kgslon() { & kubectl get --show-labels -o=wide --namespace $args }
function kgpslon() { & kubectl get pods --show-labels -o=wide --namespace $args }
function kgdeslon() { & kubectl get deployment --show-labels -o=wide --namespace $args }
function kgwon() { & kubectl get --watch -o=wide --namespace $args }
function kgpwon() { & kubectl get pods --watch -o=wide --namespace $args }
function kgdewon() { & kubectl get deployment --watch -o=wide --namespace $args }
function kgsvwon() { & kubectl get service --watch -o=wide --namespace $args }
function kgiwon() { & kubectl get ingress --watch -o=wide --namespace $args }
function kgcwon() { & kubectl get configmap --watch -o=wide --namespace $args }
function kgsewon() { & kubectl get secret --watch -o=wide --namespace $args }
function kgwjn() { & kubectl get --watch -o=json --namespace $args }
function kgpwjn() { & kubectl get pods --watch -o=json --namespace $args }
function kgdewjn() { & kubectl get deployment --watch -o=json --namespace $args }
function kgsvwjn() { & kubectl get service --watch -o=json --namespace $args }
function kgiwjn() { & kubectl get ingress --watch -o=json --namespace $args }
function kgcwjn() { & kubectl get configmap --watch -o=json --namespace $args }
function kgsewjn() { & kubectl get secret --watch -o=json --namespace $args }
function kgslwn() { & kubectl get --show-labels --watch --namespace $args }
function kgpslwn() { & kubectl get pods --show-labels --watch --namespace $args }
function kgdeslwn() { & kubectl get deployment --show-labels --watch --namespace $args }
function kgwsln() { & kubectl get --watch --show-labels --namespace $args }
function kgpwsln() { & kubectl get pods --watch --show-labels --namespace $args }
function kgdewsln() { & kubectl get deployment --watch --show-labels --namespace $args }
function kgslwon() { & kubectl get --show-labels --watch -o=wide --namespace $args }
function kgpslwon() { & kubectl get pods --show-labels --watch -o=wide --namespace $args }
function kgdeslwon() { & kubectl get deployment --show-labels --watch -o=wide --namespace $args }
function kgwosln() { & kubectl get --watch -o=wide --show-labels --namespace $args }
function kgpwosln() { & kubectl get pods --watch -o=wide --show-labels --namespace $args }
function kgdewosln() { & kubectl get deployment --watch -o=wide --show-labels --namespace $args }
function kgwslon() { & kubectl get --watch --show-labels -o=wide --namespace $args }
function kgpwslon() { & kubectl get pods --watch --show-labels -o=wide --namespace $args }
function kgdewslon() { & kubectl get deployment --watch --show-labels -o=wide --namespace $args }

# e.g. k create deploy nginx --image=nginx dy
function dy { "--dry-run=client"; "-o=yaml" } 
# e.g. k delete pod x f
function f { "--force"; "--grace-period"; "0" }

# Usage tracking for aliases (optional, disabled by default)
# Enable with: $env:TRACK_ALIAS_USAGE = "true"
if ($env:TRACK_ALIAS_USAGE -eq "true") {
    $aliasUsageLog = Join-Path $env:USERPROFILE ".alias-usage.log"
    
    function Track-AliasUsage {
        param([string]$AliasName, [string]$FullCommand)
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $entry = "$timestamp|$AliasName|$FullCommand"
        Add-Content -Path $aliasUsageLog -Value $entry -ErrorAction SilentlyContinue
    }
    
    # Wrap common aliases to track usage (example for a few key ones)
    # Note: This is a simplified version - full implementation would wrap all aliases
    $original_kgp = Get-Command kgp -ErrorAction SilentlyContinue
    if ($original_kgp) {
        function kgp { 
            Track-AliasUsage -AliasName "kgp" -FullCommand "kubectl get pods"
            & kubectl get pods $args 
        }
    }
}

Set-Location ~/Workspace
Clear-Host