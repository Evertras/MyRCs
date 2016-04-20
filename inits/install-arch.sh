#!/bin/bash

current_user=$1
home_dir = /home/${current_user}

yell() { echo "$0: $@" >&2; }
die() { yell "$@"; exit 111; }
try() { "$@" || die "cannot $@"; }

# ========================
# Update all packages
try pacman -Syyu --noconfirm

# ========================
# Util
try pacman -S --noconfirm zip unzip

# ========================
# i3 window manager
try pacman -S --noconfirm xorg-xinit
try pacman -S --noconfirm st
try pacman -S --noconfirm i3-wm dmenu i3status gtk-engine-murrine

# ========================
# Python package manager (pip) and Fabric
try pacman -S --noconfirm python2-pip
try pip2 install fabric

# ========================
# Docker
try pacman -S --noconfirm docker
try systemctl start docker
try systemctl enable docker

# ========================
# Node
try pacman -S --noconfirm nodejs npm

# ========================
# Fluff
try npm install -g i3-style
try i3-style deep-purple -o ${home_dir}/.config/i3/config

pushd /tmp
  try wget https://aur.archlinux.org/cgit/aur.git/snapshot/gtk-theme-arc.tar.gz
  try tar -zxf gtk-theme-arc.tar.gz
  try pushd gtk-theme-arc
    try makepkg -s
    try pacman -U gtk-theme-arc*.pkg.tar.xz
  popd
popd

# ========================
# VIM customization
pushd ${home_dir}
  try cp ../{bash,vim}rc ${home_dir}
  try git clone https://github.com/VundleVim/Vundle.vim.git .vim/bundle/Vundle.vim
  try mkdir ${home_dir}/.vim/colors
  pushd .vim/colors
    try wget https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim
  popd
popd

# ========================
# Sublime Text
try pacman -S --noconfirm sublime-text-dev

# ========================
# Cleanup
chown -R ${current_user} ${home_dir}