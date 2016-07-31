set nocompatible " magic

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
set shiftwidth=4 " shift line by 4 spaces when using >> or <<
set showmatch " show matching open/close for bracket
set showmode " show what mode you are in
set showcmd " show what commands you are typing
set t_vb= " disable screen flash
set tabstop=4 " tab is 4 spaces
set wildmenu " turn on the wild menu
" }}}

" Search {{{
set ignorecase " ignore case when searching
set smartcase " ...unless it looks like you are trying to search with case
set hlsearch " highlight search results
set incsearch " highlight search results as you type
set nowrapscan " do not wrap around to beginning when searching
" }}}

" Syntax, Filetype {{{
syntax enable " enable syntax highlighting
syntax sync fromstart " syntax highlight from start of file--slow but accurate
filetype on " enable filetype detection
filetype indent on " enable filetype-specific indentation
filetype plugin on " enable filetype-specific plugins
" }}}

" Plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'bling/vim-airline' " better statusline
Plug 'ervandew/supertab' " tab completion
Plug 'hdima/python-syntax' " syntax highlighting
Plug 'hynek/vim-python-pep8-indent' " modifies indentation behavior to comply with pep8
Plug 'kien/ctrlp.vim' " fuzzy file finder
Plug 'morhetz/gruvbox' " excellent colorscheme
Plug 'scrooloose/syntastic' " syntax checking
" }}}

" Colors {{{
set t_Co=256 " hope terminal supports 256 colors
colorscheme gruvbox " makes things look good
" }}}

" Vim Airline {{{
let g:airline#extensions#tabline#enabled=1 " display all buffers when there's only one tab open
let g:airline#extensions#whitespace#enabled=1
" }}}

" Syntastic {{{
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:systastic_mode_map={'passive_filetypes': ['python']} " avoid syntax check clashes
" }}}

" Python Syntax {{{
let python_highlight_all=1 " enable all Python syntax highlighting features
" }}}

" Ctrl-P {{{
let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_show_hidden=1 " show hidden files
let g:ctrlp_switch_buffer=1
let g:ctrlp_match_window='max:10,results:100'
let g:ctrlp_use_caching=1
let g:ctrlp_root_markers=['cscope.out', 'tags']
let g:ctrlp_extensions=['buffertag']
let g:ctrlp_by_filename=1
" }}}

nmap <Space> <leader>
