set nocompatible
filetype off

call plug#begin()

Plug 'altercation/vim-colors-solarized'
Plug 'arouene/vim-ansible-vault'
Plug 'chriskempson/base16-vim'
Plug 'dahu/Asif'
Plug 'dahu/vim-asciidoc'
Plug 'dahu/vimple'
Plug 'davewongillies/vim-eyaml'
Plug 'garbas/vim-snipmate'
Plug 'glench/vim-jinja2-syntax'
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'jamessan/vim-gnupg'
Plug 'lervag/vimtex'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'noprompt/vim-yardoc'
Plug 'rodjek/vim-puppet'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips', { 'commit': '53c2333bee77720e7f30edcdef51341e26152717' }
Plug 'terryma/vim-multiple-cursors'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-perl/vim-perl'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/SyntaxRange'

call plug#end()

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

" Toggle nerdtree
map <C-k> :NERDTreeToggle<CR>

set clipboard=unnamedplus
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
" set noswapfile
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
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set showbreak=↪\
"set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set viminfo='10,\"100,:20,%,n~/.viminfo  " Tell vim to remember certain things when we exit
                                         "  '10  :  marks will be remembered for up to 10 previously edited files
                                         "  "100 :  will save up to 100 lines for each register
                                         "  :20  :  up to 20 lines of command-line history will be remembered
                                         "  %    :  saves and restores the buffer list
                                         "  n... :  where to save the viminfo files

" undo stuff taken from https://stackoverflow.com/a/22676189/157108
" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*
set iskeyword+=:

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

" VimTeX
let g:vimtex_compiler_method = 'latexmk'
let maplocalleader = "´"

" vim-airline customisations
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'hybridline'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby', 'php', 'puppet', 'yaml', 'python', 'sh', 'bash' ], }
let g:syntastic_puppet_puppetlint_args='--no-documentation-check --no-class_inherits_from_params_class-check --relative'
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_yaml_checkers = [ 'yamlxs', 'yamllint' ]
let g:syntastic_rst_checkers = ['sphinx']

let g:snipMate = { 'snippet_version' : 1 }

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
autocmd FileType haproxy setlocal commentstring=#\ %s

" Highlight and clear extra whitespace at the
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd BufWritePre * :call TrimWhiteSpace()
