@echo off
title AD's Notepad++ Setting Files Moving
rem -------------------------------------------------------
rem Author	: An, Hyungjun
rem E-mal	: hyungjun@pusan.ac.kr
rem -------------------------------------------------------
rem -------------------------------------------------------
rem Step 0. 관리자 권한 확인

set READY=NO
fsutil dirty query %systemdrive% > nul
if '%errorlevel%' NEQ '0' (
    echo 관리자 권한으로 실행하세요.	
    goto EXIT
)
pushd "%~dp0"
set READY=YES
echo.
echo ------------------------------------------------------
echo Step 01. Notepad++ 세팅 파일 이동
echo ------------------------------------------------------
copy "Notepad++"	"%USERPROFILE%\AppData\Roaming\Notepad++\"
echo.
:EXIT
echo ------------------------------------------------------
if %READY% == YES	echo 설정 변경이 완료되었습니다.
if %READY% == NO	echo 설정 변경이 취소되었습니다.
echo (종료를 원하시면 아무 키나 누르세요...)
echo ------------------------------------------------------
pause > nul
