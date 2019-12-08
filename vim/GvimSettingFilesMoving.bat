@echo off
echo ------------------------------------------------------
echo 	Title	: AD's Gvim Setting Files Moving
echo 	Author	: An, Hyungjun
echo 	E-mal	: hyungjun0429@gmail.com
echo ------------------------------------------------------
echo.
echo ------------------------------------------------------
echo 	Check Admin
echo ------------------------------------------------------
fsutil dirty query %systemdrive% > nul
if '%errorlevel%' NEQ '0' (		
    echo !!!      Please Run as Administrator      !!!
    goto EXIT
)
pushd "%~dp0"
echo.
echo ------------------------------------------------------
echo 	Gvim 테마, vimrc, vim 파일 이동
echo ------------------------------------------------------
set "VIMPATH=C:\Program Files (x86)\Vim\vim81"
copy "colors"	"%VIMPATH%\colors"
copy "syntax"	"%VIMPATH%\syntax\"

copy ctags58.exe 				"%VIMPATH%\ctags.exe"

echo source %cd%\vimrc_AD.vim > "%USERPROFILE%\_vimrc"
echo.
echo ------------------------------------------------------
echo 	Vundle 다운로드
echo ------------------------------------------------------
git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/
echo.
echo ------------------------------------------------------
echo (종료를 원하시면 아무 키나 누르세요...)
:EXIT
pause > nul