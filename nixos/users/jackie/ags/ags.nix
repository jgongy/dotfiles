{ inputs, pkgs, ... }:

{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    esbuild
    gtk3
  ];

  programs.ags = {
    enable = true;
    configDir = ../ags;
  };
}
