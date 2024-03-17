{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./vim.nix
    ./bash/bash.nix
    ./wezterm/wezterm.nix
    ./anyrun/anyrun.nix
    ./theme.nix
    ./ags/ags.nix
    ./coding.nix
  ];

  nixpkgs = {};

  home = {
    username = "jackie";
    homeDirectory = "/home/jackie";
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.shellAliases = {
    "systemctl" = "systemctl --no-pager --full";
  };

  home.packages = with pkgs; [
    firefox
  ];

  programs.home-manager.enable = true;

  # systemd.user.services = {
  #   home-manager-restore = {
  #     Unit = {
  #       Description = "Restore settings with home-manager";
  #     };
  #     Install = {
  #       WantedBy = "default.target";
  #     };
  #     Service = {
  #       Environment = "PATH=/run/current-system/sw/bin";
  #       ExecStart = "home-manager switch --flake /etc/nixos#jackie@gong-nix";
  #       Type = "oneshot";
  #     };
  #   };
  # };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
