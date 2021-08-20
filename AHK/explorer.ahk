#include lib_run.ahk

Global PATH_DIR := ""

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
	
$1::
	FormatTime, cur_time ,, yyMMddHHmm
	FileAppend, This is a new file.`n, %PATH_DIR%\NewFile_%cur_time%.txt
	suspendOn()
	return

$2::
	RUN_AOR_GitBash(PATH_DIR)
	suspendOn()
	return

$3::
	f := PATH_DIR . "\sample_macro.ahk"

	IfNotExist, %f%, {
		FileCopy, %TOOLBOX_ROOT_AHK%\sample_macro.ahk, %f%
	}

	suspendOn()
	return

$4::
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run, %TOOLBOX_ROOT_AHK%\util_aor_gvim.ahk "%f%"
	}
	suspendOn()
	return

$5::
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run, notepad++.exe "%f%"
	}
	suspendOn()
	return

suspendOn() {
	Gui, Destroy
	Suspend, On
}

suspendOff() {
	Local LineNum := 1
	Local Lines := ""
	
	PATH_DIR := COMMON_GetActiveExplorerPath()

	if (!PATH_DIR) {
		MsgBox, Wrong Usage
		suspendOn()
		return
	}

	Lines := Lines . "[" . (LineNum++) . "] " . "Make New File" . "`n"
	Lines := Lines . "[" . (LineNum++) . "] " . "Git Bash" . "`n"
	Lines := Lines . "[" . (LineNum++) . "] " . "Copy sample_macro.ahk`n"
	Lines := Lines . "[" . (LineNum++) . "] " . "Open with GVIM`n"
	Lines := Lines . "[" . (LineNum++) . "] " . "Open with Notepad++"

	FOCUS_MainDesktop()

	Suspend, Off
	Gui, Color, Red
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Font, s12 cWhite, Consolas
	Gui, Add, Text, , %Lines%
	Gui, Show, NoActivate,
	Sleep, 10000
	suspendOn()
}
