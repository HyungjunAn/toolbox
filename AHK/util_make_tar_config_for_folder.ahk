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
			
parsePath(gsRootPath)

Loop % buffer.Length()
{
	line := buffer[A_Index]
	FileAppend, %line%`n, %gsTargetFile%
}

ExitApp

parsePath(rootPath) {
	Local TARCmd := ""
	Local TAROpt := ""
	Local pos := 0

	Loop, Files, %rootPath%\*,
	{
		TARCmd := A_LoopFileName
		TAROpt := A_LoopFileLongPath

		pos := InStr(TAROpt, TOOLBOX_ROOT_BLOG_POSTS)

		if (pos) {
			TARCmd := SubStr(TARCmd, 12)
		}
	
		if (InStr(FileExist(TAROpt), "D")) {
			parsePath(TAROpt)
		} else if (!isIgnoreExt(A_LoopFileExt)) {
			cmd := gsPrefix . TARCmd . "|" . TARExe . "|" . TAROpt
			buffer.Push(cmd)
		}
	}
}

isIgnoreExt(ext) {
	switch (ext) {
	case "exe", "swp":
		return true
	default:
		return false
	}
}
