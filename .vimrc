" Minimal vimrc suitable for students
" Enable sensible defaults
set nocompatible
set backspace=indent,eol,start
set number
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
syntax on

" Enable filetype plugins
filetype plugin indent on

" Easy undo and swap handling
set undofile
set directory=~/.vim/tmp//

" Small status line
set laststatus=2
set showcmd

" Preserve backups in temp
set backupdir=~/.vim/backup//
set writebackup

" End of .vimrc
