" vim:foldmethod=marker

" Plugins {{{

" Install vim-plug automatically if not found (assumes $MYVIMRC is defined)
" From: https://github.com/junegunn/vim-plug/wiki/faq#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim
    \ --create-dirs
    \ --insecure
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'JuliaEditorSupport/julia-vim' " julia syntax support
Plug 'Rykka/colorv.vim' " color tool
Plug 'airblade/vim-gitgutter' " useful git info
Plug 'ervandew/supertab' " tab completion
Plug 'hdima/python-syntax', { 'for': 'python' } " better Python syntax highlighting
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' } " modifies indentation behavior to comply with pep8
Plug 'kien/ctrlp.vim' " fuzzy file finder
Plug 'morhetz/gruvbox' " excellent colorscheme
Plug 'pangloss/vim-javascript', { 'for': 'javascript' } " better javascript support
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' } " better markdown support
Plug 'tell-k/vim-autopep8', { 'for': 'python' } " clean up ugly code
Plug 'tmhedberg/SimpylFold', { 'for': 'python' } " better folding for Python
Plug 'tpope/vim-commentary' " comment stuff out
Plug 'tpope/vim-fugitive' " git stuff
Plug 'vim-airline/vim-airline' " better statusline
Plug 'vim-airline/vim-airline-themes' " you got this
Plug 'w0rp/ale' " async linter
call plug#end()

" }}}

" Plugin Settings {{{

" vim-airline
let g:airline_extensions=['ale', 'branch', 'ctrlp', 'hunks', 'tabline']
let g:airline#extensions#tabline#fnamemod=':t' " just show buffer filename
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''

" ale
let g:ale_echo_msg_error_str='E'
let g:ale_echo_msg_warning_str='W'
let g:ale_echo_msg_format='[%linter%] %s [%severity%]'
let g:ale_history_enabled=0 " don't keep history of commands
let g:ale_lint_delay=500 " delay (ms) after text is changed for linters to run (default 200)
let g:ale_set_highlights=0 " don't highlight errors, just show in gutter
let g:ale_sign_column_always=1 " don't want text to move when I start editing a file
let g:ale_python_flake8_options='--max-line-length=99'
let g:ale_linters={
  \ 'javascript': ['eslint'],
  \ 'python': ['flake8'],
  \ }

" python-syntax
let python_highlight_all=1 " enable all Python syntax highlighting features

" ctrlp
let g:ctrlp_show_hidden=1 " show hidden files
let g:ctrlp_switch_buffer=1 " jump to open buffer if already opened
let g:ctrlp_match_window='max:10,results:100' " limit window height and number of results
let g:ctrlp_use_caching=0 " fast enough
let g:ctrlp_by_filename=1 " search by filename instead of full path

if executable('ag')
  let g:ctrlp_user_command='ag %s -l --nocolor -g ""' " faster listing of files in ctrlp
endif

" gitgutter
let g:gitgutter_eager=0 " only run on save or when new buffer is loaded

" gruvbox
let g:gruvbox_contrast_dark='soft'

" vim-markdown
let g:vim_markdown_frontmatter=1

" }}}

" General Settings {{{

filetype on " enable filetype detection
filetype indent on " enable filetype-specific indentation
filetype plugin on " enable filetype-specific plugins

syntax enable " enable syntax highlighting
syntax sync fromstart " syntax highlight from start of file--slow but accurate

set autoindent " copy indent from current line when creating new line
set background=dark " easier on the eyes
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
set ttymouse=xterm2 " better mouse handling
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
set t_Co=256
colorscheme gruvbox

" Clipboard
if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
endif

set guicursor=n-v-c:block-Cursor
set guicursor+=a:blinkon0

" }}}

" FileType Settings {{{

autocmd FileType html,tex setlocal wrap

autocmd FileType julia,python setlocal shiftwidth=4 " shift line by 4 spaces when using >> or <<
autocmd FileType julia,python setlocal tabstop=4 " tab is 4 spaces

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

" Move between ale errors quickly
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Easily open this file in a split
nnoremap <leader>ev :split $MYVIMRC<CR>

" Easily re-source this file
nnoremap <leader>sv :source $MYVIMRC<CR>

" Easier than reaching for esc key
inoremap jk <ESC>

" Remove trailing whitespace
nnoremap <leader>rtw :%s/\s\+$//e<CR>

" Show syntax items under cursor
map <F10> :echo "hi<" . synIDattr(synID(line("."), col("."),1), "name") . "> trans<"
      \ . synIDattr(synID(line("."), col("."),0), "name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name") . ">"<CR>

" }}}
