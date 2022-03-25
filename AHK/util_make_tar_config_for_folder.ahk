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
global lines := ""

;global separator := "/"
global separator := ""

makeCmdLines(gsRootPath)

FileAppend, %lines%, %gsTargetFile%

ExitApp

isIgnoreExt(ext) {
	switch (ext) {
	case "exe", "swp":
		return true
	default:
		return false
	}
}

isTextExt(ext) {
	switch (ext) {
	case "txt", "md", "log", "ahk", "cpp", "hs", "py", "js", "java":
		return true
	default:
		return false
	}
}

makeCmdLines(path) {
	Local TARExe := "%TOOLBOX_ROOT_AHK%\util_run.ahk"
	
	lines := lines . makeCmd(TARExe, path) . "`n"

	Loop, Files, %path%\*, FD
	{
		fileAttr := FileExist(A_LoopFileLongPath)
		TARExe := "%TOOLBOX_ROOT_AHK%\util_run.ahk"
	
		if (isIgnoreExt(A_LoopFileExt)) {
			continue
		}
	
		if (InStr(fileAttr, "D")) {
			if (InStr(fileAttr, "H")) {
				continue
			}

			makeCmdLines(A_LoopFileLongPath)
		} else {
			if (isTextExt(A_LoopFileExt)) {
				TARExe := "%TOOLBOX_ROOT_AHK%\util_aor_gvim.ahk"
			}
			
			lines := lines . makeCmd(TARExe, A_LoopFileLongPath) . "`n"
		}
	}
}

makeCmd(exe, path) {
	Local TARCmd := SubStr(path, StrLen(gsRootPath) + 1)
	Local cmd := ""
			
	TARCmd := RegExReplace(TARCmd, "\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])-", "")
	
	Loop
	{
		TARCmd := StrReplace(TARCmd, "\", separator, cnt)
	
	    if (cnt = 0) {
	        break
		}
	}
	
	cmd := gsPrefix . TARCmd . "|" . exe . "|" . path

	return cmd
}
