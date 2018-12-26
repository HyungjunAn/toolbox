;####################################
; AD's HotKey
;####################################

myMotto(1000)
SetWorkingDir, %A_ScriptDir%
google_drive = %USERPROFILE%\Google 드라이브
PID_ALARM   := 0
PID_BROWSINGMODE := 0

IfInString, A_ScriptName, .ahk, {
	ext = ahk
} else {
	ext = exe
}

Main         = Main.%ext%
Alarm        = Alarm.%ext%
BrowsingMode = BrowsingMode.%ext%

programSwitch(PID_ALARM, Alarm, "on")

If (A_UserName != "hyungjun.an") {
    isOffice := False
    google_homeID_num := 0
}
else {
    isOffice := True
    google_homeID_num := 1
}

SetCapsLockState, off
SetScrollLockState, off

myMotto(Time) {
    Gui, Color, White
    ;Gui, Color, Red
    Gui, -Caption +alwaysontop +ToolWindow
    ;Gui, Font, s15 cWhite, Consolas
    Gui, Font, s15 cBlack, Consolas
    Gui, Add, Text, , True Nobility is being Superior to Your Former Self. - Hemingway
    y := A_screenHeight - 40
    Gui, Show, y%y% NoActivate
    Sleep, %Time%
    Gui, Destroy
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


$!^r::
    programSwitch(PID_ALARM, Alarm, "off")
	Reload

programSwitch(ByRef PID, ByRef RunCmd, Mode := "switch") {
    if (Mode = "off" || PID) {
        Process, Close, %PID%,
        PID := 0
    }
    else if (Mode = "on" || !PID)
        Run, %RunCmd%, , , PID
}

; Control Mode
#v:: 
    Suspend
    programSwitch(PID_BROWSINGMODE, BrowsingMode, "off")
    Return

$!^a::programSwitch(PID_BROWSINGMODE, BrowsingMode)
    
; f.lux & AHK Alarm Switch
!^+f::
	myMotto(500)
	programSwitch(PID_ALARM, Alarm)
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
    ;    programSwitch(PID_ALARM, Alarm, "off")
    ;}
    ;else {
    ;    Send, !{F4}
    ;    programSwitch(PID_ALARM, Alarm, "on")
    ;}
    ;return

;------------------------------------
; Folder
;------------------------------------
!^z::
	if (isOffice) {
		Run, %USERPROFILE%\Downloads
	}
	else {
		Run, %google_drive%
	}
	return
!^,::
	if (isOffice) {
		openOrActivateUrl("Collaboration Center", false, "http://collab.lge.com/main/pages/viewpage.action?pageId=878183139")
	}
	else {
		Run, %google_drive%\Library
	}
	return

!^g::Run, %A_ScriptDir%

!^+r::Run, shell:RecycleBinFolder 

!^+e:: Run, %USERPROFILE%\AppData\Local\lxss\home\hyungjun

; DropBox
!^b::Run, Z:\\

;------------------------------------
; Program
;------------------------------------
$!^u:: runOrActivateWin("_memo.md", 	false, "gvim %USERPROFILE%\desktop\_memo.md")
;$!^m::Run, C:\Users\kysung\desktop\hyungjun_office\memo.xlsx
$!^v:: runOrActivateWin("vimrc_AD.vim",	false, "gvim vim\vimrc_AD.vim")
$!^+v::runOrActivateWin("_vimrc", 		false, "gvim %USERPROFILE%\_vimrc")
!^+g:: 
	subName = %A_ScriptName%
	cmd		= gvim %A_ScriptName%"
	runOrActivateWin(subName, false, cmd)
	return
$!^e:: Run, C:\Program Files\Git\git-bash.exe
;$!^e::Run, C:\Program Files\ConEmu\ConEmu64.exe -Dir %USERPROFILE%

#z::
    Run, SnippingTool
    WinWait, 캡처 도구
    WinActivate, 캡처 도구
    while (ErrorLevel) {
    }
	Send, ^n
    Return
    
!^c::
	runOrActivateWin("- chrome", false, "chrome")
    myMotto(1000)
    return

; PuTTY
!^p::
    Run, PuTTY
    WinWaitActive, PuTTY Configuration, , 2
    if !ErrorLevel
        Send, !e{Tab}{Down}
    return

; XNote Timer
!^t::
    Process, Exist, xntimer.exe
    if !ErrorLevel {
        Run, %google_drive%\Utility\XNote_Timer\xntimer.exe
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
!^+p::  Run, wmplayer

;Notepad++
!^[::   runOrActivateWin("- notepad++", false, "notepad++")

;Visual Studio Code
!^]::   Run, C:\Program Files\Microsoft VS Code\Code.exe

; KakaoTalk or LG ep
!^`;::
	If !isOffice {
		IfExist, C:\Program Files (x86)\Kakao
			Run, C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe
		else
			Run, C:\Program Files\Kakao\KakaoTalk\KakaoTalk.exe
	}
	else {
		runOrActivateWin("lg ep", false, "chrome.exe -new-window ep.lge.com")
	}
	return

; SystemSettings.exe
$!^s:: Run, ms-settings:bluetooth

;------------------------------------
; Web Page
;------------------------------------
!^n::   Run, http://www.naver.com/more.html
$#n::   Run, http://www.senaver.com
!^o:: 
    subName = Google Keep
    URL = https://keep.google.com
    Title := openOrActivateUrl(subName, false, URL, true)
    W := 398
    WinMove, %Title%, , A_screenWidth - W, 0, W, 1078
    return
!^d::   openOrActivateUrl("Gmail", false, "https://mail.google.com/mail")
$!^f::  openOrActivateUrl("Google 캘린더", false, "https://calendar.google.com/calendar/b/" . google_homeID_num . "/r")
!^+z::  Run, https://drive.google.com/drive/u/%google_homeID_num%/my-drive
!^+b::  Run, https://www.dropbox.com/home
!^9::   Run, https://translate.google.com/?hl=ko
!^0::   Run, https://scholar.google.co.kr/
!^q:: 
    subName = 다음 영어사전
    URL = http://small.dic.daum.net/index.do?dic=eng
    Title := openOrActivateUrl(subName, false, URL, true)
    W = 389
    H = 420
    WinMove, %Title%, , A_screenWidth - W, A_screenHeight - H, W, H
    return

;------------------------------------
; YouTube
;------------------------------------
!^x:: Run, https://www.youtube.com/results?search_query=운동+노래
!^y:: openOrActivateUrl("YouTube", false, "https://www.youtube.com/")
!^+y::openOrActivateUrl("YouTube", false, "https://www.youtube.com/channel/UC4n_ME6BVRofHr4fVoBTdNg")

openOrActivateUrl(subName, isFullMatching, URL, isCancelingFullScreen=false) {
	cmd = chrome.exe --app=%URL%
	Title := runOrActivateWin(subName, isFullMatching, cmd, isCancelingFullScreen)
	return Title
}
runOrActivateWin(subName, isFullMatching, cmd, isCancelingFullScreen=false) {
	Title := findWindow(subName, isFullMatching)
	if !Title {
		Run, %cmd%
		while !Title {
			Title := findWindow(subName, isFullMatching)
		}
		WinActivate, %Title%
		if isCancelingFullScreen {
			Send, #{Down}
			sleep, 200
		}
	}
	WinActivate, %Title%
	return Title
}

findWindow(subName, isFullMatching) {
    WinGet windows, List
    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%
		if (isFullMatching) {
        	if (Title=%subName%) {
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
$`::  keySwap_ifInTitle("XNote Timer", "!{F4}", "{Esc}")
$!Esc::
$!`:: Send ``
$Space::keySwap_ifInTitle("XNote Timer", "^{F2}", "{Space}")
$Enter::keySwap_ifInTitle("XNote Timer", "^{F3}", "{Enter}")

$^+b::keySwap_ifInTitle("Chrome", "^+b!+t{F6}", "^+b")

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
!^+u::
!^+o::
    WinGetTitle, Title, A
    WinGet, PID, PID, A
    WinGetPos, x, y, W, H, %Title%
    MsgBox, %Title%`n`nx:%x% y:%y% W:%W% H:%H%`n`nPID: %PID%
    return
