{ ... }:

{
  programs.bash = {
    enable = true;

    historySize = 1000;
    historyFileSize = 2000;

    shellOptions = [
      "histappend"
      "checkwinsize"
      "globstar"
    ];

    bashrcExtra = ''
      HISTCONTROL="ignoreboth";
      PS1='[\[\033[01;32m\]\u@\h\[\033[00m\]]'
      PROMPT_DIRTRIM=3
      PS1=$PS1'[\[\e[1;33m\]\[\e[0m\]\[\e[1;35m\]\w\[\e[0m\]]'
      PS1=$PS1'$(git branch 2>/dev/null | grep '"'"'*'"'"' | colrm 1 2 | sed s/^/[/ | sed s/$/]/)'
      PS1=$PS1'> '
    '';

  };

  home.file.".inputrc".source = ./.inputrc;
}
