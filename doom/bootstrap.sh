#!/usr/bin/env bash
set -euo pipefail

# Recreate this Doom configuration on a new machine. This folder is the
# portable private configuration; Doom's core and compiled/package state stay
# outside it and are installed or generated locally for each machine.

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
user_home="${HOME:?HOME must be set}"
doom_user_dir="${XDG_CONFIG_HOME:-"$user_home/.config"}/doom"

if ! command -v emacs >/dev/null 2>&1; then
  printf '%s\n' 'Emacs is not installed or is not on PATH.' >&2
  exit 1
fi

if [[ -n "${EMACSDIR:-}" ]]; then
  doom_emacs_dir="$EMACSDIR"
elif [[ -x "$user_home/.config/emacs/bin/doom" ]]; then
  doom_emacs_dir="$user_home/.config/emacs"
elif [[ -x "$user_home/.emacs.d/bin/doom" ]]; then
  doom_emacs_dir="$user_home/.emacs.d"
else
  doom_emacs_dir="$user_home/.config/emacs"
fi

if [[ ! -x "$doom_emacs_dir/bin/doom" ]]; then
  if [[ -e "$doom_emacs_dir" ]]; then
    printf 'Refusing to use existing non-Doom directory: %s\n' "$doom_emacs_dir" >&2
    exit 1
  fi
  if ! command -v git >/dev/null 2>&1; then
    printf '%s\n' 'Git is required to install Doom.' >&2
    exit 1
  fi
  printf 'Installing Doom core into %s\n' "$doom_emacs_dir"
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$doom_emacs_dir"
fi

if [[ -e "$doom_user_dir" && ! -L "$doom_user_dir" ]]; then
  printf 'Refusing to replace existing non-symlink Doom config: %s\n' "$doom_user_dir" >&2
  exit 1
fi

if [[ -L "$doom_user_dir" ]]; then
  linked_dir="$(readlink -f -- "$doom_user_dir")"
  if [[ "$linked_dir" != "$script_dir" ]]; then
    printf 'Doom config symlink points to %s, expected %s\n' "$linked_dir" "$script_dir" >&2
    exit 1
  fi
else
  mkdir -p -- "$(dirname -- "$doom_user_dir")"
  ln -s -- "$script_dir" "$doom_user_dir"
fi

printf 'Syncing Doom using %s\n' "$script_dir"
env DOOMDIR="$script_dir" "$doom_emacs_dir/bin/doom" sync

cat <<EOF

Doom is ready.
  Config: $script_dir
  Core:   $doom_emacs_dir
  Start:  emacs

Org files use ~/org by default.
Set ORG_DIRECTORY to choose another location.
EOF
