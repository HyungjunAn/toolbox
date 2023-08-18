;###############################################################
; AD's HotKey
;###############################################################

;	TODO
;메일 uri 파일에서 읽어오는 부분 필요없으면 삭제

;///////////////////////////////////////////////////////////////
; 	Color Table
;///////////////////////////////////////////////////////////////
;	F39C12: Orange

;///////////////////////////////////////////////////////////////
;		Serial Code
;///////////////////////////////////////////////////////////////
#include %A_ScriptDir%
#include lib_common.ahk
#include lib_focus.ahk
#include lib_run.ahk
#include lib_vpc.ahk
#include lib_office.ahk

SetWorkingDir, %A_ScriptDir%
CoordMode, Screen

global path_setting := getParentPath(A_ScriptDir)

global motto_text			:= "True Nobility is being Superior to Your Former Self."
global tmpFolder			:= A_ScriptDir . "\tmp"
global library				:= TOOLBOX_GOOGLE_DRIVE . "\Library"
global gvimFavorite			:= ""
global dir_typeandrun		:= path_setting . "\TypeAndRun\exe"
global typeandrun			:= dir_typeandrun . "\TypeAndRun.exe"
global typeandrun_cfgSrc_Common	:= path_setting . "\TypeAndRun\configSrc_Common.txt"
global typeandrun_cfgSrc		:= path_setting . "\TypeAndRun\configSrc_Home.txt"
global hotstring			:= ""

global gbIsInitDone 	:= False

global PID_GVIM_FAVORITE 	:= 0
global PID_SELECT 	:= 0
global PID_EXPLORER	:= 0

global maxHotWinNum		:= 4
global garHotWin_info	:= []
global garHotWin_file	:= []

global DIRECTION_LEFT	:= 0
global DIRECTION_RIGHT	:= 1
global DIRECTION_UP		:= 2
global DIRECTION_DOWN	:= 3

global bOffice := COMMON_IsOffice()

myMotto()

; Make temp file
FileCreateDir, %tmpFolder%

;-------------------------------------------
; 	Process about Office Environment
;-------------------------------------------
If (bOffice) {
	library				:= OFFICE_LIB
	gvimFavorite		:= OFFICE_LIB
	typeandrun_cfgSrc	:= OFFICE_SETTING_TAR
	hotstring			:= OFFICE_SETTING_HOTSTRING
}

;-------------------------------------------
; 	Process about PID
;-------------------------------------------
Loop % maxHotWinNum
{
	garHotWin_info[A_Index] := 0
	garHotWin_file[A_Index] := tmpFolder . "/hotWin_" . A_Index . ".txt"
	path := garHotWin_file[A_Index]
	FileReadLine, info, %path%, 1
	garHotWin_info[A_Index] := info
}

SetCapsLockState, off
SetScrollLockState, off

DetectHiddenWindows,on
WinGet, AHKList, List, ahk_class AutoHotkey
Loop, %AHKList%
{
    ID := AHKList%A_Index%
    If (ID <> A_ScriptHwnd)
        WinClose, ahk_id %ID%
}
DetectHiddenWindows,off

reloadTypeAndRun()
Run, select.ahk,,, PID_SELECT
Run, explorer.ahk,,, PID_EXPLORER

gbIsInitDone := True
healthNotification()
Gui, Destroy

;///////////////////////////////////////////////////////////////
;		Hot Key
;///////////////////////////////////////////////////////////////
; Reload Script
$!+r:: 
	Process, Close, %PID_SELECT%,
	Process, Close, %PID_EXPLORER%,
	closeProcess("TypeAndRun.exe")
	Reload

$^Delete::
	Process, Close, %PID_SELECT%,
	Process, Close, %PID_EXPLORER%,
	closeProcess("TypeAndRun.exe")
	myMotto(200, "White")
	ExitApp

; Control Script Suspending
$!+a:: 
	Run, %TOOLBOX_ROOT_AHK%\capslock2ctrl.ahk
	Process, Close, %PID_SELECT%,
	Process, Close, %PID_EXPLORER%,
	closeProcess("TypeAndRun.exe")
	myMotto(500, "Green")
	ExitApp

;------------------------------------
; Folder
;------------------------------------
$!^g::	Run, %TOOLBOX_ROOT%
$#d:: 	Run, %USERPROFILE%\Desktop
$#e::	Run, shell:mycomputerfolder

;------------------------------------
; Program
;------------------------------------
$^.::
	FOCUS_MainDesktop()
    WinGet, p_name, ProcessName, ahk_pid %PID_GVIM_FAVORITE%

	if (p_name != "gvim.exe") {
		FileList := "_memo.txt`n"

		Loop, Files, %gvimFavorite%\*.txt,
		{
			FileList .= A_LoopFileName "`n"
		}

		Loop, Parse, FileList, `n
		{
			title := COMMON_FindWinTitle(A_LoopField, False)

			if (title) {
				WinActivate, %title%
				WinWaitActive, %title%,, 2

				if (!ErrorLevel) {
    				WinGet, PID_GVIM_FAVORITE, PID, A
				}

				return
			}
		}

		Run, gvim "%gvimFavorite%\*.txt" "%USERPROFILE%\Desktop\stable\_memo.txt",,, PID_GVIM_FAVORITE

		return
	}

    WinGet, curPid, PID, A
	
	if (curPid != PID_GVIM_FAVORITE) {
		WinActivate, ahk_pid %PID_GVIM_FAVORITE%
	} else {
		SendInput, ^p
	}

	return

!^h::	activateHotWin(1)
!^j::	activateHotWin(2)
!^k::	activateHotWin(3)
!^l::	activateHotWin(4)

!^+h::	setHotWin(1)	
!^+j::	setHotWin(2)	
!^+k::	setHotWin(3)	
!^+l::	setHotWin(4)	

$!^e::	RUN_AOR_GitBash(TOOLBOX_ROOT)

$#c::
	subTitleArr := []
	subTitleArr[1] := "캡처 도구"
	subTitleArr[2] := "Snipping Tool"

	RUN_AOR_EXE("SnippingTool.exe")
	COMMON_Activate_SubWinTitleArr(subTitleArr, COMMON_OPT_WAIT)

	if (getOsVer() == 10) {
		SendInput, ^n
	}

    Return

RShift & Up::
$ScrollLock::
$PrintScreen::
$MButton::
	uri := VPC_GetMouseOverUri()

	if (uri) {
		RUN_OpenUrl(uri)
	} else {
		SendInput, {MButton}
	}

	return 

RShift & Down::
$Pause::
$+MButton::
	SendInput, {RButton}
	tmp := Clipboard
	Clipboard := ""
	SendInput, e
	sleep, 50
	uri := Clipboard
	Clipboard := tmp

	if (InStr(uri, "http") == 1) {
		RUN_OpenUrl(uri, COMMON_OPT_APPMODE)
	}
	return
	
;=============================================================

; Virtual Desktop Toggle
$^,::
	if (!VPC_Switch()) {
		FOCUS_VDesktop_toggle()
	}
	Return

; TypeAndRun
$!^p::
	FOCUS_MainDesktop()
	SendInput, !^p
	return

;------------------------------------
; Key & System
;------------------------------------
Capslock::Ctrl
$!^s::
	newCapLockState := !GetKeyState("CapsLock", "T")

	if (newCapLockState) {
		myMotto(0, "F39C12")
	} else {
		myMotto(10)
	}

	SetCapsLockState % newCapLockState
	return

$`::	SendInput, {ESC}
$^`::	SendInput, ^``
$!`::	SendInput, ``
^#m::	SendInput, {AppsKey}
!^w::	SendInput, !{F4}

$SC11d:: RControl

;special character
LShift & SC138:: SendInput, {sc1f1}{Tab}

;=============================================================
; For Right Hand
;-------------------------------------------------------------
RShift & Left:: 	SendInput, ^c
RShift & Right:: 	SendInput, ^v
;RShift & Down:: 	SendInput, ^z
;RShift & Up::	 	SendInput, ^+z
;RShift & Delete:: 	SendInput, ^x
RShift & PgDn:: 	SendInput, ^x
RShift & Enter::
    WinGetTitle, Title, A
	if (Title == "작업 보기") {
		SendInput, {Esc}
	} else {
		SendInput, #{Tab}
	}
	return 

;RShift & PgDn:: SendInput, ^{Tab}
RShift & End:: SendInput, ^{Tab}

;RShift & PgUp:: SendInput, ^+{Tab}
RShift & Delete:: SendInput, ^+{Tab}

RShift & SC11d:: SendInput, !{Tab}
;=============================================================

$!f::
	if (COMMON_GetActiveWinProcName() == "Code.exe") {
		SendInput, ^d^+f
	} else {
		SendInput, !f
	}
	return

; Sound Control
#`:: SendInput, {Volume_Down}
#1:: SendInput, {Volume_Up}
#2:: SendInput, {Volume_Mute}

; Windows Always on Top Toggle
#'::
    WinGetTitle, Title, A
    WinSet, Alwaysontop, Toggle, %Title%
    return

$!^-:: SendInput, -------------------------------------------------------------
$!^=:: SendInput, =============================================================

; Test
!^+o:: ListHotKeys
!^+u::
	WinGetTitle, Title, A
	WinGet, PName, ProcessName, A
    WinGet, PID, PID, A
    WinGetPos, x, y, w, h, %Title%
	MsgBox, PID: %PID%`nProcessName: %PName%`nWinTitle: %Title%`nx%x% y%y% w%w% h%h%`nscreen W[%A_ScreenWidth%] H[%A_ScreenHeight%]
	;ListHotKeys
	return
    WinGet windows, List
	tmpStr := ""
    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%
		tmpStr := tmpStr . "`n" . Title
    }
	MsgBox, %tmpStr%
    return
	;Path = %A_ScriptDir%
	;Parent := SubStr(Path, 1, InStr(SubStr(Path,1,-1), "\", 0, 0)-1)
	;msgbox %parent%
    WinGetTitle, Title, A
    WinGet, PID, PID, A
    WinGetPos, x, y, W, H, %Title%
    MsgBox, %Title%`n`nx:%x% y:%y% W:%W% H:%H%`n`nPID: %PID%
	;MsgBox, %m_interval%
    return

testFunc(ByRef str) {
	msgBox, %str%
}

;///////////////////////////////////////////////////////////////
;		Function Def.
;///////////////////////////////////////////////////////////////

myMotto(Time := 0, backC := "Red") {
	fontC := "White"
	TEXT := "    " . motto_text . "    "
	h := 40
	y := A_ScreenHeight - h

	Gui, Color, %backC%
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Font, s12 c%fontC%, Consolas
	Gui, Add, Text, , %TEXT%
	Gui, Show, y%y% h%h% NoActivate,

	if(Time) {
		Sleep % Time
		Gui, Destroy
	}
}

mouseMoveOnRightMid() {
    WinGetPos, , , Width, Height, A
    x_corner := Width - 40
    y_mid    := Height // 2
    MouseMove, %x_corner%, %y_mid%, 0
}

closeProcess(pidOrName) {
	Process, Close, %pidOrName%,
	return
}

getParentPath(path) {
	return SubStr(path, 1, InStr(SubStr(path,1,-1), "\", 0, 0)-1)
}

getOsVer() {
	sFullVer := A_OSVersion
	ver := SubStr(sFullVer, 1, InStr(sFullVer, ".") - 1)
	return ver
}

getUriArrayFromFile(path, arTitle, arAddress)
{
	local cnt := 0

	Loop, Read, %path%
	{
		local arrStr := COMMON_StrSplit(A_LoopReadLine, A_Tab)

		if (arrStr.Length() == 2) {
			arTitle.Push(arrStr[1])
			arAddress.Push(arrStr[2])
			cnt++
		}
	}

	return cnt
}

getUriFromFile(path, ByRef title, ByRef address)
{
	local bIsTitleReadTurn := True

	Loop, Read, %path%
	{
		if bIsTitleReadTurn
		{
			title := A_LoopReadLine
		}
		else
		{
			address := A_LoopReadLine
		}
		bIsTitleReadTurn := !bIsTitleReadTurn
	}
}

activateHotWin(index)
{
	if (!gbIsInitDone)
		return

	info := garHotWin_info[index]

	Process, Exist, %info%,

	if (ErrorLevel) {
		actCmd := "ahk_pid " . info
	} else if (WinExist(info)) {
		actCmd := info
	} else {
		return
	}

	FOCUS_MainDesktop()
	WinActivate, %actCmd%
	COMMON_GUI_BlinkActiveWin()
}

setHotWin(index)
{
	if (!gbIsInitDone)
		return

	if (COMMON_GetActiveWinProcName() == "chrome.exe") {
		WinGetTitle, winInfo, A
	} else {
		WinGet, winInfo, PID, A
	}

	garHotWin_info[index] := winInfo

	path := garHotWin_file[index]
	FileDelete, %path%
	FileAppend, %winInfo%, %path%
	myMotto(300)
}

IfSend_UpDown(mode, elseStr) {
	local direction := (mode == DIRECTION_UP)? "Up": "Down"

	switch (COMMON_GetActiveWinProcName()) {
	case "KakaoTalk.exe", "firefox.exe":
        mouseMoveOnRightMid()
    	SendInput, {Wheel%direction%}
	case "PowerShell.exe":
		SendInput, {%direction%}
	default:
		SendInput, %elseStr%
	}
}

reloadTypeAndRun() {
	ifExist, %typeandrun%, {
		closeProcess("TypeAndRun.exe")
		if ("X" != FileExist(typeandrun_cfgSrc) && "X" != FileExist(typeandrun_cfgSrc_Common)) {
			FileDelete, %dir_typeandrun%\~Config.ini
			FileDelete, %dir_typeandrun%\Config.ini

			cmd = util_make_tar_config.ahk "%typeandrun_cfgSrc%" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%

			cmd = util_make_tar_config.ahk "%typeandrun_cfgSrc_Common%" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%

			cmd = util_make_tar_config_for_hotstring.ahk "hs" "%hotstring%" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%

			cmd = util_make_tar_config_for_folder.ahk "ahk" "%TOOLBOX_ROOT_AHK%" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%

			cmd = util_make_tar_config_for_folder.ahk "cs" "%TOOLBOX_ROOT_BLOG_POSTS%\cs" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%

			cmd = util_make_tar_config_for_folder.ahk "kor" "%TOOLBOX_ROOT_BLOG_POSTS%\ko" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%

			cmd = util_make_tar_config_for_folder.ahk "en" "%TOOLBOX_ROOT_NOTE_ENGLISH%\res" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%

			cmd = util_make_tar_config_for_folder.ahk "fn" "%TOOLBOX_GOOGLE_DRIVE%\finance" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%

			cmd = util_make_tar_config_for_folder.ahk "o" "%OFFICE_LIB_ROOT%\docs" "%dir_typeandrun%\Config.ini"
			RunWait, %cmd%
		}
		Run, %typeandrun%
	}
}

runWinFindTool() {
	Local Title := ""
	Local Titles := ""
	Local Line := 0
	Local Height := 0

    WinGet windows, List

    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%
		if (Title) {
			Titles := Titles . Title . "`n"
			Line := Line + 1
		}
    }

	;MsgBox, %Line% %A_DetectHiddenWindows%

	Height := 30 * Line

	InputBox, UserInput, Type Window Name to Find, %Titles%, , 800, %Height%, , , , 10

	if (!ErrorLevel && UserInput) {
		subName := UserInput
	} else {
		return
	}
	
    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%
        IfInString, Title, %subName%, {
			WinActivate, %Title%
		}
    }
}

healthNotification() {
	Local text := ""
	Local f := tmpFolder . "\today.txt"
	Local curTime := ""
	Local oldTime := ""

	IfNotExist, %f%, {
		FileAppend, 0, %f%
	}

	FormatTime, curTime,, yyMMdd
	FileReadLine, oldTime, %f%, 1

	if (curTime == oldTime) {
		return
	}

	FileDelete, %f%
	FileAppend, %curTime%, %f%

	;text := text . "운동: 6/1W`n"
	;text := text . "양치: 2/1D`n"
	;text := text . "음주: 1/1W`n"
	;text := text . "정식: 1/1D`n"
	;text := text . "`n"
	;text := text . "(X: 과자, 탄산, 과식, 과음, 단당, HP)"

	;text := text . "[운동] 종아리, 신전, 계단, 풀업, 스쿼트, 푸쉬업`n"
	;text := text . "[위생] 양치, 건조`n"
	;text := text . "`n"
	;text := text . "[금지] 과음, 과식, 당류, 폰질`n"
	text := motto_text

	MsgBox, %text%
}
