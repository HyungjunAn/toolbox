;-----------------------------------
;	useage example
;-----------------------------------
;C:\Program Files (x86)\Notepad++\notepad++.exe
;memo1			%USERPROFILE%\Desktop\memo1.txt
;memo2			"C:\Users\ADSY\memo2.txt"
;
;C:\Windows\explorer.exe
;myFolder			"C:\Users\name\myFolder"
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#include lib_common.ahk

if A_Args.Length < 2
{
	msg := "This script requires at least 2 parameters but it only received " . A_Args.Length . "`n"
	msg := msg . "ex) " . A_ScriptName . "<SRC_FILE> <TARGET_FILE>"
	MsgBox msg
    ExitApp
}

global gsSrcFile 	:= A_Args[1]
global gsTargetFile	:= A_Args[2]

global arrStr := []

global TARCmd := ""
global TARExe := ""
global TAROpt := ""
global lines := ""
global prefix := ""

Loop Read, gsSrcFile
{
	line := A_LoopReadLine

	arrStr := COMMON_StrSplit(line, A_Tab)
	n := arrStr.Length

	if (n > 2) {
		MsgBox("Grammar Error: Line " . A_Index)
		break
	}

	if (n == 0) {
		continue
	} else if (n == 1) {
		if (InStr(arrStr[1], "::") == StrLen(arrStr[1]) - 1) {
			prefix := SubStr(arrStr[1], 1, StrLen(arrStr[1]) - 2)
		} else {
			TARExe := arrStr[1]
		}

		continue
	}

	if (InStr(line, A_Tab) > 1) {
		prefix := ""
	}
	
	TARCmd := arrStr[1]
	TAROpt := arrStr[2]
	cmd := prefix . TARCmd . "|" . TARExe . "|" . TAROpt

	lines := lines . cmd . "`n"
}

FileAppend(lines, gsTargetFile, "CP949")

ExitApp
