#!/bin/sh
# Install or remove the K-system kubectl aliases for bash and zsh.
#
#   posix/install.sh [install] [--shell auto|bash|zsh|both] [--prefix DIR] [--dry-run]
#                    [--bashrc FILE] [--zshrc FILE]
#   posix/install.sh uninstall [same options]
#
# --shell auto uses the shell named by $SHELL (bash or zsh); it is the default for install.
# uninstall defaults to both shells.
#
# What it does, and only this:
#   * copies the shell files into a directory of their own (default
#     ${XDG_DATA_HOME:-~/.local/share}/devops-k-aliases);
#   * adds one marked block to each chosen rc file that sources them.
# It never edits anything outside that block, backs up an rc file before changing it, writes
# through symlinks (dotfile managers keep working), and does nothing when already up to date.
# "uninstall" removes the block and the copied files and nothing else.
#
# Generate the shell files first if they are missing: python3 tools/generate_aliases.py

set -eu

BEGIN='# >>> devops-k-aliases >>>'
END='# <<< devops-k-aliases <<<'
NOTE='# Managed by posix/install.sh; "install.sh uninstall" removes this block.'
MARKER=.installed-by-devops-k-aliases
FILES='k-aliases.sh k-completion-data.sh k-completion.bash k-completion.zsh k-init.bash k-init.zsh'

action=install
shell_choice=
prefix=
dry_run=0
bashrc=
zshrc=

die() { echo "install.sh: $*" >&2; exit 1; }
say() { echo "$*"; }

usage() { sed -n '2,/^$/s/^# \{0,1\}//p' "$0"; }

while [ $# -gt 0 ]; do
    case $1 in
        install|uninstall) action=$1 ;;
        --shell) [ $# -ge 2 ] || die "--shell needs a value"; shell_choice=$2; shift ;;
        --prefix) [ $# -ge 2 ] || die "--prefix needs a value"; prefix=$2; shift ;;
        --bashrc) [ $# -ge 2 ] || die "--bashrc needs a value"; bashrc=$2; shift ;;
        --zshrc) [ $# -ge 2 ] || die "--zshrc needs a value"; zshrc=$2; shift ;;
        --dry-run) dry_run=1 ;;
        -h|--help) usage; exit 0 ;;
        *) die "unknown argument: $1 (try --help)" ;;
    esac
    shift
done

[ -n "${HOME:-}" ] || die "HOME is not set"
src=$(cd "$(dirname "$0")" && pwd)
[ -n "$prefix" ] || prefix=${XDG_DATA_HOME:-$HOME/.local/share}/devops-k-aliases
bashrc=${bashrc:-$HOME/.bashrc}
zshrc=${zshrc:-${ZDOTDIR:-$HOME}/.zshrc}

# The prefix is written into an rc file inside double quotes, so refuse anything the shell
# would interpret.
case $prefix in
    /*) ;;
    *) die "--prefix must be an absolute path" ;;
esac
case $prefix in
    *[\"\$\`\\]*|*'
'*) die "--prefix must not contain quotes, \$, backticks, backslashes or newlines" ;;
esac
# shellcheck disable=SC2016  # the literal text $HOME is what goes into the rc file
case $prefix in
    "$HOME"/*) prefix_ref='$HOME'${prefix#"$HOME"} ;;
    *) prefix_ref=$prefix ;;
esac

detect_shell() { # sets $targets from $SHELL
    case ${SHELL:-} in
        */bash) targets=bash ;;
        */zsh) targets=zsh ;;
        *) die "cannot tell which shell you use (SHELL=${SHELL:-unset}); pass --shell bash, zsh or both" ;;
    esac
}

if [ -z "$shell_choice" ]; then
    if [ "$action" = uninstall ]; then shell_choice=both; else shell_choice=auto; fi
fi
case $shell_choice in
    auto) detect_shell ;;
    bash) targets="bash" ;;
    zsh) targets="zsh" ;;
    both) targets="bash zsh" ;;
    *) die "--shell must be auto, bash, zsh or both" ;;
esac

umask 077
tmp=${TMPDIR:-/tmp}/devops-k-install.$$
trap 'rm -f "$tmp".*' EXIT INT TERM

rc_path() { if [ "$1" = bash ]; then echo "$bashrc"; else echo "$zshrc"; fi; }
init_name() { echo "k-init.$1"; }

block_for() {
    printf '%s\n%s\n%s\n%s\n' "$BEGIN" "$NOTE" \
        "[ -r \"$prefix_ref/$(init_name "$1")\" ] && . \"$prefix_ref/$(init_name "$1")\"" "$END"
}

# --- rc file editing ----------------------------------------------------------------------

check_rc() { # refuse to touch a file whose markers are not exactly one begin, then one end
    [ -d "$1" ] && die "$1 is a directory"
    [ -e "$1" ] || return 0
    begins=$(grep -cxF "$BEGIN" "$1" || true)
    ends=$(grep -cxF "$END" "$1" || true)
    if [ "$begins" != "$ends" ] || [ "$begins" -gt 1 ]; then
        die "$1 has damaged $BEGIN markers ($begins begin, $ends end); fix it by hand, nothing was changed"
    fi
    if [ "$begins" = 1 ]; then
        # Counting is not enough: with the end first, replacing "from begin to end" would swallow
        # everything after the begin marker.
        begin_line=$(grep -nxF "$BEGIN" "$1" | cut -d: -f1)
        end_line=$(grep -nxF "$END" "$1" | cut -d: -f1)
        if [ "$begin_line" -ge "$end_line" ]; then
            die "$1 has damaged $BEGIN markers (the end marker is before the begin marker, so they are out of order); fix it by hand, nothing was changed"
        fi
    fi
}

has_block() { [ -e "$1" ] && grep -qxF "$BEGIN" "$1"; }

# new content for an rc file: $1 file, $2 shell, to $3
compose_install() {
    if has_block "$1"; then
        block_for "$2" > "$tmp.block"
        awk -v b="$BEGIN" -v e="$END" -v blk="$tmp.block" '
            skip { if ($0 == e) skip = 0; next }
            $0 == b { while ((getline line < blk) > 0) print line; close(blk); skip = 1; next }
            { print }' "$1" > "$3"
    else
        {
            if [ -s "$1" ]; then
                cat "$1"
                [ "$(tail -c 1 "$1" | wc -l)" -eq 0 ] && echo
                echo
            fi
            block_for "$2"
        } > "$3"
    fi
}

# the file without the block and without the one blank line install put before it
compose_uninstall() {
    awk -v b="$BEGIN" -v e="$END" '
        skip { if ($0 == e) skip = 0; next }
        $0 == b { held = 0; skip = 1; next }
        { if (held) { print ""; held = 0 }
          if ($0 == "") { held = 1; next }
          print }
        END { if (held) print "" }' "$1" > "$2"
}

# replace the contents of $1 with $2 (through symlinks), keeping a backup of the original
commit_rc() {
    if [ -e "$1" ] && cmp -s "$1" "$2"; then
        say "unchanged: $1"
        return 0
    fi
    if [ "$dry_run" = 1 ]; then
        say "would update: $1"
        return 0
    fi
    if [ -e "$1" ]; then
        # Never overwrite an earlier backup: the first one holds the file as you wrote it.
        backup=$1.k-aliases-backup-$(date +%Y%m%d%H%M%S)
        n=0
        base=$backup
        while [ -e "$backup" ]; do
            n=$((n + 1))
            backup=$base.$n
        done
        cp -p "$1" "$backup"
        say "backup: $backup"
    fi
    cat "$2" > "$1"
    say "updated: $1"
}

# --- install ------------------------------------------------------------------------------

do_install() {
    for f in $FILES; do
        [ -r "$src/$f" ] || die "$src/$f is missing; run: python3 tools/generate_aliases.py"
    done
    for t in $targets; do check_rc "$(rc_path "$t")"; done
    if [ -d "$prefix" ] && [ -n "$(ls -A "$prefix")" ] && [ ! -e "$prefix/$MARKER" ]; then
        die "$prefix exists and was not created by this installer; choose another --prefix"
    fi

    if [ "$dry_run" = 1 ]; then
        say "would copy $FILES to $prefix"
    else
        mkdir -p "$prefix"
        for f in $FILES; do
            if [ -e "$prefix/$f" ] && cmp -s "$src/$f" "$prefix/$f"; then continue; fi
            cp "$src/$f" "$prefix/$f"
            say "installed: $prefix/$f"
        done
        printf 'Installed by posix/install.sh. "install.sh uninstall" removes these files.\n' > "$prefix/$MARKER"
    fi

    for t in $targets; do
        rc=$(rc_path "$t")
        compose_install "$rc" "$t" "$tmp.new"
        commit_rc "$rc" "$tmp.new"
    done

    warn_collisions
    say "Done. Start a new shell (or source the rc file) to use the aliases."
    say "Tab completion needs kubectl on PATH; for bash it also needs bash 4.1+ and bash-completion v2."
}

warn_collisions() { # names that already resolve to a command, builtin or keyword
    names=$(sed -n '/^__k_names=(/,/^)/{/^  k/p;}' "$src/k-aliases.sh")
    clash=
    for n in $names; do
        if command -v "$n" >/dev/null 2>&1; then clash="$clash $n"; fi
    done
    if [ -n "$clash" ]; then
        say "note: these names already exist as commands; the functions will take precedence:$clash"
    fi
}

# --- uninstall ----------------------------------------------------------------------------

# The copied files are shared by bash and zsh. Succeeds, setting $user_rc, if the rc file of a
# shell we are NOT uninstalling still has a block that sources them.
prefix_in_use() {
    for other in bash zsh; do
        case " $targets " in *" $other "*) continue ;; esac
        user_rc=$(rc_path "$other")
        for t in $targets; do [ "$user_rc" = "$(rc_path "$t")" ] && continue 2; done
        if has_block "$user_rc" && grep -qF "\"$prefix_ref/$(init_name "$other")\"" "$user_rc"; then
            return 0
        fi
    done
    return 1
}

do_uninstall() {
    for t in $targets; do check_rc "$(rc_path "$t")"; done
    for t in $targets; do
        rc=$(rc_path "$t")
        if has_block "$rc"; then
            compose_uninstall "$rc" "$tmp.new"
            commit_rc "$rc" "$tmp.new"
        else
            say "no block in: $rc"
        fi
    done

    if [ ! -d "$prefix" ]; then
        say "nothing to remove at $prefix"
    elif [ ! -e "$prefix/$MARKER" ]; then
        say "left alone: $prefix was not created by this installer"
    elif prefix_in_use; then
        say "kept: $prefix is still used by $user_rc (uninstall that shell too to remove it)"
    elif [ "$dry_run" = 1 ]; then
        say "would remove the installed files from $prefix"
    else
        for f in $FILES $MARKER; do rm -f "$prefix/$f"; done
        rmdir "$prefix" 2>/dev/null || say "kept $prefix: it still contains other files"
        say "removed: $prefix"
    fi
}

"do_$action"
