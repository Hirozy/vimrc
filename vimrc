set nocompatible

syntax on                   " Enable syntax highlighting.
set nu
set encoding=utf-8
set clipboard=unnamed

:set norelativenumber
augroup relative_number
    autocmd!
    autocmd InsertEnter * :set relativenumber
    autocmd InsertLeave * :set norelativenumber
augroup END

filetype plugin indent on   " Load plugins according to detected filetype.

set tags=./.tags;,.tags     " Set tags

set shiftwidth=4            " >> indents by 4 spaces.
set tabstop=4               " Tab key indents by 4 spaces.
set expandtab               " Use spaces instead of tabs.
set shiftround              " >> indents to next multiple of 'shiftwidth'.
set autoindent              " Indent according to previous line.
set smartindent

set cursorline              " Highlight current line

set incsearch               " Highlight while searching with / or ?.
set hlsearch                " Keep matches highlighted.
nnoremap <silent> <F2>c :set hlsearch!<CR>

set showmode               " Show current mode in command-line.
set showcmd                " Show already typed keys when more are expected.

set splitbelow             " Open new windows below the current window.
set splitright             " Open new windows right of the current window.

set mouse=a                " Using the mouse

set signcolumn=yes

" Put all temporary files under the same directory.
" https://github.com/mhinz/vim-galore#handling-backup-swap-undo-and-viminfo-files
set backup
set backupdir   =$HOME/.vim/files/backup/
set backupext   =-vimbackup
set backupskip  =
set directory   =$HOME/.vim/files/swap//
set updatecount =100
set undofile
set undodir     =$HOME/.vim/files/undo/
set viminfo     ='100,n$HOME/.vim/files/info/viminfo

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'

Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

Plug 'fatih/vim-go', { 'tag': '*' }

Plug 'skywind3000/asyncrun.vim'

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.status == 'updated' ||  a:info.force
    if has('mac')
        !/usr/local/bin/python3 install.py --clang-completer --go-completer
    elseif has("win64") || has("win32") || has("win16")
        !echo "Nothing to do"
    elseif has('unix')
        !/usr/bin/python3 install.py --clang-completer --go-completer
    endif
  endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

" Plug 'davidhalter/jedi-vim'

" Plug 'Shougo/deoplete.nvim'
" Plug 'roxma/nvim-yarp'
" Plug 'roxma/vim-hug-neovim-rpc'
" Plug 'zchee/deoplete-jedi'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-indent'
" Plug 'kana/vim-textobj-syntax'
" Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
" Plug 'sgur/vim-textobj-parameter'

Plug 'terryma/vim-multiple-cursors'

Plug 'python-mode/python-mode', { 'branch': 'develop' }

Plug 'Raimondi/delimitMate'

Plug 'w0rp/ale'

Plug 'mhinz/vim-signify'

Plug 'octol/vim-cpp-enhanced-highlight'

" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" Plug 'lervag/vimtex'

" Color scheme
Plug 'altercation/vim-colors-solarized'
Plug 'tomasr/molokai'

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

Plug 'Shougo/echodoc.vim'

" Initialize plugin system
call plug#end()

" for solarized
set background=dark
colorscheme solarized

" for molokai
" colorscheme molokai
" let g:molokai_original = 1
let g:rehash256 = 1

let g:asyncrun_open=6
let g:asyncrun_bell=1
nnoremap <silent> <F10> :call asyncrun#quickfix_toggle(6) <CR>
nnoremap <silent> <F9> :AsyncRun g++ -g -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/a.out" <CR>
nnoremap <F5> :call CompileOption() <CR>
nnoremap <F6> :call CompileOptionWithInput() <CR>

nnoremap <F2><F5> :so $HOME/.vim/vimrc <CR>
nnoremap <F2>pi :PlugInstall <CR>
nnoremap <F2>pu :PlugUpdate <CR>
nnoremap <F2>pc :PlugClean <CR>
nnoremap <F2>pp :PlugUpgrade <CR>
nnoremap <C-n> :call ToggleNERD() <CR>

function! CompileOption()
    exec "w"
    if &filetype == 'cpp'
        :AsyncRun g++ -g -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/a.out"
        :sleep
        :AsyncRun -raw -mode=0 -cwd="$(VIM_FILEDIR)" "$(VIM_FILEDIR)/a.out"
    elseif &filetype == 'python' 
        :AsyncRun -cwd="$(VIM_FILEDIR)" python3 "$(VIM_FILEPATH)"
    elseif &filetype == 'tex'
        :AsyncRun -cwd="$(VIM_FILEDIR)" pdflatex  -synctex=1 -interaction=nonstopmode -file-line-error -recorder "$(VIM_FILEPATH)"
    endif
endfunction

function! CompileOptionWithInput()
    exec "w"
    if &filetype == 'cpp'
        :AsyncRun g++ -g -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/a.out"
        :call asyncrun#quickfix_toggle(6)
        :sleep
        :AsyncRun -raw -mode=2 -cwd="$(VIM_FILEDIR)" "$(VIM_FILEDIR)/a.out"
    elseif &filetype == 'python'
        :AsyncRun -cwd="$(VIM_FILEDIR)" -mode=2 python3 "$(VIM_FILEPATH)" 
    endif
endfunction

function! ToggleNERD()
    exec "NERDTreeToggle"
    :AsyncRun echo "Toggle NERDTree"
endfunction

" For airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1 


" For YCM
let g:ycm_global_ycm_extra_conf='~/.vim/ycm_extra_conf.py'
let g:ycm_add_preview_to_completeopt=0
let g:ycm_show_diagnostics_ui=0
let g:ycm_server_log_level='info'
let g:ycm_min_num_identifier_candidate_chars=2
let g:ycm_collect_identifiers_from_comments_and_strings=1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion='<c-z>'

if has('mac')
    let g:ycm_server_python_interpreter = '/usr/local/bin/python3'
elseif has('unix')
    let g:ycm_server_python_interpreter = '/usr/bin/python3'
endif

let g:ycm_python_binary_path = 'python'
let g:ycm_path_to_python_interpreter = ''
set completeopt=menu,menuone

noremap <c-z> <NOP>

let g:ycm_semantic_triggers={
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

let g:ycm_filetype_whitelist={ 
			\ 'c':1,
			\ 'cpp':1, 
			\ 'go':1,
            \ 'python':1,
            \ 'vim':1
			\ }

let g:pymode_options=1
let g:pymode_virtualenv=1

" For vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_concepts_highlight = 1


" For ale
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''

" For ultisnips
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<F1>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

" For NerdTree
let NERDTreeMinimalUI=1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" let g:jedi#popup_select_first=0
" let g:jedi#auto_vim_configuration = 0
" let g:jedi#popup_on_dot = 0

" For deoplete
" inoremap <silent><expr> <Tab>
"     \ pumvisible() ? "\<C-n>" : deoplete#manual_complete()
" let g:deoplete#enable_at_startup = 1
