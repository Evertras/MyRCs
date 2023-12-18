#!/usr/bin/env bash

set -e

# Contains various things that I want in WSL... ideally this
# can be run from a fresh install and get me mostly where I want to go.
# It should always be safe to run this any number of times, and avoid
# unintentionally upgrading anything

sudo apt update

# Common place to run custom-built things from to avoid more global installs
mkdir -p ~/bin

# Installs the myriad of dependencies required to build Python,
# so that we can install it with asdf or pyenv
#sudo apt install -y --no-upgrade build-essential libncursesw5-dev libreadline-gplv2-dev libssl-dev libgdbm-dev libc6-dev libsqlite3-dev libbz2-dev libffi-dev

# Needed for neovim treesitter yaml
sudo apt install -y g++

# Neovim
if ! type nvim; then
  echo "Building neovim from source"
  # The apt package is very old, we want latest so we build from source
  # https://github.com/neovim/neovim/wiki/Building-Neovim#build-prerequisites
  sudo apt install -y --no-upgrade ninja-build gettext cmake unzip curl
  # Needed in WSL
  sudo apt install -y nd
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
    # Need to keep .evertras/store/nvim around for dependencies, so link to make that explicit
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
  pushd ~/bin
    curl -L https://github.com/junegunn/fzf/releases/download/0.44.1/fzf-0.44.1-linux_amd64.tar.gz | tar -xz
  popd
fi

echo ""
echo "Done! You may need to restart for any major installs to take effect."
