#!/usr/bin/env bash

set -e

# Contains various things that I want in Ubuntu... ideally this
# can be run from a fresh install and get me mostly where I want to go.
# It should always be safe to run this any number of times, and avoid
# unintentionally upgrading anything

sudo apt update

# Common place to run custom-built things from to avoid more global installs
mkdir -p ~/bin

# Installs the myriad of dependencies required to build Python,
# so that we can install it with asdf or pyenv
sudo apt install -y --no-upgrade build-essential libncursesw5-dev libreadline-gplv2-dev libssl-dev libgdbm-dev libc6-dev libsqlite3-dev libbz2-dev libffi-dev

read -p "Install desktop environment? [y\n] " desktop

if [[ "${desktop}" =~ ^[Yy]$ ]]; then
  # Rust (mostly for Alacritty)
  if ! type cargo; then
    echo "DO NOT MODIFY BASHRC/PROFILE (or fix them later if you did)"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    reloadbash
  fi

  # Desktop environment with i3
  if ! type i3; then
    # i3 in Ubuntu 20.04 is old and doesn't support include, so just get latest
    rm -rf ~/.evertras/store/i3
    mkdir -p ~/.evertras/store/i3
    pushd ~/.evertras/store/i3
      # https://i3wm.org/docs/repositories.html
      /usr/lib/apt/apt-helper download-file https://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2023.02.18_all.deb keyring.deb SHA256:a511ac5f10cd811f8a4ca44d665f2fa1add7a9f09bef238cdfad8461f5239cc4
      sudo apt install ./keyring.deb
      echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
      sudo apt update
      sudo apt install i3
    popd
    rm -rf ~/.evertras/store/i3
  fi

  if ! type dmenu; then
    sudo apt install -y dmenu
  fi

  if ! type picom; then
    # https://github.com/yshui/picom#build
    sudo apt install -y libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev
    rm -rf ~/.evertras/store/picom
    mkdir -p ~/.evertras/store/picom
    pushd ~/.evertras/store/picom
      git clone https://github.com/yshui/picom
      cd picom

      echo "Running meson setup"
      meson setup --buildtype=release build
      echo "Running ninja build"
      ninja -C build
      echo "Installing picom to ~/bin/picom"
      mv build/src/picom ~/bin/picom
    popd
    rm -rf ~/.evertras/store/picom
  fi

  # Alacritty as the standard terminal
  if ! type alacritty; then
    # https://github.com/alacritty/alacritty/blob/master/INSTALL.md#dependencies
    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
    cargo install alacritty
  fi

  # Wezterm as an alternative
  if ! flatpak list | grep org.wezfurlong.wezterm &>/dev/null; then
    flatpak install flathub org.wezfurlong.wezterm
  fi

  # Kitty as an alternative
  if ! type kitty; then
    rm -rf ~/.evertras/store/kitty.app
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin dest=~/.evertras/store launch=n
    ln -s ~/.evertras/store/kitty.app/bin/kitty ~/bin/kitty
    ln -s ~/.evertras/store/kitty.app/bin/kitten ~/bin/kitten
  fi
fi

# Neovim
if ! type nvim; then
  echo "Installing Neovim from source"
  # The apt package is very old, we want latest so we build from source
  # Need this for GLIBCXX_3.4.29
  if [ ! -f /etc/apt/sources.list.d/ubuntu-toolchain-r-ubuntu-test-focal.list ]; then
    sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
    sudo apt update
  fi
  sudo apt install -y g++-11
  # https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
  sudo apt install -y ninja-build gettext cmake unzip curl
  rm -rf ~/.evertras/store/nvim
  mkdir -p ~/.evertras/store/nvim
  pushd ~/.evertras/store/nvim
    git clone https://github.com/neovim/neovim
    pushd neovim
      # Latest has had some strange behavior in the past, so pin here
      git checkout v0.9.4
      make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=~/.evertras/store/nvim"
      make install
    popd
    # Get rid of the giant git repo
    rm -rf ~/.evertras/store/nvim/neovim
    # Need to keep .evertras/store/nvim around for dependencies, so just link to make that explicit
    ln -s ~/.evertras/store/nvim/bin/nvim ~/bin/nvim
  popd
fi

# Direnv
if ! type direnv; then
  sudo apt install -y direnv
fi

# Used to using ag for searching
if ! type ag; then
  sudo apt install -y silversearcher-ag
fi

# jq/fx for json
if ! type jq; then
  sudo apt install -y jq
fi

if ! type fx; then
  fx_version=31.0.0
  curl -Lo ~/bin/fx "https://github.com/antonmedv/fx/releases/download/${fx_vesion}/fx_linux_amd64"
  chmod +x ~/bin/fx
fi

# Ripgrep is used by a Neovim plugin
if ! type rg; then
  sudo apt install -y ripgrep
fi

# Tmux + tmuxinator
if ! type tmux; then
  sudo apt install -y tmux
fi

if ! type tmuxinator; then
  sudo apt install -y tmuxinator
fi

# asdf
if ! type asdf; then
  # https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
fi

# Starship
if ! type starship; then
  curl -sS https://starship.rs/install.sh | sh
fi

# fzf
if ! type fzf; then
  # Get later version than what's in apt
  pushd ~/bin
    echo "Installing fzf to ~/bin"
    curl -L https://github.com/junegunn/fzf/releases/download/0.44.1/fzf-0.44.1-linux_amd64.tar.gz | tar -xz
  popd
fi

# entr
if ! type entr; then
  rm -rf ~/.evertras/store/entr
  mkdir -p ~/.evertras/store/entr
  pushd ~/.evertras/store/entr
    git clone https://github.com/eradman/entr build
    pushd build
      ./configure
      make test
      make install DESTDIR=~/.evertras/store/entr
      ln -s ~/.evertras/store/entr/usr/local/bin/entr ~/bin/entr
    popd
    rm -rf build
  popd
fi

echo ""
echo "Done! You may need to restart for any major installs to take effect."
