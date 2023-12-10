" This file has no plugins because we want to use our full neovim setup instead.
" This is more useful for barebones vim environments where I want to stay sane
" with familiar keybindings.
syntax enable

set nocompatible

" General rebinds for convenience
let mapleader=','
inoremap jk <esc>
nnoremap <leader><space> :nohlsearch<CR>
nnoremap ; :
vnoremap ; :
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" General settings
set autoread
set number
set relativenumber
set incsearch
set hlsearch
set wildmode=longest,list
set noshowmode
set shortmess+=c
filetype plugin indent on
set scrolloff=8
set shiftwidth=4
set splitbelow
set splitright
set colorcolumn=80
set foldmethod=syntax
set tabstop=4
set expandtab
set mouse=
" Makes the cursor start at the beginning of the line for tabs
"set list listchars=tab:\

" Our shell scripts are bash scripts, trust us
let g:is_bash = 1

" Stop adding new comment starts on newlines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Open all folds
autocmd FileType * normal zR

" Make vim check if it needs to reload with autoread
au FocusGained,BufEnter * :checktime

" Correctly wrap at 80 characters for Markdown reformatting
au BufRead,BufNewFile *.md setlocal textwidth=80
