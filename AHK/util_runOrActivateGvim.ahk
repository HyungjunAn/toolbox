#include Lib_VPC.ahk

VPC_FocusOut()

if (A_Args.Length() < 1) {
	msg := "This script requires at least 1 parameters but it doesn't received`n"
	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
	MsgBox, %msg%
    ExitApp
}

global gsFilePath 	:= A_Args[1]
global gsFileName 	:= gsFilePath

SplitPath, gsFilePath, gsFileName

;MsgBox, %gsFilePath%`n%gsFileName%

WinGet windows, List
Loop %windows% {
	id := windows%A_Index%
	WinGetTitle Title, ahk_id %id%
    If (InStr(Title, gsFileName) = 1 && InStr(Title, "GVIM")) {
		break
	}
	Title := ""
}

if !Title {
	cmd := "gvim """ . gsFilePath . """"
	Run, %cmd%
} else {
	WinActivate, %Title%
}
ExitApp
