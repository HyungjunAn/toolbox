;###############################################################
; AD's HotKey
;###############################################################

;///////////////////////////////////////////////////////////////
;		TODO
;///////////////////////////////////////////////////////////////
; vpc gui 배너 뜰 수 있게 하면 이쁠듯
;Alt-tab이 VPC일 때는 원복으로 동작하게
;근태 들어가는 단축키 생성(새로 켜게 하는 것이 어떨런지 iexplorer에서)
;jira 테이블 왔다갔다 할때 데시보드 아니면 다시 대시보드로 돌아가게
;메일 EP 대시보드 주소 근태 주소 등 텍스트 파일로 관리(이거는 Office 안에 들어가게)
;Shift-Click 이거 Clipboard에 적히는 내용보고 jira 같은 거일때만 넘어가도록
;VPC일 때만 켜지는 단축키들을 별도의 스크립트로 관리
;타이머 용 별도 Script를 관리
;함수 모듈화 (#include)
;캡쳐단축키 Win 10은 따로 있던데 이거 어떻게 될런지
;GUI 이름 변경 & 스크립트 따로 분리
;Program Switch -> Process Switch
;URI 파일 GVIM 켤 수 있게
;GVIM 찾아 바꾸기 어떻게 하는지 정리

;///////////////////////////////////////////////////////////////
;		Serial Code
;///////////////////////////////////////////////////////////////
#include %A_ScriptDir%
#include Lib_VPC.ahk

SetWorkingDir, %A_ScriptDir%
global path_setting := getParentPath(A_ScriptDir)

global On 				:= True
global Off 				:= False
global Toggle			:= -1

global isGuiOn			:= True
global url_CurTabNum	:= 0
global url_MaxTabNum	:= 2
global url_epTabNum  	:= url_MaxTabNum + 1
global url_mailTabNum 	:= url_MaxTabNum + 2
global did_I_Think		:= False

global recentlyWinTitle1
global recentlyWinTitle2

global google_drive := USERPROFILE . "\Google 드라이브"
global xnote_timer	:= path_setting . "\XNote_Timer\xntimer.exe"

global git_bash			:= "C:\Program Files\Git\git-bash.exe"
global dir_typeandrun	:= "D:\myUtility\TypeAndRun\"
global typeandrun		:= dir_typeandrun . "\TypeAndRun.exe"
global typeandrun_cfg	:= path_setting . "\TypeAndRun\Config.ini"

global office_worklib 			:= "D:\Library"
global office_worklib_setting 	:= office_worklib . "\setting"

global PID_AHK_BROWSINGMODE 	:= 0
global PID_AHK_DISABLE_CAPSLOCK	:= 0

global isOffice := False
global google_homeID_num := 0

myMotto(500)

If (A_UserName == "hyungjun.an") {
    isOffice := True
    google_homeID_num := 1
	typeandrun_cfg := office_worklib_setting . "\TypeAndRun\Config.ini"
}

ifExist, %typeandrun%, {
	closeProcess("TypeAndRun.exe")
	ifExist, %typeandrun_cfg%, {
		FileDelete, %dir_typeandrun%\~Config.ini
		FileCopy, %typeandrun_cfg%, %dir_typeandrun%\Config.ini, 1
	}
	Run, %typeandrun%
}

IfInString, A_ScriptName, .ahk, {
	ext = ahk
} else {
	ext = exe
}

BrowsingMode 	= BrowsingMode.%ext%
DisableCapslock = DisableCapslock.%ext%

programSwitch(PID_AHK_DISABLE_CAPSLOCK, DisableCapslock, On)

SetCapsLockState, off
SetScrollLockState, off

;alarm()

;///////////////////////////////////////////////////////////////
;		Hot Key
;///////////////////////////////////////////////////////////////
; Reload Script
$!^r:: 
	programSwitch(PID_AHK_DISABLE_CAPSLOCK, DisableCapslock, Off)
	Reload
	Return

;$!^F12:: did_I_Think := True

; Suspend & Control Mode
$!+a:: 
	Suspend, Toggle
	programSwitch(PID_AHK_DISABLE_CAPSLOCK, DisableCapslock, "switch")
	if (A_IsSuspended) {
		closeProcess("TypeAndRun.exe")
	} else {
		Run, %typeandrun%
	}
	suspend_context()
	return 

; GUI Off
$!^a::
	if (isGuiOn) {
		myMotto(200, "Red")
		isGuiOn := False
	}
	else {
		isGuiOn := True
		myMotto(200)
	}
	Return
    ;Process, Exist, flux.exe
    ;PID := ErrorLevel
    ;Process, Close, flux.exe
    ;Run, %USERPROFILE%\AppData\Local\FluxSoftware\Flux\flux.exe
    ;while !InStr(WinTitle, "f.lux")
    ;    WinGetTitle, WinTitle, A
    ;WinWaitActive, %WinTitle%
    ;if PID {
    ;    WinClose, %WinTitle%
    ;}
    ;else {
    ;    Send, !{F4}
    ;}
    ;return

;------------------------------------
; Folder
;------------------------------------
!^z::
	if (isOffice) {
		runOrActivateWin("Q-Dir", false, "C:\Program Files (x86)\Q-Dir\Q-Dir.exe")
		;Run, %USERPROFILE%\Downloads
	}
	else {
		Run, %google_drive%
	}
	return
!^,::
	if (isOffice) {
		Run, %office_worklib%
	}
	else {
		Run, %google_drive%\Library
	}
	return

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
$!^u:: runOrActivateWin("_memo.md", 	false, "gvim %USERPROFILE%\desktop\_memo.md")
;$!^m::Run, C:\Users\kysung\desktop\hyungjun_office\memo.xlsx
$!^v:: runOrActivateWin("vimrc_AD.vim",	false, "gvim vim\vimrc_AD.vim")
$!^+v::runOrActivateWin("_vimrc", 		false, "gvim %USERPROFILE%\_vimrc")
!^+g:: 
	subName = %A_ScriptName%
	cmd		= gvim %A_ScriptName%
	runOrActivateWin(subName, false, cmd)
	return
!^+p:: runOrActivateWin("Config.ini", false, "gvim " . typeandrun_cfg)

$!^e::  runOrActivateGitBash("pc_setting", "--cd=""" . path_setting . """")
$!^+n:: runOrActivateGitBash("library", "--cd=""" . office_worklib . """")
;$!^e::Run, C:\Program Files\ConEmu\ConEmu64.exe -Dir %USERPROFILE%

#z::
	runOrActivateWin("캡처 도구", false, "SnippingTool")
	if (!isOffice) {
		Send, ^n
	}
    Return
    
!^c::
	runOrActivateWin("- chrome", false, "chrome")
    myMotto(1000)
    return

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
        Send, ^{F2}
    }
    else
        Send, {F6}
    return

; Internet Explorer
!^+i::
!^i::runOrActivateWin("- Internet Explorer", false, "iexplore.exe")

;Edit Time
!^+t::Run, chrome.exe --profile-directory="Profile 1" --app-id=mdkfiefeoimmobmhdimachkfcpkgahlc

;Window Media Player
;!^+p::  Run, wmplayer

;Visual Studio Code
!^[::
!^]::   Run, C:\Program Files\Microsoft VS Code\Code.exe

; KakaoTalk or LG ep
!^`;::
	If (!isOffice) {
		IfExist, C:\Program Files (x86)\Kakao
			Run, C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe
		else
			Run, C:\Program Files\Kakao\KakaoTalk\KakaoTalk.exe
	}
	else if (VPC_ActivateVpc()) {
		Send, !^`;
	}
	else {
		runOrActivateWin("- chrome", false, "chrome")
		Send, ^{%url_epTabNum%}
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
    W := 398
    WinMove, %Title%, , A_screenWidth - W, 0, W, 1078
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
	if VPC_ActivateVpc()
	{
		Send, !^d
	} else if (isOffice) {
		runOrActivateWin("- chrome", false, "chrome")
		Send, ^{%url_mailTabNum%}
	} else {
		openOrActivateUrl("Gmail", false, "https://mail.google.com/mail")
	}
	return 

$+LButton::
	Suspend, Permit
	if VPC_IsCurrWinVpc()
	{
		clipboard=""
		Send, {RButton}
		sleep, 100
		Send, e
		sleep, 100
		if clipboard
		{
			Run, Chrome.exe %clipboard%
		}
	} else { 
		Send, +{LButton}
	}
	return 

$!^f::  openOrActivateUrl("Google 캘린더", false, "https://calendar.google.com/calendar/b/" . google_homeID_num . "/r")
!^+z::  Run, https://drive.google.com/drive/u/%google_homeID_num%/my-drive

!^1::
$!^8:: runOrActivateWin("- notepad++", false, "notepad++")

; Switch Between VPC and Local
$!+n::
$!^n::
$^,::
	Suspend, Permit
	VPC_SwitchVpcAndLocal()
	Return

$!^F12:: gui_bar()

; TypeAndRun
$!^9::
$!^-::
$!^p:: Send, !^p
;	Suspend, Off
;	suspend_context()
;	if (isExistVPC()) {
;		if (findWindow(recentlyWinTitle2, True)) {
;			WinActivate, %recentlyWinTitle2%
;		} else {
;			runOrActivateWin("- notepad++", false, "notepad++")			
;		}
;		WinActivate, %recentlyWinTitle1%
;	}
;	Send, !^9
;	Return

!^0::
	runOrActivateWin("- chrome", false, "chrome")
	url_CurTabNum := Mod(url_CurTabNum, url_MaxTabNum)
	url_CurTabNum := url_CurTabNum + 1
	Send, ^{%url_CurTabNum%}
	;url     = https://translate.google.com/?hl=ko
	;url     = https://scholar.google.co.kr/
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

!^Space:: Send {Home}+{End}
#,::Send {backspace}
#.::Send {delete}

+Esc::Send ~

$Esc::
$`::keySwap_ifInTitle("XNote Timer", "!{F4}", "{Esc}")

$!Esc::
$!`:: Send ``
$Space::keySwap_ifInTitle("XNote Timer", "^{F2}", "{Space}")
$Enter::keySwap_ifInTitle("XNote Timer", "^{F3}", "{Enter}")

^#m:: Send {AppsKey}
^#s:: Send {F2}
!^w:: Send !{F4}

; For Right Hand
$PrintScreen:: Send, ^x
$ScrollLock:: Send, ^c
$Pause:: Send, ^v
RShift & PrintScreen:: Send, ^z
RShift & Pause:: Send, ^+z
LShift & PrintScreen:: Send, {PrintScreen}
LShift & ScrollLock:: Send, {ScrollLock}
LShift & Pause:: Send, {Pause}

; Virtual Desktop 
$^#w:: Send ^#{F4}
$^#n:: Send ^#{left}
$^#p:: Send ^#{right}

; Window Positioning
!^h:: Send #{left}
!^j:: Send #{down}
!^k:: Send #{up}
!^l:: Send #{right}

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

RShift & Left::
!^+o:: 
	testFunc(USERPROFILE . " " . A_ScriptName)
	return 
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
destroyAllGui() {
    Gui, MyMotto_GUI:Destroy
    Gui, Suspend_GUI:Destroy
    Gui, Alarm_GUI:Destroy
	Gui, Bar_GUI:Destroy
}

myMotto(Time, Color := "White") {
	h := 40
    y := A_screenHeight - h
	c := "Black"
	if (Color != "White") {
		c := "White"
	}

    Gui, MyMotto_GUI:Color, %Color%
    Gui, MyMotto_GUI:-Caption +alwaysontop +ToolWindow
    Gui, MyMotto_GUI:Font, s15 c%c%, Consolas
    Gui, MyMotto_GUI:Add, Text, , True Nobility is being Superior to Your Former Self. - Hemingway

	if (isGuiOn) {
    	Gui, MyMotto_GUI:Show, y%y% h%h% NoActivate
    	Sleep, %Time%
    	Gui, MyMotto_GUI:Destroy
	}
}

gui_bar() {
	static isOn := True
	h := 30
    y := A_screenHeight - h - 40
	w := A_screenWidth
	Color := "F39C12"		; Orange

    Gui, Bar_GUI:Color, %Color%
    Gui, Bar_GUI:-Caption +alwaysontop +ToolWindow
    Gui, Bar_GUI:Font, s10 cBlack, Consolas
    Gui, Bar_GUI:Add, Text, , True Nobility is being Superior to Your Former Self. - Hemingway

	if (isGuiOn && isOn) {
    	Gui, Bar_GUI:Show, y%y% w%w% h%h% NoActivate
	} else {
    	Gui, Bar_GUI:Destroy
	}
	isOn := !isOn
}

suspend_notice() {
	h := 30
    y := A_screenHeight - h - 40
	w := A_screenWidth

	Gui, Suspend_GUI:Color, Red
	Gui, Suspend_GUI:-Caption +alwaysontop +ToolWindow
	Gui, Suspend_GUI:Show, y%y% w%w% h%h% NoActivate,
	return
}

alarm_gui(sleepTime) {
	h := 40
	if (did_I_Think) {
		w := 100
	} else {
		w := A_screenWidth
	}
	y := A_screenHeight - h

	Gui, Alarm_GUI:Color, Red
	Gui, Alarm_GUI:-Caption +alwaysontop +ToolWindow
	if (isGuiOn) {
		Gui, Alarm_GUI:Show, y%y% w%w% h%h% NoActivate,
		Sleep, %sleepTime%
		Gui, Alarm_GUI:Destroy
	}
}
alarm() {
	m_interval 		:= 10
	alarm_time 		:= 400
	alarm_interval 	:= 200
	repeat_n 		:= 10

	while True {
	    FormatTime, s, , s
	    FormatTime, m, , m
	    if !Mod(m, m_interval) {
	        Loop %repeat_n% {
	            alarm_gui(alarm_time)
	            Sleep, %alarm_interval%
	        }
	        Sleep % 60000 * m_interval - ((alarm_time + alarm_interval) * repeat_n + 200)
	    }
	    else {
	        Sleep % (60 - s) * 1000
		}
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

programSwitch(ByRef PID, ByRef RunCmd, Mode := "switch") {
    if (Mode = Off || PID) {
		Process, Close, %PID%,
		PID := 0
	}
    else if (Mode = Off || !PID) {
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

suspend_context() {
	destroyAllGui()
	if (A_IsSuspended) {
		suspend_notice()
		isGuiOn := false
    	programSwitch(PID_AHK_BROWSINGMODE, BrowsingMode, "off")
	}
	else {
		isGuiOn := True
	}
	return
}

closeProcess(processName) {
	Process, Exist, %processName%,
	Process, Close, %ErrorLevel%
	return
}

getParentPath(path) {
	return SubStr(path, 1, InStr(SubStr(path,1,-1), "\", 0, 0)-1)
}
