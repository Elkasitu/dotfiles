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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'junegunn/fzf', {'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'valloric/listtoggle'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'
Plug 'simnalamburt/vim-mundo'
Plug 'scrooloose/nerdtree'
Plug 'rust-lang/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'neovimhaskell/haskell-vim'
Plug 'leafgarland/typescript-vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ayu-theme/ayu-vim'

call plug#end()


" Settings
set number
set showcmd
set expandtab
set tabstop=4
set shiftwidth=4
set ignorecase
set smartcase
set nomodeline
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
set colorcolumn=100
set mouse=a
set cursorline
set formatoptions+=j
set wildignore=*.pyc
set updatetime=100


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

" Search for a model definition within Odoo
function! SearchModelDefinition(model) abort
    call RipgrepFzf('\b_name.*' . a:model . '[''"\]]+$', 0)
endfunc

function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:' . reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

" Custom commands
command! -nargs=1 SearchModelDefinition call SearchModelDefinition(<q-args>)
command! -bang -nargs=* Rg call RipgrepFzf(<q-args>, <bang>0)

" Appearance
syntax on
colorscheme ayu
autocmd ColorScheme * highlight Crap ctermbg=red guibg=red
set background=dark
set termguicolors

" Global variables
let g:python_host_prog = '/home/elkasitu/.pyenv/versions/3.6.8/bin/python'
let g:python3_host_prog = '/home/elkasitu/.pyenv/versions/3.6.8/bin/python'

" Fzf
let g:fzf_buffers_jump = 1
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='tomorrow'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

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

" GitGutter
set signcolumn=yes

" Misc
let mapleader = "-"


" Language
set encoding=utf-8
let $LANG='en'
set langmenu=en


" Autocmd
" Match trailing WS
match Crap /\s\+$/
autocmd BufWinEnter * match Crap /\s\+$/
" Git conflicts
autocmd BufWinEnter * match Crap '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" More trailing WS
autocmd InsertEnter * match Crap /\s\+\%#\@<!$/
autocmd InsertLeave * match Crap /\s\+$/
autocmd BufWinLeave * call clearmatches()
" Rofi theme files
autocmd BufNewFile,BufRead /*.rasi setf css


" Mappings
" FZF
nnoremap <C-p>a :Rg 
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
nnoremap <C-p>q :BTags<CR>

" Odoo
nnoremap <C-p>o :SearchModelDefinition 

" Tagbar
nnoremap <F8> :TagbarToggle<CR>

" Gundo
nnoremap <F5> :MundoToggle<CR>

" NERDTree
nnoremap <F3> :NERDTreeToggle<CR>

" Misc
nnoremap <leader>r :call NumberToggle()<CR>
nnoremap <leader>p :bp<CR>
nnoremap <leader>n :bn<CR>
nnoremap <space> za
nmap <leader>v <Plug>(coc-rename)

" Copy/Cut/Paste from XOrg's CLIPBOARD buffer
" requires vim compiled with the +clipboard flag
if has('clipboard')
    vnoremap <C-c> "+y
    vnoremap <C-x> "+d
    nnoremap <C-c> "+yy
    nnoremap <C-x> "+dd
    nnoremap <C-v> "+p
endif

" Make d/dd send contents to the black hole register by default
nnoremap d "_d
