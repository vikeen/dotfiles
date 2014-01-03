" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

"set backup                  " keep a backup file
"set backupdir=~/.vim/backup " where to put backup files
set ruler                   " show the cursor position all the time
set showcmd	                " display incomplete commands
set incsearch               " do incremental searching
 
" Don't use Ex mode, use Q for formatting
map Q gq

" TODO More hotkeys. These open an older version of the current file in
" a horizontal split, and highlight the differences. The first opens
" the most recently saved version of the file; the second opens the
" most recently committed version of the file in the current branch;
" and the third opens the version of the file one revision earlier than
" that in the current branch.

" In an xterm the mouse should work quite well, thus enable it.
set mouse=a

" Allow 256-color mode
set t_Co=256

source $VIMRUNTIME/menu.vim
set wildmenu
set wildmode=longest:full
set cpo-=<
set wcm=<C-Z>
"set listchars=tab:>-,trail:-
"set list
map <F4> :emenu <C-Z>

" Ethan tweaks:
    " set auto indention on
    " keep (up to) 2000 lines of command history
    " Always show the tab-line
    " Reserve 4 columns for folding info
    " Re-color folding highlights
    " Load monolithic tag files
    " When browsing directories, open files in horiz. split by default
    " Use four spaces for (new) tabs and default indentations
    " Turn on syntactic folding for perl, bash scripts, javascript, c, c++,
    "       vim, (pl/)sql, html, xml, and xhtml
    " Use indent-type folding for all other filetypes
    " Only open the top-most folding level
    " Set PL/SQL as the default filetype for all .sql files (see sql.vim)

set autoindent
set history=2000
set showtabline=2
set foldcolumn=4
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set foldmethod=indent
set foldlevelstart=20
set foldminlines=1
"set tags=/home/jmrake/proc.tags,/home/jmrake/js.tags,/home/jmrake/sql.tags,/home/jmrake/perl.tags,/home/jmrake/xml.tags,/home/jmrake/fc_proc.tags,/home/jmrake/fc_js.tags,/home/jmrake/fc_sql.tags,/home/jmrake/fc_perl.tags,/home/jmrake/fc_xml.tags

let g:netrw_browse_split = 3    " <cr> opens files in a new tab (dir browsing mode)
let g:netrw_keepdir = 0         " Keep the current directory the same as the browsing directory
let g:netrw_liststyle = 1       " List time-stamp information and file size during browsing (help page on netrw is incorrect)
let g:netrw_list_hide = '^\..*' " When hiding is turned on, hide all files and directories starting with a period (use 'a' to toggle hiding)
let g:netrw_maxfilenamelen = 64 " We have some long file names, so this needs to be adjusted to keep the columns lined up.

colorscheme desert256-ethan " Use easily legible (and varied) coloring for syntax

let g:sql_type_default = 'plsql'    " style .sql files like pl/sql by default
let g:is_bash = 1                   " style shell scripts like bash by default

" A few languages' syntax-coloring plugins have built-in folding that's turned off by default,
" so, we need to turn those on:
let perl_fold = 1               " Perl
let perl_fold_blocks = 1        " (ditto)
let perl_include_pod = 1        " (ditto)
let g:tex_fold_enabled = 1      " (La)TeX
let g:sh_fold_enabled = 1       " Bash
let javascript_fold = 1         " JavaScript
let g:xml_syntax_folding = 1    " XML

" Turn on CSS for HTML generation
let g:html_use_css = 1
let g:html_ignore_folding = 1

" Oracle defaults for the sql*plus plug-in
let g:sqlplus_userid = ''
let g:sqlplus_passwd = ''
let g:sqlplus_db = ''

autocmd Syntax c,cpp,vim,xml,html,xhtml,perl,sh,tex setlocal foldmethod=syntax   " Override with syntactic if possible
autocmd Syntax c,cpp,perl normal zM
autocmd Syntax xml,html,xhtml,javascript normal zM | zr
" Open one extra fold level in perl modules, since the whole module itself
" is foldable (and we don't want that folded by default). 
autocmd BufNewFile,BufRead *.pm normal zr
autocmd Syntax xml setlocal foldcolumn=8    " There's too much nesting in XML for only 4 columns to be useful
autocmd Syntax xml setlocal nowrap          " Don't wrap lines in XML

autocmd BufNewFile,BufRead *.tex set formatprg=fmt\ -s\ -w\ 105\ |
autocmd BufNewFile,BufRead *.tex setlocal textwidth=98
autocmd BufNewFile,BufRead *.txt set formatprg=fmt\ -s\ -w\ 80\ |
autocmd BufNewFile,BufRead *.txt setlocal textwidth=74
" This formats comments (such as this line)
autocmd Syntax c,cpp,pc set formatprg=fmt\ -p\ //\ |
autocmd Syntax vim set formatprg=fmt\ -p\ \\\"\ \ |
autocmd Syntax perl set formatprg=fmt\ -p\ #\ \ |

autocmd BufNewFile,BufRead c,cpp,sh runtime! ftplugin/man.vim

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig    new | set bt=nofile | r ++edit # | 0d_ | diffthis
	 	\ | wincmd p | diffthis
"map <C-D>           :DiffOrig<CR>

" This command opens a new browsing tab for the current file's containing
" directory.
map <C-A>           :Texplore<CR>

" This command opens a buffer and formats the current file (expanding
" folds, keeping syntax coloring) to html.
"map <C-W>           :TOhtml<CR>

" Add some hotkeys to change the display width of soft-tabs
" Ctrl-t, Ctrl-t sets soft-tabs to 8 spaces
" Ctrl-t, (pause) sets soft-tabs to 4 spaces
map <C-t> :set ts=4<CR>
map <C-t><C-t> :set ts=8<CR>

" Toggle things that making copying out of vim a pain:
map <silent> <F3>       zi :set foldcolumn=4<cr>
map <silent> <F3><F3>   zi :set foldcolumn=0<cr>

" When editing perl, add a map for perltidy
autocmd Syntax perl vmap <leader>t :!perltidy<cr>
autocmd Syntax perl nmap <leader>t :%!perltidy<cr>

" Map [ALT]+[LMB]+Drag to visual block select
noremap <M-LeftMouse> <LeftMouse><ESC><C-V>
noremap <M-LeftDrag> <LeftDrag>

" Map VT F17 and F18 to b and e, respectively, to allow <C-Left> and <C-Right>
" to skip backward and forward by words. This requires SecureCRT to map
" <C-Left> and <C-Right> to VT F17 and F18.
map [31~          b
map [32~          e
map [33~          {
map [34~          }

" Set up the :ha[rdcopy] command so that it creates a pdf of the current
" buffer instead of actually trying to print it. This uses ghostscript (gs)
" and ps2pdf.

set printexpr=PrintFile(v:fname_in)
function PrintFile(fname)
  call system("ps2pdf " . a:fname)
  call delete(a:fname)
  return v:shell_error
endfunc

