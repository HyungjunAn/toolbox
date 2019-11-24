;###############################################################
; AD's HotKey
;###############################################################

;///////////////////////////////////////////////////////////////
;		TODO
;///////////////////////////////////////////////////////////////
; vpc gui 배너 뜰 수 있게 하면 이쁠듯
;Alt-tab이 VPC일 때는 원복으로 동작하게
;VPC일 때만 켜지는 단축키들을 별도의 스크립트로 관리
;Program Switch -> Process Switch
;URI 파일 GVIM 켤 수 있게
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
#include Lib_VPC.ahk
#include Lib_Vim.ahk

SetWorkingDir, %A_ScriptDir%
global path_setting := getParentPath(A_ScriptDir)

global On 				:= True
global Off 				:= False
global Toggle			:= -1

global isVirtualDesktopLeft := True

global isGuiOn			:= True
global guiShowFlag		:= False

global recentlyWinTitle1
global recentlyWinTitle2

global google_drive := USERPROFILE . "\Google 드라이브"
global xnote_timer	:= path_setting . "\XNote_Timer\xntimer.exe"

global library				:= google_drive . "\Library"
global git_bash				:= "C:\Program Files\Git\git-bash.exe"
global dir_typeandrun		:= path_setting . "\TypeAndRun\exe"
global typeandrun			:= dir_typeandrun . "\TypeAndRun.exe"
global typeandrun_cfgSrc	:= path_setting . "\TypeAndRun\configSrc.txt"

global url_CurTabNum	:= 0
global url_MaxTabNum	:= 0

global gsUriListPath	:= "data/uri_list.txt"
global garUriTitle		:= []
global garUriAddress 	:= []

global gsMailUriTitle	:= "Gmail"
global gsMailUriAddress	:= "https://mail.google.com/mail"

global gsEpUriTitle		:= ""
global gsEpUriAddress	:= ""

global gsTmpGvimLibPid	:= "tmp/tmpGvimLibPid.txt"

global PID_GVIM_LIBRARY 		:= 0
global PID_AHK_BROWSINGMODE 	:= 0

global isOffice := False

global office_worklib 			:= "D:\Library"
global office_worklib_setting 	:= office_worklib . "\setting"

global google_homeID_num := 0

myMotto(300)

;-------------------------------------------
; 	Process about Office Environment
;-------------------------------------------
If (A_UserName == "hyungjun.an") {
    isOffice := True
    google_homeID_num := 1
	library				:= office_worklib
	typeandrun_cfgSrc	:= office_worklib_setting . "\TypeAndRun\configSrc.txt"
	gsUriListPath		:= office_worklib_setting . "\AHK\url_office.txt"

	path := office_worklib_setting . "\AHK\url_mail.txt"
	getUriFromFile(path, gsMailUriTitle, gsMailUriAddress)
	
	path := office_worklib_setting . "\AHK\url_ep.txt"
	getUriFromFile(path, gsEpUriTitle, gsEpUriAddress)
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
	ifExist, %typeandrun_cfgSrc%, {
		FileDelete, %dir_typeandrun%\~Config.ini
		cmd = util_mkTARConfig.ahk "%typeandrun_cfgSrc%" "%dir_typeandrun%\Config.ini"
		RunWait, %cmd%
	}
	Run, %typeandrun%
}

IfInString, A_ScriptName, .ahk, {
	ext = ahk
} else {
	ext = exe
}

BrowsingMode 	= BrowsingMode.%ext%

IfExist, %gsTmpGvimLibPid%, {
	FileReadLine, PID_GVIM_LIBRARY, %gsTmpGvimLibPid%, 1
}

SetCapsLockState, off
SetScrollLockState, off

;alarm()

;///////////////////////////////////////////////////////////////
;		Hot Key
;///////////////////////////////////////////////////////////////
; Reload Script
$!+r:: 
	programSwitch(PID_AHK_BROWSINGMODE, BrowsingMode, Off)
	Reload
	Return

; Control Script Suspending
$!+ESC::
	isGuiOn := True
	myMotto(200, "White")
    programSwitch(PID_AHK_BROWSINGMODE, BrowsingMode, Off)
	ExitApp
	return

$!+a:: 
	Suspend, Toggle
	isGuiOn := True
	if (!A_IsSuspended) {
		SetCapsLockState, off
		myMotto(200)
	} else {
		myMotto(200, "Green")
		isGuiOn := False
    	programSwitch(PID_AHK_BROWSINGMODE, BrowsingMode, Off)
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
!^z::
	if (isOffice) {
		runOrActivateWin("Q-Dir", false, path_setting . "\Q-Dir\Q-Dir_x64.exe")
		;Run, %USERPROFILE%\Downloads
	}
	else {
		Run, %google_drive%
	}
	return
!^,:: 	Run, %library%
!^g::	Run, %A_ScriptDir%
!^+r::	Run, shell:RecycleBinFolder 
!^+e:: 	Run, %USERPROFILE%\AppData\Local\lxss\home\hyungjun
$#d:: 	Run, %USERPROFILE%\Desktop

; DropBox
!^b::Run, Z:\\

;------------------------------------
; Program
;------------------------------------
$!^m::
$^NumpadAdd:: runOrActivateWin("계산기", 	false, "calc")
$!^u:: 	runOrActivateWin("_memo.md", 	false, "gvim %USERPROFILE%\desktop\_memo.md")
;$!^m::Run, C:\Users\kysung\desktop\hyungjun_office\memo.xlsx
$!^v:: 	runOrActivateWin("vimrc_AD.vim",	false, "gvim """ . path_setting . "\vim\vimrc_AD.vim""")
$!^+v::	runOrActivateWin("_vimrc", 		false, "gvim %USERPROFILE%\_vimrc")
!^+g:: 	runOrActivateWin(A_ScriptName, false, "gvim """ . A_ScriptName . """")
!^+p:: 	runOrActivateWin("configSrc.txt", false, "gvim """ . typeandrun_cfgSrc . """")
$^.::
	Title := ""
	Process, Exist, %PID_GVIM_LIBRARY%

	if (ErrorLevel) {
		WinGetTitle, Title, ahk_pid %PID_GVIM_LIBRARY%
	}

	IfInString, Title, GVIM
	{
		WinActivate, ahk_pid %PID_GVIM_LIBRARY%
	} else {
		Run, "gvim ""%library%\*""",,, PID_GVIM_LIBRARY
		FileDelete, %gsTmpGvimLibPid%
		FileAppend, %PID_GVIM_LIBRARY%, %gsTmpGvimLibPid%
	}
	return

$!^e::  runOrActivateGitBash("pc_setting", "--cd=""" . path_setting . """")
$!^+n:: runOrActivateGitBash("library", "--cd=""" . office_worklib . """")
;$!^e::Run, C:\Program Files\ConEmu\ConEmu64.exe -Dir %USERPROFILE%

#z::
	runOrActivateWin("캡처 도구", false, "SnippingTool")
	if (getOsVer() == 10) {
		Send, ^n
	}
    Return
    
!^c:: runOrActivateWin("- chrome", false, "chrome")

; MobaXterm
$!^.:: 
	cmd = C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe
	runOrActivateWin("__", false, cmd)
	return 
   ; Run, C:\Program Files\PuTTY\putty.exe
   ; WinWaitActive, PuTTY Configuration, , 2
   ; if !ErrorLevel
   ;     Send, !e{Tab}{Down}
   ; return

; XNote Timer
!^t::
    Process, Exist, xntimer.exe
    if !ErrorLevel {
        Run, %xnote_timer%
        WinWaitActive, XNote Timer, , 2
        Send, {F11}
    } else {
		Process, Close, xntimer.exe
	}
    return

; Internet Explorer
$!^i::runOrActivateWin("- Internet Explorer", false, "iexplore.exe")

$!^+i::
	if (VPC_ActivateVpc()) {
		Send, !^+i
	} else if (isOffice) {
		runOrActivateWin("- Internet Explorer", false, "iexplore.exe")
		Send, ^1
	} else {
		;
	}
	return

;Edit Time
!^+t::Run, chrome.exe --profile-directory="Profile 1" --app-id=mdkfiefeoimmobmhdimachkfcpkgahlc

;Window Media Player
;!^+p::  Run, wmplayer

;Visual Studio Code
!^[::
!^]::   Run, C:\Program Files\Microsoft VS Code\Code.exe

; KakaoTalk or LG ep
$!^`;::
	if (VPC_ActivateVpc())
	{
		Send, !^`;
	}
	else if (isOffice)
	{
		openOrActivateUrl(gsEpUriTitle, true, gsEpUriAddress)
	}
	else
	{
		IfExist, C:\Program Files (x86)\Kakao
			Run, C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe
		else
			Run, C:\Program Files\Kakao\KakaoTalk\KakaoTalk.exe
	}
	return

; SystemSettings.exe
$!^s:: Run, ms-settings:bluetooth

;------------------------------------
; Web Page
;------------------------------------
$#n::   Run, http://www.senaver.com

!^o:: 
    subName = Google Keep
    url = https://keep.google.com
    Title := openOrActivateUrl(subName, false, url, true)
    ;W := 398
	;H := A_ScreenHeight - 40
    ;WinMove, %Title%, , A_screenWidth - W, 0, W, H
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
	if VPC_ActivateVpc() {
		Send, !^d
	} else if (isOffice) {
		runOrActivateWin("- chrome", false, "chrome")
	} else {
		openOrActivateUrl(gsMailUriTitle, false, gsMailUriAddress)
	}
	return 

$MButton::
	if VPC_IsCurrWinVpc() {
		Send, {RButton}
		tmp := clipboard
		clipboard=""
		sleep, 50
		Send, e
		sleep, 50
		if (InStr(clipboard, "http") == 1)
		{
			Run, Chrome.exe %clipboard%
		}
		clipboard := tmp
	} else {
		Send, {MButton}
	}
	return 

$!^f::  openOrActivateUrl("Google 캘린더", false, "https://calendar.google.com/calendar/b/" . google_homeID_num . "/r")
!^+z::  Run, https://drive.google.com/drive/u/%google_homeID_num%/my-drive

!^1::
$!^8:: runOrActivateWin("- notepad++", false, "notepad++")

; Virtual Desktop Toggle
$!+n::
$!^n::
$^,::
	if (isVirtualDesktopLeft) {
		Send, ^#{right}
	} else {
		Send, ^#{left}
	}
	isVirtualDesktopLeft := !isVirtualDesktopLeft
	Return

; TypeAndRun
$!^F12::
$!^9::
$!^-::
$!^p:: Send, !^p

!^0::
	url_CurTabNum := Mod(url_CurTabNum, url_MaxTabNum) + 1
	activateChromeTabAsSpecificUri(url_CurTabNum)
	return

;------------------------------------
; YouTube
;------------------------------------
!^x:: Run, https://www.youtube.com/results?search_query=운동+노래
!^y:: openOrActivateUrl("YouTube", false, "https://www.youtube.com/")
!^+y::openOrActivateUrl("YouTube", false, "https://www.youtube.com/channel/UC4n_ME6BVRofHr4fVoBTdNg")

;------------------------------------
; Key & System
;------------------------------------
Capslock::Ctrl
!^+c::Capslock

$SC11d:: RControl
; special character translator(Shift & Right Alt)
Shift & SC138:: Send, {sc1f1}

!^Space:: Send {Home}+{End}
#,::Send {backspace}
#.::Send {delete}

$+`::  
$+ESC:: Send, ~

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

; Window Positioning
!^h:: Send #{left}
!^j:: Send #{down}
!^k:: Send #{up}
!^l:: Send #{right}

#Down::	VPC_Send("", "#{down}")
#Up::	VPC_Send("", "#{up}")

#h:: Send {Left}
#j:: Send {Down}
#k:: Send {Up}
#l:: Send {Right}
^#h:: Send ^{Left}
^#j:: Send ^{Down}
^#k:: Send ^{Up}
^#l:: Send ^{Right}
+#h:: Send +{Left}
+#j:: Send +{Down}
+#k:: Send +{Up}
+#l:: Send +{Right}

#w:: Send {Home}
#s:: Send {End}
#q:: Send {PgUp}
#a:: Send {PgDn}
+#w:: Send +{Home}
+#s:: Send +{End}

$^n:: 
    If isInActiveProcessName("KakaoTalk.exe") {
        mouseMoveOnRightMid()
        Send, {WheelDown}
    }
    else
        keySwap_ifInTitle("powershell", "{Down}", "^n")
    return
$^p::
    If isInActiveProcessName("KakaoTalk.exe") {
        mouseMoveOnRightMid()
        Send, {WheelUp}
    }
    else
        keySwap_ifInTitle("powershell", "{Up}", "^p")
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

; Windows Always on Top Toggle
#'::
    WinGetTitle, Title, A
    WinSet, Alwaysontop, Toggle, %Title%
    return

;------------------------------------
; VI Mode
;------------------------------------

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

!^+o:: myMotto(10000)
	;testFunc(USERPROFILE . " " . A_ScriptName)
	;return 
!^+u::
	Path = %A_ScriptDir%
	Parent := SubStr(Path, 1, InStr(SubStr(Path,1,-1), "\", 0, 0)-1)
	msgbox %parent%
	Process, Exist, TypeAndRun.exe,
	Process, Close, %ErrorLevel%
	;MsgBox, %PID_TYPEANDRUN%
    WinGetTitle, Title, A
    WinGet, PID, PID, A
    WinGetPos, x, y, W, H, %Title%
    MsgBox, %Title%`n`nx:%x% y:%y% W:%W% H:%H%`n`nPID: %PID%
	MsgBox, %m_interval%
    return

testFunc(ByRef str) {
	msgBox, %str%
}

;///////////////////////////////////////////////////////////////
;		Function Def.
;///////////////////////////////////////////////////////////////

myMotto(Time, backC := "Red") {
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
		Sleep % Time
		Gui, Destroy
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

keySwap_ifInTitle(str, key1, key2) {
    WinGetTitle, Title, A
    IfInString, Title, %str%
        Send, %key1%
    else
        Send, %key2%
}

isInActiveProcessName(str) {
    WinGet, p_name, ProcessName, A
    return, InStr(p_name, str)
}

mouseMoveOnRightMid() {
    WinGetPos, , , Width, Height, A
    x_corner := Width - 25
    y_mid    := Height // 2
    MouseMove, %x_corner%, %y_mid%, 0
}

programSwitch(ByRef PID, ByRef RunCmd, Mode := -1) {
    if (Mode = Off || PID) {
		Process, Close, %PID%,
		PID := 0
	}
    else if (Mode = On || !PID) {
        Run, %RunCmd%, , , PID
	}
}

openOrActivateUrl(subName, isFullMatching, url, isCancelingFullScreen=false) {
	cmd = chrome.exe --app=%url%
	Title := runOrActivateWin(subName, isFullMatching, cmd, isCancelingFullScreen)
	return Title
}

runOrActivateWin(subName, isFullMatching, cmd, isCancelingFullScreen=false) {
	Local interval := 50
	Local check := 0

	Title := findWindow(subName, isFullMatching)
	if !Title {
		Run, %cmd%
		while (!Title && check < 1000) {
			Title := findWindow(subName, isFullMatching)
			sleep, %interval%
			check := check + interval
		}
		if !Title {
			return ""
		}
		if isCancelingFullScreen {
			WinActivate, %Title%
			Send, #{Down}
			sleep, 200
		}
	}
	WinActivate, %Title%
	return Title
}

runOrActivateGitBash(subName, option="") {
	Title := findWindow("MINGW64:", False)
	IfInString, Title, %subName%, {
		WinActivate, %Title%
	} else {
		Run, %git_bash% %option%
	}
}

findWindow(subName, isFullMatching=True) {
    WinGet windows, List
    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%
		if (isFullMatching) {
        	if (Title == subName) {
            	return %Title%
        	}
		}
		else {
        	IfInString, Title, %subName%, {
            	return %Title%
        	}
		}
    }
    return ""
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


$ESC::
$`::
	if (!VIM_ChangeMode_Command()) {
		Send, {ESC}
	}
	return

$#::
$i:: 
	if (!VIM_ChangeMode_Insert()) {
		Send, i
	}
	return

$v:: 
	if (!VIM_ChangeMode_Visual()) {
		Send, v
	}
	return

$h::VIM_SendKey("h", "{Left}")
$l::VIM_SendKey("l", "{Right}")
$j::VIM_SendKey("j", "{Down}")
$k::VIM_SendKey("k", "{Up}")

$w::VIM_SendKey("w", "^{Right}")
$b::VIM_SendKey("b", "^{Left}")


	


