#!/usr/bin/env bash
set -euo pipefail

# Install system dependencies used by the Doom configuration on Arch Linux.
# This intentionally does not use --needed: requested packages are installed
# again even when the same version is already present.
#
# Run as a normal user when yay is installed:
#   bash doom/install-dependencies.sh
#
# Without yay, run this script as root so pacman can install official packages:
#   sudo bash doom/install-dependencies.sh
# The script itself never invokes sudo.

if ! command -v pacman >/dev/null 2>&1; then
  printf '%s\n' 'This installer requires pacman and is intended for Arch Linux.' >&2
  exit 1
fi

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

repo_packages=(
  base-devel
  emacs
  ttf-fira-code
  ttf-fira-sans
  noto-fonts-emoji
  git
  ripgrep
  fd
  tree-sitter-cli
  curl
  wget
  unzip
  tar
  jq
  sqlite
  libxml2
  make
  cmake
  aspell
  aspell-en
  gnuplot
  imagemagick
  xclip
  wl-clipboard
  gcc
  clang
  gdb
  nodejs
  npm
  deno
  typescript
  typescript-language-server
  eslint
  prettier
  python
  python-pip
  python-pytest
  ruff
  uv
  go
  gopls
  go-tools
  rust
  rust-analyzer
  dart
  elixir
  erlang
  rebar3
  php
  composer
  ocaml
  opam
  dune
  zig
  dotnet-sdk
  jdk-openjdk
  kotlin
  ktlint
  maven
  gradle
  shellcheck
  shfmt
  docker
  docker-compose
  hunspell
  hunspell-en_us
  pandoc-cli
  plantuml
  graphviz
  tflint
  terraform
  taplo-cli
  tombi
  marksman
  lua-language-server
  stylua
  bash-language-server
  dockerfile-language-server
  yaml-language-server
  vscode-css-languageserver
  vscode-html-languageserver
  vscode-json-languageserver
  vue-language-server
  svelte-language-server
  tidy
  markdownlint-cli2
  android-tools
)

# These are current AUR package names for servers and Android SDK components
# that are not in the official repositories. They are only installed when yay
# is available. Review AUR build prompts before accepting them.
aur_packages=(
  basedpyright
  jdtls
  kotlin-language-server
  omnisharp-roslyn
  terraform-ls-bin
  android-sdk-cmdline-tools-latest
  android-sdk-build-tools
  android-platform
  flutter
)

if (( EUID == 0 )); then
  pacman -S "${repo_packages[@]}"
  printf '%s\n' 'Running as root: skipping AUR packages because yay must not run as root.'
  printf '%s\n' 'Install yay, then rerun this script as your normal user for AUR packages.'
elif command -v yay >/dev/null 2>&1; then
  yay -S "${repo_packages[@]}" "${aur_packages[@]}"
else
  printf '%s\n' 'yay was not found; installing official repository packages with pacman requires root.' >&2
  printf '%s\n' 'Install yay, or rerun as root: sudo bash doom/install-dependencies.sh' >&2
  exit 1
fi

cat <<EOF

System packages are installed. Project-local setup is still required:

  Doom:
    bash "$script_dir/bootstrap.sh"

  Python/Jupyter:
    uv add --dev basedpyright ruff pytest jupyter ipykernel

  Node/React/React Native:
    npm ci

  Android:
    accept SDK licenses and install the SDK platform/build-tools versions
    required by each project's gradlew wrapper.

  Codex/OpenCode:
    install the upstream CLIs separately and ensure both commands are on PATH.

The installer does not install credentials, project dependencies, or React
Native packages globally. bootstrap.sh installs Doom itself when needed.
Review AUR prompts before accepting them.
EOF
