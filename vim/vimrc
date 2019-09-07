syntax on
set nocompatible
filetype off

" Settings for personal use
set number
set background=dark
set tabstop=2
set shiftwidth=2
set softtabstop=2
"set tabstop=4
"set shiftwidth=4
"set softtabstop=4
set autoindent
set expandtab
set noswapfile
colorscheme stereokai

" Enable Syntax Highlighting for Cuda
au BufNewFile,BufRead *.cu set ft=cuda
au BufNewFile,BufRead *.cuh set ft=cuda

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'ervandew/supertab'
Plugin 'tpope/vim-fugitive'
Plugin 'bling/vim-bufferline'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'
" Plugin 'valloric/youcompleteme'
Plugin 'tpope/vim-commentary'

"All plugins must be added before this
call vundle#end()            " required

"Plugin parameters
let g:neocomplete#enable_at_startup = 1 "for neocomplete
set laststatus=2 "for Airline

" Kep Mappings
map <C-n> :NERDTreeToggle<CR> 
" CtrlP mappings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" For Kitty Terminal
let &t_ut=''

filetype plugin on    " required
