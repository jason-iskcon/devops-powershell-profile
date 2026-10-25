# Tab completion for the k aliases in bash.
#
# Each alias runs kubectl with fixed arguments (kgp is "kubectl get pods"), so completing
# "kgp <TAB>" has to behave like completing "kubectl get pods <TAB>". This rewrites the
# command line to that form and hands it to kubectl's own completion, which is loaded the
# first time it is needed. So flags, flag values, resource names and --namespace handling
# all come from kubectl, and the aliases cost nothing at shell start-up.
#
# Needs bash 4.1+ and the bash-completion package (v2), as kubectl's own completion does.
# Source k-aliases.sh and k-completion-data.sh first (k-init.bash does).

__k_complete() {
    local name=${COMP_WORDS[0]}
    local -a __k_implicit=()
    __k_implicit_args "$name" || return 0

    if ! declare -F __start_kubectl >/dev/null 2>&1; then
        command -v kubectl >/dev/null 2>&1 || return 0
        # shellcheck disable=SC1090  # kubectl's own generated completion script
        source <(kubectl completion bash 2>/dev/null) || return 0
        declare -F __start_kubectl >/dev/null 2>&1 || return 0
    fi

    # "<spaces>kgp rest" -> "<spaces>kubectl get pods rest", keeping the cursor in place.
    local lead=${COMP_LINE%%[![:space:]]*}
    local rest=${COMP_LINE:${#lead}+${#name}}
    local prefix=kubectl
    [[ ${#__k_implicit[@]} -gt 0 ]] && prefix+=" ${__k_implicit[*]}"
    COMP_POINT=$((COMP_POINT - ${#name} + ${#prefix}))
    COMP_LINE=$lead$prefix$rest
    COMP_WORDS=(kubectl "${__k_implicit[@]}" "${COMP_WORDS[@]:1}")
    COMP_CWORD=$((COMP_CWORD + ${#__k_implicit[@]}))

    # kubectl's script needs bash-completion's helper functions; if that package is not loaded
    # in this shell, do nothing rather than print "command not found" on every Tab.
    __start_kubectl 2>/dev/null
}

# shellcheck disable=SC2154  # __k_names is defined by k-aliases.sh
if [[ $(type -t compopt) = builtin ]]; then
    complete -o default -F __k_complete "${__k_names[@]}"
else
    complete -o default -o nospace -F __k_complete "${__k_names[@]}"
fi
