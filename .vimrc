"
"   _____                  _            _             _                    
"  |  __ \                (_)          ( )           (_)                   
"  | |  | | __ _ _ __ ___  _  ___ _ __ |/ ___  __   ___ _ __ ___  _ __ ___ 
"  | |  | |/ _` | '_ ` _ \| |/ _ \ '_ \  / __| \ \ / / | '_ ` _ \| '__/ __|
"  | |__| | (_| | | | | | | |  __/ | | | \__ \  \ V /| | | | | | | | | (__ 
"  |_____/ \__,_|_| |_| |_|_|\___|_| |_| |___/ (_)_/ |_|_| |_| |_|_|  \___|
"                                                                          
"                                                                          
"          (title created with http://patorjk.com/software/taag)
"

" ------------------------------------------------------------------------------
"                                 Basic Settings                                
" ------------------------------------------------------------------------------
call pathogen#runtime_append_all_bundles()
autocmd!

set nocompatible                " no need to remain compatible
let mapleader = ','             " change map leader
set wrapscan                    " wrap around when searching ?
set ch=2                        " make command-line two lines high
set nu                          " show line numbers
set mousehide                   " hide the mouse
set scrolloff=4                 " keep the cursor four lines off the edge
set foldmethod=marker           " use markers for folds
set nohls                       " don't highlight searches
set hl+=sr                      " invert status bar
set hl+=Sr                      " invert other status bars
set backspace=indent,eol,start  " backspace over everything in insert mode
set tabstop=4                   " tab width
set shiftwidth=4                " when shifting
set hidden                      " enable hidden buffers
set laststatus=2                " always have a status line
set showcmd                     " show current command
set noshowmode                  " don't show the mode in insert, visual, etc.
set backup                      " save backup files
set backupdir=~/.backup         " save them in the backup folder
set incsearch                   " set incremental search
set tags+=./tags                " include local tags

" status line
set stl=%f\ (%Y)\ Line\ %l/%L\ -\ Column\ %c\ %w%h%r\ %{VCSStatus()}

filetype on                      " filetype plugin
filetype plugin indent on        " switch it on
syntax on                        " turn on syntax highlighting

nmap <silent> <Leader>cd :lcd %:h<cr>
nmap <silent> <Leader>md :!mkdir -p %:p:h<cr>
nmap <silent> <Leader>u yyp :s/./-/g<cr>
nmap <silent> <Leader>t :call Tag()<cr>

function! Tag()
    ! ctags -R .
endfunction

" ------------------------------------------------------------------------------
"                             Windoze Compatability                            
" ------------------------------------------------------------------------------

if has('win32')
    let $HOME = $USERPROFILE
    let $SETTINGS = $HOME.'\vimfiles'
    nmap <silent> <C-CR> :silent !start cmd.exe<cr>
    " make sure we don't start in C:\WINDOWS\system32
    if getcwd() == $SYSTEMROOT.'\system32'
        cd $HOME
    endif
else
    " default settings path
    let $SETTINGS = $HOME.'/.vim'
    nmap <silent> <C-CR> :silent !gnome-terminal --geometry=114x32+200+200 &<cr>
endif

" ------------------------------------------------------------------------------
"                              Quick-edit Commands                              
" ------------------------------------------------------------------------------

" Edit/source vimrc's
nmap <silent> <Leader>ev :e $MYVIMRC<cr>
nmap <silent> <Leader>sv :so $MYVIMRC<cr>
nmap <silent> <Leader>eg :e $MYGVIMRC<cr>
nmap <silent> <Leader>sg :so $MYGVIMRC<cr>

" Edit filetype file (when the hell was the last time I used this?)
nmap <silent> <Leader>et :let $filetype=&filetype<cr>:e $SETTINGS/ftplugin/$filetype.vim<cr>

" Edit/source .in.vim (hidden source script)
nmap <silent> <Leader>ei :e .in.vim<cr>
nmap <silent> <Leader>si :so .in.vim<cr>

" Switching to/from header files (a.vim)
nmap <silent> <Leader>a :A<cr>

" Default build/clean shortcuts
nmap <F11> :make!<cr>
nmap <S-F11> :make! clean<cr>
if has("autocmd")
    au QuickFixCmdPost * botright 8cw
endif


" ------------------------------------------------------------------------------
"                                Window Mappings                                
" ------------------------------------------------------------------------------

" Close windows and delete/move between buffers
nmap <silent> <C-c> :close<cr>
nmap <silent> <C-PageDown> :bn<cr>
nmap <silent> <C-PageUp> :bp<cr>

" Move between windows
nmap <silent> <C-j> <C-w>j
nmap <silent> <C-k> <C-w>k
nmap <silent> <C-h> <C-w>h
nmap <silent> <C-l> <C-w>l

" List buffers
nnoremap <F5> :ls<cr>:buffer<space>

" Let semicolon be good enough to start commands
nmap <silent> ; :

" ------------------------------------------------------------------------------
"                             Environment Variables                            
" ------------------------------------------------------------------------------
"   Nothing here right now

" ------------------------------------------------------------------------------
"                                 Plugin Options                                
" ------------------------------------------------------------------------------

nmap <silent> <F7> :NERDTreeToggle<cr>
let NERDTreeIgnore = ['\.o$', '\.h$', '\.class$', '\.hi$']

nmap <silent> <F8> :TagbarToggle<cr>

" ------------------------------------------------------------------------------
"                                Filetype Options                                
" ------------------------------------------------------------------------------
if has("autocmd")
    " Set java omnifunction and doc search
    au filetype java setlocal omnifunc=javacomplete#Complete

    au filetype c set tags+=~/.vim/tags/c.tags

    " Use autoindenting and spaces for haskell files
    au filetype haskell setlocal autoindent
    au filetype haskell setlocal expandtab
endif

" ------------------------------------------------------------------------------
"                                 create Headers                                
" ------------------------------------------------------------------------------

function! s:GetHeaderSpaceCount(str, n)
    return (a:n - len(a:str)) / 2
endfunction

function! s:RoundSpaces(str)
    if (len(a:str) % 2) == 1
        return a:str.' '
    endif
    return a:str
endfunction

function! GetHeader(str)
    let header_width = 80
    if &filetype =~ 'vim'
        let sep = '" '.repeat('-', header_width-2)
        let blank = repeat(' ', s:GetHeaderSpaceCount(a:str, header_width-2))
        let title = '" '.blank.a:str.s:RoundSpaces(blank)
        return sep."\n".title."\n".sep
    elseif &filetype =~ 'haskell'
        let sep = '{-'.repeat('-', header_width-4).'-}'
        let blank = repeat(' ', s:GetHeaderSpaceCount(a:str, header_width-4))
        let title = '{-'.blank.a:str.s:RoundSpaces(blank).'-}'
        return sep."\n".title."\n".sep
    else
        return 'Unrecognized filetype.'
    endif
endfunction

" ------------------------------------------------------------------------------
"                                 GVim Settings                                
" ------------------------------------------------------------------------------

if has("gui_running")
    colorscheme slate2
    set guioptions-=T
    set guioptions-=L
    nmap <F9> :set lines=45 columns=150<cr>
    if has("gui_gtk2")
        set guifont=Droid\ Sans\ Mono\ 8
    else
        set guifont=ProggyCleanTT:h12
    endif
endif
