" Vim color file
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last Change:	2001 Jul 23

" This is the default color scheme.  It doesn't define the Normal
" highlighting, it uses whatever the colors used to be.

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal
set bg&

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "default_AD"

" vim: sw=2

hi VertSplit    guifg=#BBBBBB ctermfg=250  guibg=#BBBBBB ctermbg=250  gui=NONE cterm=NONE
hi StatusLine   guifg=#404040 ctermfg=238  guibg=#BBBBBB ctermbg=250  gui=BOLD cterm=BOLD
hi StatusLineNC guifg=#BBBBBB ctermfg=250  guibg=#ECECEC ctermbg=255  gui=ITALIC cterm=NONE