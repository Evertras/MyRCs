# Basic nix shell to bring along some common stuff to use in non-NixOS places
# Experimental... meant to be run with --pure
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
  # Things used at runtime
  buildInputs = with pkgs; [
    gcc
    glibc
    libffi
    libstdcxx5
    openssl.dev
    pkg-config
    readline
    zlib.dev
  ];

  packages = with pkgs; [
    # Helpful for debugging
    # Usage example:
    #  nix-index
    #  nix-locate sys_errlist.h
    nix-index

    # Core important things for --pure
    cacert
    curl
    git
    gnupg
    openssh
    ps
    unixtools.column
    unzip
    which
    wget
    zip

    # Terminal stuff
    fx
    jq
    neovim
    ripgrep
    silver-searcher
    starship
    tmux
    tmuxinator

    # Networking stuff
    sipcalc

    # Dev stuff
    asdf-vm
    cargo
    direnv
    go
    rustc
    vagrant

    # AWS stuff
    awscli2
    ssm-session-manager-plugin
  ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  shellHook = ''
    source ${pkgs.asdf-vm}/etc/profile.d/asdf-prepare.sh
    # Not technically 'pure' but I really like my bashrc
    source ~/.bashrc
  '';
}
