@echo off
title AD's WindowsRDP and FireWall Inbound Rule Setting
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
echo Step 01. Windows 원격 접속 설정
echo ------------------------------------------------------

:QUESTION_RDPON
set user_answer=
set /p user_answer=절전모드를 해제하고 Windows RDP를 허용하시겠습니까?(Y/N):
if "%user_answer%" == "Y" goto RDP_ON
if "%user_answer%" == "y" goto RDP_ON
if "%user_answer%" == "N" goto SKIP_RDPON
if "%user_answer%" == "n" goto SKIP_RDPON
echo 잘못 입력하셨습니다.
goto QUESTION_RDPON
:RDP_ON
powercfg.exe -change -monitor-timeout-ac 10
powercfg.exe -change -standby-timeout-ac 0
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
:SKIP_RDPON

:QUESTION_WINRDP
set user_answer=
set /p user_answer=Windows RDP용 포트를 변경하시겠습니까?(Y/N):
if "%user_answer%" == "Y" goto WINRDP_PORT_CHANGE
if "%user_answer%" == "y" goto WINRDP_PORT_CHANGE
if "%user_answer%" == "N" goto SKIP_WINRDP_SET
if "%user_answer%" == "n" goto SKIP_WINRDP_SET
echo 잘못 입력하셨습니다.
goto QUESTION_WINRDP
:WINRDP_PORT_CHANGE
netsh advfirewall firewall delete rule name="AD_RDP_Windows_TCP" > nul
netsh advfirewall firewall delete rule name="AD_RDP_Windows_UDP" > nul
set user_answer=
echo Windows 원격 접속용 포트 번호를 입력하세요.
set /p user_answer=
set WINRDP_PORT=%user_answer%
if "%user_answer%" == "3389" goto SKIP_FWsettings
netsh advfirewall firewall add rule name="AD_RDP_Windows_TCP" dir=in action=allow protocol=tcp localport=%WINRDP_PORT%
netsh advfirewall firewall add rule name="AD_RDP_Windows_UDP" dir=in action=allow protocol=udp localport=%WINRDP_PORT%

:SKIP_FWsettings
set "TMP_PATH=HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
reg add "%TMP_PATH%" /v "PortNumber" 	/t "REG_DWORD" /d %WINRDP_PORT%	/f
:SKIP_WINRDP_SET
echo.
echo ------------------------------------------------------
echo Step 02. 방화벽 인바운드 규칙 추가
echo ------------------------------------------------------
:QUESTION_FWINB
set user_answer=
set /p user_answer=방화벽 인바운드 규칙(포트)을 추가하시겠습니까?(Y/N):
if "%user_answer%" == "Y" goto FWINB_RULE_ADD
if "%user_answer%" == "y" goto FWINB_RULE_ADD
if "%user_answer%" == "N" goto SKIP_FWINB_SET
if "%user_answer%" == "n" goto SKIP_FWINB_SET
echo 잘못 입력하셨습니다.
goto QUESTION_FWINB
:FWINB_RULE_ADD

:SET_RULE_NAME
set RULE_NAME=
echo 추가하실 규칙 이름을 입력하세요.
set /p RULE_NAME=이름:
if "%RULE_NAME%" == "" (
	echo 잘못 입력하셨습니다.
	goto SET_RULE_NAME
)
:SET_RULE_PORT
set RULE_PORT=
echo 추가하실 포트를 입력하세요.
set /p RULE_PORT=포트:
if "%RULE_PORT%" == "" (
	echo 잘못 입력하셨습니다.
	goto SET_RULE_PORT
)
netsh advfirewall firewall add rule name="%RULE_NAME%_TCP" dir=in action=allow protocol=tcp localport=%RULE_PORT%
netsh advfirewall firewall add rule name="%RULE_NAME%_UDP" dir=in action=allow protocol=udp localport=%RULE_PORT%
goto QUESTION_FWINB
:SKIP_FWINB_SET

:EXIT
echo.
echo ------------------------------------------------------
if %READY% == YES	echo 설정 변경이 완료되었습니다.
if %READY% == NO	echo 설정 변경이 취소되었습니다.
echo (종료를 원하시면 아무 키나 누르세요...)
echo ------------------------------------------------------
pause > nul
