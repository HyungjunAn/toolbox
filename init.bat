@echo off
echo ------------------------------------------------------
echo 	Title	: AD's Setting init batch
echo 	Author	: An, Hyungjun
echo 	E-mal	: hyungjun0429@gmail.com
echo ------------------------------------------------------
echo.
echo ------------------------------------------------------
echo 	Check Admin
echo ------------------------------------------------------
fsutil dirty query %systemdrive% > nul
if '%errorlevel%' NEQ '0' (
    echo Please Run as Administrator !!
    goto EXIT
)

pushd "%~dp0"

echo ------------------------------------------------------
echo 	환경 변수 설정
echo ------------------------------------------------------
echo Current Path: %cd%

set "ROOT=%cd%"
set "ROOT_AHK=%ROOT%\AHK"
set "ROOT_VIM=%ROOt%\vim"
del "%USERPROFILE%\Desktop\ahk"

set "CHROME32=C:\Program Files (x86)\Google\Chrome\Application"
set "CHROME64=C:\Program Files\Google\Chrome\Application"

IF exist "%CHROME32%\" (
	set "CHROME_EXE=%CHROME32%\chrome.exe"
) else IF exist "%CHROME64%\" (
	set "CHROME_EXE=%CHROME64%\chrome.exe"
) else (
	echo ERROR: There is no Chrome.exe
)

IF exist "%USERPROFILE%\내 드라이브" (
	set "GOOGLE_DRIVE=%USERPROFILE%\내 드라이브"
) else (
	echo ERROR: There is no Google Drive
)

@echo on
setx TOOLBOX_ROOT "%ROOT%"
setx TOOLBOX_ROOT_TAR "%ROOT%\TypeAndRun"
setx TOOLBOX_ROOT_BLOG "%ROOT%\blog"
setx TOOLBOX_ROOT_BLOG_POSTS "%ROOT%\blog\_posts"
setx TOOLBOX_ROOT_AHK "%ROOT_AHK%"
mklink "%USERPROFILE%\Desktop\ahk" "%ROOT_AHK%\main.ahk"
setx TOOLBOX_CHROME_EXE "%CHROME_EXE%"
setx TOOLBOX_GOOGLE_DRIVE "%GOOGLE_DRIVE%"
@echo off

echo.
echo ------------------------------------------------------
echo 	Gvim 테마, vimrc, vim 파일 이동
echo ------------------------------------------------------

set VIM_VERSION=vim82
set VIMPATH=
set "VIMPATH32=C:\Program Files (x86)\Vim\%VIM_VERSION%"
set "VIMPATH64=C:\Program Files\Vim\%VIM_VERSION%"

echo source %ROOT_VIM%\vimrc_AD.vim > "%USERPROFILE%\_vimrc"


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

:ERR_VIM
echo.
echo ------------------------------------------------------
echo 	Vundle 다운로드
echo ------------------------------------------------------
git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/
echo.
echo.
echo ------------------------------------------------------
echo	PATH 확인
echo ------------------------------------------------------
call :findPath "%VIMPATH%"
call :findPath "C:\Apache24\bin"

echo ------------------------------------------------------
:EXIT
echo (종료를 원하시면 아무 키나 누르세요...)
pause > nul

:findPath
set "TARGET_PATH=%~1"
echo %PATH% | find "%TARGET_PATH%" > nul
if errorlevel 1 (
	echo Update PATH is Needed!! : "%TARGET_PATH%"
)

