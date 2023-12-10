# Basic nix shell to bring along some common stuff to use in non-NixOS places
# Experimental... meant to be run with --pure
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
  packages = with pkgs; [
    # Core important things for --pure
    git
    openssh
    which

    # General stuff
    neovim
    starship
  ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  shellHook = ''
    source ~/.bashrc
  '';
}
