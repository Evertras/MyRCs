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

" Gotta go fast
Plugin 'easymotion/vim-easymotion'

" Editorconfig stuff
Plugin 'editorconfig/editorconfig-vim'

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

" Go stuff
Plugin 'fatih/vim-go'

" File tree
Plugin 'scrooloose/nerdtree'

" Base colors
Plugin 'dikiaap/minimalist'

call vundle#end()            " required
filetype plugin indent on    " required
" /VUNDLE

" Using minimalist as a base, but...
colorscheme minimalist

" ...we make some adjustments for slick transparency effects in iterm2
hi Normal       ctermbg=NONE
hi NonText      ctermbg=NONE
hi Comment      ctermfg=103   cterm=bold
hi NERDTreeFile ctermfg=244
hi LineNr       ctermbg=NONE
hi StatusLine   ctermbg=NONE  ctermfg=244
hi StatusLineNC ctermbg=NONE  ctermfg=240
hi VertSplit    ctermbg=NONE
hi SignColumn   ctermbg=NONE

" ...and some more interesting colors for git diffs
hi DiffAdd    ctermfg=112 ctermbg=NONE
hi DiffChange ctermfg=214 ctermbg=NONE
hi DiffDelete ctermfg=167 ctermbg=NONE

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
set splitbelow
set splitright

" EASYMOTION settings
let g:EasyMotion_do_mapping = 0
nmap ' <Plug>(easymotion-overwin-f)

" EDITORCONFIG settings
let g:EditorConfig_exclude_patterns = ['fugitive://.\*'] " To avoid conflicts with fugitive

" DEOPLETE settings
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('omni_patterns', {
\ 'go': '[^. *\t]\.\w*',
\})

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
autocmd FileType typescript nnoremap <leader>t :TSType<CR>
autocmd FileType typescript nnoremap <leader>d :TSDef<CR>
autocmd FileType typescript nnoremap <leader>r :TSRefs<CR>
autocmd FileType typescript nnoremap <leader>i :TSImport<CR>

" VIM-GO settings
autocmd FileType go nnoremap <leader>i :GoImports<CR>
autocmd FileType go nnoremap <leader>v :GoVet<CR>
autocmd FileType go nnoremap <leader>d :GoDef<CR>

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

