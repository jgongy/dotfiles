" Automatically detect file type
filetype plugin on

" Autoindent when returning on a line
set autoindent

" Size of autoindent
set tabstop=2

" Turn tab character \t into spaces
set expandtab

" Autoindents inside curly braces with two spaces
set shiftwidth=2

" Indent a multiple of shiftwidth
set shiftround

" Autoinserts asterisks inside block comments
set formatoptions+=r

" Use hybrid line numbers unless in insert mode or not focused
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" Allows click to line
set mouse=a

" Make status line persistent
set laststatus=2

" Sets highlight on search
set hlsearch

" Start searching while typing search string
set incsearch

" Set hidden buffers
set hidden

" Enables command line completion for Vim commands
set wildmenu

" Colors code keywords
syntax on

" Create keybind to highlight lines over 80 characters long
" See https://bit.ly/3TsiRTE for source
let mapleader=","
nnoremap <Leader>H :call<SID>LongLineHLToggle()<cr>
hi OverLength ctermbg=none cterm=none
match OverLength /\%>80v/
fun! s:LongLineHLToggle()
 if !exists('w:longlinehl')
  let w:longlinehl = matchadd('ErrorMsg', '.\%>80v', 0)
  echo "Long lines highlighted"
 else
  call matchdelete(w:longlinehl)
  unl w:longlinehl
  echo "Long lines unhighlighted"
 endif
endfunction

" autocmd FileType python setlocal ts=2 | setlocal expandtab
