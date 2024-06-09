{ inputs, pkgs, ... }:

{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bun
    esbuild
    gtk3
    libnotify
  ];

  programs.ags = {
    enable = true;
    configDir = ../ags;
  };
}
