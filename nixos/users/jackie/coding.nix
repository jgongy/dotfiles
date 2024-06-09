{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jackie Gong";
    userEmail = "gongjackiegong@gmail.com";
    extraConfig = {
      credential.helper = "store";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      eamodio.gitlens
    ];
  };

  programs.vscode.userSettings = {
    "editor.minimap.enabled" = false;
    "editor.rulers" = [
      80
    ];
    "editor.tabsize" = 2;
  };
}
