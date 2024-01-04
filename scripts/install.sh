#!/usr/bin/env bash

set -e

cd ${0%/*}
cd ..

function link() {
	src=$(pwd)/${1}
	linkfile=${HOME}/${1}

  if [ -f "${linkfile}" ]; then
    echo "File ${linkfile} already exists, not touching"
    return
  fi

	echo "Linking ${src} -> ${linkfile}"
	ln -s ${src} ${linkfile}
}

function linkconfig() {
	src=$(pwd)/etc/${1}
	linkfile=${HOME}/.config/${1}
	dir=${linkfile%/*}

  if [ -f "${linkfile}" ]; then
    echo "File ${linkfile} already exists, not touching"
    return
  fi

	if [[ -d ${src} ]]; then
		echo "Linking dir ${src} -> ${linkfile}"
	else
		echo "Linking ${src} -> ${linkfile} in ${dir}"
	fi
	rm ${linkfile} &>/dev/null || true
	mkdir -p "${dir}"
	ln -s ${src} ${linkfile}
}

function cp-if-not-exists() {
  from="${1}"
  to="${2}"
  if [ ! -f "${to}" ]; then
    echo "Copying ${from} to ${to}"
    mkdir -p "${to%/*}"
    cp "${from}" "${to}"
  fi
}

link .asdfrc
link .bashrc
link .bash_profile
link .editorconfig
link .face
link .tmux.conf
link .wezterm.lua
link .vimrc

# Sample tmux config
if ! [[ -f ~/.tmux.local.conf ]]; then
  echo "# Custom tmux settings for this machine.  Example:

# Use homebrew's bash
#set -g default-shell /usr/local/bin/bash" > ~/.tmux.local.conf
fi

# Nvim .config
linkconfig nvim/init.lua
linkconfig nvim/lua/evertras
linkconfig nvim/after/plugin

# Starship .config
linkconfig starship.toml

# Alacritty .config
linkconfig alacritty/base.yml
linkconfig alacritty/mode-demo.base.yml
touch ~/.config/alacritty/override.yml
linkconfig alacritty/alacritty.yml
cp-if-not-exists etc/alacritty/mode-demo.base.yml ~/.config/alacritty/mode-demo.yml

# Kitty .config
linkconfig kitty/kitty.conf
mkdir -p ~/.config/kitty/kitty.d
cp-if-not-exists etc/kitty/kitty.d/override.conf ~/.config/kitty/kitty.d/override.conf

# i3 for Linux machines
linkconfig i3/config
linkconfig i3status/config
cp-if-not-exists etc/i3/machine-specific.conf ~/.config/i3/machine-specific.conf
cp-if-not-exists etc/i3/startup.sh ~/.config/i3/startup.sh

# Template for tmuxinator
cp-if-not-exists etc/tmuxinator/copyme.yml ~/.config/tmuxinator/copyme.yml

# Non-NixOS config
linkconfig nix/nix.conf

# Bootstrap neovim with Packer
if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
  echo "Installing Packer for Neovim"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

# Create a GPG key if one doesn't already exist
gpg_key=$(gpg --list-secret-keys --keyid-format=long | grep '^sec' | head -n1 | awk '{print $2}' | awk -F/ '{print $2}')
gpg_bin=$(which gpg2 || which gpg)

if [ -z "${gpg_key}" ]; then
  echo "No existing GPG key found, generating..."
  ${gpg_bin} --full-generate-key
  gpg_key=$(${gpg_bin} --list-secret-keys --keyid-format=long | grep '^sec' | head -n1 | awk '{print $2}' | awk -F/ '{print $2}')

  echo "Printing public GPG key, paste this into Github!"
  gpg --armor --export "${gpg_key}"
fi

gnupg_agent_config_file=~/.gnupg/gpg-agent.conf
nixos_config_file=/etc/nixos/configuration.nix

# TODO: Confirm this is still needed
if [ -f "${nixos_config_file}" ] && [ ! -f "${gnupg_agent_config_file}" ]; then
  mkdir -p ~/.gnupg/
  echo "Bootstrapping ~/.gnupg/gpg-agent.conf to make pinentry work with Nix"
  echo 'pinentry-program /run/current-system/sw/bin/pinentry' > "${gnupg_agent_config_file}"
fi

# Bootstrap standard .gitconfig to use our GPG key
if [ ! -f ~/.gitconfig ]; then
  echo "Creating basic ~/.gitconfig with GPG signing enabled"
  read -p "Email to use for default git commits: " git_commit_email
  echo ""
  # TODO: Check this automatically some day
  echo "Using GPG key ${gpg_key} (NOTE: this may need to be updated if using a GPG key with different email!)"
  echo "[user]
  email = ${git_commit_email}
  name = Brandon Fulljames
  signingkey = ${gpg_key}
[commit]
  gpgsign = true
[gpg]
  program = ${gpg_bin}
[init]
  defaultBranch = main" > ~/.gitconfig
fi

# Create an SSH key if one doesn't already exist
if [ ! -d ~/.ssh ]; then
  echo "No SSH keys found, creating one"
  read -p "Label to use for SSH key (ex: bfullj@gmail.com): " ssh_label
  ssh-keygen -t ed25519 -C "${ssh_label}"
fi

# Make sure en_US is actually installed (need this for WSL, etc)
if ! locale -a 2>/dev/null | grep en_US &>/dev/null; then
  echo "en_US locale not installed, generating..."
  sudo locale-gen en_US.UTF-8
fi
