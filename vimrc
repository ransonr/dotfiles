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
Plug 'JuliaEditorSupport/julia-vim' " julia syntax support
Plug 'airblade/vim-gitgutter' " useful git info
Plug 'benmills/vimux' " run commands in a tmux pane
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' } " modifies indentation behavior to comply with pep8
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " fuzzy file finder
Plug 'junegunn/fzf.vim' " handy mappings for fzf
Plug 'morhetz/gruvbox' " excellent colorscheme
Plug 'prabirshrestha/asyncomplete-lsp.vim' " provides LSP autocompletion source for asyncomplete.vim
Plug 'prabirshrestha/asyncomplete.vim' " async autocompletion
Plug 'prabirshrestha/vim-lsp' " async LSP for vim8 and neovim
Plug 'ransonr/vim-lucius' " fork of Jon's colorscheme
Plug 'tmhedberg/SimpylFold', { 'for': 'python' } " better folding for Python
Plug 'tpope/vim-commentary' " comment stuff out
Plug 'tpope/vim-fugitive' " git stuff
Plug 'vim-airline/vim-airline' " better statusline
Plug 'vim-airline/vim-airline-themes' " you got this
Plug 'vim-python/python-syntax', { 'for': 'python' } " better Python syntax highlighting
Plug 'vim-test/vim-test' " make it easier to run tests
call plug#end()

" }}}

" Plugin Settings {{{

" vim-lsp
if executable('pyls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': {server_info->['pyls']},
    \ 'allowlist': ['python'],
    \ 'workspace_config': {
    \   'pyls': {
    \     'plugins': {
    \       'jedi': {'enabled': v:true},
    \       'pycodestyle': {'enabled': v:true},
    \       'pydocstyle': {'enabled': v:false},
    \       'pyflakes': {'enabled': v:true},
    \       'pylint': {'enabled': v:false},
    \       'rope': {'enabled': v:false}
    \     }
    \   }
    \ }})
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_install
  autocmd!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup end

let g:lsp_diagnostics_enabled=1 " enable reporting of linter errors/warnings
let g:lsp_diagnostics_signs_enabled=1 " flag errors/warnings in the signs column
let g:lsp_diagnostics_echo_cursor=1 " echo error for the current line to status
let g:lsp_diagnostics_highlights_enabled=0 " disable highlighting of errors since they're flagged with signs
let g:lsp_diagnostics_virtual_text_enabled=0 " don't show annoying virtual text next to errors
let g:lsp_document_highlight_enabled=0 " don't highlight the symbol under the cursor
let g:lsp_fold_enabled=0 " use SimpylFold for (python) folding
" let g:lsp_log_verbose=1
" let g:lsp_log_file=expand('~/vim-lsp.log')

" asyncomplete
let g:asyncomplete_auto_popup=0 " disable auto popup since we define a mapping to use tab for autocompletion

" vim-airline
let g:airline_extensions=['branch', 'fzf', 'hunks', 'lsp', 'tabline']
let g:airline#extensions#tabline#fnamemod=':t' " just show buffer filename
let g:airline_powerline_fonts=1

" python-syntax
let python_highlight_all=1 " enable all Python syntax highlighting features

" gitgutter
let g:gitgutter_eager=0 " only run on save or when new buffer is loaded

" vim-test
let test#strategy='vimux' " run tests with vimux
let test#python#runner='pytest'

" gruvbox
let g:gruvbox_contrast_dark='soft'

" netrw
let g:netrw_liststyle=3 " tree style listing
let g:netrw_winsize=20 " use 20% of the window
let g:netrw_banner=0
let g:netrw_browse_split=4 " open files in previous window

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

" Easily open this file in a split
nnoremap <leader>ev :split $MYVIMRC<CR>

" Easily re-source this file
nnoremap <leader>sv :source $MYVIMRC<CR>

" Easier than reaching for esc key
inoremap jk <ESC>

" Remove trailing whitespace
nnoremap <leader>rtw :%s/\s\+$//e<CR>

" fzf.vim shortcuts
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <leader>f :Ag<CR>

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Use tab to trigger autocompletion
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

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
