" NOTE: Requires Vundle -- https://github.com/gmarik/Vundle.vim
" Vundle config
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Required
Plugin 'gmarik/Vundle.vim'

" HTML5 support
Plugin 'othree/html5.vim'

" CSS coloring
Plugin 'ap/vim-css-color'

" Syntastic
Plugin 'scrooloose/syntastic'

call vundle#end()
filetype plugin on
filetype plugin indent on

" Our color scheme
colorscheme molokai

" Tab settings
set tabstop=4
set softtabstop=4
set shiftwidth=4

set wildmenu	" Show visual menu when tabbing through stuff
set number		" Show line numbers
set relativenumber	" Show relative line numbers around current line
set showcmd		" Show last command in bottom right
set cursorline	" Highlight current line
set lazyredraw	" Redraw only when needed
set incsearch	" Search while typing
set hlsearch	" Highlight matches
set foldenable	" Enable folding
set foldlevelstart=99	" Start with everything unfolded
set foldmethod=indent	" Fold based on indentation
set rulerformat=%l\:%c	"Better rule format, we don't care about relative character pos
set omnifunc=syntaxcomplete#Complete	" Omnicomplete
set wrap		" Wrap lines visually
set linebreak	" Break at natural points

" Key remaps
let mapleader=","

" Clear highlighted search with ,<space>
nnoremap <leader><space> :nohlsearch<CR>

" Omnicomplete mappings
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
inoremap <A-n> <C-n>
inoremap <A-p> <C-p>

" Swap colon/semicolon functionality
" EDIT: No swap for now, just straight up replace ; with : and still keep :
nnoremap ; :
" nnoremap : ;
" vnoremap : ;
vnoremap ; :

" Space toggles folds
nnoremap <space> za

" Quick escape key
inoremap jk <esc>

" Starting Syntastic settings
" set statusline += %#warningmessage#
" set statusline += %{SyntasticStatusLineFlag()}
" set statusline += %*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_tidy_exec = 'tidy5'
let g:syntastic_html_tidy_ignore_errors = [" proprietary attribute \"ng-", " proprietary attribute \"autoscroll", "trimming empty", "is not recognized", "discarding unexpected"]
