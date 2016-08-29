set nu
set nocompatible
set laststatus=2
filetype plugin on
runtime mrcros/matchit.vim
set cursorline
set nrformats=
set noswapfile
set shiftwidth=2
set softtabstop=2
set expandtab
set suffixesadd+=.js
set visualbell                  "No sounds

" Set up leader key to <,>
let mapleader = ","

" This allows buffers to be hidden if you've modified a buffer.
set hidden

" ------ NERD Tree ------
" Key mapping for open NERDTree
nmap <leader>ne :NERDTreeToggle<cr>

" Key mapping to find the current file in the tree
nmap <leader>n :NERDTreeFind<cr>

" Open a NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim if the only window left open is a NERDTree
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" ------

" Key mapping for Dash
:nmap <silent> <leader>d <Plug>DashSearch

" Disable Arrows Keys
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Map Keys for Managing Buffers
map <C-J> :bnext<CR>
map <C-K> :bprev<CR>
map <C-L> :tabn<CR>
map <C-H> :tabp<CR>

" To open a new empty buffer
map <C-T> :enew<CR>

" Map keys to insert empty line without enter insert mode
map <Enter> o<ESC>
map <S-Enter> O<ESC>

" Map key to insert empty space without enter insert mode
:nnoremap <space> i<space><esc>

" ------ airline ------
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" " Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" ------

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'gavocanov/vim-js-indent', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'tpope/vim-surround'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'rizzatti/dash.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'dkprice/vim-easygrep'
Plug 'valloric/YouCompleteMe'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'pangloss/vim-javascript'
Plug 'morhetz/gruvbox'
call plug#end()
