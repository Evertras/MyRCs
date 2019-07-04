syntax enable

" VUNDLE BOILERPLATE
set nocompatible              " be iMproved, required
filetype off                  " required
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Gotta go fast
Plugin 'easymotion/vim-easymotion'

" Editorconfig stuff
Plugin 'editorconfig/editorconfig-vim'

" Git stuff
Plugin 'airblade/vim-gitgutter'

" Autocomplete stuff
Plugin 'Shougo/deoplete.nvim'
" Plugin 'Shougo/denite.nvim'

" Typescript/Vue stuff
Plugin 'leafgarland/typescript-vim'
Plugin 'mhartington/nvim-typescript'
Plugin 'posva/vim-vue'

" Go stuff
Plugin 'fatih/vim-go'

" YAML stuff that's faster than defaults
Plugin 'stephpy/vim-yaml'

" TOML stuff
Plugin 'cespare/vim-toml'

" File tree
Plugin 'scrooloose/nerdtree'

" Base colors
Plugin 'dikiaap/minimalist'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()            " required
filetype plugin indent on    " required
" /VUNDLE

" Switch between light/dark color schemes easily... these
" are defined in our .bashrc so we can also switch tmux
let s:scheme = $EVERTRAS_SCREEN_MODE
let s:transparency = $EVERTRAS_SCREEN_TRANSPARENCY

if s:scheme == 'dark'
	" Using minimalist as a base, but...
	colorscheme minimalist

	if s:transparency == 'true'
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
	endif
else
	" Using solarized as a base, but...
	set background=light
	colorscheme solarized

	if s:transparency == 'true'
		" ...we make some adjustments for slick transparency effects in iterm2
		hi Normal       ctermbg=NONE
		hi NonText      ctermbg=NONE
		hi Comment      ctermfg=028   cterm=bold
		hi NERDTreeFile ctermfg=237
		hi LineNr       ctermbg=NONE
		hi StatusLine   ctermbg=NONE  ctermfg=244
		hi StatusLineNC ctermbg=NONE  ctermfg=240
		hi VertSplit    ctermbg=NONE
		hi SignColumn   ctermbg=NONE
	endif
endif

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
set autoread
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

" Make vim check if it needs to reload with autoread
au FocusGained,BufEnter * :checktime

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

" NEOSNIPPET settings
let g:neosnippet#enable_completed_snippet = 1

" Remap tab to autocomplete naturally with deoplete/neosnippet
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" Remap enter key to finish an autocomplete selection
imap <expr><silent><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"

" NVIM_TYPESCRIPT settings
let g:nvim_typescript#vue_support = 0
let g:nvim_typescript#max_completion_detail = 100
let g:nvim_typescript#signature_complete = 0
autocmd FileType typescript nnoremap <leader>t :TSType<CR>
autocmd FileType typescript nnoremap <leader>d :TSDef<CR>
autocmd FileType typescript nnoremap <leader>r :TSRefs<CR>
autocmd FileType typescript nnoremap <leader>i :TSImport<CR>
autocmd FileType typescript nnoremap <leader>f :TSGetCodeFix<CR>

" VIM-VUE settings
autocmd FileType vue syntax sync fromstart

" VIM-GO settings
autocmd FileType go nnoremap <leader>i :GoImports<CR>
autocmd FileType go nnoremap <leader>v :GoVet<CR>
autocmd FileType go nnoremap <leader>d :GoDef<CR>
autocmd FileType go nnoremap <leader>f :GoInfo<CR>
let g:go_fmt_options = { 'gofmt': '-s' }

" GITGUTTER settings
let g:gitgutter_override_sign_column_highlight = 0
let g:gitgutter_sign_added = '➟'
let g:gitgutter_sign_modified = '➟'
let g:gitgutter_sign_removed = '__'
let g:gitgutter_sign_removed_first_line = '__'
let g:gitgutter_sign_modified_removed = '➟'

" NERDTREE settings
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeIgnore = ['^node_modules$']

" When we open vim, open it with Nerdtree if and only if we did 'vim .' (or
" some directory)
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" If the last open window is Nerdtree, close vim entirely
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

