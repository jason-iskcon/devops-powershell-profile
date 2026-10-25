# Tab completion for the k aliases in zsh.
#
# Each alias runs kubectl with fixed arguments (kgp is "kubectl get pods"), so completing
# "kgp <TAB>" has to behave like completing "kubectl get pods <TAB>". This rewrites the
# command line to that form and hands it to kubectl's own completion (_kubectl), which is
# loaded the first time it is needed. So flags, flag values, resource names and --namespace
# handling all come from kubectl, and the aliases cost nothing at shell start-up.
#
# Source k-aliases.sh and k-completion-data.sh first (k-init.zsh does).

_k_complete() {
    local -a __k_implicit
    __k_implicit_args "$words[1]" || return 0

    if (( ! $+functions[_kubectl] )); then
        (( $+commands[kubectl] )) || return 0
        source <(kubectl completion zsh 2>/dev/null) || return 0
        (( $+functions[_kubectl] )) || return 0
    fi

    # kgp <TAB> -> kubectl get pods <TAB>
    words=(kubectl $__k_implicit "${(@)words[2,-1]}")
    (( CURRENT += $#__k_implicit ))

    _kubectl
}

__k_register_completion() {
    compdef _k_complete "${__k_names[@]}"
}

if (( $+functions[compdef] )); then
    __k_register_completion
else
    # compinit has not run yet (the rc file usually calls it after us). Register on the first
    # prompt rather than running compinit ourselves, which would slow down start-up twice.
    autoload -Uz add-zsh-hook
    __k_register_completion_once() {
        (( $+functions[compdef] )) || return 0
        __k_register_completion
        add-zsh-hook -d precmd __k_register_completion_once
        unfunction __k_register_completion_once
    }
    add-zsh-hook precmd __k_register_completion_once
fi
