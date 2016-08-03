set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/base16-vim'
Plugin 'dahu/Asif'
Plugin 'dahu/vim-asciidoc'
Plugin 'dahu/vimple'
Plugin 'gmarik/Vundle.vim'
Plugin 'godlygeek/tabular'
Plugin 'lervag/vimtex'
Plugin 'rodjek/vim-puppet'
Plugin 'scrooloose/syntastic'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tomtom/tlib_vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-tbone'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-perl/vim-perl'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/SyntaxRange'

call vundle#end()

filetype plugin indent on

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline\ 11
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

if &t_Co >= 256 || has("gui_running")
  colorscheme zenburn
endif

if &t_Co > 2 || has("gui_running")
  " switch syntax highlighting on, when the terminal has colors
  syntax on
endif

" clear highlighted search results by ,/
nmap <silent> ,/ :nohlsearch<CR>

set modeline
set cursorline
set encoding=utf-8
set fileencoding=utf-8
set history=1000                         "  remember more commands and search history
set hlsearch                             "  highlight search terms
set ignorecase                           "  ignore case when searching
set incsearch                            "  show search matches as you type
set infercase
set noerrorbells                         "  don't beep
set noshowmode
set noswapfile
set ruler
set scrolloff=2
set shiftround                           "  use multiple of shiftwidth when indenting with '<' and '>'
set shiftwidth=4                         "  number of spaces to use for autoindenting
set showmatch                            "  set show matching parenthesis
set sidescrolloff=2
set smartcase                            "  ignore case if search pattern is all lowercase, case-sensitive otherwise
set ttyfast
set undolevels=1000                      "  use many muchos levels of undo
set visualbell                           "  don't beep
set whichwrap+=<,>,[,]
set wildignore=*.swp,*.bak,*.pyc,*.class
set viminfo='10,\"100,:20,%,n~/.viminfo  " Tell vim to remember certain things when we exit
                                         "  '10  :  marks will be remembered for up to 10 previously edited files
                                         "  "100 :  will save up to 100 lines for each register
                                         "  :20  :  up to 20 lines of command-line history will be remembered
                                         "  %    :  saves and restores the buffer list
                                         "  n... :  where to save the viminfo files

" vim-airline customisations
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'hybridline'

let g:syntastic_puppet_puppetlint_args='--no-documentation-check --no-class_inherits_from_params_class-check --relative'
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby', 'php', 'puppet', 'yaml', 'python' ], }

function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction

" Restore cursor position
augroup resCur
    autocmd!
    autocmd BufReadPost * call setpos(".", getpos("'\""))
augroup END

augroup gzip
    autocmd!
    autocmd BufReadPre,FileReadPre *.gz set bin
    autocmd BufReadPost,FileReadPost   *.gz '[,']!gunzip
    autocmd BufReadPost,FileReadPost   *.gz set nobin
    autocmd BufReadPost,FileReadPost   *.gz execute ":doautocmd BufReadPost " . expand("%:r")
    autocmd BufWritePost,FileWritePost *.gz !mv <afile> <afile>:r
    autocmd BufWritePost,FileWritePost *.gz !gzip <afile>:r
    autocmd FileAppendPre      *.gz !gunzip <afile>
    autocmd FileAppendPre      *.gz !mv <afile>:r <afile>
    autocmd FileAppendPost     *.gz !mv <afile> <afile>:r
    autocmd FileAppendPost     *.gz !gzip <afile>:r
augroup END

autocmd filetype yaml set ai sw=2 sts=2 et
autocmd BufRead,BufNewFile haproxy*.cfg* set ft=haproxy
autocmd BufNewFile,BufReadPost *.md,*.markdown set filetype=markdown

" Highlight and clear extra whitespace at the
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd BufWritePre * :call TrimWhiteSpace()
