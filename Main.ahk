;####################################
; AD's HotKey
;####################################

google_drive = %USERPROFILE%\Google 드라이브
Title_FFY    = Floating for YouTube™
isFirstChromeExcute := False
PID_ALARM   := 0
PID_BROWSINGMODE := 0

IfExist, %google_drive%\pc_sSetting, {
	SetWorkingDir, %A_ScriptDir%
	first_param = %1%
	If (first_param = "") {
    		isFirstChromeExcute := True
    		myMotto(20000)
	}
}

IfInString, A_ScriptName, .ahk
	ext = ahk
else
	ext = exe

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
    Gui, Color, Red
    Gui, -Caption +alwaysontop +ToolWindow
    Gui, Font, s15 cWhite, Consolas
    Gui, Add, Text, , True nobility is being superior to your former self. - Hemingway
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
    Run, Autohotkey.exe %Main% "blabla"
    return

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
    return

$!^a::programSwitch(PID_BROWSINGMODE, BrowsingMode)
    
; f.lux & AHK Alarm Switch
!^+f::programSwitch(PID_ALARM, Alarm)
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
!^z::Run, %google_drive%
!^,::Run, %google_drive%\Library
!^g::Run, %google_drive%\pc_setting

!^+r::Run, shell:RecycleBinFolder 

!^+e:: Run, %USERPROFILE%\AppData\Local\lxss\home\hyungjun

; DropBox
!^b::Run, Z:\\

;------------------------------------
; Program
;------------------------------------
$!^u::Run, gvim %USERPROFILE%\desktop\_memo.md
$!^m::Run, C:\Users\kysung\desktop\hyungjun_office\memo.xlsx
$!^v::Run, gvim vim\vimrc_AD.vim
!^+g::Run, gvim %A_ScriptName%
$!^e::Run, C:\Program Files\ConEmu\ConEmu64.exe -Dir %USERPROFILE%


#z::
    Run, SnippingTool
    WinWait, 캡처 도구
    WinActivate, 캡처 도구
    while (ErrorLevel) {
    }
	Send, ^n
    Return
    
!^c::
    if (isFirstChromeExcute) {
        ;Run, Chrome.exe https://mail.google.com
        isFirstChromeExcute := False
        Run, Chrome.exe
    }
    else 
        runOrActivateWin("- chrome", "chrome")
    myMotto(4000)
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
!^i::
	subName = - Internet Explorer
	Title := findWindow(subName)
	if !Title {
		Run, iexplore.exe
		while !Title {
			Title := findWindow(subName)
		}
	}
	else 
		WinActivate, %Title%
        Return

;Edit Time
!^+t::Run, chrome.exe --profile-directory="Profile 1" --app-id=mdkfiefeoimmobmhdimachkfcpkgahlc

;Trello
;!^+q::Run, chrome.exe --profile-directory="Profile 1" --app-id=gkcknpgdmiigoagkcoglklgaagnpojed

;Window Media Player
!^+p::  Run, wmplayer

;Notepad++
!^[::   runOrActivateWin("- notepad++", "notepad++")

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
		subName = lg ep
		Title := findWindow(subName)
		if !Title {
			Run, chrome.exe -new-window ep.lge.com
			while !Title {
				Title := findWindow(subName)
			}
		}
		else {
			WinActivate, %Title%
		}
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
    Title := openOrActivateUrl(subName, URL, true)
    W := 398
    WinMove, %Title%, , A_screenWidth - W, 0, W, 1078
    return
!^d::   openOrActivateUrl("Gmail", "https://mail.google.com/mail")
!^+i::  Run, https://aranetworks.sharepoint.com
$!^f::  openOrActivateUrl("Google 캘린더", "https://calendar.google.com/calendar/b/" . google_homeID_num . "/r")
!^+z::  Run, https://drive.google.com/drive/u/%google_homeID_num%/my-drive
!^+b::  Run, https://www.dropbox.com/home
!^9::   Run, https://translate.google.com/?hl=ko
!^0::   Run, https://scholar.google.co.kr/
!^q:: 
    subName = 다음 영어사전
    URL = http://small.dic.daum.net/index.do?dic=eng
    Title := openOrActivateUrl(subName, URL, true)
    W = 389
    H = 420
    WinMove, %Title%, , A_screenWidth - W, A_screenHeight - H, W, H
    return

;------------------------------------
; YouTube
;------------------------------------
!^x:: Run, https://www.youtube.com/results?search_query=운동+노래
!^y:: openOrActivateUrl("YouTube", "https://www.youtube.com/")
!^+y::openOrActivateUrl("YouTube", "https://www.youtube.com/channel/UC4n_ME6BVRofHr4fVoBTdNg")

openOrActivateUrl(subName, URL, isCancelingFullScreen=false) {
	cmd = chrome.exe --app=%URL%
	Title := runOrActivateWin(subName, cmd, isCancelingFullScreen)
	return Title
}
runOrActivateWin(subName, cmd, isCancelingFullScreen=false) {
	Title := findWindow(subName)
	if !Title {
		Run, %cmd%
		while !Title {
			Title := findWindow(subName)
		}
		WinActivate, %Title%
		if isCancelingFullScreen {
			Send, #{Up}
			sleep, 600
			Send, #{Down}
		}
	}
	else 
		WinActivate, %Title%
        return Title
}

findWindow(subName) {
    WinGet windows, List
    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%
        IfInString, Title, %subName%, {
            return %Title%
        }
    }
    return ""
}
            
; Floating for YouTube
$!q::
    WinGetTitle, Title, A
    IfInString, Title, YouTube - , {
        ClipBoard = 
        Send, {RButton}
        Sleep, 200
        Send, e

        if !ClipBoard {
            MouseGetPos, xpos, ypos   
            MouseMove, xpos + 10, ypos + 50
            Send {LButton}
        }
        WinClose, %Title_FFY%
        if isOffice
            Run, chrome.exe --profile-directory=Default --app-id=jjphmlaoffndcnecccgemfdaaoighkel
        else
            Run, chrome.exe --profile-directory="profile 1" --app-id=jjphmlaoffndcnecccgemfdaaoighkel
        WinWaitActive, %Title_FFY%
        Sleep, 1000
        Send, ^v
    }
    else
        Send, !q
    return

$!^+q::
    WinClose, %Title_FFY%
    Run, chrome.exe  --profile-directory=Default --app-id=jjphmlaoffndcnecccgemfdaaoighkel
    return

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
    MsgBox, %Title%
    MsgBox, x:%x% y:%y% W:%W% H:%H%
    MsgBox, PID: %PID%
    return

