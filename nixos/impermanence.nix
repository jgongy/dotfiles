{ ... }:
{
  imports = [
      ./users/jackie/impermanence.nix
  ];

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
    ];
    files = [
      "/etc/machine-id"
    ];
  };
}
