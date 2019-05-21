syntax enable

" VUNDLE
set nocompatible              " be iMproved, required
filetype off                  " required

if !has ('nvim')
	set pyx=3
	set pyxversion=3
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

if !has ('nvim')
else
	Plugin 'roxma/nvim-yarp'
	Plugin 'roxma/vim-hug-neovim-rpc'
endif

" Git stuff
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Autocomplete stuff
Plugin 'Shougo/deoplete.nvim'
Plugin 'Shougo/denite.nvim'
Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'Shougo/vimproc.vim'
Plugin 'Shougo/echodoc.vim'

" Typescript/Vue stuff
Plugin 'leafgarland/typescript-vim'
Plugin 'mhartington/nvim-typescript'
Plugin 'posva/vim-vue'

" File tree
Plugin 'scrooloose/nerdtree'

" Colors to choose from... only using minimalist for now but eh
Plugin 'owickstrom/vim-colors-paramount'
Plugin 'dikiaap/minimalist'

call vundle#end()            " required
filetype plugin indent on    " required
" /VUNDLE

" Using minimalist for now, but...
colorscheme minimalist

" ...we make some adjustments for nice transparency effects in iterm2
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE

" ...and some more interesting colors for git diffs
hi DiffAdd ctermfg=112
hi DiffChange ctermfg=214
hi DiffDelete ctermfg=167

" General rebinds for convenience
let mapleader=','
inoremap jk <esc>
nnoremap <leader><space> :nohlsearch<CR>
nnoremap ; :
vnoremap ; :

" General settings
set number
set relativenumber
set incsearch
set hlsearch
set wildmode=longest,list
set noshowmode
set shortmess+=c
filetype plugin indent on
set tabstop=4
set shiftwidth=4

" DEOPLETE settings
let g:deoplete#enable_at_startup = 1

" ECHODOC settings
let g:echodoc#enable_at_startup = 1

" NEOSNIPPET settings
let g:neosnippet#enable_completed_snippet = 1

" Remap tab to autocomplete naturally with deoplete/neosnippet
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><S-TAB>
 \ pumvisible() ? "\<C-p>" : "\<TAB>"

" Remap enter key to finish an autocomplete selection
imap <expr><silent><CR> pumvisible() ? deoplete#mappings#close_popup() .
      \ "\<Plug>(neosnippet_jump_or_expand)" : "\<CR>"
smap <silent><CR> <Plug>(neosnippet_jump_or_expand)

" NVIM_TYPESCRIPT settings
let g:nvim_typescript#vue_support = 1
nnoremap <leader>t :TSType<CR>
nnoremap <leader>d :TSDef<CR>
nnoremap <leader>r :TSRefs<CR>
nnoremap <leader>i :TSImport<CR>

" GITGUTTER settings
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_added = '➟'
let g:gitgutter_sign_modified = '➟'
let g:gitgutter_sign_removed = '__'
let g:gitgutter_sign_removed_first_line = '__'
let g:gitgutter_sign_modified_removed = '➟'

" NERDTREE settings
map <C-n> :NERDTreeToggle<CR>

" When we open vim, open it with Nerdtree if and only if we did 'vim .' (or
" some directory)
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" If the last open window is Nerdtree, close vim entirely
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

