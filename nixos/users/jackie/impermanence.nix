{ ... } :
{
  environment.persistence."/persist" = {
    directories = [
      "/home/jackie"
    ];
    # users.jackie = {
    #   directories = [
    #     "github"
    #     ".mozilla"
    #     ".config"
    #   ];
    #   files = [
    #     ".git-credentials"
    #   ];
    # };
  };
}
