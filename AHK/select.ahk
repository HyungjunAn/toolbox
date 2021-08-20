#include lib_run.ahk

Global isOffice := A_Args[1]
Global office_TitleAndUri := []
Global guiText := ""

if (isOffice) {
	path := "%USERPROFILE%\office.cfg"
	FileReadLine, line, %path%, 1
	office_TitleAndUri := COMMON_StrSplit(line, A_Tab)
}

Loop, Read, %A_ScriptName%
{
	if (InStr(A_LoopReadLine, "::")) {
		guiText := A_LoopReadLine . "`n"
	}
}

suspendOn()

$!^i:: 
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

$c::
	RUN_AOR_Chrome(COMMON_OPT_MAINMONITOR)
	suspendOn()
	return

$s::
	RUN_AOR_Chrome(COMMON_OPT_SUBMONITOR)
	COMMON_GUI_BlinkActiveWin("black", 80)
	suspendOn()
	return

$m::
	RUN_AOR_EXE("C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe")
	suspendOn()
	return

$d::
	RUN_AOR_EXE(path_setting . "\Q-Dir\Q-Dir_x64.exe")
	suspendOn()
	return

$n::
	RUN_AOR_EXE("notepad++.exe")
	suspendOn()
	return

$p::
	RUN_AOR_URL("Papago", "https://papago.naver.com/", COMMON_OPT_APPMODE)
	suspendOn()
	return

$k::
	RUN_AOR_URL("Google Keep", "https://keep.google.com", COMMON_OPT_APPMODE)
	suspendOn()
	return

$t::
	RUN_AOR_URL("Todoist", "https://todoist.com/app/project/2271101384", COMMON_OPT_APPMODE)
	suspendOn()
	return

$y::
	RUN_AOR_URL("YouTube", "https://www.youtube.com/", COMMON_OPT_APPMODE)
	suspendOn()
	return

$v::
	RUN_AOR_EXE(USERPROFILE . "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
	suspendOn()
	return

$0::
	if (isOffice) {
		RUN_AOR_URL(office_TitleAndUri[1], office_TitleAndUri[2], COMMON_OPT_APPMODE)
	} else {
		RUN_AOR_URL("Gmail", "https://mail.google.com/mail", COMMON_OPT_APPMODE)
	}
	suspendOn()
	return

suspendOn() {
	Gui, Destroy
	Suspend, On
}

suspendOff() {
	FOCUS_MainDesktop()
	Suspend, Off
	Gui, Color, Red
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Font, s12 cWhite, Consolas
	Gui, Add, Text, , Insert Hot Key
	;Gui, Add, Text, , %guiText%
	Gui, Show, NoActivate,
	Sleep, 1000
	suspendOn()
}
