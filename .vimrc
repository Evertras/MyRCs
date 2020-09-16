syntax enable

set nocompatible

" PLUGINS
call plug#begin('~/.vim/plugged')

" Gotta go fast
Plug 'easymotion/vim-easymotion'

" Editorconfig stuff
Plug 'editorconfig/editorconfig-vim'

" Git stuff
Plug 'airblade/vim-gitgutter'

" Autocomplete stuff
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}

" Typescript syntax stuff
Plug 'leafgarland/typescript-vim'
Plug 'posva/vim-vue'

" TOML stuff
Plug 'cespare/vim-toml'

" FBS stuff
Plug 'dcharbon/vim-flatbuffers'

" File tree
Plug 'scrooloose/nerdtree'

" Base colors
Plug 'dikiaap/minimalist'
Plug 'crusoexia/vim-monokai'
Plug 'NLKNguyen/papercolor-theme'
Plug 'altercation/vim-colors-solarized'

call plug#end()
" /PLUGINS

" Switch between light/dark color schemes easily... these
" are defined in our .bashrc so we can also switch tmux
let s:scheme = $EVERTRAS_SCREEN_MODE
let s:transparency = $EVERTRAS_SCREEN_TRANSPARENCY

if s:scheme == 'dark'
	" Using monokai as a base, but...
	colorscheme monokai

	"if s:transparency == 'true'
	" ...we make some adjustments
	hi Normal       ctermbg=NONE
	hi NonText      ctermbg=NONE
	hi Comment      ctermfg=103   cterm=bold
	hi NERDTreeFile ctermfg=103
	hi NERDTreeExecFile ctermfg=202
	hi NERDTreeDir  ctermfg=078   cterm=bold
	hi LineNr       ctermbg=NONE
	hi StatusLine   ctermbg=NONE  ctermfg=244
	hi StatusLineNC ctermbg=NONE  ctermfg=240
	hi VertSplit    ctermbg=NONE
	hi SignColumn   ctermbg=NONE
	hi Error        ctermfg=202
	hi CocErrorFloat        ctermbg=202
	"endif

	" ...and some more interesting colors for git diffs
	hi DiffAdd    ctermfg=112 ctermbg=NONE
	hi DiffChange ctermfg=214 ctermbg=NONE
	hi DiffDelete ctermfg=167 ctermbg=NONE

	hi Search ctermbg=023
elseif s:scheme == 'neutral'
	" Using minimalist as a base, but...
	set background=dark
	colorscheme minimalist

	" ...we want to highlight the line we're on
	set cursorline

	if s:transparency == 'true'
		" ...we make some adjustments for slick transparency effects in iterm2
		hi Normal       ctermbg=NONE
		hi NonText      ctermbg=NONE
		hi Comment      ctermfg=107   cterm=bold
		hi NERDTreeFile ctermfg=247
		hi LineNr       ctermbg=NONE  ctermfg=245
		hi StatusLine   ctermbg=NONE  ctermfg=246
		hi StatusLineNC ctermbg=NONE  ctermfg=243
		hi VertSplit    ctermbg=NONE
		hi SignColumn   ctermbg=NONE
	endif

	" ...and some more interesting colors for git diffs
	hi DiffAdd    ctermfg=155 ctermbg=NONE
	hi DiffChange ctermfg=221 ctermbg=NONE
	hi DiffDelete ctermfg=001 ctermbg=NONE
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
nnoremap <space> za
nnoremap <leader>R :source ~/.vimrc<CR>

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
set colorcolumn=80
set foldmethod=syntax
" Makes the cursor start at the beginning of the line for tabs
"set list listchars=tab:\ 

" Our shell scripts are bash scripts, trust us
let g:is_bash = 1

" Stop adding new comment starts on newlines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd FileType * normal zR

" Don't use relative paths for files
"autocmd BufEnter * lcd %:p:h

" Make vim check if it needs to reload with autoread
au FocusGained,BufEnter * :checktime

" Tab navigates popup menus
imap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

" EASYMOTION settings
let g:EasyMotion_do_mapping = 0
nmap ' <Plug>(easymotion-overwin-f)

" COC settings
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent> <leader>y <Plug>(coc-type-definition)
nmap <silent> <leader>i <Plug>(coc-implementation)
nmap <silent> <leader>r <Plug>(coc-references)
nmap <silent> <leader>o :<C-u>CocList outline<cr>
nmap <silent> <leader>F <Plug>(coc-format)
nmap <leader>f <Plug>(coc-fix-current)

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

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*\.'. a:extension .'$#'
endfunction

if s:scheme == 'dark'
	call NERDTreeHighlightFile('go', '171', 'none', '171', '#151515')
	call NERDTreeHighlightFile('yaml', '220', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('yml', '220', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('sh', '202', 'none', '202', '#151515')
	call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
else
	" TODO: make this nicer, this is just the old defaults
	call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
	call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
	call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
	call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
	call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
	call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
	call NERDTreeHighlightFile('ts', 'green', 'none', '#ffa500', '#151515')
	call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
endif

