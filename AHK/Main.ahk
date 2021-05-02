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
;!^+c::

;///////////////////////////////////////////////////////////////
;		Serial Code
;///////////////////////////////////////////////////////////////
#include %A_ScriptDir%
#include Lib_Common.ahk
#include Lib_VPC.ahk

SetWorkingDir, %A_ScriptDir%
global path_setting := getParentPath(A_ScriptDir)

global isGuiOn			:= True
global guiShowFlag		:= False

global library				:= USERPROFILE . "\Google 드라이브\Library"
global gvimFavorite			:= USERPROFILE . "\Desktop"
global dir_typeandrun		:= path_setting . "\TypeAndRun\exe"
global typeandrun			:= dir_typeandrun . "\TypeAndRun.exe"
global typeandrun_cfgSrc_Common	:= path_setting . "\TypeAndRun\configSrc_Common.txt"
global typeandrun_cfgSrc		:= path_setting . "\TypeAndRun\configSrc_Home.txt"

; For Chrome
global BR0_curTabNum	:= 0
global BR0_maxTabNum	:= 0
global BR0_uriListPath	:= "data/uri_list_browser0.txt"
global BR0_uriTitles		:= []
global BR0_uriAddresses 	:= []

; For Second Browser(ex. firefox, edge...)
global BR1_curTabNum	:= 0
global BR1_maxTabNum	:= 0
global BR1_uriListPath	:= "data/uri_list_browser1.txt"
global BR1_uriTitles		:= []
global BR1_uriAddresses 	:= []

global gsMailUriTitle	:= "Gmail"
global gsMailUriAddress	:= "https://mail.google.com/mail"

global gbIsInitDone 	:= False

global PID_GVIM_FAVORITE 		:= 0

global maxSelectPidNum		:= 4
global garSelectPid_pid		:= []
global garSelectPid_file	:= []

global PID_AHK_VIMMODE 			:= 0

global DIRECTION_LEFT	:= 0
global DIRECTION_RIGHT	:= 1
global DIRECTION_UP		:= 2
global DIRECTION_DOWN	:= 3

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
	BR0_uriListPath		:= office_worklib_setting . "\AHK\url_office.txt"

	path := office_worklib_setting . "\AHK\url_mail.txt"
	getUriFromFile(path, gsMailUriTitle, gsMailUriAddress)
}

;-------------------------------------------
; 	Get URI's Title and Address
;-------------------------------------------
BR0_maxTabNum := getUriArrayFromFile(BR0_uriListPath, BR0_uriTitles, BR0_uriAddresses)
BR1_maxTabNum := getUriArrayFromFile(BR1_uriListPath, BR1_uriTitles, BR1_uriAddresses)

;-------------------------------------------
; 	Process about TypeAndRun
;-------------------------------------------
reloadTypeAndRun()

;-------------------------------------------
; 	Process about PID
;-------------------------------------------
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
; Memo
;------------------------------------
; Google Keep - home
;!^o:: ROA_BrowserTab(1, 1)
!^o:: openOrActivateUrl("Google Keep", false, "https://keep.google.com")

; Google Keep - archive
;!^[::
;!^]:: ROA_BrowserTab(1, 3)


;------------------------------------
; Program
;------------------------------------
$!^u:: runOrActivateProc(USERPROFILE . "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
;		Run, onenote:

$^.::
	focusOnMain()
    WinGet, p_name, ProcessName, ahk_pid %PID_GVIM_FAVORITE%

	if (p_name != "gvim.exe") {
		FileList := "_memo.txt`n"

		Loop, Files, %gvimFavorite%\*.txt,
		{
			FileList .= A_LoopFileName "`n"
		}

		Loop, Parse, FileList, `n
		{
			title := findWindow(A_LoopField, False)

			if (title) {
				WinActivate, %title%
				WinWaitActive, %title%,, 2

				if (!ErrorLevel) {
    				WinGet, PID_GVIM_FAVORITE, PID, A
				}

				return
			}
		}

		Run, gvim "%gvimFavorite%\*.txt" "%USERPROFILE%\Desktop\_memo.txt",,, PID_GVIM_FAVORITE

		return
	}

    WinGet, curPid, PID, A
	
	if (curPid != PID_GVIM_FAVORITE) {
		WinActivate, ahk_pid %PID_GVIM_FAVORITE%
	} else {
		SendInput, ^p
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
		SendInput, ^n
	}
    Return
    
!^c:: runOrActivateWin("- chrome", false, "chrome")

; MobaXterm
$!^m:: runOrActivateProc("C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe")

; Internet Explorer
;$!^i::runOrActivateWin("- Internet Explorer", false, "iexplore.exe")

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
!^q:: openOrActivateUrl("네이버 영어사전", false, "https://en.dict.naver.com/#/main")
;!^q:: 
	;ROA_BrowserTab(1, 2)
    ;subName = 다음 영어사전
    ;url = http://small.dic.daum.net/index.do?dic=eng
    ;Title := openOrActivateUrl(subName, false, url, true)
    ;W = 389
    ;H = 420
    ;WinMove, %Title%, , A_screenWidth - W, A_screenHeight - H, W, H
    return

; Mail
$!^d::
	if (VPC_ActivateVpcIfExist()) {
		SendInput, !^d
	} else if (isOffice) {
		runOrActivateWin("- chrome", false, "chrome")
	} else {
		;ROA_BrowserTab(1, 6)
		openOrActivateUrl(gsMailUriTitle, false, gsMailUriAddress)
	}
	return 

$MButton::
	if (!isOffice || !VPC_OpenUrlOnLocal()) {
		SendInput, {MButton}
	}
	return 

RShift & Space::
	if (!isOffice || !VPC_OpenUrlOnLocal()) {
		SendInput, +{Space}
	}
	return 

; Google 캘린더
;$!^f:: ROA_BrowserTab(1, 5)
$!^f:: openOrActivateUrl("Google Calendar", false, "https://calendar.google.com/")

; Papago
;$!^t:: ROA_BrowserTab(1, 4)
$!^[:: openOrActivateUrl("Papago", false, "https://papago.naver.com/")

$!^1:: openOrActivateUrl(" - Colaboratory", false, "https://colab.research.google.com")

$!^8:: runOrActivateWin("- notepad++", false, "notepad++")


; Virtual Desktop Toggle
$^,::
	if (VPC_SwitchWinIfExist()) {
		return
	}

	VDesktop_toggle()
	Return

; TypeAndRun
$!^p::
	focusOnMain()
	SendInput, !^p
	return

$!^+p::
	reloadTypeAndRun()
	myMotto(300)
	return

$!^i:: runWinFindTool()

!^9::
	BR0_curTabNum := Mod(BR0_curTabNum, BR0_maxTabNum) + 1
	ROA_BrowserTab(0, BR0_curTabNum)
	;BR1_curTabNum := Mod(BR1_curTabNum, BR1_maxTabNum) + 1
	;ROA_BrowserTab(1, BR1_curTabNum)
	return

!^0:: openOrActivateUrl(BR0_uriTitles[1], false, BR0_uriAddresses[1])
;BR0_maxTabNum := getUriArrayFromFile(BR0_uriListPath, BR0_uriTitles, BR0_uriAddresses)

;------------------------------------
; YouTube
;------------------------------------
!^y:: openOrActivateUrl("YouTube", false, "https://www.youtube.com/")

;------------------------------------
; Key & System
;------------------------------------
Capslock::Ctrl

$F1:: SetCapsLockState % !GetKeyState("CapsLock", "T")

$!^F1::SendInput, {F1}

$SC11d:: RControl
; special character translator(Shift & Right Alt)
Shift & SC138:: SendInput, {sc1f1}

; korean english trans
;+SPACE:: SendInput, {vk15SC138}

$+ESC:: SendInput, ~
$`:: SendInput, {ESC}

$^`:: SendInput, ^``

$!Esc::
$!`:: SendInput, ``

^#m:: SendInput, {AppsKey}
^#s:: SendInput, {F2}
!^w:: SendInput, !{F4}

;=============================================================
; For Right Hand
;-------------------------------------------------------------
RShift & Left:: 	SendInput, ^c
RShift & Right:: 	SendInput, ^v
RShift & Down:: 	SendInput, ^z
RShift & Up::	 	SendInput, ^+z
RShift & Delete:: 	SendInput, ^x
RShift & Enter::
    WinGetTitle, Title, A
	if (Title == "작업 보기") {
		SendInput, {Esc}
	} else {
		SendInput, #{Tab}
	}
	return 

RShift & PgUp:: SendInput, ^{Tab}
RShift & PgDn:: SendInput, ^+{Tab}
RShift & SC11d:: SendInput, !{Tab}
;=============================================================

; Virtual Desktop 
$^#w:: SendInput, ^#{F4}
$^#n:: SendInput, ^#{left}
$^#p:: SendInput, ^#{right}

;-------------------------------------------------------------
; Move & Edit
;-------------------------------------------------------------
!^Space:: SendInput, {Home}+{End}
#,::SendInput, {backspace}
#.::SendInput, {delete}

; Undo
^#,::SendInput, ^z
; Redo
^#.::SendInput, ^y

#h:: SendInput, {Left}
#j:: SendInput, {Down}
#k:: SendInput, {Up}
#l:: SendInput, {Right}

+#h:: SendInput, +{Left}
+#j:: SendInput, +{Down}
+#k:: SendInput, +{Up}
+#l:: SendInput, +{Right}

^#h:: SendInput, ^{Left}
^#j:: SendInput, ^{Down}
^#k:: SendInput, ^{Up}
^#l:: SendInput, ^{Right}

+^#h:: SendInput, +^{Left}
+^#j:: SendInput, +^{Down}
+^#k:: SendInput, +^{Up}
+^#l:: SendInput, +^{Right}

#w:: SendInput, {Home}
#s:: SendInput, {End}
#q:: SendInput, {PgUp}
#a:: SendInput, {PgDn}

+#w:: SendInput, +{Home}
+#s:: SendInput, +{End}
+#q:: SendInput, +{PgUp}
+#a:: SendInput, +{PgDn}

$!f::
    WinGet, p_name, ProcessName, A

	if (p_name == "Code.exe") {
		SendInput, ^d^+f
	} else {
		SendInput, !f
	}
	return

$^n:: 
	if(!IfSend_UpDown(DIRECTION_DOWN)) {
		SendInput, ^n
	}
	return

$^p::
	if(!IfSend_UpDown(DIRECTION_UP)) {
		SendInput, ^p
	}
	return

$!,:: 
	if (!IfSend_LeftRight("!{Left}")) {
		SendInput, !,
	}
	return

$!.:: 
	if (!IfSend_LeftRight("!{Right}")) {
		SendInput, !.
	}
	return
	
$!^,:: 
	if (!IfSend_LeftRight("^+{Tab}")) {
		SendInput, !^,
	}
	return

$!^.:: 
	if (!IfSend_LeftRight("^{Tab}")) {
		SendInput, !^.
	}
	return

$^BS:: SendInput, ^+{Left}{Backspace}
!^BS:: SendInput, ^+{Right}{Backspace}

; Sound Control
#`:: SendInput, {Volume_Down}
#1:: SendInput, {Volume_Up}
#2:: SendInput, {Volume_Mute}

; Click Window
;#!^,:: 
;	mouseMoveOnRightMid()
;	SendInput, {LButton}
;	return

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

$!^-:: SendInput, -------------------------------------------------------------
$!^=:: SendInput, =============================================================

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
    WinGet, PID, PID, A
	MsgBox, PID: %PID%`nProcessName: %PName%`nWinTitle: %Title%
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

ROA_BrowserTab(browser, tabNum) {
	static readyChk := True

	local maxNum
	local uriTitles
	local uriAddresses
	local exePath := ""
	local tmp := ""

	if (!readyChk) {
		return
	} else {
		readyChk := False
	}

	focusOnMain()

	if (browser == 0) {
		exePath := PATH_CHROME
		BR0_curTabNum	:= tabNum
		maxNum			:= BR0_maxTabNum
		uriTitles		:= BR0_uriTitles
		uriAddresses	:= BR0_uriAddresses
	} else {
		exePath := PATH_FIREFOX
		BR1_curTabNum	:= tabNum
		maxNum			:= BR1_maxTabNum
		uriTitles		:= BR1_uriTitles
		uriAddresses	:= BR1_uriAddresses
	}

	if (!runOrActivateProc(exePath)) {
		Goto, FINISH
	}

	if (maxNum < tabNum) {
		MsgBox, Error: tabNum is bigger then MaxTabNum
		Goto, FINISH
	}

	SendInput, ^{%tabNum%}

	if (!COMMON_WinWait("", uriTitles[tabNum], 1000)) {
		SendInput, ^l
		sleep, 50
		tmp := Clipboard
		Clipboard := uriAddresses[tabNum]
		SendInput, ^v{Enter}
		COMMON_WinWait("", uriTitles[tabNum], 3000)
		Clipboard := tmp
	}

FINISH:
	readyChk := True
	return
}

getUriArrayFromFile(path, arTitle, arAddress)
{
	local bIsTitleReadTurn := True
	local cnt := 0
	local title := ""
	local uri := ""

	Loop, Read, %path%
	{
		local n := getTwoString(A_LoopReadLine, title, uri)

		if (n == 2) {
			arTitle.Push(title)
			arAddress.Push(uri)
			cnt += 1
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

	Sleep, 40
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

IfSend_UpDown(mode) {
	local isWheel := False
	local direction := (mode == DIRECTION_UP)? "Up": "Down"

    WinGet, p_name, ProcessName, A

    if (p_name == "KakaoTalk.exe" || p_name == "firefox.exe") {
		isWheel := True
    } else if (p_name == "PowerShell.exe") {
		;
	} else {
		return False
	}

	if (isWheel) {
        mouseMoveOnRightMid()
    	SendInput, {Wheel%direction%}
	} else {
		SendInput, {%direction%}
	}

	return True
}

IfSend_LeftRight(keystr) {
    WinGet, p_name, ProcessName, A

    if (p_name == "chrome.exe" || p_name == "firefox.exe") {
		SendInput, %keystr%
		return True
	} else {
		return False
	}
}

reloadTypeAndRun() {
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

	if (Line > 20) {
		Height := 800
	} else if (Line > 15) {
		Height := 500
	} else if (Line > 10) {
		Height := 300
	} else {
		Height := 200
	}

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
