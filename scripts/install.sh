#!/bin/bash -e

cd ${0%/*}
cd ..

function link() {
	SRC=$(pwd)/${1}
	LINKFILE=${HOME}/${1}

	echo "Linking ${SRC} -> ${LINKFILE}"
	rm ${LINKFILE} &>/dev/null || true
	ln -s ${SRC} ${LINKFILE}
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
mkdir -p ~/.config/helix/

ln -s $(pwd)/etc/helix/config.toml ${HOME}/.config/helix/config.toml
