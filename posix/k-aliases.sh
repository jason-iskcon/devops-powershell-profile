# GENERATED FILE - do not edit.
# Source: k-grammar.toml
# Regenerate: python3 tools/generate_aliases.py
# Bash and zsh. Each function runs kubectl with fixed arguments followed by your own ("$@").
# \kubectl suppresses alias expansion but still calls a kubectl shell function if you have one.

__k_names=(
  k ka kak ke ken kk kl kln klp kp
  kpf kpfn krun kz kza kze kzl kzlp kzrun kg
  kgl kgaa kgf kgo kgol kgoall kgj kgw kgy kgjl
  kgwj kgwl kgwo kgwy kgyl kgwjl kgwol kgwyl kgjn kgon
  kgwn kgyn kgwjn kgwon kgwyn kgaaojson kgaaowide kgaaoyaml kgaaw kgjall
  kgwall kgyall kgaawj kgaawo kgaawy kgwaaj kgwaao kgwaay kgwjall kgwoall
  kgwyall kgsl kgosl kgsll kgslo kgslw kgwsl kgosll kgslol kgslwl
  kgslwo kgwosl kgwsll kgwslo kgslwol kgwosll kgwslol kgaasl kgslall kgsln
  kgaaosl kgaaslo kgaaslw kgaawsl kgoallsl kgoslall kgosln kgslaao kgslallw kgsloaa
  kgslon kgslwall kgslwn kgwallsl kgwslall kgwsln kgaaslwo kgaawosl kgaawslo kgslallwo
  kgslwaao kgslwoall kgslwon kgwaaosl kgwallslo kgwoallsl kgwoslall kgwosln kgwslaao kgwsloaa
  kgwslon kgjf kgof kgslf kgwf kgyf kgoslf kgslof kgslwf kgwjf
  kgwof kgwslf kgwyf kgslwof kgwoslf kgwslof kgp kgpl kgpaa kgpn
  kgpo kgpol kgpoall kgpaay kgpj kgpw kgpy kgpjl kgpwj kgpwl
  kgpwo kgpwy kgpyl kgpwjl kgpwol kgpwyl kgpjn kgpon kgpwn kgpyn
  kgpwjn kgpwon kgpwyn kgpaaojson kgpaaowide kgpaaoyaml kgpaaw kgpjall kgpwall kgpyall
  kgpaawj kgpaawo kgpaawy kgpwaaj kgpwaao kgpwaay kgpwjall kgpwoall kgpwyall kgpsl
  kgposl kgpsll kgpslo kgpslw kgpwsl kgposll kgpslol kgpslwl kgpslwo kgpwosl
  kgpwsll kgpwslo kgpslwol kgpwosll kgpwslol kgpaasl kgpslall kgpsln kgpaaosl kgpaaslo
  kgpaaslw kgpaawsl kgpoallsl kgposlall kgposln kgpslaao kgpslallw kgpsloaa kgpslon kgpslwall
  kgpslwn kgpwallsl kgpwslall kgpwsln kgpaaslwo kgpaawosl kgpaawslo kgpslallwo kgpslwaao kgpslwoall
  kgpslwon kgpwaaosl kgpwallslo kgpwoallsl kgpwoslall kgpwosln kgpwslaao kgpwsloaa kgpwslon kgde
  kgdel kgdeaa kgden kgdeo kgdeol kgdeoall kgdej kgdew kgdey kgdejl
  kgdewj kgdewl kgdewo kgdewy kgdeyl kgdewjl kgdewol kgdewyl kgdejn kgdeon
  kgdewn kgdeyn kgdewjn kgdewon kgdewyn kgdeaaojson kgdeaaowide kgdeaaoyaml kgdeaaw kgdejall
  kgdewall kgdeyall kgdeaawj kgdeaawo kgdeaawy kgdewaaj kgdewaao kgdewaay kgdewjall kgdewoall
  kgdewyall kgdesl kgdeosl kgdesll kgdeslo kgdeslw kgdewsl kgdeosll kgdeslol kgdeslwl
  kgdeslwo kgdewosl kgdewsll kgdewslo kgdeslwol kgdewosll kgdewslol kgdeaasl kgdeslall kgdesln
  kgdeaaosl kgdeaaslo kgdeaaslw kgdeaawsl kgdeoallsl kgdeoslall kgdeosln kgdeslaao kgdeslallw kgdesloaa
  kgdeslon kgdeslwall kgdeslwn kgdewallsl kgdewslall kgdewsln kgdeaaslwo kgdeaawosl kgdeaawslo kgdeslallwo
  kgdeslwaao kgdeslwoall kgdeslwon kgdewaaosl kgdewallslo kgdewoallsl kgdewoslall kgdewosln kgdewslaao kgdewsloaa
  kgdewslon kgsv kgsvl kgsvaa kgsvn kgsvo kgsvol kgsvoall kgsvj kgsvw
  kgsvy kgsvjl kgsvwj kgsvwl kgsvwo kgsvwy kgsvyl kgsvwjl kgsvwol kgsvwyl
  kgsvjn kgsvon kgsvwn kgsvyn kgsvwjn kgsvwon kgsvwyn kgsvaaojson kgsvaaowide kgsvaaoyaml
  kgsvaaw kgsvjall kgsvwall kgsvyall kgsvaawj kgsvaawo kgsvaawy kgsvwaaj kgsvwaao kgsvwaay
  kgsvwjall kgsvwoall kgsvwyall kgi kgil kgiaa kgin kgio kgiol kgioall
  kgij kgiw kgiy kgijl kgiwj kgiwl kgiwo kgiwy kgiyl kgiwjl
  kgiwol kgiwyl kgijn kgion kgiwn kgiyn kgiwjn kgiwon kgiwyn kgiaaojson
  kgiaaowide kgiaaoyaml kgiaaw kgijall kgiwall kgiyall kgiaawj kgiaawo kgiaawy kgiwaaj
  kgiwaao kgiwaay kgiwjall kgiwoall kgiwyall kgc kgcl kgcaa kgcn kgco
  kgcol kgcoall kgcj kgcw kgcy kgcjl kgcwj kgcwl kgcwo kgcwy
  kgcyl kgcwjl kgcwol kgcwyl kgcjn kgcon kgcwn kgcyn kgcwjn kgcwon
  kgcwyn kgcaaojson kgcaaowide kgcaaoyaml kgcaaw kgcjall kgcwall kgcyall kgcaawj kgcaawo
  kgcaawy kgcwaaj kgcwaao kgcwaay kgcwjall kgcwoall kgcwyall kgse kgsel kgseaa
  kgsen kgseo kgseol kgseoall kgsej kgsew kgsey kgsejl kgsewj kgsewl
  kgsewo kgsewy kgseyl kgsewjl kgsewol kgsewyl kgsejn kgseon kgsewn kgseyn
  kgsewjn kgsewon kgsewyn kgseaaojson kgseaaowide kgseaaoyaml kgseaaw kgsejall kgsewall kgseyall
  kgseaawj kgseaawo kgseaawy kgsewaaj kgsewaao kgsewaay kgsewjall kgsewoall kgsewyall kgno
  kgnol kgnoo kgnool kgnoj kgnow kgnoy kgnojl kgnowj kgnowl kgnowo
  kgnowy kgnoyl kgnowjl kgnowol kgnowyl kgn kgnl kgnaa kgnj kgnw
  kgny kgnjl kgnwj kgnwl kgnwo kgnwy kgnyl kgnwjl kgnwol kgnwyl
  kgnaaojson kgnaaowide kgnaaoyaml kgnaaw kgnjall kgnwall kgnyall kgnaawj kgnaawo kgnaawy
  kgnwaaj kgnwaao kgnwaay kgnwjall kgnwoall kgnwyall kgnso kgnsol kgnsoall kd
  kdl kdaa kdf kdp kdpl kdpaa kdpn kdde kddel kddeaa
  kdden kdsv kdsvl kdsvaa kdsvn kdi kdil kdiaa kdin kdc
  kdcl kdcaa kdcn kdse kdsel kdseaa kdsen kdno kdnol kdn
  kdnl kdnaa kx kxl kxaa kxf kxp kxpl kxpaa kxpn
  kxde kxdel kxdeaa kxden kxsv kxsvl kxsvaa kxsvn kxi kxil
  kxiaa kxin kxc kxcl kxcaa kxcn kxse kxsel kxseaa kxsen
  kxn kxnl kxnaa kzg kzgl kzgo kzgol kzgj kzgw kzgy
  kzgjl kzgwj kzgwl kzgwo kzgwy kzgyl kzgwjl kzgwol kzgwyl kzgsl
  kzgosl kzgsll kzgslo kzgslw kzgwsl kzgosll kzgslol kzgslwl kzgslwo kzgwosl
  kzgwsll kzgwslo kzgslwol kzgwosll kzgwslol kzgp kzgpl kzgpo kzgpol kzgpj
  kzgpw kzgpy kzgpjl kzgpwj kzgpwl kzgpwo kzgpwy kzgpyl kzgpwjl kzgpwol
  kzgpwyl kzgpsl kzgposl kzgpsll kzgpslo kzgpslw kzgpwsl kzgposll kzgpslol kzgpslwl
  kzgpslwo kzgpwosl kzgpwsll kzgpwslo kzgpslwol kzgpwosll kzgpwslol kzgde kzgdel kzgdeo
  kzgdeol kzgdej kzgdew kzgdey kzgdejl kzgdewj kzgdewl kzgdewo kzgdewy kzgdeyl
  kzgdewjl kzgdewol kzgdewyl kzgdesl kzgdeosl kzgdesll kzgdeslo kzgdeslw kzgdewsl kzgdeosll
  kzgdeslol kzgdeslwl kzgdeslwo kzgdewosl kzgdewsll kzgdewslo kzgdeslwol kzgdewosll kzgdewslol kzgsv
  kzgsvl kzgsvo kzgsvol kzgsvj kzgsvw kzgsvy kzgsvjl kzgsvwj kzgsvwl kzgsvwo
  kzgsvwy kzgsvyl kzgsvwjl kzgsvwol kzgsvwyl kzgi kzgil kzgio kzgiol kzgij
  kzgiw kzgiy kzgijl kzgiwj kzgiwl kzgiwo kzgiwy kzgiyl kzgiwjl kzgiwol
  kzgiwyl kzgc kzgcl kzgco kzgcol kzgcj kzgcw kzgcy kzgcjl kzgcwj
  kzgcwl kzgcwo kzgcwy kzgcyl kzgcwjl kzgcwol kzgcwyl kzgse kzgsel kzgseo
  kzgseol kzgsej kzgsew kzgsey kzgsejl kzgsewj kzgsewl kzgsewo kzgsewy kzgseyl
  kzgsewjl kzgsewol kzgsewyl kzd kzdl kzdp kzdpl kzdde kzddel kzdsv
  kzdsvl kzdi kzdil kzdc kzdcl kzdse kzdsel kzx kzxl kzxaa
  kzxp kzxpl kzxpaa kzxde kzxdel kzxdeaa kzxsv kzxsvl kzxsvaa kzxi
  kzxil kzxiaa kzxc kzxcl kzxcaa kzxse kzxsel kzxseaa
)

# An existing alias with one of these names would be expanded while the functions below
# are defined (a syntax error in bash, "defining function based on alias" in zsh).
for __k_n in "${__k_names[@]}"; do unalias "$__k_n" 2>/dev/null; done
unset __k_n

k() { \kubectl "$@"; }
ka() { \kubectl apply --recursive -f "$@"; }
kak() { \kubectl apply -k "$@"; }
ke() { \kubectl exec -i -t "$@"; }
ken() { \kubectl exec -i -t --namespace "$@"; }
kk() { \kubectl kustomize "$@"; }
kl() { \kubectl logs -f "$@"; }
kln() { \kubectl logs -f --namespace "$@"; }
klp() { \kubectl logs -f -p "$@"; }
kp() { \kubectl proxy "$@"; }
kpf() { \kubectl port-forward "$@"; }
kpfn() { \kubectl port-forward --namespace "$@"; }
krun() { \kubectl run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t "$@"; }
kz() { \kubectl --namespace=kube-system "$@"; }
kza() { \kubectl --namespace=kube-system apply --recursive -f "$@"; }
kze() { \kubectl --namespace=kube-system exec -i -t "$@"; }
kzl() { \kubectl --namespace=kube-system logs -f "$@"; }
kzlp() { \kubectl --namespace=kube-system logs -f -p "$@"; }
kzrun() { \kubectl --namespace=kube-system run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t "$@"; }
kg() { \kubectl get "$@"; }
kgl() { \kubectl get -l "$@"; }
kgaa() { \kubectl get --all-namespaces "$@"; }
kgf() { \kubectl get --recursive -f "$@"; }
kgo() { \kubectl get -o=wide "$@"; }
kgol() { \kubectl get -o=wide -l "$@"; }
kgoall() { \kubectl get -o=wide --all-namespaces "$@"; }
kgj() { \kubectl get -o=json "$@"; }
kgw() { \kubectl get --watch "$@"; }
kgy() { \kubectl get -o=yaml "$@"; }
kgjl() { \kubectl get -o=json -l "$@"; }
kgwj() { \kubectl get --watch -o=json "$@"; }
kgwl() { \kubectl get --watch -l "$@"; }
kgwo() { \kubectl get --watch -o=wide "$@"; }
kgwy() { \kubectl get --watch -o=yaml "$@"; }
kgyl() { \kubectl get -o=yaml -l "$@"; }
kgwjl() { \kubectl get --watch -o=json -l "$@"; }
kgwol() { \kubectl get --watch -o=wide -l "$@"; }
kgwyl() { \kubectl get --watch -o=yaml -l "$@"; }
kgjn() { \kubectl get -o=json --namespace "$@"; }
kgon() { \kubectl get -o=wide --namespace "$@"; }
kgwn() { \kubectl get --watch --namespace "$@"; }
kgyn() { \kubectl get -o=yaml --namespace "$@"; }
kgwjn() { \kubectl get --watch -o=json --namespace "$@"; }
kgwon() { \kubectl get --watch -o=wide --namespace "$@"; }
kgwyn() { \kubectl get --watch -o=yaml --namespace "$@"; }
kgaaojson() { \kubectl get --all-namespaces -o=json "$@"; }
kgaaowide() { \kubectl get --all-namespaces -o=wide "$@"; }
kgaaoyaml() { \kubectl get --all-namespaces -o=yaml "$@"; }
kgaaw() { \kubectl get --all-namespaces --watch "$@"; }
kgjall() { \kubectl get -o=json --all-namespaces "$@"; }
kgwall() { \kubectl get --watch --all-namespaces "$@"; }
kgyall() { \kubectl get -o=yaml --all-namespaces "$@"; }
kgaawj() { \kubectl get --all-namespaces --watch -o=json "$@"; }
kgaawo() { \kubectl get --all-namespaces --watch -o=wide "$@"; }
kgaawy() { \kubectl get --all-namespaces --watch -o=yaml "$@"; }
kgwaaj() { \kubectl get --watch --all-namespaces -o=json "$@"; }
kgwaao() { \kubectl get --watch --all-namespaces -o=wide "$@"; }
kgwaay() { \kubectl get --watch --all-namespaces -o=yaml "$@"; }
kgwjall() { \kubectl get --watch -o=json --all-namespaces "$@"; }
kgwoall() { \kubectl get --watch -o=wide --all-namespaces "$@"; }
kgwyall() { \kubectl get --watch -o=yaml --all-namespaces "$@"; }
kgsl() { \kubectl get --show-labels "$@"; }
kgosl() { \kubectl get -o=wide --show-labels "$@"; }
kgsll() { \kubectl get --show-labels -l "$@"; }
kgslo() { \kubectl get --show-labels -o=wide "$@"; }
kgslw() { \kubectl get --show-labels --watch "$@"; }
kgwsl() { \kubectl get --watch --show-labels "$@"; }
kgosll() { \kubectl get -o=wide --show-labels -l "$@"; }
kgslol() { \kubectl get --show-labels -o=wide -l "$@"; }
kgslwl() { \kubectl get --show-labels --watch -l "$@"; }
kgslwo() { \kubectl get --show-labels --watch -o=wide "$@"; }
kgwosl() { \kubectl get --watch -o=wide --show-labels "$@"; }
kgwsll() { \kubectl get --watch --show-labels -l "$@"; }
kgwslo() { \kubectl get --watch --show-labels -o=wide "$@"; }
kgslwol() { \kubectl get --show-labels --watch -o=wide -l "$@"; }
kgwosll() { \kubectl get --watch -o=wide --show-labels -l "$@"; }
kgwslol() { \kubectl get --watch --show-labels -o=wide -l "$@"; }
kgaasl() { \kubectl get --all-namespaces --show-labels "$@"; }
kgslall() { \kubectl get --show-labels --all-namespaces "$@"; }
kgsln() { \kubectl get --show-labels --namespace "$@"; }
kgaaosl() { \kubectl get --all-namespaces -o=wide --show-labels "$@"; }
kgaaslo() { \kubectl get --all-namespaces --show-labels -o=wide "$@"; }
kgaaslw() { \kubectl get --all-namespaces --show-labels --watch "$@"; }
kgaawsl() { \kubectl get --all-namespaces --watch --show-labels "$@"; }
kgoallsl() { \kubectl get -o=wide --all-namespaces --show-labels "$@"; }
kgoslall() { \kubectl get -o=wide --show-labels --all-namespaces "$@"; }
kgosln() { \kubectl get -o=wide --show-labels --namespace "$@"; }
kgslaao() { \kubectl get --show-labels --all-namespaces -o=wide "$@"; }
kgslallw() { \kubectl get --show-labels --all-namespaces --watch "$@"; }
kgsloaa() { \kubectl get --show-labels -o=wide --all-namespaces "$@"; }
kgslon() { \kubectl get --show-labels -o=wide --namespace "$@"; }
kgslwall() { \kubectl get --show-labels --watch --all-namespaces "$@"; }
kgslwn() { \kubectl get --show-labels --watch --namespace "$@"; }
kgwallsl() { \kubectl get --watch --all-namespaces --show-labels "$@"; }
kgwslall() { \kubectl get --watch --show-labels --all-namespaces "$@"; }
kgwsln() { \kubectl get --watch --show-labels --namespace "$@"; }
kgaaslwo() { \kubectl get --all-namespaces --show-labels --watch -o=wide "$@"; }
kgaawosl() { \kubectl get --all-namespaces --watch -o=wide --show-labels "$@"; }
kgaawslo() { \kubectl get --all-namespaces --watch --show-labels -o=wide "$@"; }
kgslallwo() { \kubectl get --show-labels --all-namespaces --watch -o=wide "$@"; }
kgslwaao() { \kubectl get --show-labels --watch --all-namespaces -o=wide "$@"; }
kgslwoall() { \kubectl get --show-labels --watch -o=wide --all-namespaces "$@"; }
kgslwon() { \kubectl get --show-labels --watch -o=wide --namespace "$@"; }
kgwaaosl() { \kubectl get --watch --all-namespaces -o=wide --show-labels "$@"; }
kgwallslo() { \kubectl get --watch --all-namespaces --show-labels -o=wide "$@"; }
kgwoallsl() { \kubectl get --watch -o=wide --all-namespaces --show-labels "$@"; }
kgwoslall() { \kubectl get --watch -o=wide --show-labels --all-namespaces "$@"; }
kgwosln() { \kubectl get --watch -o=wide --show-labels --namespace "$@"; }
kgwslaao() { \kubectl get --watch --show-labels --all-namespaces -o=wide "$@"; }
kgwsloaa() { \kubectl get --watch --show-labels -o=wide --all-namespaces "$@"; }
kgwslon() { \kubectl get --watch --show-labels -o=wide --namespace "$@"; }
kgjf() { \kubectl get -o=json --recursive -f "$@"; }
kgof() { \kubectl get -o=wide --recursive -f "$@"; }
kgslf() { \kubectl get --show-labels --recursive -f "$@"; }
kgwf() { \kubectl get --watch --recursive -f "$@"; }
kgyf() { \kubectl get -o=yaml --recursive -f "$@"; }
kgoslf() { \kubectl get -o=wide --show-labels --recursive -f "$@"; }
kgslof() { \kubectl get --show-labels -o=wide --recursive -f "$@"; }
kgslwf() { \kubectl get --show-labels --watch --recursive -f "$@"; }
kgwjf() { \kubectl get --watch -o=json --recursive -f "$@"; }
kgwof() { \kubectl get --watch -o=wide --recursive -f "$@"; }
kgwslf() { \kubectl get --watch --show-labels --recursive -f "$@"; }
kgwyf() { \kubectl get --watch -o=yaml --recursive -f "$@"; }
kgslwof() { \kubectl get --show-labels --watch -o=wide --recursive -f "$@"; }
kgwoslf() { \kubectl get --watch -o=wide --show-labels --recursive -f "$@"; }
kgwslof() { \kubectl get --watch --show-labels -o=wide --recursive -f "$@"; }
kgp() { \kubectl get pods "$@"; }
kgpl() { \kubectl get pods -l "$@"; }
kgpaa() { \kubectl get pods --all-namespaces "$@"; }
kgpn() { \kubectl get pods --namespace "$@"; }
kgpo() { \kubectl get pods -o=wide "$@"; }
kgpol() { \kubectl get pods -o=wide -l "$@"; }
kgpoall() { \kubectl get pods -o=wide --all-namespaces "$@"; }
kgpaay() { \kubectl get pods --all-namespaces -o=yaml "$@"; }
kgpj() { \kubectl get pods -o=json "$@"; }
kgpw() { \kubectl get pods --watch "$@"; }
kgpy() { \kubectl get pods -o=yaml "$@"; }
kgpjl() { \kubectl get pods -o=json -l "$@"; }
kgpwj() { \kubectl get pods --watch -o=json "$@"; }
kgpwl() { \kubectl get pods --watch -l "$@"; }
kgpwo() { \kubectl get pods --watch -o=wide "$@"; }
kgpwy() { \kubectl get pods --watch -o=yaml "$@"; }
kgpyl() { \kubectl get pods -o=yaml -l "$@"; }
kgpwjl() { \kubectl get pods --watch -o=json -l "$@"; }
kgpwol() { \kubectl get pods --watch -o=wide -l "$@"; }
kgpwyl() { \kubectl get pods --watch -o=yaml -l "$@"; }
kgpjn() { \kubectl get pods -o=json --namespace "$@"; }
kgpon() { \kubectl get pods -o=wide --namespace "$@"; }
kgpwn() { \kubectl get pods --watch --namespace "$@"; }
kgpyn() { \kubectl get pods -o=yaml --namespace "$@"; }
kgpwjn() { \kubectl get pods --watch -o=json --namespace "$@"; }
kgpwon() { \kubectl get pods --watch -o=wide --namespace "$@"; }
kgpwyn() { \kubectl get pods --watch -o=yaml --namespace "$@"; }
kgpaaojson() { \kubectl get pods --all-namespaces -o=json "$@"; }
kgpaaowide() { \kubectl get pods --all-namespaces -o=wide "$@"; }
kgpaaoyaml() { \kubectl get pods --all-namespaces -o=yaml "$@"; }
kgpaaw() { \kubectl get pods --all-namespaces --watch "$@"; }
kgpjall() { \kubectl get pods -o=json --all-namespaces "$@"; }
kgpwall() { \kubectl get pods --watch --all-namespaces "$@"; }
kgpyall() { \kubectl get pods -o=yaml --all-namespaces "$@"; }
kgpaawj() { \kubectl get pods --all-namespaces --watch -o=json "$@"; }
kgpaawo() { \kubectl get pods --all-namespaces --watch -o=wide "$@"; }
kgpaawy() { \kubectl get pods --all-namespaces --watch -o=yaml "$@"; }
kgpwaaj() { \kubectl get pods --watch --all-namespaces -o=json "$@"; }
kgpwaao() { \kubectl get pods --watch --all-namespaces -o=wide "$@"; }
kgpwaay() { \kubectl get pods --watch --all-namespaces -o=yaml "$@"; }
kgpwjall() { \kubectl get pods --watch -o=json --all-namespaces "$@"; }
kgpwoall() { \kubectl get pods --watch -o=wide --all-namespaces "$@"; }
kgpwyall() { \kubectl get pods --watch -o=yaml --all-namespaces "$@"; }
kgpsl() { \kubectl get pods --show-labels "$@"; }
kgposl() { \kubectl get pods -o=wide --show-labels "$@"; }
kgpsll() { \kubectl get pods --show-labels -l "$@"; }
kgpslo() { \kubectl get pods --show-labels -o=wide "$@"; }
kgpslw() { \kubectl get pods --show-labels --watch "$@"; }
kgpwsl() { \kubectl get pods --watch --show-labels "$@"; }
kgposll() { \kubectl get pods -o=wide --show-labels -l "$@"; }
kgpslol() { \kubectl get pods --show-labels -o=wide -l "$@"; }
kgpslwl() { \kubectl get pods --show-labels --watch -l "$@"; }
kgpslwo() { \kubectl get pods --show-labels --watch -o=wide "$@"; }
kgpwosl() { \kubectl get pods --watch -o=wide --show-labels "$@"; }
kgpwsll() { \kubectl get pods --watch --show-labels -l "$@"; }
kgpwslo() { \kubectl get pods --watch --show-labels -o=wide "$@"; }
kgpslwol() { \kubectl get pods --show-labels --watch -o=wide -l "$@"; }
kgpwosll() { \kubectl get pods --watch -o=wide --show-labels -l "$@"; }
kgpwslol() { \kubectl get pods --watch --show-labels -o=wide -l "$@"; }
kgpaasl() { \kubectl get pods --all-namespaces --show-labels "$@"; }
kgpslall() { \kubectl get pods --show-labels --all-namespaces "$@"; }
kgpsln() { \kubectl get pods --show-labels --namespace "$@"; }
kgpaaosl() { \kubectl get pods --all-namespaces -o=wide --show-labels "$@"; }
kgpaaslo() { \kubectl get pods --all-namespaces --show-labels -o=wide "$@"; }
kgpaaslw() { \kubectl get pods --all-namespaces --show-labels --watch "$@"; }
kgpaawsl() { \kubectl get pods --all-namespaces --watch --show-labels "$@"; }
kgpoallsl() { \kubectl get pods -o=wide --all-namespaces --show-labels "$@"; }
kgposlall() { \kubectl get pods -o=wide --show-labels --all-namespaces "$@"; }
kgposln() { \kubectl get pods -o=wide --show-labels --namespace "$@"; }
kgpslaao() { \kubectl get pods --show-labels --all-namespaces -o=wide "$@"; }
kgpslallw() { \kubectl get pods --show-labels --all-namespaces --watch "$@"; }
kgpsloaa() { \kubectl get pods --show-labels -o=wide --all-namespaces "$@"; }
kgpslon() { \kubectl get pods --show-labels -o=wide --namespace "$@"; }
kgpslwall() { \kubectl get pods --show-labels --watch --all-namespaces "$@"; }
kgpslwn() { \kubectl get pods --show-labels --watch --namespace "$@"; }
kgpwallsl() { \kubectl get pods --watch --all-namespaces --show-labels "$@"; }
kgpwslall() { \kubectl get pods --watch --show-labels --all-namespaces "$@"; }
kgpwsln() { \kubectl get pods --watch --show-labels --namespace "$@"; }
kgpaaslwo() { \kubectl get pods --all-namespaces --show-labels --watch -o=wide "$@"; }
kgpaawosl() { \kubectl get pods --all-namespaces --watch -o=wide --show-labels "$@"; }
kgpaawslo() { \kubectl get pods --all-namespaces --watch --show-labels -o=wide "$@"; }
kgpslallwo() { \kubectl get pods --show-labels --all-namespaces --watch -o=wide "$@"; }
kgpslwaao() { \kubectl get pods --show-labels --watch --all-namespaces -o=wide "$@"; }
kgpslwoall() { \kubectl get pods --show-labels --watch -o=wide --all-namespaces "$@"; }
kgpslwon() { \kubectl get pods --show-labels --watch -o=wide --namespace "$@"; }
kgpwaaosl() { \kubectl get pods --watch --all-namespaces -o=wide --show-labels "$@"; }
kgpwallslo() { \kubectl get pods --watch --all-namespaces --show-labels -o=wide "$@"; }
kgpwoallsl() { \kubectl get pods --watch -o=wide --all-namespaces --show-labels "$@"; }
kgpwoslall() { \kubectl get pods --watch -o=wide --show-labels --all-namespaces "$@"; }
kgpwosln() { \kubectl get pods --watch -o=wide --show-labels --namespace "$@"; }
kgpwslaao() { \kubectl get pods --watch --show-labels --all-namespaces -o=wide "$@"; }
kgpwsloaa() { \kubectl get pods --watch --show-labels -o=wide --all-namespaces "$@"; }
kgpwslon() { \kubectl get pods --watch --show-labels -o=wide --namespace "$@"; }
kgde() { \kubectl get deployment "$@"; }
kgdel() { \kubectl get deployment -l "$@"; }
kgdeaa() { \kubectl get deployment --all-namespaces "$@"; }
kgden() { \kubectl get deployment --namespace "$@"; }
kgdeo() { \kubectl get deployment -o=wide "$@"; }
kgdeol() { \kubectl get deployment -o=wide -l "$@"; }
kgdeoall() { \kubectl get deployment -o=wide --all-namespaces "$@"; }
kgdej() { \kubectl get deployment -o=json "$@"; }
kgdew() { \kubectl get deployment --watch "$@"; }
kgdey() { \kubectl get deployment -o=yaml "$@"; }
kgdejl() { \kubectl get deployment -o=json -l "$@"; }
kgdewj() { \kubectl get deployment --watch -o=json "$@"; }
kgdewl() { \kubectl get deployment --watch -l "$@"; }
kgdewo() { \kubectl get deployment --watch -o=wide "$@"; }
kgdewy() { \kubectl get deployment --watch -o=yaml "$@"; }
kgdeyl() { \kubectl get deployment -o=yaml -l "$@"; }
kgdewjl() { \kubectl get deployment --watch -o=json -l "$@"; }
kgdewol() { \kubectl get deployment --watch -o=wide -l "$@"; }
kgdewyl() { \kubectl get deployment --watch -o=yaml -l "$@"; }
kgdejn() { \kubectl get deployment -o=json --namespace "$@"; }
kgdeon() { \kubectl get deployment -o=wide --namespace "$@"; }
kgdewn() { \kubectl get deployment --watch --namespace "$@"; }
kgdeyn() { \kubectl get deployment -o=yaml --namespace "$@"; }
kgdewjn() { \kubectl get deployment --watch -o=json --namespace "$@"; }
kgdewon() { \kubectl get deployment --watch -o=wide --namespace "$@"; }
kgdewyn() { \kubectl get deployment --watch -o=yaml --namespace "$@"; }
kgdeaaojson() { \kubectl get deployment --all-namespaces -o=json "$@"; }
kgdeaaowide() { \kubectl get deployment --all-namespaces -o=wide "$@"; }
kgdeaaoyaml() { \kubectl get deployment --all-namespaces -o=yaml "$@"; }
kgdeaaw() { \kubectl get deployment --all-namespaces --watch "$@"; }
kgdejall() { \kubectl get deployment -o=json --all-namespaces "$@"; }
kgdewall() { \kubectl get deployment --watch --all-namespaces "$@"; }
kgdeyall() { \kubectl get deployment -o=yaml --all-namespaces "$@"; }
kgdeaawj() { \kubectl get deployment --all-namespaces --watch -o=json "$@"; }
kgdeaawo() { \kubectl get deployment --all-namespaces --watch -o=wide "$@"; }
kgdeaawy() { \kubectl get deployment --all-namespaces --watch -o=yaml "$@"; }
kgdewaaj() { \kubectl get deployment --watch --all-namespaces -o=json "$@"; }
kgdewaao() { \kubectl get deployment --watch --all-namespaces -o=wide "$@"; }
kgdewaay() { \kubectl get deployment --watch --all-namespaces -o=yaml "$@"; }
kgdewjall() { \kubectl get deployment --watch -o=json --all-namespaces "$@"; }
kgdewoall() { \kubectl get deployment --watch -o=wide --all-namespaces "$@"; }
kgdewyall() { \kubectl get deployment --watch -o=yaml --all-namespaces "$@"; }
kgdesl() { \kubectl get deployment --show-labels "$@"; }
kgdeosl() { \kubectl get deployment -o=wide --show-labels "$@"; }
kgdesll() { \kubectl get deployment --show-labels -l "$@"; }
kgdeslo() { \kubectl get deployment --show-labels -o=wide "$@"; }
kgdeslw() { \kubectl get deployment --show-labels --watch "$@"; }
kgdewsl() { \kubectl get deployment --watch --show-labels "$@"; }
kgdeosll() { \kubectl get deployment -o=wide --show-labels -l "$@"; }
kgdeslol() { \kubectl get deployment --show-labels -o=wide -l "$@"; }
kgdeslwl() { \kubectl get deployment --show-labels --watch -l "$@"; }
kgdeslwo() { \kubectl get deployment --show-labels --watch -o=wide "$@"; }
kgdewosl() { \kubectl get deployment --watch -o=wide --show-labels "$@"; }
kgdewsll() { \kubectl get deployment --watch --show-labels -l "$@"; }
kgdewslo() { \kubectl get deployment --watch --show-labels -o=wide "$@"; }
kgdeslwol() { \kubectl get deployment --show-labels --watch -o=wide -l "$@"; }
kgdewosll() { \kubectl get deployment --watch -o=wide --show-labels -l "$@"; }
kgdewslol() { \kubectl get deployment --watch --show-labels -o=wide -l "$@"; }
kgdeaasl() { \kubectl get deployment --all-namespaces --show-labels "$@"; }
kgdeslall() { \kubectl get deployment --show-labels --all-namespaces "$@"; }
kgdesln() { \kubectl get deployment --show-labels --namespace "$@"; }
kgdeaaosl() { \kubectl get deployment --all-namespaces -o=wide --show-labels "$@"; }
kgdeaaslo() { \kubectl get deployment --all-namespaces --show-labels -o=wide "$@"; }
kgdeaaslw() { \kubectl get deployment --all-namespaces --show-labels --watch "$@"; }
kgdeaawsl() { \kubectl get deployment --all-namespaces --watch --show-labels "$@"; }
kgdeoallsl() { \kubectl get deployment -o=wide --all-namespaces --show-labels "$@"; }
kgdeoslall() { \kubectl get deployment -o=wide --show-labels --all-namespaces "$@"; }
kgdeosln() { \kubectl get deployment -o=wide --show-labels --namespace "$@"; }
kgdeslaao() { \kubectl get deployment --show-labels --all-namespaces -o=wide "$@"; }
kgdeslallw() { \kubectl get deployment --show-labels --all-namespaces --watch "$@"; }
kgdesloaa() { \kubectl get deployment --show-labels -o=wide --all-namespaces "$@"; }
kgdeslon() { \kubectl get deployment --show-labels -o=wide --namespace "$@"; }
kgdeslwall() { \kubectl get deployment --show-labels --watch --all-namespaces "$@"; }
kgdeslwn() { \kubectl get deployment --show-labels --watch --namespace "$@"; }
kgdewallsl() { \kubectl get deployment --watch --all-namespaces --show-labels "$@"; }
kgdewslall() { \kubectl get deployment --watch --show-labels --all-namespaces "$@"; }
kgdewsln() { \kubectl get deployment --watch --show-labels --namespace "$@"; }
kgdeaaslwo() { \kubectl get deployment --all-namespaces --show-labels --watch -o=wide "$@"; }
kgdeaawosl() { \kubectl get deployment --all-namespaces --watch -o=wide --show-labels "$@"; }
kgdeaawslo() { \kubectl get deployment --all-namespaces --watch --show-labels -o=wide "$@"; }
kgdeslallwo() { \kubectl get deployment --show-labels --all-namespaces --watch -o=wide "$@"; }
kgdeslwaao() { \kubectl get deployment --show-labels --watch --all-namespaces -o=wide "$@"; }
kgdeslwoall() { \kubectl get deployment --show-labels --watch -o=wide --all-namespaces "$@"; }
kgdeslwon() { \kubectl get deployment --show-labels --watch -o=wide --namespace "$@"; }
kgdewaaosl() { \kubectl get deployment --watch --all-namespaces -o=wide --show-labels "$@"; }
kgdewallslo() { \kubectl get deployment --watch --all-namespaces --show-labels -o=wide "$@"; }
kgdewoallsl() { \kubectl get deployment --watch -o=wide --all-namespaces --show-labels "$@"; }
kgdewoslall() { \kubectl get deployment --watch -o=wide --show-labels --all-namespaces "$@"; }
kgdewosln() { \kubectl get deployment --watch -o=wide --show-labels --namespace "$@"; }
kgdewslaao() { \kubectl get deployment --watch --show-labels --all-namespaces -o=wide "$@"; }
kgdewsloaa() { \kubectl get deployment --watch --show-labels -o=wide --all-namespaces "$@"; }
kgdewslon() { \kubectl get deployment --watch --show-labels -o=wide --namespace "$@"; }
kgsv() { \kubectl get service "$@"; }
kgsvl() { \kubectl get service -l "$@"; }
kgsvaa() { \kubectl get service --all-namespaces "$@"; }
kgsvn() { \kubectl get service --namespace "$@"; }
kgsvo() { \kubectl get service -o=wide "$@"; }
kgsvol() { \kubectl get service -o=wide -l "$@"; }
kgsvoall() { \kubectl get service -o=wide --all-namespaces "$@"; }
kgsvj() { \kubectl get service -o=json "$@"; }
kgsvw() { \kubectl get service --watch "$@"; }
kgsvy() { \kubectl get service -o=yaml "$@"; }
kgsvjl() { \kubectl get service -o=json -l "$@"; }
kgsvwj() { \kubectl get service --watch -o=json "$@"; }
kgsvwl() { \kubectl get service --watch -l "$@"; }
kgsvwo() { \kubectl get service --watch -o=wide "$@"; }
kgsvwy() { \kubectl get service --watch -o=yaml "$@"; }
kgsvyl() { \kubectl get service -o=yaml -l "$@"; }
kgsvwjl() { \kubectl get service --watch -o=json -l "$@"; }
kgsvwol() { \kubectl get service --watch -o=wide -l "$@"; }
kgsvwyl() { \kubectl get service --watch -o=yaml -l "$@"; }
kgsvjn() { \kubectl get service -o=json --namespace "$@"; }
kgsvon() { \kubectl get service -o=wide --namespace "$@"; }
kgsvwn() { \kubectl get service --watch --namespace "$@"; }
kgsvyn() { \kubectl get service -o=yaml --namespace "$@"; }
kgsvwjn() { \kubectl get service --watch -o=json --namespace "$@"; }
kgsvwon() { \kubectl get service --watch -o=wide --namespace "$@"; }
kgsvwyn() { \kubectl get service --watch -o=yaml --namespace "$@"; }
kgsvaaojson() { \kubectl get service --all-namespaces -o=json "$@"; }
kgsvaaowide() { \kubectl get service --all-namespaces -o=wide "$@"; }
kgsvaaoyaml() { \kubectl get service --all-namespaces -o=yaml "$@"; }
kgsvaaw() { \kubectl get service --all-namespaces --watch "$@"; }
kgsvjall() { \kubectl get service -o=json --all-namespaces "$@"; }
kgsvwall() { \kubectl get service --watch --all-namespaces "$@"; }
kgsvyall() { \kubectl get service -o=yaml --all-namespaces "$@"; }
kgsvaawj() { \kubectl get service --all-namespaces --watch -o=json "$@"; }
kgsvaawo() { \kubectl get service --all-namespaces --watch -o=wide "$@"; }
kgsvaawy() { \kubectl get service --all-namespaces --watch -o=yaml "$@"; }
kgsvwaaj() { \kubectl get service --watch --all-namespaces -o=json "$@"; }
kgsvwaao() { \kubectl get service --watch --all-namespaces -o=wide "$@"; }
kgsvwaay() { \kubectl get service --watch --all-namespaces -o=yaml "$@"; }
kgsvwjall() { \kubectl get service --watch -o=json --all-namespaces "$@"; }
kgsvwoall() { \kubectl get service --watch -o=wide --all-namespaces "$@"; }
kgsvwyall() { \kubectl get service --watch -o=yaml --all-namespaces "$@"; }
kgi() { \kubectl get ingress "$@"; }
kgil() { \kubectl get ingress -l "$@"; }
kgiaa() { \kubectl get ingress --all-namespaces "$@"; }
kgin() { \kubectl get ingress --namespace "$@"; }
kgio() { \kubectl get ingress -o=wide "$@"; }
kgiol() { \kubectl get ingress -o=wide -l "$@"; }
kgioall() { \kubectl get ingress -o=wide --all-namespaces "$@"; }
kgij() { \kubectl get ingress -o=json "$@"; }
kgiw() { \kubectl get ingress --watch "$@"; }
kgiy() { \kubectl get ingress -o=yaml "$@"; }
kgijl() { \kubectl get ingress -o=json -l "$@"; }
kgiwj() { \kubectl get ingress --watch -o=json "$@"; }
kgiwl() { \kubectl get ingress --watch -l "$@"; }
kgiwo() { \kubectl get ingress --watch -o=wide "$@"; }
kgiwy() { \kubectl get ingress --watch -o=yaml "$@"; }
kgiyl() { \kubectl get ingress -o=yaml -l "$@"; }
kgiwjl() { \kubectl get ingress --watch -o=json -l "$@"; }
kgiwol() { \kubectl get ingress --watch -o=wide -l "$@"; }
kgiwyl() { \kubectl get ingress --watch -o=yaml -l "$@"; }
kgijn() { \kubectl get ingress -o=json --namespace "$@"; }
kgion() { \kubectl get ingress -o=wide --namespace "$@"; }
kgiwn() { \kubectl get ingress --watch --namespace "$@"; }
kgiyn() { \kubectl get ingress -o=yaml --namespace "$@"; }
kgiwjn() { \kubectl get ingress --watch -o=json --namespace "$@"; }
kgiwon() { \kubectl get ingress --watch -o=wide --namespace "$@"; }
kgiwyn() { \kubectl get ingress --watch -o=yaml --namespace "$@"; }
kgiaaojson() { \kubectl get ingress --all-namespaces -o=json "$@"; }
kgiaaowide() { \kubectl get ingress --all-namespaces -o=wide "$@"; }
kgiaaoyaml() { \kubectl get ingress --all-namespaces -o=yaml "$@"; }
kgiaaw() { \kubectl get ingress --all-namespaces --watch "$@"; }
kgijall() { \kubectl get ingress -o=json --all-namespaces "$@"; }
kgiwall() { \kubectl get ingress --watch --all-namespaces "$@"; }
kgiyall() { \kubectl get ingress -o=yaml --all-namespaces "$@"; }
kgiaawj() { \kubectl get ingress --all-namespaces --watch -o=json "$@"; }
kgiaawo() { \kubectl get ingress --all-namespaces --watch -o=wide "$@"; }
kgiaawy() { \kubectl get ingress --all-namespaces --watch -o=yaml "$@"; }
kgiwaaj() { \kubectl get ingress --watch --all-namespaces -o=json "$@"; }
kgiwaao() { \kubectl get ingress --watch --all-namespaces -o=wide "$@"; }
kgiwaay() { \kubectl get ingress --watch --all-namespaces -o=yaml "$@"; }
kgiwjall() { \kubectl get ingress --watch -o=json --all-namespaces "$@"; }
kgiwoall() { \kubectl get ingress --watch -o=wide --all-namespaces "$@"; }
kgiwyall() { \kubectl get ingress --watch -o=yaml --all-namespaces "$@"; }
kgc() { \kubectl get configmap "$@"; }
kgcl() { \kubectl get configmap -l "$@"; }
kgcaa() { \kubectl get configmap --all-namespaces "$@"; }
kgcn() { \kubectl get configmap --namespace "$@"; }
kgco() { \kubectl get configmap -o=wide "$@"; }
kgcol() { \kubectl get configmap -o=wide -l "$@"; }
kgcoall() { \kubectl get configmap -o=wide --all-namespaces "$@"; }
kgcj() { \kubectl get configmap -o=json "$@"; }
kgcw() { \kubectl get configmap --watch "$@"; }
kgcy() { \kubectl get configmap -o=yaml "$@"; }
kgcjl() { \kubectl get configmap -o=json -l "$@"; }
kgcwj() { \kubectl get configmap --watch -o=json "$@"; }
kgcwl() { \kubectl get configmap --watch -l "$@"; }
kgcwo() { \kubectl get configmap --watch -o=wide "$@"; }
kgcwy() { \kubectl get configmap --watch -o=yaml "$@"; }
kgcyl() { \kubectl get configmap -o=yaml -l "$@"; }
kgcwjl() { \kubectl get configmap --watch -o=json -l "$@"; }
kgcwol() { \kubectl get configmap --watch -o=wide -l "$@"; }
kgcwyl() { \kubectl get configmap --watch -o=yaml -l "$@"; }
kgcjn() { \kubectl get configmap -o=json --namespace "$@"; }
kgcon() { \kubectl get configmap -o=wide --namespace "$@"; }
kgcwn() { \kubectl get configmap --watch --namespace "$@"; }
kgcyn() { \kubectl get configmap -o=yaml --namespace "$@"; }
kgcwjn() { \kubectl get configmap --watch -o=json --namespace "$@"; }
kgcwon() { \kubectl get configmap --watch -o=wide --namespace "$@"; }
kgcwyn() { \kubectl get configmap --watch -o=yaml --namespace "$@"; }
kgcaaojson() { \kubectl get configmap --all-namespaces -o=json "$@"; }
kgcaaowide() { \kubectl get configmap --all-namespaces -o=wide "$@"; }
kgcaaoyaml() { \kubectl get configmap --all-namespaces -o=yaml "$@"; }
kgcaaw() { \kubectl get configmap --all-namespaces --watch "$@"; }
kgcjall() { \kubectl get configmap -o=json --all-namespaces "$@"; }
kgcwall() { \kubectl get configmap --watch --all-namespaces "$@"; }
kgcyall() { \kubectl get configmap -o=yaml --all-namespaces "$@"; }
kgcaawj() { \kubectl get configmap --all-namespaces --watch -o=json "$@"; }
kgcaawo() { \kubectl get configmap --all-namespaces --watch -o=wide "$@"; }
kgcaawy() { \kubectl get configmap --all-namespaces --watch -o=yaml "$@"; }
kgcwaaj() { \kubectl get configmap --watch --all-namespaces -o=json "$@"; }
kgcwaao() { \kubectl get configmap --watch --all-namespaces -o=wide "$@"; }
kgcwaay() { \kubectl get configmap --watch --all-namespaces -o=yaml "$@"; }
kgcwjall() { \kubectl get configmap --watch -o=json --all-namespaces "$@"; }
kgcwoall() { \kubectl get configmap --watch -o=wide --all-namespaces "$@"; }
kgcwyall() { \kubectl get configmap --watch -o=yaml --all-namespaces "$@"; }
kgse() { \kubectl get secret "$@"; }
kgsel() { \kubectl get secret -l "$@"; }
kgseaa() { \kubectl get secret --all-namespaces "$@"; }
kgsen() { \kubectl get secret --namespace "$@"; }
kgseo() { \kubectl get secret -o=wide "$@"; }
kgseol() { \kubectl get secret -o=wide -l "$@"; }
kgseoall() { \kubectl get secret -o=wide --all-namespaces "$@"; }
kgsej() { \kubectl get secret -o=json "$@"; }
kgsew() { \kubectl get secret --watch "$@"; }
kgsey() { \kubectl get secret -o=yaml "$@"; }
kgsejl() { \kubectl get secret -o=json -l "$@"; }
kgsewj() { \kubectl get secret --watch -o=json "$@"; }
kgsewl() { \kubectl get secret --watch -l "$@"; }
kgsewo() { \kubectl get secret --watch -o=wide "$@"; }
kgsewy() { \kubectl get secret --watch -o=yaml "$@"; }
kgseyl() { \kubectl get secret -o=yaml -l "$@"; }
kgsewjl() { \kubectl get secret --watch -o=json -l "$@"; }
kgsewol() { \kubectl get secret --watch -o=wide -l "$@"; }
kgsewyl() { \kubectl get secret --watch -o=yaml -l "$@"; }
kgsejn() { \kubectl get secret -o=json --namespace "$@"; }
kgseon() { \kubectl get secret -o=wide --namespace "$@"; }
kgsewn() { \kubectl get secret --watch --namespace "$@"; }
kgseyn() { \kubectl get secret -o=yaml --namespace "$@"; }
kgsewjn() { \kubectl get secret --watch -o=json --namespace "$@"; }
kgsewon() { \kubectl get secret --watch -o=wide --namespace "$@"; }
kgsewyn() { \kubectl get secret --watch -o=yaml --namespace "$@"; }
kgseaaojson() { \kubectl get secret --all-namespaces -o=json "$@"; }
kgseaaowide() { \kubectl get secret --all-namespaces -o=wide "$@"; }
kgseaaoyaml() { \kubectl get secret --all-namespaces -o=yaml "$@"; }
kgseaaw() { \kubectl get secret --all-namespaces --watch "$@"; }
kgsejall() { \kubectl get secret -o=json --all-namespaces "$@"; }
kgsewall() { \kubectl get secret --watch --all-namespaces "$@"; }
kgseyall() { \kubectl get secret -o=yaml --all-namespaces "$@"; }
kgseaawj() { \kubectl get secret --all-namespaces --watch -o=json "$@"; }
kgseaawo() { \kubectl get secret --all-namespaces --watch -o=wide "$@"; }
kgseaawy() { \kubectl get secret --all-namespaces --watch -o=yaml "$@"; }
kgsewaaj() { \kubectl get secret --watch --all-namespaces -o=json "$@"; }
kgsewaao() { \kubectl get secret --watch --all-namespaces -o=wide "$@"; }
kgsewaay() { \kubectl get secret --watch --all-namespaces -o=yaml "$@"; }
kgsewjall() { \kubectl get secret --watch -o=json --all-namespaces "$@"; }
kgsewoall() { \kubectl get secret --watch -o=wide --all-namespaces "$@"; }
kgsewyall() { \kubectl get secret --watch -o=yaml --all-namespaces "$@"; }
kgno() { \kubectl get nodes "$@"; }
kgnol() { \kubectl get nodes -l "$@"; }
kgnoo() { \kubectl get nodes -o=wide "$@"; }
kgnool() { \kubectl get nodes -o=wide -l "$@"; }
kgnoj() { \kubectl get nodes -o=json "$@"; }
kgnow() { \kubectl get nodes --watch "$@"; }
kgnoy() { \kubectl get nodes -o=yaml "$@"; }
kgnojl() { \kubectl get nodes -o=json -l "$@"; }
kgnowj() { \kubectl get nodes --watch -o=json "$@"; }
kgnowl() { \kubectl get nodes --watch -l "$@"; }
kgnowo() { \kubectl get nodes --watch -o=wide "$@"; }
kgnowy() { \kubectl get nodes --watch -o=yaml "$@"; }
kgnoyl() { \kubectl get nodes -o=yaml -l "$@"; }
kgnowjl() { \kubectl get nodes --watch -o=json -l "$@"; }
kgnowol() { \kubectl get nodes --watch -o=wide -l "$@"; }
kgnowyl() { \kubectl get nodes --watch -o=yaml -l "$@"; }
kgn() { \kubectl get namespaces "$@"; }
kgnl() { \kubectl get namespaces -l "$@"; }
kgnaa() { \kubectl get namespaces --all-namespaces "$@"; }
kgnj() { \kubectl get namespaces -o=json "$@"; }
kgnw() { \kubectl get namespaces --watch "$@"; }
kgny() { \kubectl get namespaces -o=yaml "$@"; }
kgnjl() { \kubectl get namespaces -o=json -l "$@"; }
kgnwj() { \kubectl get namespaces --watch -o=json "$@"; }
kgnwl() { \kubectl get namespaces --watch -l "$@"; }
kgnwo() { \kubectl get namespaces --watch -o=wide "$@"; }
kgnwy() { \kubectl get namespaces --watch -o=yaml "$@"; }
kgnyl() { \kubectl get namespaces -o=yaml -l "$@"; }
kgnwjl() { \kubectl get namespaces --watch -o=json -l "$@"; }
kgnwol() { \kubectl get namespaces --watch -o=wide -l "$@"; }
kgnwyl() { \kubectl get namespaces --watch -o=yaml -l "$@"; }
kgnaaojson() { \kubectl get namespaces --all-namespaces -o=json "$@"; }
kgnaaowide() { \kubectl get namespaces --all-namespaces -o=wide "$@"; }
kgnaaoyaml() { \kubectl get namespaces --all-namespaces -o=yaml "$@"; }
kgnaaw() { \kubectl get namespaces --all-namespaces --watch "$@"; }
kgnjall() { \kubectl get namespaces -o=json --all-namespaces "$@"; }
kgnwall() { \kubectl get namespaces --watch --all-namespaces "$@"; }
kgnyall() { \kubectl get namespaces -o=yaml --all-namespaces "$@"; }
kgnaawj() { \kubectl get namespaces --all-namespaces --watch -o=json "$@"; }
kgnaawo() { \kubectl get namespaces --all-namespaces --watch -o=wide "$@"; }
kgnaawy() { \kubectl get namespaces --all-namespaces --watch -o=yaml "$@"; }
kgnwaaj() { \kubectl get namespaces --watch --all-namespaces -o=json "$@"; }
kgnwaao() { \kubectl get namespaces --watch --all-namespaces -o=wide "$@"; }
kgnwaay() { \kubectl get namespaces --watch --all-namespaces -o=yaml "$@"; }
kgnwjall() { \kubectl get namespaces --watch -o=json --all-namespaces "$@"; }
kgnwoall() { \kubectl get namespaces --watch -o=wide --all-namespaces "$@"; }
kgnwyall() { \kubectl get namespaces --watch -o=yaml --all-namespaces "$@"; }
kgnso() { \kubectl get namespaces -o=wide "$@"; }
kgnsol() { \kubectl get namespaces -o=wide -l "$@"; }
kgnsoall() { \kubectl get namespaces -o=wide --all-namespaces "$@"; }
kd() { \kubectl describe "$@"; }
kdl() { \kubectl describe -l "$@"; }
kdaa() { \kubectl describe --all-namespaces "$@"; }
kdf() { \kubectl describe --recursive -f "$@"; }
kdp() { \kubectl describe pods "$@"; }
kdpl() { \kubectl describe pods -l "$@"; }
kdpaa() { \kubectl describe pods --all-namespaces "$@"; }
kdpn() { \kubectl describe pods --namespace "$@"; }
kdde() { \kubectl describe deployment "$@"; }
kddel() { \kubectl describe deployment -l "$@"; }
kddeaa() { \kubectl describe deployment --all-namespaces "$@"; }
kdden() { \kubectl describe deployment --namespace "$@"; }
kdsv() { \kubectl describe service "$@"; }
kdsvl() { \kubectl describe service -l "$@"; }
kdsvaa() { \kubectl describe service --all-namespaces "$@"; }
kdsvn() { \kubectl describe service --namespace "$@"; }
kdi() { \kubectl describe ingress "$@"; }
kdil() { \kubectl describe ingress -l "$@"; }
kdiaa() { \kubectl describe ingress --all-namespaces "$@"; }
kdin() { \kubectl describe ingress --namespace "$@"; }
kdc() { \kubectl describe configmap "$@"; }
kdcl() { \kubectl describe configmap -l "$@"; }
kdcaa() { \kubectl describe configmap --all-namespaces "$@"; }
kdcn() { \kubectl describe configmap --namespace "$@"; }
kdse() { \kubectl describe secret "$@"; }
kdsel() { \kubectl describe secret -l "$@"; }
kdseaa() { \kubectl describe secret --all-namespaces "$@"; }
kdsen() { \kubectl describe secret --namespace "$@"; }
kdno() { \kubectl describe nodes "$@"; }
kdnol() { \kubectl describe nodes -l "$@"; }
kdn() { \kubectl describe namespaces "$@"; }
kdnl() { \kubectl describe namespaces -l "$@"; }
kdnaa() { \kubectl describe namespaces --all-namespaces "$@"; }
kx() { \kubectl delete "$@"; }
kxl() { \kubectl delete -l "$@"; }
kxaa() { \kubectl delete --all "$@"; }
kxf() { \kubectl delete --recursive -f "$@"; }
kxp() { \kubectl delete pods "$@"; }
kxpl() { \kubectl delete pods -l "$@"; }
kxpaa() { \kubectl delete pods --all "$@"; }
kxpn() { \kubectl delete pods --namespace "$@"; }
kxde() { \kubectl delete deployment "$@"; }
kxdel() { \kubectl delete deployment -l "$@"; }
kxdeaa() { \kubectl delete deployment --all "$@"; }
kxden() { \kubectl delete deployment --namespace "$@"; }
kxsv() { \kubectl delete service "$@"; }
kxsvl() { \kubectl delete service -l "$@"; }
kxsvaa() { \kubectl delete service --all "$@"; }
kxsvn() { \kubectl delete service --namespace "$@"; }
kxi() { \kubectl delete ingress "$@"; }
kxil() { \kubectl delete ingress -l "$@"; }
kxiaa() { \kubectl delete ingress --all "$@"; }
kxin() { \kubectl delete ingress --namespace "$@"; }
kxc() { \kubectl delete configmap "$@"; }
kxcl() { \kubectl delete configmap -l "$@"; }
kxcaa() { \kubectl delete configmap --all "$@"; }
kxcn() { \kubectl delete configmap --namespace "$@"; }
kxse() { \kubectl delete secret "$@"; }
kxsel() { \kubectl delete secret -l "$@"; }
kxseaa() { \kubectl delete secret --all "$@"; }
kxsen() { \kubectl delete secret --namespace "$@"; }
kxn() { \kubectl delete namespaces "$@"; }
kxnl() { \kubectl delete namespaces -l "$@"; }
kxnaa() { \kubectl delete namespaces --all "$@"; }
kzg() { \kubectl --namespace=kube-system get "$@"; }
kzgl() { \kubectl --namespace=kube-system get -l "$@"; }
kzgo() { \kubectl --namespace=kube-system get -o=wide "$@"; }
kzgol() { \kubectl --namespace=kube-system get -o=wide -l "$@"; }
kzgj() { \kubectl --namespace=kube-system get -o=json "$@"; }
kzgw() { \kubectl --namespace=kube-system get --watch "$@"; }
kzgy() { \kubectl --namespace=kube-system get -o=yaml "$@"; }
kzgjl() { \kubectl --namespace=kube-system get -o=json -l "$@"; }
kzgwj() { \kubectl --namespace=kube-system get --watch -o=json "$@"; }
kzgwl() { \kubectl --namespace=kube-system get --watch -l "$@"; }
kzgwo() { \kubectl --namespace=kube-system get --watch -o=wide "$@"; }
kzgwy() { \kubectl --namespace=kube-system get --watch -o=yaml "$@"; }
kzgyl() { \kubectl --namespace=kube-system get -o=yaml -l "$@"; }
kzgwjl() { \kubectl --namespace=kube-system get --watch -o=json -l "$@"; }
kzgwol() { \kubectl --namespace=kube-system get --watch -o=wide -l "$@"; }
kzgwyl() { \kubectl --namespace=kube-system get --watch -o=yaml -l "$@"; }
kzgsl() { \kubectl --namespace=kube-system get --show-labels "$@"; }
kzgosl() { \kubectl --namespace=kube-system get -o=wide --show-labels "$@"; }
kzgsll() { \kubectl --namespace=kube-system get --show-labels -l "$@"; }
kzgslo() { \kubectl --namespace=kube-system get --show-labels -o=wide "$@"; }
kzgslw() { \kubectl --namespace=kube-system get --show-labels --watch "$@"; }
kzgwsl() { \kubectl --namespace=kube-system get --watch --show-labels "$@"; }
kzgosll() { \kubectl --namespace=kube-system get -o=wide --show-labels -l "$@"; }
kzgslol() { \kubectl --namespace=kube-system get --show-labels -o=wide -l "$@"; }
kzgslwl() { \kubectl --namespace=kube-system get --show-labels --watch -l "$@"; }
kzgslwo() { \kubectl --namespace=kube-system get --show-labels --watch -o=wide "$@"; }
kzgwosl() { \kubectl --namespace=kube-system get --watch -o=wide --show-labels "$@"; }
kzgwsll() { \kubectl --namespace=kube-system get --watch --show-labels -l "$@"; }
kzgwslo() { \kubectl --namespace=kube-system get --watch --show-labels -o=wide "$@"; }
kzgslwol() { \kubectl --namespace=kube-system get --show-labels --watch -o=wide -l "$@"; }
kzgwosll() { \kubectl --namespace=kube-system get --watch -o=wide --show-labels -l "$@"; }
kzgwslol() { \kubectl --namespace=kube-system get --watch --show-labels -o=wide -l "$@"; }
kzgp() { \kubectl --namespace=kube-system get pods "$@"; }
kzgpl() { \kubectl --namespace=kube-system get pods -l "$@"; }
kzgpo() { \kubectl --namespace=kube-system get pods -o=wide "$@"; }
kzgpol() { \kubectl --namespace=kube-system get pods -o=wide -l "$@"; }
kzgpj() { \kubectl --namespace=kube-system get pods -o=json "$@"; }
kzgpw() { \kubectl --namespace=kube-system get pods --watch "$@"; }
kzgpy() { \kubectl --namespace=kube-system get pods -o=yaml "$@"; }
kzgpjl() { \kubectl --namespace=kube-system get pods -o=json -l "$@"; }
kzgpwj() { \kubectl --namespace=kube-system get pods --watch -o=json "$@"; }
kzgpwl() { \kubectl --namespace=kube-system get pods --watch -l "$@"; }
kzgpwo() { \kubectl --namespace=kube-system get pods --watch -o=wide "$@"; }
kzgpwy() { \kubectl --namespace=kube-system get pods --watch -o=yaml "$@"; }
kzgpyl() { \kubectl --namespace=kube-system get pods -o=yaml -l "$@"; }
kzgpwjl() { \kubectl --namespace=kube-system get pods --watch -o=json -l "$@"; }
kzgpwol() { \kubectl --namespace=kube-system get pods --watch -o=wide -l "$@"; }
kzgpwyl() { \kubectl --namespace=kube-system get pods --watch -o=yaml -l "$@"; }
kzgpsl() { \kubectl --namespace=kube-system get pods --show-labels "$@"; }
kzgposl() { \kubectl --namespace=kube-system get pods -o=wide --show-labels "$@"; }
kzgpsll() { \kubectl --namespace=kube-system get pods --show-labels -l "$@"; }
kzgpslo() { \kubectl --namespace=kube-system get pods --show-labels -o=wide "$@"; }
kzgpslw() { \kubectl --namespace=kube-system get pods --show-labels --watch "$@"; }
kzgpwsl() { \kubectl --namespace=kube-system get pods --watch --show-labels "$@"; }
kzgposll() { \kubectl --namespace=kube-system get pods -o=wide --show-labels -l "$@"; }
kzgpslol() { \kubectl --namespace=kube-system get pods --show-labels -o=wide -l "$@"; }
kzgpslwl() { \kubectl --namespace=kube-system get pods --show-labels --watch -l "$@"; }
kzgpslwo() { \kubectl --namespace=kube-system get pods --show-labels --watch -o=wide "$@"; }
kzgpwosl() { \kubectl --namespace=kube-system get pods --watch -o=wide --show-labels "$@"; }
kzgpwsll() { \kubectl --namespace=kube-system get pods --watch --show-labels -l "$@"; }
kzgpwslo() { \kubectl --namespace=kube-system get pods --watch --show-labels -o=wide "$@"; }
kzgpslwol() { \kubectl --namespace=kube-system get pods --show-labels --watch -o=wide -l "$@"; }
kzgpwosll() { \kubectl --namespace=kube-system get pods --watch -o=wide --show-labels -l "$@"; }
kzgpwslol() { \kubectl --namespace=kube-system get pods --watch --show-labels -o=wide -l "$@"; }
kzgde() { \kubectl --namespace=kube-system get deployment "$@"; }
kzgdel() { \kubectl --namespace=kube-system get deployment -l "$@"; }
kzgdeo() { \kubectl --namespace=kube-system get deployment -o=wide "$@"; }
kzgdeol() { \kubectl --namespace=kube-system get deployment -o=wide -l "$@"; }
kzgdej() { \kubectl --namespace=kube-system get deployment -o=json "$@"; }
kzgdew() { \kubectl --namespace=kube-system get deployment --watch "$@"; }
kzgdey() { \kubectl --namespace=kube-system get deployment -o=yaml "$@"; }
kzgdejl() { \kubectl --namespace=kube-system get deployment -o=json -l "$@"; }
kzgdewj() { \kubectl --namespace=kube-system get deployment --watch -o=json "$@"; }
kzgdewl() { \kubectl --namespace=kube-system get deployment --watch -l "$@"; }
kzgdewo() { \kubectl --namespace=kube-system get deployment --watch -o=wide "$@"; }
kzgdewy() { \kubectl --namespace=kube-system get deployment --watch -o=yaml "$@"; }
kzgdeyl() { \kubectl --namespace=kube-system get deployment -o=yaml -l "$@"; }
kzgdewjl() { \kubectl --namespace=kube-system get deployment --watch -o=json -l "$@"; }
kzgdewol() { \kubectl --namespace=kube-system get deployment --watch -o=wide -l "$@"; }
kzgdewyl() { \kubectl --namespace=kube-system get deployment --watch -o=yaml -l "$@"; }
kzgdesl() { \kubectl --namespace=kube-system get deployment --show-labels "$@"; }
kzgdeosl() { \kubectl --namespace=kube-system get deployment -o=wide --show-labels "$@"; }
kzgdesll() { \kubectl --namespace=kube-system get deployment --show-labels -l "$@"; }
kzgdeslo() { \kubectl --namespace=kube-system get deployment --show-labels -o=wide "$@"; }
kzgdeslw() { \kubectl --namespace=kube-system get deployment --show-labels --watch "$@"; }
kzgdewsl() { \kubectl --namespace=kube-system get deployment --watch --show-labels "$@"; }
kzgdeosll() { \kubectl --namespace=kube-system get deployment -o=wide --show-labels -l "$@"; }
kzgdeslol() { \kubectl --namespace=kube-system get deployment --show-labels -o=wide -l "$@"; }
kzgdeslwl() { \kubectl --namespace=kube-system get deployment --show-labels --watch -l "$@"; }
kzgdeslwo() { \kubectl --namespace=kube-system get deployment --show-labels --watch -o=wide "$@"; }
kzgdewosl() { \kubectl --namespace=kube-system get deployment --watch -o=wide --show-labels "$@"; }
kzgdewsll() { \kubectl --namespace=kube-system get deployment --watch --show-labels -l "$@"; }
kzgdewslo() { \kubectl --namespace=kube-system get deployment --watch --show-labels -o=wide "$@"; }
kzgdeslwol() { \kubectl --namespace=kube-system get deployment --show-labels --watch -o=wide -l "$@"; }
kzgdewosll() { \kubectl --namespace=kube-system get deployment --watch -o=wide --show-labels -l "$@"; }
kzgdewslol() { \kubectl --namespace=kube-system get deployment --watch --show-labels -o=wide -l "$@"; }
kzgsv() { \kubectl --namespace=kube-system get service "$@"; }
kzgsvl() { \kubectl --namespace=kube-system get service -l "$@"; }
kzgsvo() { \kubectl --namespace=kube-system get service -o=wide "$@"; }
kzgsvol() { \kubectl --namespace=kube-system get service -o=wide -l "$@"; }
kzgsvj() { \kubectl --namespace=kube-system get service -o=json "$@"; }
kzgsvw() { \kubectl --namespace=kube-system get service --watch "$@"; }
kzgsvy() { \kubectl --namespace=kube-system get service -o=yaml "$@"; }
kzgsvjl() { \kubectl --namespace=kube-system get service -o=json -l "$@"; }
kzgsvwj() { \kubectl --namespace=kube-system get service --watch -o=json "$@"; }
kzgsvwl() { \kubectl --namespace=kube-system get service --watch -l "$@"; }
kzgsvwo() { \kubectl --namespace=kube-system get service --watch -o=wide "$@"; }
kzgsvwy() { \kubectl --namespace=kube-system get service --watch -o=yaml "$@"; }
kzgsvyl() { \kubectl --namespace=kube-system get service -o=yaml -l "$@"; }
kzgsvwjl() { \kubectl --namespace=kube-system get service --watch -o=json -l "$@"; }
kzgsvwol() { \kubectl --namespace=kube-system get service --watch -o=wide -l "$@"; }
kzgsvwyl() { \kubectl --namespace=kube-system get service --watch -o=yaml -l "$@"; }
kzgi() { \kubectl --namespace=kube-system get ingress "$@"; }
kzgil() { \kubectl --namespace=kube-system get ingress -l "$@"; }
kzgio() { \kubectl --namespace=kube-system get ingress -o=wide "$@"; }
kzgiol() { \kubectl --namespace=kube-system get ingress -o=wide -l "$@"; }
kzgij() { \kubectl --namespace=kube-system get ingress -o=json "$@"; }
kzgiw() { \kubectl --namespace=kube-system get ingress --watch "$@"; }
kzgiy() { \kubectl --namespace=kube-system get ingress -o=yaml "$@"; }
kzgijl() { \kubectl --namespace=kube-system get ingress -o=json -l "$@"; }
kzgiwj() { \kubectl --namespace=kube-system get ingress --watch -o=json "$@"; }
kzgiwl() { \kubectl --namespace=kube-system get ingress --watch -l "$@"; }
kzgiwo() { \kubectl --namespace=kube-system get ingress --watch -o=wide "$@"; }
kzgiwy() { \kubectl --namespace=kube-system get ingress --watch -o=yaml "$@"; }
kzgiyl() { \kubectl --namespace=kube-system get ingress -o=yaml -l "$@"; }
kzgiwjl() { \kubectl --namespace=kube-system get ingress --watch -o=json -l "$@"; }
kzgiwol() { \kubectl --namespace=kube-system get ingress --watch -o=wide -l "$@"; }
kzgiwyl() { \kubectl --namespace=kube-system get ingress --watch -o=yaml -l "$@"; }
kzgc() { \kubectl --namespace=kube-system get configmap "$@"; }
kzgcl() { \kubectl --namespace=kube-system get configmap -l "$@"; }
kzgco() { \kubectl --namespace=kube-system get configmap -o=wide "$@"; }
kzgcol() { \kubectl --namespace=kube-system get configmap -o=wide -l "$@"; }
kzgcj() { \kubectl --namespace=kube-system get configmap -o=json "$@"; }
kzgcw() { \kubectl --namespace=kube-system get configmap --watch "$@"; }
kzgcy() { \kubectl --namespace=kube-system get configmap -o=yaml "$@"; }
kzgcjl() { \kubectl --namespace=kube-system get configmap -o=json -l "$@"; }
kzgcwj() { \kubectl --namespace=kube-system get configmap --watch -o=json "$@"; }
kzgcwl() { \kubectl --namespace=kube-system get configmap --watch -l "$@"; }
kzgcwo() { \kubectl --namespace=kube-system get configmap --watch -o=wide "$@"; }
kzgcwy() { \kubectl --namespace=kube-system get configmap --watch -o=yaml "$@"; }
kzgcyl() { \kubectl --namespace=kube-system get configmap -o=yaml -l "$@"; }
kzgcwjl() { \kubectl --namespace=kube-system get configmap --watch -o=json -l "$@"; }
kzgcwol() { \kubectl --namespace=kube-system get configmap --watch -o=wide -l "$@"; }
kzgcwyl() { \kubectl --namespace=kube-system get configmap --watch -o=yaml -l "$@"; }
kzgse() { \kubectl --namespace=kube-system get secret "$@"; }
kzgsel() { \kubectl --namespace=kube-system get secret -l "$@"; }
kzgseo() { \kubectl --namespace=kube-system get secret -o=wide "$@"; }
kzgseol() { \kubectl --namespace=kube-system get secret -o=wide -l "$@"; }
kzgsej() { \kubectl --namespace=kube-system get secret -o=json "$@"; }
kzgsew() { \kubectl --namespace=kube-system get secret --watch "$@"; }
kzgsey() { \kubectl --namespace=kube-system get secret -o=yaml "$@"; }
kzgsejl() { \kubectl --namespace=kube-system get secret -o=json -l "$@"; }
kzgsewj() { \kubectl --namespace=kube-system get secret --watch -o=json "$@"; }
kzgsewl() { \kubectl --namespace=kube-system get secret --watch -l "$@"; }
kzgsewo() { \kubectl --namespace=kube-system get secret --watch -o=wide "$@"; }
kzgsewy() { \kubectl --namespace=kube-system get secret --watch -o=yaml "$@"; }
kzgseyl() { \kubectl --namespace=kube-system get secret -o=yaml -l "$@"; }
kzgsewjl() { \kubectl --namespace=kube-system get secret --watch -o=json -l "$@"; }
kzgsewol() { \kubectl --namespace=kube-system get secret --watch -o=wide -l "$@"; }
kzgsewyl() { \kubectl --namespace=kube-system get secret --watch -o=yaml -l "$@"; }
kzd() { \kubectl --namespace=kube-system describe "$@"; }
kzdl() { \kubectl --namespace=kube-system describe -l "$@"; }
kzdp() { \kubectl --namespace=kube-system describe pods "$@"; }
kzdpl() { \kubectl --namespace=kube-system describe pods -l "$@"; }
kzdde() { \kubectl --namespace=kube-system describe deployment "$@"; }
kzddel() { \kubectl --namespace=kube-system describe deployment -l "$@"; }
kzdsv() { \kubectl --namespace=kube-system describe service "$@"; }
kzdsvl() { \kubectl --namespace=kube-system describe service -l "$@"; }
kzdi() { \kubectl --namespace=kube-system describe ingress "$@"; }
kzdil() { \kubectl --namespace=kube-system describe ingress -l "$@"; }
kzdc() { \kubectl --namespace=kube-system describe configmap "$@"; }
kzdcl() { \kubectl --namespace=kube-system describe configmap -l "$@"; }
kzdse() { \kubectl --namespace=kube-system describe secret "$@"; }
kzdsel() { \kubectl --namespace=kube-system describe secret -l "$@"; }
kzx() { \kubectl --namespace=kube-system delete "$@"; }
kzxl() { \kubectl --namespace=kube-system delete -l "$@"; }
kzxaa() { \kubectl --namespace=kube-system delete --all "$@"; }
kzxp() { \kubectl --namespace=kube-system delete pods "$@"; }
kzxpl() { \kubectl --namespace=kube-system delete pods -l "$@"; }
kzxpaa() { \kubectl --namespace=kube-system delete pods --all "$@"; }
kzxde() { \kubectl --namespace=kube-system delete deployment "$@"; }
kzxdel() { \kubectl --namespace=kube-system delete deployment -l "$@"; }
kzxdeaa() { \kubectl --namespace=kube-system delete deployment --all "$@"; }
kzxsv() { \kubectl --namespace=kube-system delete service "$@"; }
kzxsvl() { \kubectl --namespace=kube-system delete service -l "$@"; }
kzxsvaa() { \kubectl --namespace=kube-system delete service --all "$@"; }
kzxi() { \kubectl --namespace=kube-system delete ingress "$@"; }
kzxil() { \kubectl --namespace=kube-system delete ingress -l "$@"; }
kzxiaa() { \kubectl --namespace=kube-system delete ingress --all "$@"; }
kzxc() { \kubectl --namespace=kube-system delete configmap "$@"; }
kzxcl() { \kubectl --namespace=kube-system delete configmap -l "$@"; }
kzxcaa() { \kubectl --namespace=kube-system delete configmap --all "$@"; }
kzxse() { \kubectl --namespace=kube-system delete secret "$@"; }
kzxsel() { \kubectl --namespace=kube-system delete secret -l "$@"; }
kzxseaa() { \kubectl --namespace=kube-system delete secret --all "$@"; }
