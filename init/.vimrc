set nocp
syntax on
filetype plugin indent on


" Vundle Packages
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'octol/vim-cpp-enhanced-highlight'
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
  Plugin 'moll/vim-bbye'
call vundle#end()
filetype plugin indent on

" Plug packages
call plug#begin()
  Plug 'ParamagicDev/vim-medic_chalk'
  Plug 'luochen1990/rainbow'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
call plug#end()

" Remove trailing whitespace
" autocmd BufWritePre * %s/\s\+$//e

" Colors
colorscheme medic_chalk

highlight Normal ctermfg=046 ctermbg=NONE
highlight Visual ctermfg=129 ctermbg=NONE 
highlight VertSplit cterm=NONE ctermfg=NONE ctermbg=NONE
highlight LineNr  cterm=NONE ctermfg=NONE ctermbg=NONE
highlight CursorColumn cterm=NONE ctermbg=NONE
highlight CursorLine cterm=NONE ctermbg=232
highlight StatusLine   ctermbg=100 ctermfg=0 cterm=NONE 
highlight StatusLineNC ctermbg=14 ctermfg=0 cterm=inverse 
hi modemsg ctermfg=129 ctermbg=NONE
"autocmd InsertEnter * highlight CursorLine cterm=NONE ctermbg=233
let g:airline_theme='term'
let g:rainbow_active = 1
set fillchars=vert:\ 


" 80 Character indicator
let &colorcolumn=101
highlight ColorColumn ctermfg=5 ctermbg=52

" Multi-Cursor selection
map   <C-LeftMouse>         <Plug>(VM-Mouse-Cursor)
" Easy access escape key
let mapleader=" "
"map 00 <Esc>
"imap 00 <Esc>
"vmap 00 <Esc>

set timeoutlen=500 ttimeoutlen=0 
nnoremap <Insert> a
inoremap <Insert> <Esc> 
noremap <Leader><Leader> :
noremap \ :
"noremap <silent> <Leader> <Esc>:noh<CR>
noremap <silent> <ESC>OA <Up>
noremap <silent> <ESC>OB <Down>
noremap <silent> <ESC>OC <Right>
noremap <silent> <ESC>OD <Left>

noremap <Leader>e :e 
noremap <Leader>b :b 
noremap <Leader>w :update<CR>
noremap <Leader>r :so %<CR>
noremap <Leader>q :q<CR>
noremap <Leader>Q :qa<CR>
noremap <Leader>k :Bdelete<CR>
noremap <Leader>v :100vsplit<CR>
noremap <Leader>V :split<CR>
noremap <Leader>l :ls<CR>
"noremap <del> "_x
noremap <silent> ss yy

noremap <silent> a :wincmd h<CR><Esc>
noremap <silent> s y 

noremap <silent> f :wincmd l<CR><Esc>

noremap <silent> h B


noremap <silent> l h
noremap <silent> ; l
noremap <silent> ' w

noremap <silent> A :bp<CR>
noremap <silent> S p 
noremap <silent> F :bn<CR>

noremap <silent> G G
noremap <silent> H 0
noremap <silent> J 3<C-Y>
noremap <silent> K 3<C-E>
noremap <silent> L }
noremap <silent> : {
noremap <silent> " $

map o o<Esc>
map c c<Esc>
noremap I a
"Keep cursor in same position after leaving insert
"au InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])
map <PageDown> <ESC>4<C-E>
map <PageUp> <ESC>4<C-Y>
imap <PageDown> <Esc>4<C-E>
imap <PageUp> <Esc>4<C-Y>

nmap Q <Esc>
nmap q <Esc>
noremap <C-s> <nop>
noremap <C-S> <nop>
nmap <C-d> D

" Use Alt-Arrows to switch windows
noremap <silent> <A-Up> <Esc>:wincmd k<CR>
noremap <silent> <A-Down> <Esc>:wincmd j<CR>
noremap <silent> <A-Left> <Esc>:wincmd h<CR>
noremap <silent> <A-Right> <Esc>:wincmd l<CR>

" Have Vim jump to the last position when reopening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif



"autocmd FileType c,cpp,java,php autocmd BufWritePre <buffer> %s/\s\+$//e
" Options
set nobackup
set showcmd		      " Show (partial) command in status line.
set showmatch		    " Show matching brackets.
set incsearch		    " Incremental search
set autowrite		    " Automatically save before commands like :next and :make
set hidden		      " Hide buffers when they are abandoned
set mouse=a		      " Enable mouse usage (all modes)
set modelines=0     " Turn off modelines
set wrap
set textwidth=100
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set scrolloff=5
set backspace=indent,eol,start
set ttyfast
set laststatus=2
set showmode
set number          " Show line numbers
set autoindent
set autochdir
set ignorecase		  " Do case insensitive matching
set smartcase		    " Do smart case matching
set hlsearch
set incsearch
set scrolloff=0
set noswapfile
set cursorline 
set splitbelow
set splitright
set wildmode=longest,list
set wildmenu

set ead=both 
" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif
