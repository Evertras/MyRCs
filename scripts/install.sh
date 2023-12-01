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

link .bashrc
link .tmux.conf
link .vimrc

mkdir -p ~/.bashrc.d/themes

# Sample tmux config
if ! [[ -f ~/.tmux.local.conf ]]; then
  echo "# Custom tmux settings for this machine.  Example:

# Use homebrew's bash
#set -g default-shell /usr/local/bin/bash" > ~/.tmux.local.conf
fi

# Link all our themes
for SRCFILE in ./.bashrc.d/themes/*; do
	if [[ -f ${SRCFILE} ]]; then
		THEME_FILE=.bashrc.d/themes/${SRCFILE##*/}
		link ${THEME_FILE}
	fi
done

# Helix .config
linkconfig helix/config.toml

# Nvim .config
linkconfig nvim/init.lua
linkconfig nvim/lua/evertras
linkconfig nvim/after/plugin

# Alacritty .config
linkconfig alacritty/base.yml
linkconfig alacritty/mode-demo.base.yml
touch ~/.config/alacritty/override.yml
linkconfig alacritty/alacritty.yml

if [ ! -f ~/.config/alacritty/mode-demo.yml ]; then
  echo "Copying Alacritty mode-demo.base.yml into mode-demo.yml"
  cp etc/alacritty/mode-demo.base.yml ~/.config/alacritty/mode-demo.yml
fi

nixos_config_file=/etc/nixos/configuration.nix

if [ -f "${nixos_config_file}" ] && [ ! -L "${nixos_config_file}" ]; then
  read -p "Link nix configuration to ${nixos_config_file}? [y/n] " -n 1 -r
  echo ""

  if [[ ! REPLY =~ ^[Yy]$ ]]; then
    echo "Enter password: "
    read -s password
    hashed=$(mkpasswod "${password}")
    sudo echo "{
  passwords = {
    evertras = "'"'"${hashed}"'"'";
  };
}" > /etc/nixos/passwords.nix
    echo "Backing up old configuration.nix to /etc/nixos/old-config.nix"
    sudo cp "${nixos_config_file}" /etc/nixos/old-config.nix
    echo "Linking ./nix/configuration.nix -> ${nixos_config_file}"
    sudo rm "${nixos_config_file}"
    sudo ln -s ./nix/configuration.nix "${nixos_config_file}"
  fi
fi
