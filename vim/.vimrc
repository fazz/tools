set autoindent
set cindent
set tabstop=4
set expandtab
set shiftwidth=4
set hlsearch
set ruler
set modeline
set modelines=5
set visualbell

filetype plugin indent on

map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_
set wmh=0

set printoptions=number:y

setlocal cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,g0,hs,ps,ts,+s,c3,C0,(2s,us,\U0,w0,m0,j0,)20,*30

set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
au BufNewFile,BufRead *.ice	setf slice

if &t_Co > 1
    syntax enable
    colorscheme fazz
    set background=dark
endif

set list listchars=tab:>-,trail:.,extends:>
set nolist

