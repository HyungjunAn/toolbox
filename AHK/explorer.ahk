#include lib_run.ahk

Global PATH_DIR := ""
Global guiText := COMMON_ParseKeyAndDescription(A_ScriptName)

suspendOn()

$!^n:: 
	Suspend, Permit
	if (A_IsSuspended) {
		suspendOff()
	} else {
		suspendOn()
	}
	return

$`::
$ESC::
	suspendOn()
	return
	
;Make New File
$1::
	suspendOn()
	FormatTime, cur_time ,, yyMMddHHmm
	FileAppend, This is a new file.`n, %PATH_DIR%\NewFile_%cur_time%.txt
	return

;Git Bash
$2::
	suspendOn()
	RUN_AOR_GitBash(PATH_DIR)
	return

;Copy sample_macro.ahk
$3::
	suspendOn()
	f := PATH_DIR . "\sample_macro.ahk"

	IfNotExist, %f%, {
		FileCopy, %TOOLBOX_ROOT_AHK%\sample_macro.ahk, %f%
	}
	return

;Open with GVIM
$4::
	suspendOn()
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run, %TOOLBOX_ROOT_AHK%\util_aor_gvim.ahk "%f%"
	}
	return

;Open with Notepad++
$5::
	suspendOn()
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run, notepad++.exe "%f%"
	}
	return

suspendOn() {
	Gui, Destroy
	Suspend, On
}

suspendOff() {
	PATH_DIR := COMMON_GetActiveExplorerPath()

	if (!PATH_DIR) {
		MsgBox, Wrong Usage
		suspendOn()
		return
	}

	Suspend, Off
	Gui, Color, Red
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Font, s12 cWhite, Consolas
	;Gui, Add, Text, , %Lines%
	Gui, Add, Text, , %guiText%
	Gui, Show, NoActivate,

	COMMON_Sleep(10000) 
	suspendOn()
}
