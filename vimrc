" vim:foldmethod=marker

" Plugins {{{

" Install vim-plug automatically if not found (assumes $MYVIMRC is defined)
" From: https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" UI {{{
Plug 'morhetz/gruvbox' " excellent colorscheme
Plug 'ransonr/vim-lucius' " fork of Jon's colorscheme
Plug 'vim-airline/vim-airline' " better statusline
Plug 'vim-airline/vim-airline-themes' " you got this
" }}}

" Language-specific {{{
Plug 'JuliaEditorSupport/julia-vim', { 'for': 'julia' } " julia syntax support
Plug 'deoplete-plugins/deoplete-jedi', { 'for': 'python' } " jedi plugin for deoplete
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' } " modifies indentation behavior to comply with pep8
Plug 'tmhedberg/SimpylFold', { 'for': 'python' } " better folding for Python
Plug 'vim-python/python-syntax', { 'for': 'python' } " better Python syntax highlighting
" }}}

" Git {{{
Plug 'airblade/vim-gitgutter' " useful git info
Plug 'tpope/vim-fugitive' " git stuff
" }}}

" LSP-like {{{
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'w0rp/ale' " async linter
" }}}

" Utils {{{
Plug 'benmills/vimux' " run commands in a tmux pane
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzzy file finder
Plug 'junegunn/fzf.vim' " handy mappings for fzf
Plug 'tpope/vim-commentary' " comment stuff out
Plug 'vim-test/vim-test' " make it easier to run tests
" }}}

call plug#end()

" }}}

" Plugin Settings {{{

" deoplete {{{
let g:deoplete#enable_at_startup = 1 " enable deoplete by default
let g:deoplete#disable_auto_complete = 1 " use tab to trigger completion (see mappings)
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif " automatically close the method preview window
" }}}

" vim-airline {{{
let g:airline_extensions=['ale', 'branch', 'fzf', 'hunks', 'tabline']
let g:airline#extensions#tabline#fnamemod=':t' " just show buffer filename
let g:airline_powerline_fonts=1
" }}}

" ale {{{
let g:ale_echo_msg_error_str='E'
let g:ale_echo_msg_warning_str='W'
let g:ale_echo_msg_format='[%linter%] %s [%severity%]'
let g:ale_history_enabled=0 " don't keep history of commands
let g:ale_lint_delay=500 " delay (ms) after text is changed for linters to run (default 200)
let g:ale_set_highlights=0 " don't highlight errors, just show in gutter
let g:ale_sign_column_always=1 " don't want text to move when I start editing a file
let g:ale_python_flake8_options='--max-line-length=99'
" Disable pyls linting since we use flake8 for that still
let g:ale_python_pyls_config={
      \   'pyls': {
      \     'plugins': {
      \       'jedi': {'enabled': v:true},
      \       'pycodestyle': {'enabled': v:false},
      \       'pydocstyle': {'enabled': v:false},
      \       'pyflakes': {'enabled': v:false},
      \       'pylint': {'enabled': v:false},
      \       'rope': {'enabled': v:false}
      \     }
      \   },
      \ }
let g:ale_linters={
  \ 'python': ['pyls', 'flake8'],
  \ }
let g:ale_fixers={
  \ 'python': ['autopep8', 'isort'],
  \ }
" }}}

" python-syntax {{{
let python_highlight_all=1 " enable all Python syntax highlighting features
" }}}

" gitgutter {{{
let g:gitgutter_eager=0 " only run on save or when new buffer is loaded
" }}}

" vim-test {{{
let test#strategy='vimux' " run tests with vimux
let test#python#runner='pytest'
" }}}

" gruvbox {{{
let g:gruvbox_contrast_dark='soft'
" }}}

" netrw {{{
let g:netrw_liststyle=3 " tree style listing
let g:netrw_winsize=20 " use 20% of the window
let g:netrw_banner=0
let g:netrw_browse_split=4 " open files in previous window
" }}}

" }}}

" General Settings {{{

filetype on " enable filetype detection
filetype indent on " enable filetype-specific indentation
filetype plugin on " enable filetype-specific plugins

syntax enable " enable syntax highlighting
syntax sync fromstart " syntax highlight from start of file--slow but accurate

set autoindent " copy indent from current line when creating new line
set backspace=start,indent,eol " backspace over everything in insert mode
set colorcolumn=100 " display ruler at 100 lines
set complete=.,w,b,u " scan current buffer, other windows, buffer list, unloaded buffers
set cursorline " highlights the current line
set encoding=utf-8 " represent characters internally as utf-8
set expandtab " use spaces instead of tabs
set hidden " switch between buffers without saving
set laststatus=2 " always show the status line
set lazyredraw " redraw the screen only when needed
set modeline " enable settings on a per file basis
set mouse=a " enable mouse stuff
set mousehide " hide mouse when typing
set noerrorbells " disable error bells
set nospell " no need for spellcheck
set noswapfile " turn backup off
set nowrap " don't wrap lines visually
set number " show file line numbers
set ruler " show current line and column positions in file
set scrolloff=5 " min number of lines above and below cursor
set shiftwidth=2 " shift line by 2 spaces when using >> or <<
set showcmd " show what commands you are typing
set showmatch " show matching open/close for bracket
set showmode " show what mode you are in
set sidescrolloff=2 " min number of columns to the right and left of cursor
set smartindent " C-like indenting when possible
set splitbelow " put new window below current when splitting
set splitright " put new window to the right when splitting vertically
set t_vb= " disable screen flash
set tabstop=2 " tab is 2 spaces
set timeoutlen=500 " reduce lag for mapped sequences
set wildmenu " enhanced command-line completion
set wildmode=list:longest,list:full " list all autocomplete matches and complete next full match

" Folding
set foldlevelstart=0 " close all folds by default
set foldmethod=syntax " sytax highlighting items specify folds
set foldnestmax=10 " at most 10 nested folds

" Search
set ignorecase " ignore case when searching
set smartcase " ...unless it looks like you are trying to search with case
set hlsearch " highlight search results
set incsearch " highlight search results as you type
set nowrapscan " do not wrap around to beginning when searching

" Colors
set background=dark " easier on the eyes
set t_Co=256
" colorscheme gruvbox
colorscheme lucius
LuciusDarkLowContrast

" Clipboard
if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
endif

" gvim
set guicursor=n-v-c:block-Cursor
set guicursor+=a:blinkon0

let g:python3_host_prog=expand('~/miniconda3/envs/vimenv/bin/python3')
let g:loaded_python_provider=0 " disable Python 2 support

" }}}

" FileType Settings {{{

augroup filetype_wrap
  autocmd!
  autocmd FileType html,tex,markdown setlocal wrap
augroup END

augroup filetype_python_or_julia
  autocmd!
  autocmd FileType julia,python setlocal shiftwidth=4 " shift line by 4 spaces when using >> or <<
  autocmd FileType julia,python setlocal tabstop=4 " tab is 4 spaces
augroup END

" }}}

" Mappings {{{

nmap <Space> <leader>

" Move between buffers easily
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>

" Close the current buffer
nnoremap <silent> <leader>q :bw<CR>

" Move around splits easily
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Easier toggling of folds
nnoremap - za

" Easily open this file in a split
nnoremap <leader>ev :split $MYVIMRC<CR>

" Easily re-source this file
nnoremap <leader>sv :source $MYVIMRC<CR>

" Easier than reaching for esc key
inoremap jk <ESC>

" Move between ale errors quickly
nmap <silent> [g <Plug>(ale_previous_wrap)
nmap <silent> ]g <Plug>(ale_next_wrap)

" Ale go to definition and references
nmap <silent> gd <Plug>(ale_go_to_definition_in_vsplit)
nmap <silent> gr :ALEFindReferences -vsplit<CR>

" Remove trailing whitespace
nnoremap <leader>rtw :%s/\s\+$//e<CR>

" fzf.vim shortcuts
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <leader>f :Ag<CR>

" Utility function for tab completion
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Use tab to trigger autocompletion
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ deoplete#manual_complete()
inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Vimux
" Open ipython in the current conda environment
function! VimuxIPython()
  call VimuxRunCommand("conda activate " . $CONDA_DEFAULT_ENV . "; ipython"))
endfunction

" Send the current python file to ipython
function! VimuxSourcePython()
  if &filetype ==# "python"
    call VimuxRunCommand("%load " . expand("%:p"))
  endif
endfunction

function! VimuxSendLine()
  let l:command = getline(".")
  call VimuxRunCommand(l:command)
endfunction

nnoremap <silent> <leader>vip :call VimuxIPython()<CR>
nnoremap <silent> <leader>vsp :call VimuxSourcePython()<CR>
nnoremap <C-c><C-c> :call VimuxSendLine()<CR>
nnoremap <silent> <leader>vi :VimuxInspectRunner<CR>
nnoremap <silent> <leader>vx :VimuxCloseRunner<CR>

" exit terminal mode with Esc
tnoremap <Esc> <C-\><C-n>

" }}}
