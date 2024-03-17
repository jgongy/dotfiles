{ inputs, pkgs, ... }:

{
  users.users.jackie = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ];
    hashedPasswordFile = "/persist/passwords/jackie";
  };

  environment.systemPackages = with pkgs; [
    home-manager
    inputs.wezterm.packages.${pkgs.system}.default
    inputs.anyrun.packages.${pkgs.system}.anyrun
  ];

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
}
