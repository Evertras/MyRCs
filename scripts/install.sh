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
