set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf'
Plugin 'lifepillar/vim-solarized8'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Configure Solarized
set termguicolors
set background=dark          " or 'light'
colorscheme solarized8_high

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Put your non-Plugin stuff after this line
"
if filereadable(expand("~/.nonplugin_vimrc"))
    source ~/.nonplugin_vimrc
endif
