#!/usr/bin/env bash

set -e

cd ${0%/*}
cd ..

function link() {
	src=$(pwd)/${1}
	linkfile=${HOME}/${1}

	echo "Linking ${src} -> ${linkfile}"
	rm ${linkfile} &>/dev/null || true
	ln -s ${src} ${linkfile}
}

function linkconfig() {
	src=$(pwd)/etc/${1}
	linkfile=${HOME}/.config/${1}
	dir=${linkfile%/*}

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
link .tmux.conf
link .tool-versions
link .vimrc
link shell.nix

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

# Starship config
linkconfig starship.toml

# Alacritty .config
linkconfig alacritty/base.yml
linkconfig alacritty/mode-demo.base.yml
touch ~/.config/alacritty/override.yml
linkconfig alacritty/alacritty.yml
cp-if-not-exists etc/alacritty/mode-demo.base.yml ~/.config/alacritty/mode-demo.yml

# i3 for Linux machines
linkconfig i3/config
cp-if-not-exists etc/i3/machine-specific.conf ~/.config/i3/machine-specific.conf
cp-if-not-exists etc/i3/startup.sh ~/.config/i3/startup.sh

# Template for tmuxinator
cp-if-not-exists etc/tmuxinator/copyme.yml ~/.config/tmuxinator/copyme.yml

# Bootstrap neovim with Packer
if [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]; then
  echo "Installing Packer for Neovim"
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

# NixOS madness
nixos_config_file=/etc/nixos/configuration.nix

if [ -f "${nixos_config_file}" ]; then
  read -p "Link nix configuration to ${nixos_config_file}? [y/n] " -n 1 -r
  echo ""

  if [[ ! REPLY =~ ^[Yy]$ ]]; then

    if [ ! -f "/etc/nixos/passwords/evertras" ]; then
      sudo mkdir -p /etc/nixos/passwords/
      while [ "${password}" != "${password_confirm}" ] && [ -n "${password}" ]; do
        read -s -p "Set evertras password: " password
        echo ""
        read -s -p "Confirm evertras password: " password_confirm
        echo ""
      done
      mkpasswd "${password}" | sudo tee /etc/nixos/passwords/evertras
      sudo chmod 0600 /etc/nixos/passwords/evertras
    fi

    echo "Backing up old configuration.nix to /etc/nixos/old-config.nix"
    sudo cp "${nixos_config_file}" /etc/nixos/old-config.nix
    echo "Linking ./nix/configuration.nix -> ${nixos_config_file}"
    sudo rm -f "${nixos_config_file}"
    sudo ln -s $(pwd)/nix/configuration.nix "${nixos_config_file}"

    echo "Switching..."
    sudo nixos-rebuild switch
  fi
fi

gnupg_agent_config_file=~/.gnupg/gpg-agent.conf

if [ -f "${nixos_config_file}" ] && [ ! -f "${gnupg_agent_config_file}" ]; then
  echo "Bootstrapping ~/.gnupg/gpg-agent.conf to make pinentry work with Nix"
  echo 'pinentry-program /run/current-system/sw/bin/pinentry' > "${gnupg_agent_config_file}"
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

# Bootstrap standard .gitconfig to use our GPG key
if [ ! -f ~/.gitconfig ]; then
  echo "Creating basic ~/.gitconfig with GPG signing enabled"
  echo "Using GPG key ${gpg_key}"
  echo "[user]
  email = bfullj@gmail.com
  name = Brandon Fulljames
  signingkey = ${gpg_key}
[commit]
  gpgsign = true
[gpg]
  program = ${gpg_bin}" > ~/.gitconfig
fi

# Make sure en_US is actually installed (need this for WSL, etc)
if ! locale -a 2>/dev/null | grep en_US &>/dev/null; then
  echo "en_US locale not installed, generating..."
  sudo locale-gen en_US.UTF-8
fi
