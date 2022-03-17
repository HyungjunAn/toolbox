SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include lib_common.ahk

if A_Args.Length() < 2
{
	msg := "This script requires at least 2 parameters but it only received " . A_Args.Length() . "`n"
	msg := msg . "ex) " . A_ScriptName . "<PREFIX> <SRC_PATH> <TARGET_FILE>"
	MsgBox, %msg%
    ExitApp
}

global gsPrefix 	:= A_Args[1]
global gsSrcPath 	:= A_Args[2]
global gsTargetFile	:= A_Args[3]

global buffer := []

global TARCmd := ""
global TARExe := ""
global TAROpt := ""

TARExe := "%TOOLBOX_ROOT_AHK%\util_hotstring.ahk"

Loop, Files, %gsSrcPath%\*,
{
	TARCmd := A_LoopFileName
	TAROpt := A_LoopFileLongPath
	cmd := gsPrefix . TARCmd . "|" . TARExe . "|" . TAROpt
	buffer.Push(cmd)
}

Loop % buffer.Length()
{
	line := buffer[A_Index]
	FileAppend, %line%`n, %gsTargetFile%
}

ExitApp
