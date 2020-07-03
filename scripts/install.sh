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

