{ inputs, pkgs, ... }:

{
  imports = [
    inputs.anyrun.homeManagerModules.anyrun
  ];

  programs.anyrun.enable = true;
  programs.anyrun.config = {
    plugins = [
      inputs.anyrun.packages.${pkgs.system}.applications
    ];
    closeOnClick = true;
  };
}
