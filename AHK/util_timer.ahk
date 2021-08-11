#include lib_focus.ahk

FOCUS_MainDesktop()

;if (A_Args.Length() < 1) {
;	msg := "This script requires at least 1 parameters but it doesn't received`n"
;	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
;	MsgBox, %msg%
;    ExitApp
;}

; XNote Timer

global xnote_timer	:= TOOLBOX_ROOT . "\XNote_Timer\xntimer.exe"
global winTitle := "XNote Timer"
global pName := "xntimer.exe"

Process, Exist, %pName%
if !ErrorLevel {
    Run, %xnote_timer%
    WinWaitActive, %winTitle%, , 2
    SendInput, {F11}

	w := 200
	x := (A_ScreenWidth - w) / 2
	y := 0
	h := 50

	WinMove, %winTitle%, , x, y, w, h
}

F10::
	Process, Close, %pName%
	ExitApp
	return
