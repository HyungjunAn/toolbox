;###############################################################
; AD's HotKey
;###############################################################

;///////////////////////////////////////////////////////////////
;		TODO
;///////////////////////////////////////////////////////////////
; openOr ~~ 이 계열 좀 깔끔하고 통일성 있게
;!^+i 단축키 유용성 판단해서 삭제
;메일 uri 파일에서 읽어오는 부분 필요없으면 삭제

;///////////////////////////////////////////////////////////////
; 	Color Table
;///////////////////////////////////////////////////////////////
;	F39C12: Orange

;///////////////////////////////////////////////////////////////
;		Serial Code
;///////////////////////////////////////////////////////////////
#include %A_ScriptDir%
#include Lib_Common.ahk
#include Lib_VPC.ahk

SetWorkingDir, %A_ScriptDir%
CoordMode, Screen

global path_setting := getParentPath(A_ScriptDir)

global tmpFolder			:= A_ScriptDir . "\tmp"
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

global DIRECTION_LEFT	:= 0
global DIRECTION_RIGHT	:= 1
global DIRECTION_UP		:= 2
global DIRECTION_DOWN	:= 3

global isOffice := False

global office_worklib 			:= "D:\library_office"
global office_worklib_setting 	:= office_worklib . "\setting"

global google_homeID_num := 0

myMotto()

; Make temp file
FileCreateDir, %tmpFolder%

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
	garSelectPid_file[A_Index] := tmpFolder . "/pidSelect_" . A_Index . ".txt"
	path := garSelectPid_file[A_Index]
	FileReadLine, PID, %path%, 1
	garSelectPid_pid[A_Index] := PID
}

SetCapsLockState, off
SetScrollLockState, off

healthNotification()

gbIsInitDone := True
Gui, Destroy

;///////////////////////////////////////////////////////////////
;		Hot Key
;///////////////////////////////////////////////////////////////
; Reload Script
$!^r:: 
	gbIsInitDone = False
	Reload
	Return

; Control Script Suspending
$^Delete::
	myMotto(200, "White")
	ExitApp
	return

$!^a:: 
	Suspend, Toggle
	if (!A_IsSuspended) {
		Run, %typeandrun%
		SetCapsLockState, off
		myMotto(200)
	} else {
		closeProcess("TypeAndRun.exe")
		myMotto(1000, "Green")
	}
	Return

;------------------------------------
; Folder
;------------------------------------
$!^g::	Run, %AHJ_TB%
$#d:: 	Run, %USERPROFILE%\Desktop

;------------------------------------
; Program
;------------------------------------
$!^z::	runOrActivateProc(path_setting . "\Q-Dir\Q-Dir_x64.exe")
$!^u::	runOrActivateProc(USERPROFILE . "\AppData\Local\Programs\Microsoft VS Code\Code.exe")

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
$!^n::	explorerUtil()

$#c::
	runOrActivateWin("캡처 도구", false, "SnippingTool")
	if (getOsVer() == 10) {
		SendInput, ^n
	}
    Return
    
!^c:: runOrActivateWin("- chrome", false, "chrome")

; MobaXterm
$!^m:: runOrActivateProc("C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe")

; KakaoTalk
$!^`;::
	IfExist, C:\Program Files (x86)\Kakao
		cmd := "C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe"
	else
		cmd := "C:\Program Files\Kakao\KakaoTalk\KakaoTalk.exe"

	runOrActivateWin("카카오톡", false, cmd)
	return

; Notepad++
$!^8::	runOrActivateProc("notepad++.exe")

;=============================================================
; Web Page
;-------------------------------------------------------------
; Dictionary
!^q:: openOrActivateUrl("네이버 영어사전", false, "https://en.dict.naver.com/#/mini/main")

; Google 캘린더
$!^f:: openOrActivateUrl("Google Calendar", false, "https://calendar.google.com/")

; Google Keep
$!^o:: openOrActivateUrl("Google Keep", false, "https://keep.google.com")

; Papago
$!^[:: openOrActivateUrl("Papago", false, "https://papago.naver.com/")

; Colab
$!^1:: openOrActivateUrl(" - Colaboratory", false, "https://colab.research.google.com")

; YouTube
$!^y:: openOrActivateUrl("YouTube", false, "https://www.youtube.com/")

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

!^0:: openOrActivateUrl(BR0_uriTitles[1], false, BR0_uriAddresses[1])
;BR0_maxTabNum := getUriArrayFromFile(BR0_uriListPath, BR0_uriTitles, BR0_uriAddresses)

$MButton::
	if (!isOffice || !VPC_OpenUrlOnLocal()) {
		SendInput, {MButton}
	}
	return 

$+MButton::
	SendInput, {RButton}
	tmp := Clipboard
	Clipboard := ""
	sleep, 50
	SendInput, e
	sleep, 50
	uri := Clipboard
	Clipboard := tmp

	if (InStr(uri, "http") == 1) {
		openUrl(uri, True)
	}
	return
	
;=============================================================


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

$!^i:: runWinFindTool()

!^9::
	BR0_curTabNum := Mod(BR0_curTabNum, BR0_maxTabNum) + 1
	ROA_BrowserTab(0, BR0_curTabNum)
	;BR1_curTabNum := Mod(BR1_curTabNum, BR1_maxTabNum) + 1
	;ROA_BrowserTab(1, BR1_curTabNum)
	return



;------------------------------------
; Key & System
;------------------------------------
Capslock::Ctrl
$!^s::	SetCapsLockState % !GetKeyState("CapsLock", "T")
$`::	SendInput, {ESC}
$^`::	SendInput, ^``
$!`::	SendInput, ``
^#m::	SendInput, {AppsKey}
!^w::	SendInput, !{F4}
$SC11d:: RControl
;special character translator(Shift & Right Alt)
Shift & SC138:: SendInput, {sc1f1}
; korean english trans
;+SPACE:: SendInput, {vk15SC138}

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
$!^Space:: SendInput, {Home}+{End}
$#,::	SendInput, {backspace}
$^#,::	SendInput, ^{Backspace}
$#.::	SendInput, {delete}
$^#.::	SendInput, ^{Delete}

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
	if (COMMON_GetActiveWinProcName() == "Code.exe") {
		SendInput, ^d^+f
	} else {
		SendInput, !f
	}
	return

$^n:: IfSend_UpDown(DIRECTION_DOWN, "^n")
$^p:: IfSend_UpDown(DIRECTION_UP, "^p")
$!,::	sendIfBrowser("!{Left}", "!,")
$!.::	sendIfBrowser("!{Right}", "!.")
$!^,::	sendIfBrowser("^+{Tab}", "!^,")
$!^.::	sendIfBrowser("^{Tab}", "!^.")

; Sound Control
#`:: SendInput, {Volume_Down}
#1:: SendInput, {Volume_Up}
#2:: SendInput, {Volume_Mute}

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

; Test
!^+o:: ListHotKeys
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

activateSelectPid(index)
{
	if (!gbIsInitDone)
		return

	pid := garSelectPid_pid[index]

	Process, Exist, %pid%,

	if (!ErrorLevel)
		return

	focusOnMain()

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

sendIfBrowser(str, elseStr) {
	p_name := COMMON_GetActiveWinProcName()

    if (p_name == "chrome.exe" || p_name == "firefox.exe") {
		SendInput, %str%
	} else {
		SendInput, %elseStr%
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

explorerUtil() {
	Local LineNum := 1
	Local Lines := ""
	Local ErrorMsg := ""
	Local f := ""

	cur_path := COMMON_GetActiveExplorerPath()

	if (!cur_path) {
		ErrorMsg := "Wrong Usage"
		goto, ERROR
	}

	Lines := Lines . "[" . (LineNum++) . "] " . "Make New File" . "`n"
	Lines := Lines . "[" . (LineNum++) . "] " . "Git Bash" . "`n"
	Lines := Lines . "[" . (LineNum++) . "] " . "Copy custom_macro.ahk`n"
	Lines := Lines . "[" . (LineNum++) . "] " . "Open with GVIM`n"
	Lines := Lines . "[" . (LineNum++) . "] " . "Open with Notepad++"
	
	InputBox, UserInput, Type Util #, %Lines%, , , , , , , 10
	
	if (ErrorLevel || !UserInput) {
		return
	}

	switch (UserInput)
	{
	case 1:
		FormatTime, cur_time ,, yyMMddHHmm
		FileAppend, This is a new file.`n, %cur_path%\NewFile_%cur_time%.txt
	case 2:
		runOrActivateGitBash(cur_path)
	case 3:
		f := cur_path . "\custom_macro.ahk"
		IfExist, %f%, {
			ErrorMsg := "Exist Already!!"
			goto, ERROR
		}
		srcF := A_ScriptDir . "\CustomMacro.ahk"
		FileCopy, %srcF%, %f%
	case 4:
		f := COMMON_GetSelectedItemPath()
		if (f) {
			Run, %AHJ_TB_AHK%\util_runOrActivateGvim.ahk "%f%"
		}
	case 5:
		f := COMMON_GetSelectedItemPath()
		if (f) {
			Run, notepad++.exe "%f%"
		}
	default: 
		ErrorMsg := "Invalid Command!!"
		goto, ERROR
	}
	return

ERROR:
	MsgBox, %ErrorMsg%
	return 
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

	text := text . "운동: 6/1W`n"
	text := text . "양치: 2/1D`n"
	text := text . "음주: 1/1W`n"
	text := text . "정식: 1/1D`n"
	text := text . "`n"
	text := text . "(X: 과자, 탄산, 과식, 과음, 단당)"

	MsgBox, %text%
}
