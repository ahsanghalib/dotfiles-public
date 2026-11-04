# Dotfiles

Linux desktop and development configurations. Pick the parts you want and
adjust them for your machine. There is no all-in-one installer, so existing
settings are not replaced automatically.

## Install a configuration

Clone the repository, open a terminal in its root, and back up any existing
configuration directory before creating a symlink. Run only the commands for
the applications you use. Each command assumes its destination does not
already exist.

### Alacritty

```sh
mkdir -p "$HOME/.config"
ln -s "$PWD/alacritty" "$HOME/.config/alacritty"
```

The settings use the included Catppuccin Mocha theme and expect JetBrains Mono
Nerd Font. Install it separately from [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts),
or change the font family in the config to one already installed on your system.

### Neovim

```sh
mkdir -p "$HOME/.config"
ln -s "$PWD/nvim" "$HOME/.config/nvim"
```

Start Neovim to install the configured plugins, then follow the setup and
requirements in [`nvim/README.md`](nvim/README.md). The configuration targets
Neovim 0.12 or newer.

### Niri

```sh
mkdir -p "$HOME/.config"
ln -s "$PWD/niri" "$HOME/.config/niri"
```

Edit the output names in `niri/config.kdl` to match your displays before
starting Niri.

### Tmux

Tmux reads `~/.tmux.conf` by default. This setup also uses the XDG path when
reloading the config, so link it at both locations:

```sh
mkdir -p "$HOME/.config/tmux"
ln -s "$PWD/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
ln -s "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
```

The config expects Zsh, Alacritty, and the plugins listed in `tmux/tmux.conf`.
It starts TPM from `/usr/share/tmux-plugin-manager/tpm`; if TPM is installed
elsewhere, change that path at the end of the config. After installing TPM,
press the Tmux prefix followed by `I` to install the listed plugins.

### Zed

```sh
mkdir -p "$HOME/.config"
ln -s "$PWD/zed" "$HOME/.config/zed"
```

### Doom Emacs

Install Emacs and Git, then run this from the repository root:

```sh
bash doom/bootstrap.sh
```

The script links the Doom config and synchronizes its packages. It installs
Doom core when needed; see [`doom/docs.md`](doom/docs.md) for details. The
optional [`doom/install-dependencies.sh`](doom/install-dependencies.sh) is for
Arch Linux and installs system packages.

## Optional helper commands

To make the helper scripts available on your `PATH`, create `~/.local/bin` and
link only the commands you want. Check that the destination names are free
first:

```sh
mkdir -p "$HOME/.local/bin"
ln -s "$PWD/bin/crypt-file" "$HOME/.local/bin/crypt-file"
ln -s "$PWD/bin/crypt-folder" "$HOME/.local/bin/crypt-folder"
ln -s "$PWD/bin/tmux-sessionizer" "$HOME/.local/bin/tmux-sessionizer"
ln -s "$PWD/niri/bin/niri-outputs" "$HOME/.local/bin/niri-outputs"
```

`crypt-file` uses GPG. `crypt-folder` uses gocryptfs and may request elevated
privileges to install it through your system package manager if missing.
`tmux-sessionizer` requires `fzf` and
the `dev-session` command; set `CODE_ROOTS` to choose where it searches for Git
repositories. `niri-outputs` requires Niri, `jq`, and `fuzzel`.

`reset-nvim.sh` is not an installer: it deletes Neovim's local plugin, state,
and cache directories. Read the script before running it.

## Fonts and third-party software

Font binaries and copied plugin/reference sources are not included. Tmux
plugins are fetched by TPM. The root MIT license applies to this repository's
original material only.
