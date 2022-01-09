set nocompatible
filetype off

" Set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

" Download plug-ins to the ~/.vim/plugged/ directory
call vundle#begin('~/.vim/plugged')

" Let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

call vundle#end()
filetype plugin indent on

set nu     " Enable line numbers
syntax on  " Enable syntax highlighting

" How many columns of whitespace a \t is worth
set tabstop=4 " How many columns of whitespace a "level of indentation" is worth
set shiftwidth=4

set incsearch  " Enable incremental search
set hlsearch   " Enable highlight search

set termwinsize=12x0   " Set terminal size
set splitbelow         " Always split below
set mouse=a            " Enable mouse drag on window splits

Plugin 'sheerun/vim-polyglot'
Plugin 'cocopon/iceberg.vim'

set background=dark   " dark or light
colorscheme iceberg   " Your favorite color scheme's name

Plugin 'jiangmiao/auto-pairs'
Plugin 'preservim/nerdtree'

nmap <F2> :NERDTreeToggle<CR>
nmap <F5> :NERDTreeRefreshRoot<CR>
nmap <C-b> :NERDTreeFocus<CR> 
