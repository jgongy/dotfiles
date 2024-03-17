{ ... } :
{
  environment.persistence."/persist" = {
    users.jackie = {
      directories = [
        "github"
        ".mozilla"
      ];
      files = [
        ".git-credentials"
        ".config/hypr/hyprland.conf"
      ];
    };
  };
}
