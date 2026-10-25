# Source this from ~/.bashrc (posix/install.sh adds the line for you).
# Defines the k aliases as functions and, in interactive shells, their tab completion.

__k_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd) || return
# shellcheck source=posix/k-aliases.sh
. "$__k_dir/k-aliases.sh"
case $- in
    *i*)
        # shellcheck source=posix/k-completion-data.sh
        . "$__k_dir/k-completion-data.sh"
        # shellcheck source=posix/k-completion.bash
        . "$__k_dir/k-completion.bash"
        ;;
esac
unset __k_dir
