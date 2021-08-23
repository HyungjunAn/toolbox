#include lib_run.ahk
#include lib_office.ahk

Global guiText := COMMON_ParseKeyAndDescription(A_ScriptName)
Global isOffice := A_Args[1]
Global officeUrl_title := ""
Global officeUrl_url := ""

if (isOffice) {
	FileReadLine, officeUrl_title, %OFFICE_SETTING_URL%, 1
	FileReadLine, officeUrl_url, %OFFICE_SETTING_URL%, 2
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

;Chrome
$c::
	suspendOn()
	RUN_AOR_Chrome(COMMON_OPT_MAINMONITOR)
	return

;Chrome - Sub
$s::
	suspendOn()
	RUN_AOR_Chrome(COMMON_OPT_SUBMONITOR)
	COMMON_GUI_BlinkActiveWin("black", 80)
	return

;MobaXterm
$m::
	suspendOn()
	RUN_AOR_EXE("C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe")
	return

;Q-Dir
$d::
	suspendOn()
	RUN_AOR_EXE(TOOLBOX_ROOT . "\Q-Dir\Q-Dir_x64.exe")
	return

;Notepad++
$n::
	suspendOn()
	RUN_AOR_EXE("notepad++.exe")
	return

;Papago
$p::
	suspendOn()
	RUN_AOR_URL("Papago", "https://papago.naver.com/", COMMON_OPT_APPMODE)
	return

;Google Keep
$k::
	suspendOn()
	RUN_AOR_URL("Google Keep", "https://keep.google.com", COMMON_OPT_APPMODE)
	return

;Todoist
$t::
	suspendOn()
	RUN_AOR_URL("Todoist", "https://todoist.com/app/project/2271101384", COMMON_OPT_APPMODE)
	return

;YouTube
$y::
	suspendOn()
	RUN_AOR_URL("YouTube", "https://www.youtube.com/", COMMON_OPT_APPMODE)
	return

;visual studio code
$v::
	suspendOn()
	RUN_AOR_EXE(USERPROFILE . "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
	return

;Gmail or DashBoard
$0::
	suspendOn()
	if (isOffice) {
		RUN_AOR_URL(officeUrl_title, officeUrl_url, COMMON_OPT_APPMODE)
	} else {
		RUN_AOR_URL("Gmail", "https://mail.google.com/mail", COMMON_OPT_APPMODE)
	}
	return

;KakaoTalk
$`;::
	suspendOn()
	IfExist, C:\Program Files (x86)\Kakao
		cmd := "C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe"
	else
		cmd := "C:\Program Files\Kakao\KakaoTalk\KakaoTalk.exe"

	RUN_AOR_SubWinTitle("Ä«Ä«¿ÀÅå", cmd)
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
	Gui, Add, Text, , %guiText%
	Gui, Show, NoActivate,

	COMMON_Sleep(10000) 
	suspendOn()
}
