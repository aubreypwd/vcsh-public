syntax on
set nowrap

"@see https://askubuntu.com/questions/74485/how-to-display-hidden-characters-in-vim/74503
set list
set listchars=tab:→\ ,nbsp:␣,trail:•,precedes:«,extends:»

"@see https://marioyepes.com/vim-setup-for-modern-web-development/
set belloff=esc
set clipboard=unnamed,unnamedplus " Use the OS clipboard

set expandtab             " Use apropiate number of spaces
set hlsearch              " Highlight search results
set ignorecase            " Search ingnoring case
set list lcs=tab:\¦\      "(here is a space)
set mouse=a               " Enable mouse on all modes
set nocompatible
set noerrorbells          " I hate bells
set noswapfile            " Do not leave any backup files
set number                " Show numbers on the left
set showmatch
set smartcase             " Do not ignore case if the search patter has uppercase
set splitright splitbelow
set tabstop=2             " Tab size of x spaces
set termguicolors
set background=dark
set backspace=indent,eol,start
set list

if has("mouse_sgr")
	set ttymouse=sgr
else
	set ttymouse=xterm2
end

" Keep VisualMode after indent with > or <
vmap < <gv
vmap > >gv

" Move Visual blocks with J an K
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Autocomand to remember last editing position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

autocmd BufRead,BufNewFile *.md,*.txt setlocal wrap " DO wrap on markdown files
"autocmd BufRead,BufNewFile * start "Start in insert mode

"For committing
set cc=51,71
highlight ColorColumn ctermbg=0 guibg=black
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%51v.*/

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
	\| PlugInstall --sync | source $MYVIMRC
\| endif

"Plugins
call plug#begin('~/.vim/plugged')
	Plug 'patstockwell/vim-monokai-tasty'
	Plug 'sheerun/vim-polyglot'
	Plug 'tpope/vim-sensible'
	Plug 'tpope/vim-surround'
	Plug 'mutewinter/nginx.vim'
	Plug 'rhysd/committia.vim'
	Plug 'preservim/nerdtree'
call plug#end()

" UI
colorscheme vim-monokai-tasty

hi Normal ctermbg=16 guibg=NONE
hi LineNr ctermbg=16 guibg=NONE

let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

autocmd VimLeave * silent !echo -ne "\033[0 q"

" Open NERDTree automatically when vim starts if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Shortcut to toggle sidebar
nnoremap <C-n> :NERDTreeToggle<CR>
