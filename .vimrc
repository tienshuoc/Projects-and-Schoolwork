"Indentation Options
set autoindent "New lines inherit the indentation of previous lines
set expandtab "Convert tabs to spaces
filetype plugin indent on "Enable indentation rules, syntax highlighting that are file-type specific
set shiftwidth=4 "When shifting, indent using 4 spaces
set smarttab "Insert "tabstop" number of spaces when the "tab" key is pressed
set softtabstop=4 "Indent using 4 spaces
set tabstop=4 "Tab size is equal to 4 spaces

"Search Options
set hlsearch "Enable search highlighting
set ignorecase "Ignore case when searching
set incsearch "Incremental search that shows partial matches
set smartcase "Automatically switch search to case-sensitive when search query contains an uppercase letter

"Performance Options
set complete-=i "Limit the files searched for auto-completes

"Text Rendering Options
set display+=lastline "Always try to show a paragraph's last line
set encoding=utf-8 "Use an encoding that supports unicode
set linebreak "Avoid wrapping a line in the middle of a word
set scrolloff=1 "The number of screen lines to keep above and below the cursor (a large value causes the cursor to stay in the middle line when possible
syntax enable "Enable syntax highlighting
set wrap "Enable line wrapping (display on newline when line is full to prevent horizontal scrolling

"User Interface Options
set laststatus=2 "Always display the status bar
set ruler "Always show cursor position in status bar
set wildmenu "Display command line's tab complete options as a menu


set number "Show line numbers on the sidebar
set relativenumber "Show relative numbers to current line
set mouse=a "Enable mouse for scrolling and resizing
set title "set the window's title, reflecting the file currently being edited
set background=dark "Vim will try to use colors that suit a dark background

"Code Folding Options
"set foldmethod=indent "Fold based on indentation levels

"Miscellaneous Options
set backspace=indent,eol,start "Allow backspacing over indentation, line breaks and insertion start
"set confirm "Display a confirmation dialog when closing an unsaved file
set history=1000 "Increase the undo limit
"set noswapfile  "Disable swap files

set nocompatible "Enable enhancements and improvements of Vi




"KEY MAPPINGS
"remap esc, enter normal mode by typing two j
imap jj <Esc> 
"press 'J'/'K' in visual mode to move selected text down/up with autoformatting
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


"set cursor to straigh line in insert mode
"let &t_SI .= "\e[=1c"
"let &t_EI .= "\e[=2c"
if has("autocmd")
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' | 
    \   silent execute '!echo -ne "\e[6 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[4 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif

"GNOME Terminal (version 2.26):
"if has("autocmd")
"  au InsertEnter * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
"  au VimEnter,InsertLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape block"
"  au VimLeave * silent execute "!gconftool-2 --type string --set /apps/gnome-terminal/profiles/Default/cursor_shape ibeam"
"endif


" PLUGINS
" Vim-Plug settings (':PlugInstall' to install)
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'frazrepo/vim-rainbow' "color paired brackets
Plug 'preservim/nerdcommenter' "quick commenter ('\cc' to comment out,'\cu' to uncomment,'\cA' to add appending comment)
Plug 'itchyny/lightline.vim' "lightline (status bar) 
Plug 'jiangmiao/auto-pairs' "auto add, delete bracket pairs
Plug 'tpope/vim-surround' "vim surround
Plug 'yegappan/taglist' "taglist
"colorschemes
Plug 'dracula/vim',{'as':'dracula'}
Plug 'morhetz/gruvbox'
Plug 'tomasr/molokai'
Plug 'flazz/vim-colorschemes' "All colorschemes
"Tomorrow-Night

call plug#end()
colorscheme gruvbox
let g:rainbow_active = 1
