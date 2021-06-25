;-----------------------------------
;	useage example
;-----------------------------------
;C:\Program Files (x86)\Notepad++\notepad++.exe
;memo1			%USERPROFILE%\Desktop\memo1.txt
;memo2			"C:\Users\ADSY\memo2.txt"
;
;C:\Windows\explorer.exe
;myFolder			"C:\Users\name\myFolder"

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include Lib_Common.ahk

if A_Args.Length() < 2
{
	msg := "This script requires at least 2 parameters but it only received " . A_Args.Length() . "`n"
	msg := msg . "ex) " . A_ScriptName . "<SRC_FILE> <TARGET_FILE>"
	MsgBox, %msg%
    ExitApp
}

global gsSrcFile 	:= A_Args[1]
global gsTargetFile	:= A_Args[2]

global arrStr := []
global buffer := []

global TARCmd := ""
global TARExe := ""
global TAROpt := ""
global line := ""
global prefix := ""

Loop
{
    FileReadLine, line, %gsSrcFile%, %A_Index%
    if ErrorLevel
        break

	arrStr := COMMON_StrSplit(line, A_Tab)

	switch (arrStr.Length()) {
	case 0:
	case 1:
		TARExe := arrStr[1]
		prefix := ""
	case 2:
		if (arrStr[1] == "[PREFIX_SET]") {
			prefix := arrStr[2]
		} else if (arrStr[1] == "[PREFIX_CLEAR]") {
			prefix := ""
		} else {
			TARCmd := arrStr[1]
			TAROpt := arrStr[2]
			cmd := prefix . TARCmd . "|" . TARExe . "|" . TAROpt
			buffer.Push(cmd)
		}
	default:
		MsgBox, Grammar Error: Line %A_Index%
		break
	}
}

Loop % buffer.Length()
{
	line := buffer[A_Index]
	FileAppend, %line%`n, %gsTargetFile%
}

ExitApp
