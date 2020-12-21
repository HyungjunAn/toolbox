#include Lib_VPC.ahk

VPC_FocusOut()

;if (A_Args.Length() < 1) {
;	msg := "This script requires at least 1 parameters but it doesn't received`n"
;	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
;	MsgBox, %msg%
;    ExitApp
;}

; XNote Timer

global xnote_timer	:= USERPROFILE . "\pc_setting\XNote_Timer\xntimer.exe"

Process, Exist, xntimer.exe
if !ErrorLevel {
    Run, %xnote_timer%
    WinWaitActive, XNote Timer, , 2
    SendInput, {F11}
} else {
	Process, Close, xntimer.exe
}

ExitApp
