# Basic nix shell to bring along some common stuff to use in non-NixOS places
# Experimental... meant to be run with --pure
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
  packages = with pkgs; [
    # Core important things for --pure
    cacert
    curl
    git
    gnupg
    openssh
    ps
    unzip
    which
    wget
    zip

    # Terminal stuff
    fx
    jq
    neovim
    silver-searcher
    starship
    tmux
    tmuxinator

    # Need this globally for Copilot
    nodejs_21

    # Dev stuff
    cargo
    direnv
    go
    rustc
    vagrant
  ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  # Not technically 'pure' but I really like my bashrc
  shellHook = ''
    source ~/.bashrc
  '';
}
