#include lib_focus.ahk

FOCUS_MainDesktop()

;if (A_Args.Length() < 1) {
;	msg := "This script requires at least 1 parameters but it doesn't received`n"
;	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
;	MsgBox, %msg%
;    ExitApp
;}

global total_sec := 3
global cur_sec := 0

InputBox, UserInput, Set Timer, Enter Seconds,

if ErrorLevel {
	ExitApp
} else {
	total_sec := UserInput
}

showRemainTime(cur_sec := 0) {
	w := A_ScreenWidth - ((A_ScreenWidth * cur_sec) // total_sec)
	
	Gui, GT:Color, Red
	Gui, GT:-Caption +alwaysontop +ToolWindow
	Gui, GT:Show, x0 y0 h30 w%w% NoActivate,
}

while (total_sec != cur_sec) {
	showRemainTime(cur_sec)
	sleep, 1000
	cur_sec += 1
}

Gui, Color, Red
Gui, -Caption +alwaysontop +ToolWindow
Gui, Font, s20 cWhite, Consolas
Gui, Add, Text, , Finish!!
Gui, Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth% NoActivate,

MsgBox, Finish!!

ExitApp

F10::
	Process, Close, %pName%
	ExitApp
	return
