@echo off
echo ------------------------------------------------------
echo 	Title	: AD's Setting init batch
echo 	Author	: An, Hyungjun
echo 	E-mal	: hyungjun0429@gmail.com
echo ------------------------------------------------------
echo.
rem echo ------------------------------------------------------
rem echo 	Check Admin
rem echo ------------------------------------------------------
rem fsutil dirty query %systemdrive% > nul
rem if '%errorlevel%' NEQ '0' (		
rem     echo !!!      Please Run as Administrator      !!!
rem     goto EXIT
rem )
rem 
rem echo Done!!
rem pushd "%~dp0"

echo ------------------------------------------------------
echo 	환경 변수 설정
echo ------------------------------------------------------
echo Current Path: %cd%

@echo on
setx AHJ_TB "%cd%"
setx AHJ_TB_AHK "%AHJ_TB%\AHK"
setx AHJ_TB_TAR "%AHJ_TB%\TypeAndRun"
setx AHJ_TB_LIB "%AHJ_TB%\Library"
setx AHJ_TB_VIM "%AHJ_TB%\vim"

del "%USERPROFILE%\Desktop\ahk"
mklink "%USERPROFILE%\Desktop\ahk" "%AHJ_TB_AHK%\main.ahk"
@echo off

echo.
echo ------------------------------------------------------
echo 	Gvim 테마, vimrc, vim 파일 이동
echo ------------------------------------------------------

set VIM_VERSION=vim82
set VIMPATH=
set "VIMPATH32=C:\Program Files (x86)\Vim\%VIM_VERSION%"
set "VIMPATH64=C:\Program Files\Vim\%VIM_VERSION%"

IF exist "%VIMPATH32%\" (
	set "VIMPATH=%VIMPATH32%"
) else IF exist "%VIMPATH64%\" (
	set "VIMPATH=%VIMPATH64%"
) else (
	echo ERROR: There is no vim!
	goto ERR_VIM
)

copy "%AHJ_TB_VIM%\colors"	"%VIMPATH%\colors"
copy "%AHJ_TB_VIM%\syntax"	"%VIMPATH%\syntax\"
copy "%AHJ_TB_VIM%\ctags58.exe"	"%VIMPATH%\ctags.exe"

echo source %AHJ_TB_VIM%\vimrc_AD.vim > "%USERPROFILE%\_vimrc"

:ERR_VIM
echo.
echo ------------------------------------------------------
echo 	Vundle 다운로드
echo ------------------------------------------------------
git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/
echo.
echo ------------------------------------------------------
:EXIT
echo (종료를 원하시면 아무 키나 누르세요...)
pause > nul
