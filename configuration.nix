# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.hostName = "caique";
  networking.networkmanager.enable = true;

  # Define a user account
  users.users.olivia = {
    isNormalUser = true;
    description = "Olivia";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # If you can log in without my knowledge then the sudo password probably isn't stopping you
  security.sudo.wheelNeedsPassword = false;

  # System packages
  environment.systemPackages = with pkgs; [
    git
    (pkgs.writeShellScriptBin "update-system" ''
      cd /home/olivia/.config/nix
      ${git}/bin/git pull --rebase
      sudo nixos-rebuild switch --flake .
      cd -
    '')
  ];

  # Remote access configuration
  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.logind.lidSwitch = "ignore"; # So I can keep the lid closed

  # Configure nix & nixpkgs
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
