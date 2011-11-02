set nocompatible
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
set softtabstop=2
set autoindent
set backspace=indent,eol,start
set ruler
set incsearch
set scs
set showmatch
set wrap
set linebreak
set nolist
set number
set hidden

syntax on
filetype plugin on
filetype indent on
colorscheme slate

"let g:SuperTabDefaultCompletionType="<c-x><c-u>"

"autocmd VimEnter * LustyJuggler
"autocmd VimEnter * NeoComplCacheEnable
"autocmd VimEnter * TrinityToggleNERDTree
"autocmd VimEnter * TrinityToggleTagList
"autocmd VimEnter * TrinityToggleSourceExplorer
"autocmd VimEnter * wincmd l

autocmd BufWritePre * :%s/\s\+$//e

let mapleader = ","

noremap <C-n> :bn<CR>
noremap J :bn<CR>
noremap K :bp<CR>
noremap <C-p> :bp<CR>
map <C-c> :bd<CR>
