{ ... }:
{
  programs.vim.enable = true;
  programs.vim.settings = {
    expandtab = true;
    hidden = true;
    mouse = "a";
    number = true;
    shiftwidth = 2;
    tabstop = 2;
  };
  programs.vim.extraConfig = ''
    filetype plugin on
    set autoindent
    set shiftround
    set formatoptions+=r
    set laststatus=2
    set hlsearch
    set incsearch
    set wildmenu
    set ruler
    set re=0
    syntax on
    setlocal expandtab
  '';
}
