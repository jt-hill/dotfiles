inoremap kj <Esc>
set nocompatible
let mapleader = ' ' "use space for leader key
filetype off "required for Vundle
set clipboard=unnamedplus

" Cursor behaviour
:autocmd InsertEnter,InsertLeave * set cul!

" General visual look of Vim
set number relativenumber
set ruler
set noerrorbells visualbell t_vb=
set laststatus=2
set showmode
set splitbelow splitright

" Text searching options
set incsearch
set ignorecase
set smartcase
set showmatch

" Syntax and formatting
syntax on
set encoding=utf-8
set formatoptions=tcqrn1
set hidden

" Tabs and indenting
" set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround
set scrolloff=5
set backspace=indent,eol,start

" Command line completion options
set showcmd
set wildmenu

" Colors
"set background=dark
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1

" Remappings
" Autocomplete brackets and quotation marks
"inoremap ( ()<ESC>hli
"inoremap { {}<ESC>hli
"inoremap [ []<ESC>hli
"inoremap ' ''<ESC>hli
"inoremap " ""<ESC>hli
"inoremap ` ``<ESC>hli
" Swap colon and semicolon keys to make entering command mode easier
"nnoremap ; :
"nnoremap : ;
" Don't exit visual mode after indenting
"vnoremap > >gv
"vnoremap < <gv

" Plugins
" set the runtime path to include Vundle and initialize
"set rtp+=~/.vim/bundle/Vundle.vim
"call vundle#begin()
" Vundle plugin to manage vundle, required
"Plugin 'VundleVim/Vundle.vim'

" Add custom plugins here
"Plugin 'tpope/vim-fugitive'
"Plugin 'tpope/vim-surround'
"Plugin 'tpope/vim-commentary'
"Plugin 'morhetz/gruvbox'
"Plugin 'christoomey/vim-tmux-navigator'

"call vundle#end()
"filetype plugin indent on "required

" Call after plugin is loaded
"colorscheme gruvbox

" <Start Missing Semester template>

" Disable the default Vim startup message.
set shortmess+=I

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse+=a

" Try to prevent bad habits like using the arrow keys for movement. This is
" not the only possible bad habit. For example, holding down the h/j/k/l keys
" for movement, rather than using more efficient movement commands, is also a
" bad habit. The former is enforceable through a .vimrc, while we don't know
" how to prevent the latter.
" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

