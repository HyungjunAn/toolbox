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

@ECHO OFF
echo ------------------------------------------------------
echo 	git user name / email 설정
echo ------------------------------------------------------
set /p "c=Do you set user.name and user.email? [Y/N]: "
if /i "%c%" EQU "Y" goto :DO_USER_SET
if /i "%c%" EQU "N" goto :SKIP_USER_SET
echo (잘못된 입력입니다.)
goto :EXIT

:DO_USER_SET
set /p "userName=insert user name: "
set /p "userEmail=insert user e-mail address: "

git config user.name "%userName%"
git config user.email "%userEmail%"

echo ------------------------------------------------------
echo 	library git clone 여부 결정
echo ------------------------------------------------------
set /p "c=Do you clone library? [Y/N]: "
if /i "%c%" EQU "Y" goto :DO_USER_SET
if /i "%c%" EQU "N" goto :SKIP_USER_SET
echo (잘못된 입력입니다.)
goto :EXIT

:DO_USER_SET

mkdir library
cd library

REM git clone https://github.com/HyungjunAn/HyungjunAn.github.io.git blog
REM cd blog
REM IF ERRORLEVEL == 0 (
REM 	git config user.name "%userName%"
REM 	git config user.email "%userEmail%"
REM 	cd ..
REM )

REM git clone https://github.com/HyungjunAn/note-english.git
REM cd note-english
REM IF ERRORLEVEL == 0 (
REM 	git config user.name "%userName%"
REM 	git config user.email "%userEmail%"
REM 	cd ..
REM )

git clone https://github.com/HyungjunAn/keep.git
cd keep
IF ERRORLEVEL == 0 (
	git config user.name "%userName%"
	git config user.email "%userEmail%"
	cd ..
)

cd ..

:SKIP_USER_SET

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
setx TOOLBOX_ROOT_BLOG "%ROOT%\library\blog"
setx TOOLBOX_ROOT_BLOG_POSTS "%ROOT%\library\blog\_posts"
setx TOOLBOX_ROOT_NOTE_ENGLISH "%ROOT%\library\note-english"
setx TOOLBOX_ROOT_KEEP "%ROOT%\library\keep"
setx TOOLBOX_ROOT_AHK "%ROOT_AHK%"
setx TOOLBOX_CHROME_EXE "%CHROME_EXE%"
setx TOOLBOX_GOOGLE_DRIVE "%GOOGLE_DRIVE%"
mklink "%USERPROFILE%\Desktop\ahk" "%ROOT_AHK%\main.ahk"
@echo off
echo.

echo ------------------------------------------------------
echo 	ini 백업 파일 복사
echo ------------------------------------------------------
copy ini_backup\xntimer.ini AHK
copy ini_backup\TypeAndRun.ini TypeAndRun\exe
echo.
echo ------------------------------------------------------
echo 	AHK
echo ------------------------------------------------------
set "AHKPATH=C:\Program Files\AutoHotkey"
IF not exist "%AHKPATH%" (
	echo ERROR: There is no AHK!!
)
echo.
echo ------------------------------------------------------
echo 	Gvim
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

echo [vimrc 생성]
echo source %ROOT_VIM%\vimrc_AD.vim > "%USERPROFILE%\_vimrc"
echo "" > "%USERPROFILE%\.vimrc"
echo.
echo [vim 파일 이동]
copy "%ROOT_VIM%\colors"	"%VIMPATH%\colors"
copy "%ROOT_VIM%\syntax"	"%VIMPATH%\syntax\"
copy "%ROOT_VIM%\ctags58.exe"	"%VIMPATH%\ctags.exe"
echo.
echo [Vundle 다운로드]
git clone https://github.com/VundleVim/Vundle.vim.git %USERPROFILE%/vimfiles/

:ERR_VIM
echo.
echo ------------------------------------------------------
echo	PATH 확인
echo ------------------------------------------------------
call :findPath "%VIMPATH%"
call :findPath "C:\Apache24\bin"
call :findPath "C:\MinGW\bin"

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

