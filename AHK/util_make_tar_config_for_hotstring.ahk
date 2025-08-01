SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.
#include lib_common.ahk

if A_Args.Length < 3
{
	msg := "This script requires at least 3 parameters but it only received " . A_Args.Length . "`n"
	msg := msg . "ex) " . A_ScriptName . "<PREFIX> <SRC_PATH> <TARGET_FILE>"
	MsgBox msg
    ExitApp
}

global gsPrefix 	:= A_Args[1]
global gsSrcPath 	:= A_Args[2]
global gsTargetFile	:= A_Args[3]

global TARCmd := ""
global TARExe := ""
global TAROpt := ""
global lines := ""

TARExe := "%TOOLBOX_ROOT_AHK%\util_hotstring.ahk"

Loop Files, gsSrcPath . "\*", "R"
{
	str := SubStr(A_LoopFilePath, InStr(A_LoopFilePath, gsSrcPath) + StrLen(gsSrcPath))
	TARCmd := RegExReplace(str, "\\", "")

	TAROpt :=  A_LoopFileFullPath

	cmd := gsPrefix . TARCmd . "|" . TARExe . "|" . TAROpt
	lines := lines . cmd . "`n"
}


FileAppend(lines, gsTargetFile)

ExitApp
