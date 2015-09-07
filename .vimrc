set nocompatible

" General {{{
set backspace=start,indent,eol
set encoding=utf-8
set noswapfile
set nowrap
set number
" }}}

" UI {{{
set background=dark
set cursorline
set mousehide
" }}}

" Search {{{
set ignorecase
set smartcase
set infercase
set hlsearch
set incsearch
set nowrapscan
" }}}

" Syntax, Filetype {{{
syntax on
filetype on
filetype indent on
filetype plugin on
syntax sync fromstart
" }}}

" Plugins {{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'morhetz/gruvbox'
Plugin 'scrooloose/syntastic'
Plugin 'hdima/python-sytax'
Plugin 'ervandew/supertab'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'kien/ctrlp.vim'
Plugin 'bling/vim-airline'
" }}}

" Colors {{{
colorscheme gruvbox
" }}}

" Ctrl-P {{{
let g:ctrlp_clear_cache_on_exit=1
let g:ctrlp_show_hidden=0
let g:ctrlp_switch_buffer=1
let g:ctrlp_match_window='max:10,results:100'
let g:ctrlp_use_caching=1
let g:ctrlp_root_markers=['cscope.out', 'tags']
let g:ctrlp_extensions=['buffertag']
let g:ctrlp_by_filename=1
" }}}
