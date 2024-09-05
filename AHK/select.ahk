FileEncoding "UTF-8"

#Requires AutoHotkey v2.0-a

#include lib_run.ahk
#include lib_office.ahk

Global guiText := COMMON_ParseKeyAndDescription(A_ScriptName, 2)
Global bOffice := COMMON_IsOffice()
Global officeUrl_title := ""
Global officeUrl_url := ""
Global start_script := USERPROFILE . "\Desktop\stable\start.ahk"
Global GuiSelect := Gui()

suspendOn() {
	Global GuiSelect
	
	Suspend true
	GuiSelect.Destroy()
}

suspendOff() {
	Global GuiSelect := Gui()

	Suspend false
	FOCUS_MainDesktop()

	try {
		GuiSelect.BackColor := "303030"
		GuiSelect.Opt("-Caption +alwaysontop +ToolWindow")
		GuiSelect.SetFont("s12 cWhite", "Consolas")
		GuiSelect.Add("Text", , guiText)
		GuiSelect.Show("NoActivate")

		COMMON_Sleep(10000)
		suspendOn()
	}
}

if (bOffice) {
	Loop Read, OFFICE_SETTING_URL {
		if (A_Index == 1) {
			officeUrl_title := A_LoopReadLine
		} else if (A_Index == 2) {
			officeUrl_url := A_LoopReadLine
		} else {
			break
		}
	}

	start_script := OFFICE_SETTING . "\AHK\start.ahk"
}

suspendOn()

#SuspendExempt
$!^i::
{
	suspendOff()
}

#SuspendExempt False
$`::
$ESC:: suspendOn()

;Move Left
$h::
{
	Send "{Left}"
	PATH_DIR := COMMON_GetActiveExplorerPath()
}

;Move Down
$j::
{
	Send "{Down}"
	PATH_DIR := COMMON_GetActiveExplorerPath()
}

;Move Up
$k::
{
	Send "{Up}"
	PATH_DIR := COMMON_GetActiveExplorerPath()
}

;Move Right
$l::
{
	Send "{Right}"
	PATH_DIR := COMMON_GetActiveExplorerPath()
}

;Chrome
$c::
{
	suspendOn()
	RUN_AOR_Chrome()
}

;MS Paint
$q::
{
	suspendOn()
	RUN_AOR_EXE("mspaint", "mspaint.exe")
}

;Firefox
$s::
{
	suspendOn()
	RUN_AOR_Firefox()
}

;Windows Terminal
$w::
{
	suspendOn()
	RUN_AOR_EXE("wt.exe", "WindowsTerminal.exe")
}

;File Zilla
$f::
{
	suspendOn()
	RUN_AOR_EXE("C:\Program Files\FileZilla FTP Client\filezilla.exe")
}

;;MobaXterm
;$m::
;	suspendOn()
;	RUN_AOR_EXE("C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe")
;	return

;English TODO(GitHub)
$e::
{
	suspendOn()
	RUN_AOR_URL("HyungjunAn/todo", "https://github.com/HyungjunAn/todo", COMMON_OPT_APPMODE)
}

;Q-Dir
$d::
{
	suspendOn()
	RUN_AOR_EXE(TOOLBOX_ROOT . "\Q-Dir\Q-Dir_x64.exe")
}

;Notepad++
$n::
{
	suspendOn()
	RUN_AOR_EXE("notepad++.exe")
}

;ChatGPT
$o::
{
	suspendOn()
	RUN_AOR_URL("Translator", "https://chat.openai.com/c/e2ebe7b7-6dc5-4460-927e-086fbca2aa08", COMMON_OPT_APPMODE)
}

;DeepL
$p::
{
	suspendOn()
	RUN_AOR_URL("DeepL", "https://www.deepl.com/translator", COMMON_OPT_APPMODE)
}

;Papago
$+p::
{
	suspendOn()
	RUN_AOR_URL("Papago", "https://papago.naver.com/", COMMON_OPT_APPMODE)
}

;Google Keep or Tera Term
$m::
{
	suspendOn()
	if (!bOffice) {
		RUN_AOR_URL("Google Keep", "https://keep.google.com", COMMON_OPT_APPMODE)
	} else {
		RUN_AOR_EXE("C:\Program Files (x86)\teraterm\ttermpro.exe")
	}
}

;Todoist
$1::
{
	suspendOn()
	;RUN_AOR_URL(".+Todoist$", "https://todoist.com/app/project/2327772322", COMMON_OPT_APPMODE | COMMON_OPT_REGEXMATCHING)
	;RUN_AOR_URL(".+Todoist$", "https://todoist.com/app/project/2327772322", COMMON_OPT_APPMODE | COMMON_OPT_REGEXMATCHING | COMMON_OPT_BROWSER_EDGE)
	RUN_AOR_EXE("C:\Users\heuser\AppData\Local\Programs\todoist\Todoist.exe")
}

;Netflix
$x::
{
	suspendOn()
	RUN_AOR_URL("Netflix", "https://www.netflix.com/browse", COMMON_OPT_APPMODE)
}

;YouTube
$y::
{
	suspendOn()
	RUN_AOR_URL("YouTube", "https://www.youtube.com/", COMMON_OPT_APPMODE)
}

;밀리의 서재
$b::
{
	suspendOn()
	RUN_AOR_EXE("C:\Program Files\millie\millie.exe")
}

;Google Timer
$g::
{
	suspendOn()
	RUN_AOR_EXE("util_google_timer.ahk")
}

;visual studio code
$v::
{
	suspendOn()
	RUN_AOR_EXE(USERPROFILE . "\AppData\Local\Programs\Microsoft VS Code\Code.exe")
}

;start script
$i::
{
	suspendOn()
	run start_script
}

;Gmail or DashBoard
$0::
{
	suspendOn()
	if (bOffice) {
		RUN_AOR_URL(officeUrl_title, officeUrl_url, COMMON_OPT_APPMODE)
	} else {
		RUN_AOR_URL("Gmail", "https://mail.google.com/mail", COMMON_OPT_APPMODE)
	}
}

;Messenger
$`;::
{
	suspendOn()
	if (bOffice) {
		RUN_AOR_EXE("ms-teams.exe")
	} else {
		If (DirExist("C:\Program Files (x86)\Kakao"))
			cmd := "C:\Program Files (x86)\Kakao\KakaoTalk\KakaoTalk.exe"
		else
			cmd := "C:\Program Files\Kakao\KakaoTalk\KakaoTalk.exe"

		RUN_AOR_SubWinTitle("카카오톡", cmd)
	}
}

;Virtual Desktop(Sub)
$+d::
{
	suspendOn()
	FOCUS_VDesktop_Sub()
}

;Send Custom SIGNAL
$^c::
{
	suspendOn()
	Send "^z"
	Send "jobs`nkill -9 %"
}

;Make New File
$^f::
{
	suspendOn()
	if (PATH_DIR := COMMON_GetActiveExplorerPath()) {
		cur_time := FormatTime("R", "yyMMddHHmm")
		FileAppend("This is a new file.`n", PATH_DIR . "\NewFile_" . cur_time . ".txt")
	}
}

;Copy sample_macro.ahk
$^0::
{
	suspendOn()
	if (PATH_DIR := COMMON_GetActiveExplorerPath()) {
		f := PATH_DIR . "\sample_macro.ahk"

		If (!FileExist(f)) {
			FileCopy TOOLBOX_ROOT_AHK . "\sample_macro.ahk", f
		}
	}
}

;Open with Notepad++
$^n::
{
	suspendOn()
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run "notepad++.exe " . f
	}
}

;Open with GVIM
$^v::
{
	suspendOn()
	f := COMMON_GetSelectedItemPath()
	if (f) {
		Run TOOLBOX_ROOT_AHK . "\util_aor_gvim.ahk " . f
	}
}

;Git Bash Here
$^g::
{
	suspendOn()
	if (PATH_DIR := COMMON_GetActiveExplorerPath()) {
		PATH_DIR := "`"" . PATH_DIR . "`""
		RUN_AOR_GitBash(PATH_DIR)
	}
}

;Powershell Here
$^p::
{
	suspendOn()
	if (PATH_DIR := COMMON_GetActiveExplorerPath()) {
		RUN_AOR_PowerShell(PATH_DIR)
	}
}
