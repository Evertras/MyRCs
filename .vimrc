syntax enable

set nocompatible

" PLUGINS
call plug#begin('~/.vim/plugged')

" Gotta go fast
Plug 'easymotion/vim-easymotion'

" Git stuff
Plug 'airblade/vim-gitgutter'

" Autocomplete stuff
function! DoRemote(arg)
    UpdateRemotePlugins
endfunction
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

" Typescript stuff
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
Plug 'Quramy/tsuquyomi'
Plug 'rudism/deoplete-tsuquyomi'

" Go stuff
Plug 'fatih/vim-go'

" YAML stuff that's faster than defaults
Plug 'stephpy/vim-yaml'

" TOML stuff
Plug 'cespare/vim-toml'

" File tree
Plug 'scrooloose/nerdtree'

" Base colors
Plug 'dikiaap/minimalist'
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'

call plug#end()
" /PLUGINS

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

	" ...and some more interesting colors for git diffs
	hi DiffAdd    ctermfg=112 ctermbg=NONE
	hi DiffChange ctermfg=214 ctermbg=NONE
	hi DiffDelete ctermfg=167 ctermbg=NONE

	hi Search ctermbg=023
else
	" Using solarized as a base, but...
	set background=light
	colorscheme solarized

	" ...we want to highlight the line we're on
	set cursorline
	hi CursorLine ctermbg=223

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

	" ...and some more interesting colors for git diffs
	hi DiffAdd    ctermfg=155 ctermbg=NONE
	hi DiffChange ctermfg=221 ctermbg=NONE
	hi DiffDelete ctermfg=001 ctermbg=NONE
endif

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

" Stop adding new comment starts on newlines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Make vim check if it needs to reload with autoread
au FocusGained,BufEnter * :checktime

" EASYMOTION settings
let g:EasyMotion_do_mapping = 0
nmap ' <Plug>(easymotion-overwin-f)

" DEOPLETE settings
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})

" TYPESCRIPT settings
let g:tsuquyomi_auto_open = 1
autocmd FileType typescript nnoremap <leader>t :TsuType<CR>
autocmd FileType typescript nnoremap <leader>d :TsuDefinition<CR>
autocmd FileType typescript nnoremap <leader>r :TsuReferences<CR>
autocmd FileType typescript nnoremap <leader>i :TsuImport<CR>
autocmd FileType typescript nnoremap <leader>f :TsuQuickFix<CR>
autocmd FileType typescript nnoremap <leader>e :TsuGeterr<CR>

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

