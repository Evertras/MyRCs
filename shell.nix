# Basic nix shell to bring along some common stuff to use in non-NixOS places
# Experimental...
let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in

pkgs.mkShell {
  packages = with pkgs; [
    git
    neovim
    starship
    which
  ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  shellHook = ''
    source ~/.bashrc
  '';
}
