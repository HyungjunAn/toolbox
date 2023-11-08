#include lib_run.ahk
#include lib_office.ahk

Global guiText := COMMON_ParseKeyAndDescription(A_ScriptName)
Global bOffice := COMMON_IsOffice()
Global officeUrl_title := ""
Global officeUrl_url := ""
Global start_script := USERPROFILE . "\Desktop\stable\start.ahk"

suspendOn() {
	Suspend, On
	Gui, Destroy
}

suspendOff() {
	Suspend, Off
	FOCUS_MainDesktop()

	Gui, Color, 303030
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Font, s12 cWhite, Consolas
	Gui, Add, Text, , %guiText%
	Gui, Show, NoActivate

	COMMON_Sleep(10000)
	suspendOn()
}

if (bOffice) {
	FileReadLine, officeUrl_title, %OFFICE_SETTING_URL%, 1
	FileReadLine, officeUrl_url, %OFFICE_SETTING_URL%, 2
	start_script := OFFICE_SETTING . "\AHK\start.ahk"
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

;Move Left
$h::
	Send, {Left}
	PATH_DIR := COMMON_GetActiveExplorerPath()
	return

;Move Down
$j::
	Send, {Down}
	PATH_DIR := COMMON_GetActiveExplorerPath()
	return

;Move Up
$k::
	Send, {Up}
	PATH_DIR := COMMON_GetActiveExplorerPath()
	return

;Move Right
$l::
	Send, {Right}
	PATH_DIR := COMMON_GetActiveExplorerPath()
	return

;Chrome
$c::
	suspendOn()
	RUN_AOR_Chrome()
	return

;Firefox
$s::
	suspendOn()
	RUN_AOR_Firefox()
	return

;Windows Terminal
$w::
	suspendOn()
	RUN_AOR_EXE("wt.exe", "WindowsTerminal.exe")
	return

;File Zilla
$f::
	suspendOn()
	RUN_AOR_EXE("C:\Program Files\FileZilla FTP Client\filezilla.exe")
	return

;;MobaXterm
;$m::
;	suspendOn()
;	RUN_AOR_EXE("C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe")
;	return

;English TODO(GitHub)
$e::
	suspendOn()
	RUN_AOR_URL("HyungjunAn/todo", "https://github.com/HyungjunAn/todo", COMMON_OPT_APPMODE)
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

;ChatGPT
$o::
	suspendOn()
	RUN_AOR_URL("Translator", "https://chat.openai.com/c/e2ebe7b7-6dc5-4460-927e-086fbca2aa08", COMMON_OPT_APPMODE)
	return

;Papago
$p::
	suspendOn()
	RUN_AOR_URL("Papago", "https://papago.naver.com/", COMMON_OPT_APPMODE)
	return

;Google Keep or Tera Term
$m::
	suspendOn()
	if (!bOffice) {
		RUN_AOR_URL("Google Keep", "https://keep.google.com", COMMON_OPT_APPMODE)
	} else {
		RUN_AOR_EXE("C:\Program Files (x86)\teraterm\ttermpro.exe")
	}
	return

;Todoist
$t::
	suspendOn()
	RUN_AOR_URL("Todoist", "https://todoist.com/app/project/2271101384", COMMON_OPT_APPMODE)
	return

;Netflix
$x::
	suspendOn()
	RUN_AOR_URL("Netflix", "https://www.netflix.com/browse", COMMON_OPT_APPMODE)
	return

;YouTube
$y::
	suspendOn()
	RUN_AOR_URL("YouTube", "https://www.youtube.com/", COMMON_OPT_APPMODE)
	return

;밀리의 서재
$b::
	suspendOn()
	RUN_AOR_EXE("C:\Program Files\millie\millie.exe")
	return

;Google Timer
$g::
	suspendOn()
	RUN_AOR_EXE("util_google_timer.ahk")
	return

;visual studio code
$v::
	suspendOn()
	RUN_AOR_EXE(USERPROFILE . "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
	return

;start script
$i::
	suspendOn()
	run, %start_script%
	return

;Gmail or DashBoard
$0::
	suspendOn()
	if (bOffice) {
		RUN_AOR_URL(officeUrl_title, officeUrl_url, COMMON_OPT_APPMODE)
	} else {
		RUN_AOR_URL("Gmail", "https://mail.google.com/mail", COMMON_OPT_APPMODE)
	}
	return

;Messenger
$`;::
	suspendOn()
	if (bOffice) {
		RUN_AOR_EXE(USERPROFILE . "\AppData\Local\Microsoft\Teams\current\Teams.exe")
	} else {
		IfExist, C:\Program Files (x86)\Kakao
			cmd := "C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe"
		else
			cmd := "C:\Program Files\Kakao\KakaoTalk\KakaoTalk.exe"

		RUN_AOR_SubWinTitle("카카오톡", cmd)
	}
	return

;Virtual Desktop(Sub)
$1::
	suspendOn()
	FOCUS_VDesktop_Sub()
	return

;Make New File
$^f::
	suspendOn()
	if (PATH_DIR := COMMON_GetActiveExplorerPath()) {
		FormatTime, cur_time ,, yyMMddHHmm
		FileAppend, This is a new file.`n, %PATH_DIR%\NewFile_%cur_time%.txt
	}
	return

;Copy sample_macro.ahk
$^c::
	suspendOn()
	if (PATH_DIR := COMMON_GetActiveExplorerPath()) {
		f := PATH_DIR . "\sample_macro.ahk"

		IfNotExist, %f%, {
			FileCopy, %TOOLBOX_ROOT_AHK%\sample_macro.ahk, %f%
		}
	}

	return

;Open with Notepad++
$^n::
	suspendOn()
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run, notepad++.exe "%f%"
	}
	return

;Open with GVIM
$^v::
	suspendOn()
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run, %TOOLBOX_ROOT_AHK%\util_aor_gvim.ahk "%f%"
	}
	return

;Git Bash Here
$^g::
	suspendOn()
	if (PATH_DIR := COMMON_GetActiveExplorerPath()) {
		RUN_AOR_GitBash(PATH_DIR)
	}
	return

;Powershell Here
$^p::
	suspendOn()
	if (PATH_DIR := COMMON_GetActiveExplorerPath()) {
		RUN_AOR_PowerShell(PATH_DIR)
	}
	return


