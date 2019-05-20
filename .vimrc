syntax enable

let mapleader=','

" VUNDLE
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'vim-syntastic/syntastic'
Plugin 'Quramy/tsuquyomi'
Plugin 'leafgarland/typescript-vim'

Plugin 'scrooloose/nerdtree'

Plugin 'owickstrom/vim-colors-paramount'
Plugin 'dikiaap/minimalist'

call vundle#end()            " required
filetype plugin indent on    " required
" /VUNDLE

colorscheme minimalist

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:tsuquyomi_completion_detail = 1
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']

inoremap jk <esc>
set number
set relativenumber
set incsearch
set hlsearch
set wildmode=longest,list
nnoremap <leader><space> :nohlsearch<CR>

nnoremap ; :
vnoremap ; :

inoremap <leader>f :TsuQuickFix

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4

autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>

hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE

