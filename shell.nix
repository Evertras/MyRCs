# Basic nix shell to bring along some common stuff to use in non-NixOS places
# Do not run with --pure, use NixOS instead.  This is an overlay with some tools
# and used as a sandbox for now.
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

    # Terminal stuff
    fx
    fzf
    jq
    silver-searcher

    # Networking stuff
    sipcalc

    # AWS stuff
    awscli2
    ssm-session-manager-plugin
  ];

  LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";

  shellHook = ''
    # Not technically 'pure' but I really like my bashrc
    source ~/.bashrc
  '';
}
