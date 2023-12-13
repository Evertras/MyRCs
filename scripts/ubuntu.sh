#!/usr/bin/env bash

set -e

# Contains various things that I want in Ubuntu... ideally this
# can be run from a fresh install and get me mostly where I want to go.
# It should always be safe to run this any number of times, and avoid
# unintentionally upgrading anything

sudo apt update

# Common things
mkdir -p ~/bin

# Terminal things
if ! type tmuxinator; then
  sudo apt install -y tmuxinator
fi

# Desktop environment with i3
if ! type i3; then
  sudo apt install -y i3 dmenu
fi

if ! type picom; then
  sudo apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev
  rm -rf ~/.picom-build
  mkdir -p ~/.picom-build
  pushd ~/.picom-build
    git clone https://github.com/yshui/picom
    cd picom

    echo "Running meson setup"
    meson setup --buildtype=release build
    echo "Running ninja build"
    ninja -C build
    echo "Installing picom to ~/bin/picom"
    mv build/src/picom ~/bin/picom
  popd
  rm -rf ~/.picom-build
fi

# Rust (mostly for Alacritty)
if ! type cargo; then
  echo "DO NOT MODIFY BASHRC/PROFILE (or fix them later if you did)"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  reloadbash
fi

if ! type alacritty; then
  # https://github.com/alacritty/alacritty/blob/master/INSTALL.md#dependencies
  sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
  cargo install alacritty
fi

echo ""
echo "Done! You may need to restart for any major installs to take effect."
