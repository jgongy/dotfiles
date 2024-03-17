# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, lib, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./audio.nix
      ./impermanence.nix
      ./hyprland.nix
      ./users/jackie/configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi/";

  nix.registry = ( lib.mapAttrs ( _: flake: { inherit flake; })) (( lib.filterAttrs ( _: lib.isType "flake" )) inputs);

  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;

    builders-use-substitutes = true;
    substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };

  networking.hostName = "gong-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  security.sudo.extraConfig = "Defaults lecture=never";

  services.xserver = {
    enable = true;
    displayManager.sddm.enable = true;

    xkbOptions = "ctrl:nocaps";
  };

  # Set your time zone.
  time.timeZone = "US/Eastern";

  users.users.root = {
    # mkpasswd -m sha-512 "<password>" > "/persist/passwords/<user>"
    initialPassword = "password";
    hashedPasswordFile = "/persist/passwords/root";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    polkit
  ];

  # Figure out how to move this into individual configuration files
  systemd.services = {
    home-manager-jackie = {
      enable = true;
      description = "Restore settings with home-manager";
      # home-manager throws a not connected to network warning at the moment,
      # need to investigate how to run this service after the network comes
      # online. however, adding this dependency causes it to only run after
      # login, which fails because hyprland automatically creates a config
      # and home-manager currently has no configuration to overwrite existing
      # files
      # unitConfig = {
      #   After = "network-online.target";
      #   Wants = "network-online.target";
      # };
      serviceConfig = {
        Type="oneshot";
        Environment = "PATH=/run/current-system/sw/bin";
        ExecStart = [
            "/run/current-system/sw/bin/home-manager switch --flake /etc/nixos#jackie@gong-nix"
        ];
        User = "jackie";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

