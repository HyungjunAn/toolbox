@echo off
title AD's Gvim Setting Files Moving
rem -------------------------------------------------------
rem Author	: An, Hyungjun
rem E-mal	: hyungjun@pusan.ac.kr
rem -------------------------------------------------------
rem -------------------------------------------------------
rem Step 0. 관리자 권한 확인

echo ------------------------------------------------------
echo 	Gvim 테마, vimrc, vim 파일 이동
echo ------------------------------------------------------
set "VIMPATH=C:\Program Files (x86)\Vim\vim81"
copy "colors"	"%VIMPATH%\colors"
copy "syntax"	"%VIMPATH%\syntax\"

copy ctags58.exe 				"%VIMPATH%\ctags.exe"

copy source_cmd.vim				"%USERPROFILE%\_vimrc"

git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/

echo ------------------------------------------------------
echo (종료를 원하시면 아무 키나 누르세요...)
echo ------------------------------------------------------
pause > nul