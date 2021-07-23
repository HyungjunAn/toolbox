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
echo 	ȯ�� ���� ����
echo ------------------------------------------------------
echo Current Path: %cd%

@echo on
set "ROOT=%cd%"
setx TOOLBOX_ROOT "%ROOT%"
setx TOOLBOX_ROOT_TAR "%ROOT%\TypeAndRun"
setx TOOLBOX_ROOT_LIB "%ROOT%\Library"

set "ROOT_AHK=%ROOT%\AHK"
set "ROOT_VIM=%ROOt%\vim"

setx TOOLBOX_ROOT_AHK "%ROOT_AHK%"

del "%USERPROFILE%\Desktop\ahk"
mklink "%USERPROFILE%\Desktop\ahk" "%ROOT_AHK%\main.ahk"
@echo off

echo.
echo ------------------------------------------------------
echo 	Gvim �׸�, vimrc, vim ���� �̵�
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

copy "%ROOT_VIM%\colors"	"%VIMPATH%\colors"
copy "%ROOT_VIM%\syntax"	"%VIMPATH%\syntax\"
copy "%ROOT_VIM%\ctags58.exe"	"%VIMPATH%\ctags.exe"

echo source %ROOT_VIM%\vimrc_AD.vim > "%USERPROFILE%\_vimrc"

:ERR_VIM
echo.
echo ------------------------------------------------------
echo 	Vundle �ٿ�ε�
echo ------------------------------------------------------
git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/
echo.
echo ------------------------------------------------------
:EXIT
echo (���Ḧ ���Ͻø� �ƹ� Ű�� ��������...)
pause > nul
