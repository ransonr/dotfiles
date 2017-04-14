" vim:foldmethod=marker
set nocompatible " vim > vi


" Plugins {{{

" Install vim-plug automatically if not found (assumes $MYVIMRC is defined)
" From: https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs --insecure
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'JuliaEditorSupport/julia-vim' " Julia syntax stuff
Plug 'airblade/vim-gitgutter' " useful git info
Plug 'ervandew/supertab' " tab completion
Plug 'hdima/python-syntax' " better Python syntax highlighting
Plug 'hynek/vim-python-pep8-indent' " modifies indentation behavior to comply with pep8
Plug 'kien/ctrlp.vim' " fuzzy file finder
Plug 'morhetz/gruvbox' " excellent colorscheme
Plug 'pangloss/vim-javascript' " improved Javascript indentation/syntax
Plug 'scrooloose/syntastic' " syntax checking
Plug 'vim-airline/vim-airline' " better statusline
Plug 'vim-airline/vim-airline-themes' " you can figure this one out
call plug#end()

" vim-airline settings
let g:airline#extensions#syntastic#enabled=1 " warn me about bad syntax
let g:airline#extensions#tabline#enabled=1 " display all buffers when there's only one tab open
let g:airline#extensions#tabline#fnamemod=':t' " just show buffer filename
let g:airline_left_sep='' " don't require fancy powerline fonts
let g:airline_right_sep='' " don't require fancy powerline fonts

" syntastic settings
let g:syntastic_python_checkers=['pyflakes', 'pep8'] " run both checkers to be safe
let g:syntastic_auto_loc_list=1 " automatically open error window when errors are detected
let g:syntastic_check_on_wq=0 " don't run syntax checks when saving and closing
let g:systastic_mode_map={'mode': 'passive'} " only run checks when asked to

" python-syntax settings
let python_highlight_all=1 " enable all Python syntax highlighting features

" ctrlp settings
let g:ctrlp_clear_cache_on_exit=1 " get rid of cached content when exiting session
let g:ctrlp_show_hidden=1 " show hidden files
let g:ctrlp_switch_buffer=1 " jump to open buffer if already opened
let g:ctrlp_match_window='max:10,results:100' " limit window height and number of results
let g:ctrlp_use_caching=1 " cache files for each session
let g:ctrlp_by_filename=1 " search by filename instead of full path

" gitgutter settings
let g:gitgutter_eager=0 " only run on save or when new buffer is loaded

" }}}


" General {{{
set background=dark " easier on the eyes
set backspace=start,indent,eol " backspace over everything in insert mode
set colorcolumn=100 " display ruler at 100 lines
set cursorline " highlights the current line
set encoding=utf-8 " represent characters internally as utf-8
set expandtab " use spaces instead of tabs
set laststatus=2 " always show the status line
set mouse=a " enable mouse stuff
set mousehide " hide mouse when typing
set noerrorbells " disable error bells
set noswapfile " turn backup off
set nowrap " don't wrap lines visually
set number " show file line numbers
set ruler " show current line and column positions in file
set scrolloff=5 " min number of lines above and below cursor
set shiftwidth=2 " shift line by 2 spaces when using >> or <<
set showcmd " show what commands you are typing
set showmatch " show matching open/close for bracket
set showmode " show what mode you are in
set splitbelow " put new window below current when splitting
set splitright " put new window to the right when splitting vertically
set t_vb= " disable screen flash
set tabstop=2 " tab is 2 spaces
set timeoutlen=500 " reduce lag for mapped sequences
set wildmenu " enhanced command-line completion
" }}}


" Search {{{
set ignorecase " ignore case when searching
set smartcase " ...unless it looks like you are trying to search with case
set hlsearch " highlight search results
set incsearch " highlight search results as you type
set nowrapscan " do not wrap around to beginning when searching
" }}}


" Clipboard {{{
if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
endif
" }}}


" Syntax, Filetype {{{
filetype on " enable filetype detection
filetype indent on " enable filetype-specific indentation
filetype plugin on " enable filetype-specific plugins
syntax enable " enable syntax highlighting
syntax sync fromstart " syntax highlight from start of file--slow but accurate
" }}}


" Colors {{{
colorscheme gruvbox " makes vim pretty
" }}}


" FileType Specific Settings {{{
autocmd FileType python setlocal tabstop=4 " use 4 spaces for tabs in Python
autocmd FileType python setlocal shiftwidth=4 " use 4 spaces for tabs in Python
autocmd FileType python setlocal foldmethod=indent " Python is weird
" }}}


" Mappings {{{
nmap <Space> <leader>

" Move between buffers easily
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>

" Close the current buffer
nnoremap <silent> <leader>q :bw<CR>

" Move around splits easily
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Expand and contract folds
nnoremap - zm
nnoremap + zr

" Syntastic check/reset
nnoremap <silent> <leader>sc :SyntasticCheck<CR>
nnoremap <silent> <leader>sr :SyntasticReset<CR>

" Easily open this file in a split
nnoremap <leader>ev :split $MYVIMRC<CR>

" Easily re-source this file
nnoremap <leader>sv :source $MYVIMRC<CR>

" Easier than reaching for esc key
inoremap jk <ESC>

" }}}
