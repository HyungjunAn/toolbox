#include lib_run.ahk
#include lib_office.ahk

Global guiText := COMMON_ParseKeyAndDescription(A_ScriptName)
Global bOffice := COMMON_IsOffice()
Global officeUrl_title := ""
Global officeUrl_url := ""
Global start_script := USERPROFILE . "\Desktop\stable\start.ahk"

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

;English Memo(Notion)
$e::
	suspendOn()
	RUN_AOR_URL("En Memo", "https://www.notion.so/En-Memo-0e6615a06d9e418fb85a79c507195aea", COMMON_OPT_APPMODE)
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

;밀리의 서재
$b::
	suspendOn()
	RUN_AOR_EXE("C:\Program Files\millie\millie.exe")
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

suspendOn() {
	Suspend, On
	Gui, Destroy
}

suspendOff() {
	Suspend, Off
	FOCUS_MainDesktop()

	Gui, Color, Red
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Font, s12 cWhite, Consolas
	Gui, Add, Text, , %guiText%
	Gui, Show

	COMMON_Sleep(10000)
	suspendOn()
}
