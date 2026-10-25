# Source this from ~/.zshrc (posix/install.sh adds the line for you).
# Defines the k aliases as functions and, in interactive shells, their tab completion.

__k_dir=${${(%):-%x}:A:h}
source "$__k_dir/k-aliases.sh"
if [[ -o interactive ]]; then
    source "$__k_dir/k-completion-data.sh"
    source "$__k_dir/k-completion.zsh"
fi
unset __k_dir
