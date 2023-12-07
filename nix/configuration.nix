# Sample config that was usable in virtualbox, for reference
{ config, pkgs, ... }:

# Old way that I tried first, keeping for learning nix language
#let
#  passwords = (import ./passwords.nix).passwords;
#in

{
  imports =
    [
      # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = [
    pkgs.git
    pkgs.neovim
    pkgs.tldr
    pkgs.starship
  ];

  # To run in Virtualbox
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 2;

  virtualisation.virtualbox.guest.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  # Apparently we need to do this?
  boot.initrd.checkJournalingFS = false;

  networking.hostName = "nixbox";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  users.mutableUsers = false;
  users.users.evertras = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "wheel"
    ];
    passwordFile = "/etc/nixos/passwords/evertras";
    openssh = {
      authorizedKeys = {
        keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFNyVL/vIMAq56zRxCStyWzv+/82zBQjF6jBedkEvekb"
        ];
      };
    };
    #packages = with pkgs; [];
  };

  # Live dangerously
  security.sudo.wheelNeedsPassword = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = true;
    };
  };
}
