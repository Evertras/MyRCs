#!/bin/bash -e

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

if [ -f /etc/nix/configuration.nix ] && [ ! -L /etc/nix/configuration.nix ]; then
  read -p "Link nix configuration to /etc/nix/configuration.nix? [y/n] " -n 1 -r
  echo ""

  if [[ ! REPLY =~ ^[Yy]$ ]]; then
    echo "Backing up old configuration.nix to /etc/nix/old-config.nix"
    sudo cp /etc/nix/configuration.nix /etc/nix/old-config.nix
    echo "Linking ./nix/configuration.nix -> /etc/nix/configuration.nix"
    sudo rm /etc/nix/configuration.nix
    sudo ln -s ./nix/configuration.nix /etc/nix/configuration.nix
  fi
fi
