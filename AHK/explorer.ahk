#include lib_run.ahk

Global PATH_DIR := "init"
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
	suspendOn(False)
	return

$h::
	Send, {Left}
	PATH_DIR := COMMON_GetActiveExplorerPath()
	return
$j::
	Send, {Down}
	PATH_DIR := COMMON_GetActiveExplorerPath()
	return
$k::
	Send, {Up}
	PATH_DIR := COMMON_GetActiveExplorerPath()
	return
$l::
	Send, {Right}
	PATH_DIR := COMMON_GetActiveExplorerPath()
	return
	
;Make New File
$n::
	suspendOn()
	FormatTime, cur_time ,, yyMMddHHmm
	FileAppend, This is a new file.`n, %PATH_DIR%\NewFile_%cur_time%.txt
	return

;Powershell
$p::
	suspendOn()
	RUN_AOR_PowerShell(PATH_DIR)
	return

;Git Bash
$g::
	suspendOn()
	RUN_AOR_GitBash(PATH_DIR)
	return

;Copy sample_macro.ahk
$m::
	suspendOn()
	f := PATH_DIR . "\sample_macro.ahk"

	IfNotExist, %f%, {
		FileCopy, %TOOLBOX_ROOT_AHK%\sample_macro.ahk, %f%
	}
	return

;Open with GVIM
$v::
	suspendOn()
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run, %TOOLBOX_ROOT_AHK%\util_aor_gvim.ahk "%f%"
	}
	return

;Open with Notepad++
$t::
	suspendOn()
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run, notepad++.exe "%f%"
	}
	return

suspendOn(warning := True) {
	Suspend, On

	Gui, Destroy

	if (warning && !PATH_DIR) {
		MsgBox, Wrong Usage
	}
}

suspendOff() {
	PATH_DIR := COMMON_GetActiveExplorerPath()

	Suspend, Off
	Gui, Color, Red
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Font, s12 cWhite, Consolas
	Gui, Add, Text, , %guiText%
	Gui, Show, NoActivate
}
