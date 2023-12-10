# Basic nix shell to bring along some common stuff to use in non-NixOS places
# Experimental... meant to be run with --pure
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
  packages = with pkgs; [
    # Core important things for --pure
    busybox
    git
    gnupg
    openssh
    which

    # dev stuff
    neovim
    silver-searcher
    starship
    tmux
    tmuxinator

    # Need this globally for Copilot
    nodejs_21
  ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  # Not technically 'pure' but I really like my bashrc
  shellHook = ''
    source ~/.bashrc
  '';
}
