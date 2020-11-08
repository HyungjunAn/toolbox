;###############################################################
; AD's HotKey
;###############################################################

;///////////////////////////////////////////////////////////////
;		TODO
;///////////////////////////////////////////////////////////////
;!^+i 단축키 유용성 판단해서 삭제
;메일 uri 파일에서 읽어오는 부분 필요없으면 삭제

;///////////////////////////////////////////////////////////////
; 	Color Table
;///////////////////////////////////////////////////////////////
;	F39C12: Orange

;///////////////////////////////////////////////////////////////
; 	Not Using
;///////////////////////////////////////////////////////////////
;!^+z::
;$!^.::
;$^NumpadAdd:: 
;!^b::
;!^+e::
;#z::
;#x::
;^#h::
;^#j::
;^#k::
;^#l::
;+#h::
;+#j::
;+#k::
;+#l::
;+#w::
;+#s::
;!^x::
;!^+y::
;!^1::
;!^,:: 	
;$!^+v::
;$!^+n:: 
;!^+p::

;///////////////////////////////////////////////////////////////
;		Serial Code
;///////////////////////////////////////////////////////////////
#include %A_ScriptDir%
#include Lib_Common.ahk
#include Lib_VPC.ahk

SetWorkingDir, %A_ScriptDir%
global path_setting := getParentPath(A_ScriptDir)

global isVirtualDesktopLeft := True

global isGuiOn			:= True
global guiShowFlag		:= False

global library				:= USERPROFILE . "\Google 드라이브\Library"
global gvimFavorite			:= USERPROFILE . "\Desktop"
global dir_typeandrun		:= path_setting . "\TypeAndRun\exe"
global typeandrun			:= dir_typeandrun . "\TypeAndRun.exe"
global typeandrun_cfgSrc_Common	:= path_setting . "\TypeAndRun\configSrc_Common.txt"
global typeandrun_cfgSrc		:= path_setting . "\TypeAndRun\configSrc_Home.txt"

global url_CurTabNum	:= 0
global url_MaxTabNum	:= 0

global gsUriListPath	:= "data/uri_list.txt"
global garUriTitle		:= []
global garUriAddress 	:= []

global gsMailUriTitle	:= "Gmail"
global gsMailUriAddress	:= "https://mail.google.com/mail"

global gbIsInitDone 	:= False

global gsPath_PID_GVIM_FAVORITE	:= "tmp/tmpGvimFavoritePid.txt"
global PID_GVIM_FAVORITE 		:= 0

global maxSelectPidNum		:= 4
global garSelectPid_pid		:= []
global garSelectPid_file	:= []

global PID_AHK_VIMMODE 			:= 0

global VimMode := "VimMode.ahk"

global isOffice := False

global office_worklib 			:= "D:\library_office"
global office_worklib_setting 	:= office_worklib . "\setting"

global google_homeID_num := 0

myMotto()

;-------------------------------------------
; 	Process about Office Environment
;-------------------------------------------
If (A_UserName == "hyungjun.an") {
    isOffice := True
    google_homeID_num := 1
	library				:= office_worklib
	gvimFavorite		:= office_worklib
	typeandrun_cfgSrc	:= office_worklib_setting . "\TypeAndRun\configSrc_Office.txt"
	gsUriListPath		:= office_worklib_setting . "\AHK\url_office.txt"

	path := office_worklib_setting . "\AHK\url_mail.txt"
	getUriFromFile(path, gsMailUriTitle, gsMailUriAddress)
}

;-------------------------------------------
; 	Get URI's Title and Address
;-------------------------------------------
url_MaxTabNum := getUriArrayFromFile(gsUriListPath, garUriTitle, garUriAddress)

;-------------------------------------------
; 	Process about TypeAndRun
;-------------------------------------------
ifExist, %typeandrun%, {
	closeProcess("TypeAndRun.exe")
	if ("X" != FileExist(typeandrun_cfgSrc) && "X" != FileExist(typeandrun_cfgSrc_Common)) {
		FileDelete, %dir_typeandrun%\~Config.ini
		FileDelete, %dir_typeandrun%\Config.ini

		cmd = util_mkTARConfig.ahk "%typeandrun_cfgSrc%" "%dir_typeandrun%\Config.ini"
		RunWait, %cmd%

		cmd = util_mkTARConfig.ahk "%typeandrun_cfgSrc_Common%" "%dir_typeandrun%\Config.ini"
		RunWait, %cmd%
	}
	Run, %typeandrun%
}

;-------------------------------------------
; 	Process about PID
;-------------------------------------------
FileReadLine, PID_GVIM_FAVORITE, %gsPath_PID_GVIM_FAVORITE%, 1

Loop % maxSelectPidNum
{
	garSelectPid_pid[A_Index] := 0
	garSelectPid_file[A_Index] := "tmp/pidSelect_" . A_Index . ".txt"
	path := garSelectPid_file[A_Index]
	FileReadLine, PID, %path%, 1
	garSelectPid_pid[A_Index] := PID
}

SetCapsLockState, off
SetScrollLockState, off

;alarm()
gbIsInitDone := True
Gui, Destroy
Run, %VimMode%, , , PID_AHK_VIMMODE

;///////////////////////////////////////////////////////////////
;		Hot Key
;///////////////////////////////////////////////////////////////
; Reload Script
$!+r:: 
	Process, Close, %PID_AHK_VIMMODE%
	gbIsInitDone = False
	Reload
	Return

; Control Script Suspending
$^Delete::
	isGuiOn := True
	myMotto(200, "White")
	Process, Close, %PID_AHK_VIMMODE%
	ExitApp
	return

$!+a:: 
	Suspend, Toggle
	isGuiOn := True
	if (!A_IsSuspended) {
		Run, %typeandrun%
		SetCapsLockState, off
		myMotto(200)
		Run, %VimMode%, , , PID_AHK_VIMMODE
	} else {
		closeProcess("TypeAndRun.exe")
		myMotto(200, "Green")
		isGuiOn := False
		Process, Close, %PID_AHK_VIMMODE%
	}
	Return

; GUI Off
$!^a::
	myMotto(200, "F39C12")
	isGuiOn := !isGuiOn
	if (!isGuiOn) {
		Gui, Destroy
	}
	myMotto(200)
	Return

;------------------------------------
; Folder
;------------------------------------
!^z::	runOrActivateWin("Q-Dir", false, path_setting . "\Q-Dir\Q-Dir_x64.exe")
!^g::	Run, %AHJ_TB%
$#d:: 	Run, %USERPROFILE%\Desktop

;------------------------------------
; Program
;------------------------------------
$!^9::
$!^u:: runOrActivateProc(USERPROFILE . "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
;		Run, onenote:

$^.::
	if (gbIsInitDone) {
    	WinGet, p_name, ProcessName, ahk_pid %PID_GVIM_FAVORITE%

		if (p_name != "gvim.exe") {
			Run, gvim "%gvimFavorite%\*.txt" "%USERPROFILE%\Desktop\_memo.txt",,, PID_GVIM_FAVORITE
			FileDelete, %gsPath_PID_GVIM_FAVORITE%
			FileAppend, %PID_GVIM_FAVORITE%, %gsPath_PID_GVIM_FAVORITE%
			return
		}

    	WinGet, curPid, PID, A
		
		if (curPid != PID_GVIM_FAVORITE) {
			WinActivate, ahk_pid %PID_GVIM_FAVORITE%
		} else {
			Send, ^p
		}
	}
	return

!^h::	activateSelectPid(1)
!^j::	activateSelectPid(2)
!^k::	activateSelectPid(3)
!^l::	activateSelectPid(4)

!^+h::	setSelectPid(1)	
!^+j::	setSelectPid(2)	
!^+k::	setSelectPid(3)	
!^+l::	setSelectPid(4)	

$!^e::	runOrActivateGitBash(AHJ_TB)

$#n::
	cur_path := Explorer_GetCurrentPath()
	if (cur_path) {
		FormatTime, cur_time ,, yyMMddHHmm
		FileAppend, This is a new file.`n, %cur_path%\NewFile_%cur_time%.txt
	}
	return

$!^n:: 
	cur_path := Explorer_GetCurrentPath()
	if (cur_path) {
		runOrActivateGitBash(cur_path)
	}
	return

#c::
	runOrActivateWin("캡처 도구", false, "SnippingTool")
	if (getOsVer() == 10) {
		Send, ^n
	}
    Return
    
!^c:: runOrActivateWin("- chrome", false, "chrome")

; MobaXterm
$!^m:: runOrActivateProc("C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe")

; Internet Explorer
$!^i::runOrActivateWin("- Internet Explorer", false, "iexplore.exe")

;Visual Studio Code
!^[::
!^]::
	cmd := USERPROFILE . "\AppData\Local\Programs\Microsoft VS Code\Code.exe"
	runOrActivateWin("- Visual Studio Code", false, cmd)
	return

; KakaoTalk
$!^`;::
	IfExist, C:\Program Files (x86)\Kakao
		cmd := "C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe"
	else
		cmd := "C:\Program Files\Kakao\KakaoTalk\KakaoTalk.exe"

	runOrActivateWin("카카오톡", false, cmd)
	return

; SystemSettings.exe
$!^s:: Run, ms-settings:bluetooth

;------------------------------------
; Web Page
;------------------------------------
!^o:: 
    subName = Google Keep
    url = https://keep.google.com
    Title := openOrActivateUrl(subName, false, url, false)
    return

!^q:: 
    subName = 다음 영어사전
    url = http://small.dic.daum.net/index.do?dic=eng
    Title := openOrActivateUrl(subName, false, url, true)
    W = 389
    H = 420
    WinMove, %Title%, , A_screenWidth - W, A_screenHeight - H, W, H
    return

; Mail
$!^d::
	if (VPC_ActivateVpcIfExist()) {
		Send, !^d
	} else if (isOffice) {
		runOrActivateWin("- chrome", false, "chrome")
	} else {
		openOrActivateUrl(gsMailUriTitle, false, gsMailUriAddress)
	}
	return 

$MButton::
	if (VPC_IsCurWinVpc() && isOffice) {
		Send, {RButton}
		tmp := clipboard
		clipboard=""
		sleep, 50
		Send, e
		sleep, 50

		if (InStr(clipboard, "http") == 1) {
			Run, Chrome.exe %clipboard%
			VPC_FocusOut()
		}
		clipboard := tmp
	} else {
		Send, {MButton}
	}
	return 

$!^f::  openOrActivateUrl("Google 캘린더", false, "https://calendar.google.com/calendar/b/" . google_homeID_num . "/r")

$!^8:: runOrActivateWin("- notepad++", false, "notepad++")


; Virtual Desktop Toggle
$^,::
	if (VPC_SwitchWinIfExist()) {
		return
	}

	if (isVirtualDesktopLeft) {
		Send, ^#{right}
	} else {
		Send, ^#{left}
	}
	isVirtualDesktopLeft := !isVirtualDesktopLeft
	Return

; TypeAndRun
$!^p::
	VPC_FocusOut()
	Send, !^p
	return

!^0::
	url_CurTabNum := Mod(url_CurTabNum, url_MaxTabNum) + 1
	activateChromeTabAsSpecificUri(url_CurTabNum)
	return

;------------------------------------
; YouTube
;------------------------------------
!^y:: openOrActivateUrl("YouTube", false, "https://www.youtube.com/")

;------------------------------------
; Key & System
;------------------------------------
Capslock::Ctrl

$!^b::
!^+c::
	if (GetKeyState("CapsLock", "T")) {
		SetCapsLockState, off
	} else {
		SetCapsLockState, on
	}
	return

$!^F1::Send, {F1}

$SC11d:: RControl
; special character translator(Shift & Right Alt)
Shift & SC138:: Send, {sc1f1}

; korean english trans
;+SPACE:: Send, {vk15SC138}
!^Space:: Send {Home}+{End}
#,::Send {backspace}
#.::Send {delete}

$+ESC:: Send, ~
$`:: Send, {ESC}

$^`:: Send, ^``

$!Esc::
$!`:: Send ``

^#m:: Send {AppsKey}
^#s:: Send {F2}
!^w:: Send !{F4}

; For Right Hand
RShift & Left:: 	Send, ^c
RShift & Down:: 	Send, ^z
RShift & Up::	 	Send, ^+z
RShift & Right:: 	Send, ^v

RShift & Delete:: 	Send, ^x

+PrintScreen:: 	Send, {PrintScreen}
+ScrollLock:: 	Send, {ScrollLock}
+Pause:: 		Send, {Pause}

; Virtual Desktop 
$^#w:: Send ^#{F4}
$^#n:: Send ^#{left}
$^#p:: Send ^#{right}

#h:: Send {Left}
#j:: Send {Down}
#k:: Send {Up}
#l:: Send {Right}

#w:: Send {Home}
#s:: Send {End}
#q:: Send {PgUp}
#a:: Send {PgDn}

$^n:: 
    WinGet, p_name, ProcessName, A

    if (p_name == "KakaoTalk.exe") {
        mouseMoveOnRightMid()
        Send, {WheelDown}
    } else if (p_name == "powershell.exe") {
		Send, {Down}
	} else {
		Send, ^n
	}
    return

$^p::
    WinGet, p_name, ProcessName, A

    if (p_name == "KakaoTalk.exe") {
        mouseMoveOnRightMid()
        Send, {WheelUp}
    } else if (p_name == "powershell.exe") {
		Send, {Up}
	} else {
		Send, ^p
	}
    return

$^#,:: 
    If isInActiveProcessName("Chrome.exe")
        Send, !{Left}
    else
        Send, ^#,
    return
$^#.:: 
    If isInActiveProcessName("Chrome.exe")
        Send, !{Right}
    else
        Send, ^#.
    return

$^BS:: Send ^+{Left }{Backspace}
!^BS:: Send ^+{Right}{Backspace}

; Sound Control
#`:: Send {Volume_Down}
#1:: Send {Volume_Up}
#2:: Send {Volume_Mute}

; Click Window
#!^,:: 
	mouseMoveOnRightMid()
	Send, {LButton}
	return

; Windows Always on Top Toggle
#'::
    WinGetTitle, Title, A
    WinSet, Alwaysontop, Toggle, %Title%
    return

$!^F12::
	existFlag := False
	subName := " - GVIM"
    WinGet windows, List
    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%
        IfInString, Title, %subName%, {
			existFlag := True
			WinActivate, %Title%	
		}
    }
	if (!existFlag) 
		MsgBox, There is no GVIM window.
	return 

$!^-:: Send, -------------------------------------------------------------

;------------------------------------
; Display Resolution
;------------------------------------
!^+=::ChangeResolution(32,1920,1080,60)
!^+-::ChangeResolution(32,1360,768, 60)

ChangeResolution( cD, sW, sH, rR ) {
  VarSetCapacity(dM,156,0), NumPut(156,2,&dM,36)
  DllCall("EnumDisplaySettingsA", UInt,0, UInt,-1, UInt,&dM ), 
  NumPut(0x5c0000,dM,40)
  NumPut(cD,dM,104), NumPut(sW,dM,108), NumPut(sH,dM,112), NumPut(rR,dM,120)
  Return DllCall("ChangeDisplaySettingsA", UInt,&dM, UInt,0 )
}
; color_depth: The number of bits per pixel for color (leave at 32 for most purposes)
; width: width of the screen in pixels
; height: height of the screen in pixels
; refresh rate: the screen frequency (typically 60Hz, 4k: 30Hz

; Test
!^+o:: 
	cur_path := Explorer_GetCurrentPath()
	if (cur_path) {
		MsgBox % cur_path
		FormatTime, cur_time ,, yyMMddHHmm
		FileAppend, This is a new file.`n, %cur_path%\NewFile_%cur_time%.txt
	}
	return

	;testFunc(USERPROFILE . " " . A_ScriptName)
	;return 

!^+u::
	WinGetTitle, Title, A
	WinGet, PName, ProcessName, A
	MsgBox, ProcessName: %PName% `n WinTitle: %Title%
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
	TEXT := "    True Nobility is being Superior to Your Former Self.    "
	h := 40
	y := A_ScreenHeight - h

	if (isGuiOn) {
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
}

alarm() {
	m_interval 		:= 15
	ms_interval		:= m_interval * 60 * 1000
	ms_alarm_time 	:= 20000

	while True {
		Sleep % ms_interval
		myMotto(ms_alarm_time)
	}
}

isInActiveProcessName(str) {
    WinGet, p_name, ProcessName, A
    return, InStr(p_name, str)
}

mouseMoveOnRightMid() {
    WinGetPos, , , Width, Height, A
    x_corner := Width - 40
    y_mid    := Height // 2
    MouseMove, %x_corner%, %y_mid%, 0
}

closeProcess(pidOrName) {
	Process, Exist, %pidOrName%,
	Process, Close, %ErrorLevel%
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

activateChromeTabAsSpecificUri(tabNum)
{
	runOrActivateWin("- chrome", false, "chrome")
	Send, ^{%tabNum%}
	sleep, 100
    WinGetTitle, T, A
	if (!InStr(T, garUriTitle[tabNum]))
	{
		Send, ^l
		clipboard := garUriAddress[tabNum]
		sleep, 60
		Send, ^v
		Send, {Enter}
	}
	return
}

getUriArrayFromFile(path, arTitle, arAddress)
{
	local bIsTitleReadTurn := True
	local cnt := 0

	Loop, Read, %path%
	{
		if bIsTitleReadTurn
		{
			arTitle.Push(A_LoopReadLine)
			cnt += 1
		}
		else
		{
			arAddress.Push(A_LoopReadLine)
		}
		bIsTitleReadTurn := !bIsTitleReadTurn
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

activateSelectPid(index)
{
	if (!gbIsInitDone)
		return

	pid := garSelectPid_pid[index]

	Process, Exist, %pid%,

	if (!ErrorLevel)
		return

	WinActivate, ahk_pid %pid%

    WinGetPos, X, Y, W, H, A
	
	Gui, Color, F39C12
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Show, x%X% y%Y% w%W% h%H% NoActivate,

	Sleep % 40
	Gui, Destroy
}

setSelectPid(index)
{
	if (!gbIsInitDone)
		return

	WinGet, PID, PID, A
	garSelectPid_pid[index] := PID

	path := garSelectPid_file[index]
	FileDelete, %path%
	FileAppend, %PID%, %path%
	myMotto(300)
}

Explorer_GetCurrentPath(hwnd="") {
    WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
    WinGetClass class, ahk_id %hwnd%
    if  (process = "explorer.exe") 
        if (class ~= "(Cabinet|Explore)WClass") {
            for window in ComObjCreate("Shell.Application").Windows
                if  (window.hwnd==hwnd)
                    path := window.Document.FocusedItem.path

            SplitPath, path,,dir
        }
        return dir
}
