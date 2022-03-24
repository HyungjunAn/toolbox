SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include lib_common.ahk

if A_Args.Length() < 3
{
	msg := "This script requires at least 2 parameters but it only received " . A_Args.Length() . "`n"
	msg := msg . "ex) " . A_ScriptName . "<PREFIX> <ROOT_PATH> <TARGET_FILE>"
	MsgBox, %msg%
    ExitApp
}

global gsPrefix 	:= A_Args[1]
global gsRootPath 	:= A_Args[2]
global gsTargetFile	:= A_Args[3]

global buffer := []

global TARExe := "%TOOLBOX_ROOT_AHK%\util_aor_gvim.ahk"
global TARCmd := ""
global TAROpt := ""

global pos := 0
global midPath := ""

;global separator := "/"
global separator := ""

Loop, Files, %gsRootPath%\*, R
{
	TARCmd := A_LoopFileName
	TAROpt := A_LoopFileLongPath

	pos := InStr(A_LoopFileLongPath, TOOLBOX_ROOT_BLOG_POSTS)

	if (pos == 1) {
		TARCmd := SubStr(TARCmd, 12)
	}

	midPath := SubStr(A_LoopFileDir, StrLen(gsRootPath) + 2)

	Loop
	{
		midPath := StrReplace(midPath, "\", separator, cnt)

	    if (cnt = 0) {
	        break
		}
	}

	if (midPath) {
		midPath := midPath . separator
	}

	if (!isIgnoreExt(A_LoopFileExt)) {
		cmd := gsPrefix . separator . midPath . TARCmd . "|" . TARExe . "|" . TAROpt
		buffer.Push(cmd)
	}
}

Loop % buffer.Length()
{
	line := buffer[A_Index]
	FileAppend, %line%`n, %gsTargetFile%
}

ExitApp

isIgnoreExt(ext) {
	switch (ext) {
	case "exe", "swp":
		return true
	default:
		return false
	}
}
