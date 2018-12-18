"--------------------------------------------------------------------
" 선행사항
"--------------------------------------------------------------------
" 1. vimrc 파일에 이 파일 내용 복사
" Linux:   $ vim ~/.vimrc
" Windows: $ gvim %USERPROFILE%/_vimrc
"
" 2. Plugin 관리를 위한 Vundle 설치
" Linux:   $ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" Windows: $ git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/

"--------------------------------------------------------------------
" Basic 2-1
"--------------------------------------------------------------------
set nocompatible      " 오리지날 VI와 호환하지 않음

"--------------------------------------------------------------------
" Encoding
"--------------------------------------------------------------------
set encoding=utf-8    "기본 utf-8로 인코딩

" Windows의 경우 파일 생성시 cp949
if has('win32')
    autocmd BufNewFile * set fenc=cp949
endif

" 파일 열 때, 순서대로 인코딩 체크(fileencodings와 동일)
set fencs=ucs-bom,utf-8,cp949,euc-kr,latin1

" 터미널별로 인코딩 설정
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
    set tenc=utf-8
else
    set tenc=cp949
endif

"--------------------------------------------------------------------
" Like Another Windows Editor
"--------------------------------------------------------------------
"if has('win32')
  "source $VIMRUNTIME/vimrc_example.vim
  "source $VIMRUNTIME/mswin.vim 
  "behave mswin  
"endif
 
"--------------------------------------------------------------------
" Gui - Font, Colorscheme, Backgroud, Bar
"--------------------------------------------------------------------
"<Font>
set encoding=utf-8
let guifontsize=12
let guifontwidesize=13
let &guifont="Consolas:h" . guifontsize . ":cANSI"
let &guifontwide="D2Coding:h" . guifontwidesize . ":cDEFAULT"

"<Colorscheme & Background>
if has('gui')
  colorscheme default_AD
  set background=light
else
  "set background=dark
endif

"<Hide Toolbar, Menu Bar, Scroll Bar>
"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar

"--------------------------------------------------------------------
" Basic 2-2
"--------------------------------------------------------------------
"set number            " 행번호 표시, set nu 도 가능
set autoindent 		    " 자동 들여쓰기
set cindent 		      " C 프로그래밍용 자동 들여쓰기
set smartindent 	    " 스마트한 들여쓰기
set wrap
set nowrapscan 		    " 검색할 때 문서의 끝에서 처음으로 안돌아감
set noundofile        " undo 파일 안 만듦
set nobackup 		      " 백업 파일을 안 만듬
set hlsearch 		      " 검색어 강조, set hls 도 가능
set ignorecase 		    " 검색시 대소문자 무시, set ic 도 가능
set lbr
set incsearch 		    " 키워드 입력시 점진적 검색
set history=1000 	    " vi 편집기록 기억갯수 .viminfo에 기록
set fillchars+=vert:\ " window 구분 문자 지정
set completeopt-=preview  " scratch 창 안 뜨게
"ctags의 tags 경로
set tags=./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags
"set tags+=/원하는 절대경로

set backspace=eol,start,indent " 줄의 끝, 시작, 들여쓰기에서 백스페이스시 이전줄로

syntax on 			    " 구문강조 사용
filetype indent on 	" 파일 종류에 따른 구문강조

"set noimd			 " 모드 변경시 영어로
"set binary			" 잘 모름(근데 밑에꺼 쓰려면 같이 써야하는 듯)
"set noeol			" 자동 End Newline 없앰

"--------------------------------------------------------------------
" Visual Mode
"--------------------------------------------------------------------
if has("unix")
    hi Visual ctermbg=grey ctermfg=black
endif

"------------------------------------------
" Tab
"------------------------------------------
set tabstop=8		  " 탭 끝을 지정한 숫자의 배수 위치로 제한
set shiftwidth=8	" 기본 TAB 사이즈
"set softtabstop=2	" TAB 누르면 일단 이거 단위로 띄움, 그게 tabstop 넘어가면 실제 탭이 됨
"set expandtab		  " TAB을 space로 인식
"set smarttab		  " 행 처음의 공백을 TAB처럼

autocmd BufRead,BufNewFile *.txt set tabstop=2 shiftwidth=2 textwidth=79 " for txt(자동 줄 바꿈 포함)
autocmd BufRead,BufNewFile *.vim set tabstop=2 shiftwidth=2              " for vim file
autocmd BufRead,BufNewFile *.hs  set tabstop=2 shiftwidth=2              " for Haskell
autocmd BufRead,BufNewFile *.ll	 set tabstop=2 shiftwidth=2              " for LLVM
autocmd BufRead,BufNewFile *.py	 set tabstop=4 shiftwidth=4              " for Python

if has("win32")
	autocmd BufRead,BufNewFile *.ll set filetype=llvm
endif

"--------------------------------------------------------------------
" Ruler and Status Bar
"--------------------------------------------------------------------
set ruler 			" 화면 우측 하단에 현재 커서의 위치(줄,칸) 표시
set rulerformat=%30(%=%l:%c\ (%L)\ %{&fenc}%4m%)
set laststatus=1 	" window가 둘 이상일 때만 상태바 표시
set statusline=%<%r%=%l:%c\ (%L)\ %{&fenc}\ \-\ %f\ %m
highlight statusLine     ctermfg=grey  ctermbg=black
highlight statusLineNC   ctermfg=black ctermbg=grey  cterm=bold

" set statusline=%<%r%=%l:%c\ (%L)\ %{&fenc}\ \-\ %F\ %m " 파일 경로 전부 표시
" set statusline=%<%r%=%l:%c\ (%L)\ %f\ %m " 인코딩 표시 지운 Ver

"--------------------------------------------------------------------
" Last Cursor Position
"--------------------------------------------------------------------
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\ exe "norm	 g`\"" |
\ endif

"--------------------------------------------------------------------
" Print
"--------------------------------------------------------------------
set printoptions=number:y,left:5pc,top:3pcs
set printencoding=utf8
set printmbcharset=ISO10646
set printmbfont=r:D2Coding
set printfont=Consolas:h10:b

"--------------------------------------------------------------------
" Plugin
"--------------------------------------------------------------------
set nocompatible
filetype off

"<Vundle Path Setting>
if has("win32")
  "for Windows
  set rtp+=$USERPROFILE/vimfiles/bundle/Vundle.vim/
  call vundle#begin('$USERPROFILE/vimfiles/bundle/')	
elseif has("unix")
  "for Linux
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
endif

"<Edit Plugin List>  "(':BundleSearh'로 이름 검색 가능)
" Required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" My
Plugin 'Lokaltog/vim-easymotion'
Plugin 'taglist-plus'
Plugin 'ap/vim-buftabline'
Plugin 'cscope.vim'
    
if filereadable('.ycm_extra_conf.py')
  Plugin 'Valloric/YouCompleteMe'
"else
  "Plugin 'AutoComplPop'
endif
  
Plugin 'scrooloose/nerdcommenter'
Plugin 'The-NERD-tree'

call vundle#end()
filetype plugin indent on

"--------------------------------------------------------------------
" Each Plugin Setting
"--------------------------------------------------------------------
"<Taglist>
let Tlist_Use_Right_Window = 1
"(set location of Tag list window as right)

"<AutoComplPop>
function! InsertTabWrapper()
    let col = col('.') - 1 
    if !col || getline('.')[col-1]!~'\k'
        return "\<TAB>"
    else
        if pumvisible()
            return "\<C-N>"
        else
            return "\<C-N>\<C-P>"
        end 
    endif
endfunction
hi Pmenu ctermbg=blue
hi PmenuSel ctermfg=yellow ctermbg=black
hi PmenuSbar ctermbg=blue

"<YouCompleteMe>
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs 	= 0 
let g:ycm_enable_diagnostic_highlighting = 0

"<BufTabLine>
hi TabLineFill ctermfg=black ctermbg=NONE
hi TabLINE ctermfg=NONE ctermbg=NONE
hi TabLineSel ctermfg=White ctermbg=red

function! SetGuiTabLineColor()
    if &background=~#'light'
        hi TabLINE guifg=Black guibg=darkGrey
        hi TabLineFill guifg=darkGrey guibg=NONE
        hi TabLineSel guifg=White guibg=Black
    else
        hi TabLINE guifg=NONE guibg=NONE
        hi TabLineFill guifg=black guibg=NONE
        hi TabLineSel guifg=Black guibg=grey
    endif
endfunction

call SetGuiTabLineColor()

"--------------------------------------------------------------------
" Key Mapping
"--------------------------------------------------------------------
"<ETC>
inoremap <tab>   <c-r>=InsertTabWrapper()<cr>
map		 <F8>    :NERDTreeToggle<CR>
map		 <F9> 	 :TlistToggle<CR>

if has("gui")
"<Copy and Paste>
  noremap   <C-A> 	       <esc>ggVG<CR>
  noremap   <C-C> 	       "+Y
  noremap   <C-E>          "+gP
  noremap   <S-RightMouse> "+gP

"<Line Space>
  noremap  <F10>   :if &linespace=~#'1'<Bar>set linespace=5<Bar>else<Bar>set linespace=1<Bar>endif<CR><CR>

"<Hide Menu & Scroll Bar>
  nnoremap <F11> 	 :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR><CR>
  nnoremap <C-F11> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR><CR>

"<Color Scheme & BackGround>
noremap	<F12> :if &background=~#'light'<Bar>colorscheme wombat_AD<Bar>else<Bar>colorscheme default_AD<Bar>set background=light<Bar>endif<Bar>call SetGuiTabLineColor()<CR><CR>

noremap <C-F12> :


"<Font Size>
  let cgf=guifontsize     " Default En  Font Size
  let cwf=guifontwidesize " Default Han Font Size
  noremap <A-[>  :let cgf-=1<CR>:let cwf-=1<CR>:let &guifont = "Consolas:h" . cgf . ":cANSI"<CR>:let &guifontwide = "D2Coding:h" . cwf . ":cDEFAULT"  <CR><CR>
  noremap <A-]>  :let cgf+=1<CR>:let cwf+=1<CR>:let &guifont = "Consolas:h" . cgf . ":cANSI"<CR>:let &guifontwide = "D2Coding:h" . cwf . ":cDEFAULT"  <CR><CR>

"<Comment(nerdcommenter)>
  map	<A-j>	<leader>cm
  map	<A-k>	<leader>cu
  map	<A-l>	<leader>cc
else
  map	<F10>	<leader>cm
  map	<F11>	<leader>cu
  map	<F12>	<leader>cc
endif

"<Buffer Ctl>
nnoremap	<C-n>	:bprev<CR>
nnoremap 	<C-p>	:bnext<CR>

"<Window Ctl>
map		<C-l>		<C-W>l
map 	<C-h>		<C-W>h
map 	<C-j>		<C-W>j
map		<C-k>		<C-W>k
nmap	<C-Up>		<C-W>+
nmap	<C-Down>	<C-W>-
nmap	<C-Left>	<C-W><
nmap	<C-Right>	<C-W>>

"--------------------------------------------------------------------
" In The Future
"--------------------------------------------------------------------
"인쇄할 때 파일 경로 나오게
"인쇄할 때 페이지 번호 위치
"CMD vim에서 한글 입력 중 ESC하면 그대로 한글 입력 상태인 부분
