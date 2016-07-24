set nu
set nocompatible
filetype plugin on
runtime mrcros/matchit.vim
" set cursorline

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'gavocanov/vim-js-indent', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'tpope/vim-surround'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
call plug#end()

" Disable Arrows Keys
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

set nrformats=
set noswapfile
set shiftwidth=4
set softtabstop=4
set expandtab
set suffixesadd+=.js
