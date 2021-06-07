#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Suspend, On
noti()

;=============================================================
;	Script
;-------------------------------------------------------------













;=============================================================

F10::
	Suspend, Toggle
	noti()
	return

F11::
	Suspend, Permit
	Reload
	return

F12::
	Suspend, Permit
	ExitApp

noti() {
	Local onOff := ""
	Local text := ""
	Local fontC := "White"
	Local backC := ""

	if (A_IsSuspended) {
		onOff := "Off"
		backC := "Green"
	} else {
		onOff := "On"
		backC := "Red"
	}

	text := "Macro: " . onOff . "`n(F10: Suspend / F11: Reload / F12: Exit)"

	Gui, Destroy
	Gui, Color, %backC%
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Font, s12 c%fontC%, Consolas
	Gui, Add, Text, , %text%
	Gui, Show, y0 NoActivate,
}
