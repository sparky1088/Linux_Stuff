" Show line numbers.
set number
" Show line number on the current line and relative numbers on all other lines.
"set relativenumber
" Spell checker
"set spell
" Set auto indent
set ai
" Shows a status line
"set ls=2
" set laststatus=2
" Makes sure that spaces are used for indenting lines,
"     even when you press the "Tab" key
set expandtab
" This will insert 4 spaces for a line indent
set tabstop=4
" Set shift width to 4 spaces.
set shiftwidth=4
" Turn syntax highlighting on.
syntax on
" Highlight cursor line underneath the cursor horizontally.
set cursorline
" Highlight cursor line underneath the cursor vertically.
"set cursorcolumn
" Show file stats.
set ruler
" Show color column at 80 characters width,
"     visual reminder of keepingcode line within a popular line width.
"set colorcolumn=80
" Wraps text instead of forcing a horizontal scroll
" Mouse support
set mouse=a
set wrap
" Do not wrap lines. Allow long lines to extend as far as the line goes.
"set nowrap
" Reacts to the syntax/style of the code you are editing
set smartindent
" Enable auto completion menu after pressing TAB.
set wildmenu
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest
" There are certain files that we would never want to edit with Vim.
"     Wildmenu will ignore files with these extensions.
set wildignore+=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx
set wildignore+=.pyc,.swp:
"Show what mode you are currently editing in
set showmode
"Shows partial commands in the last line of the screen
set showcmd
" setting fold method
"set foldmethod=indent
" Enable type file detection.
"     Vim will be able to try to detect the type of file in use.
filetype on
" Enable plugins and load plugin for the detected file type.
filetype plugin on
" Load an indent file for the detected file type.
filetype indent on
" While searching though a file incrementally highlight matching characters
"     as you type.
set incsearch
" Ignore capital letters during search.
set ignorecase
" Override the ignorecase option if searching for capital letters.
"     This will allow you to search specifically for capital letters.
set smartcase
" Show matching words during a search.
set showmatch
" Use highlighting when doing a search.
set hlsearch
" Set the commands to save in history default number is 20.
set history=1000
colorscheme murphy
" This fixes the solaris color not being right after appling settings
set termguicolors
" PLUGINS ---------------------------------------------------------------- {{{

" Plugin code goes here.

" }}}


" MAPPINGS --------------------------------------------------------------- {{{

" Mappings code goes here.

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" More Vimscripts code goes here.
" If the current file type is HTML, set indentation to 2 spaces.
autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=10000
endif

" You can split a window into sections by typing `:split` or `:vsplit`.
" Display cursorline and cursorcolumn ONLY in active window.
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline cursorcolumn
augroup END
" }}}

" STATUS LINE ------------------------------------------------------------ {{{
" Status bar code goes here.
" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
"set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%
set statusline+=row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}
