" Auto-install VimPlug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !mkdir -p ~/.vim/autoload
    silent !curl -fLo ~/.vim/autoload/plug.vim
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    au VimEnter * PlugInstall
endif


" Plugins
call plug#begin('~/.local/share/vim/plugged')

Plug 'flazz/vim-colorschemes'
Plug 'sheerun/vim-polyglot'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'raimondi/delimitmate'
Plug 'yggdroot/indentline'
Plug 'neomake/neomake'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'valloric/listtoggle'
Plug 'yuttie/comfortable-motion.vim'
Plug 'tpope/vim-fugitive'
Plug 'brooth/far.vim'
Plug 'davidhalter/jedi-vim'
Plug 'hdima/python-syntax'
Plug 'majutsushi/tagbar'
Plug 'sjl/gundo.vim'
Plug 'scrooloose/nerdtree'

call plug#end()


" Settings
set number
set showcmd
set expandtab
set tabstop=4
set shiftwidth=4
set ignorecase
set smartcase
" Save undo history
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "", 0700)
endif
set undodir=~/.vim/undodir
set undofile
set noshowmode
set colorcolumn=80,100
set mouse=a
set cursorline
set formatoptions+=j


" Functions
" Toggle relative line numbers
function! NumberToggle() abort
    if(&relativenumber == 1)
        set nornu
        set number
    else
        set rnu
    endif
endfunc


" Appearance
syntax on
colorscheme jellybeans
set background=dark

" Global variables
let g:python_host_prog = '/home/elkasitu/.pyenv/versions/2.7.13/bin/python'
let g:python3_host_prog = '/home/elkasitu/.pyenv/versions/3.5.4/bin/python'

" Fzf
let g:fzf_buffers_jump = 1

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#syntastic#enabled = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" Neomake
let g:neomake_python_flake8_maker = {'args': ['--max-line-length=99']}
let g:neomake_python_enabled_makers = ['flake8']

" GitGutter
set signcolumn=yes

" Jedi-vim
let g:jedi#show_call_signatures = "1"
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "<leader>k"
let g:jedi#usages_command = "<leader>u"
let g:jedi#completions_command = "<C-space>"
let g:jedi#rename_command = "<leader>x"

" Misc
let mapleader = "-"


" Language
set encoding=utf-8
let $LANG='en'
set langmenu=en


" Autocmd
autocmd BufWritePost * Neomake


" Mappings
" FZF
nnoremap <C-p>a :Ag
nnoremap <C-p>b :Buffers<CR>
nnoremap <C-p>c :Commands<CR>
nnoremap <C-p>f :Files<CR>
nnoremap <C-p>g :GitFiles<CR>
nnoremap <C-p>r :History<CR>
nnoremap <C-p>: :History:<CR>
nnoremap <C-p>/ :History/<CR>
nnoremap <C-p>l :BLines<CR>
nnoremap <C-p>m :Marks<CR>
nnoremap <C-p>t :Tags<CR>

" Comfortable Motion
noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp> :call comfortable_motion#flick(-40)<CR>

" Tagbar
nnoremap <F8> :TagbarToggle<CR>

" Gundo
nnoremap <F5> :GundoToggle<CR>

" NERDTree
nnoremap <F3> :NERDTreeToggle<CR>

" Neomake
nnoremap <leader>m :Neomake<CR>

" Misc
nnoremap <leader>r :call NumberToggle()<CR>
nnoremap <leader>p :bp<CR>
nnoremap <leader>n :bn<CR>
nnoremap <space> za
