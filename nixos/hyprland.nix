{ pkgs, ...}:

let
  flake-compat = builtins.fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    sha256 = "0m9grvfsbwmvgwaxvdzv6cmyvjnlww004gfxjvcl806ndqaxzy4j";
  };
  hyprland-flake = (import flake-compat {
    src = builtins.fetchTarball {
      url = "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
      sha256 = "0qz5jjynsf056s9alks2z3915bmypm785cap0b03j5dvhsff3nm1";
    };
  }).defaultNix;
in {
  programs.hyprland = {
    enable = true;
    package = hyprland-flake.packages.${pkgs.system}.hyprland;
  };
}
