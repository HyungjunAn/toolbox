#include lib_common.ahk
#include lib_focus.ahk

global chromeSubWinNameRegExArr := []
global firefoxSubWinNameRegExArr := []

chromeSubWinNameRegExArr.Push "- Chrome$"
chromeSubWinNameRegExArr.Push "- Google Chrome$"

firefoxSubWinNameRegExArr.Push " Firefox$"
firefoxSubWinNameRegExArr.Push " Mozila Firefox$"

global PATH_MSEDGE	:= "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
global PATH_FIREFOX	:= "C:\Program Files\Mozilla Firefox\firefox.exe"
;global EXE_FOR_GIT_BASH := "WindowsTerminal.exe"
;global CMD_FOR_GIT_BASH := "wt -d "
global CMD_FOR_GIT_BASH := "C:\Program Files\Git\git-bash.exe --cd="
global EXE_FOR_GIT_BASH := "mintty.exe"

RUN_AOR_Chrome(opt := 0) {
	RUN_AOR_SubWinTitleArr(chromeSubWinNameRegExArr, "chrome", opt | COMMON_OPT_REGEXMATCHING)
}

RUN_AOR_Firefox(opt := 0) {
	RUN_AOR_SubWinTitleArr(firefoxSubWinNameRegExArr, "firefox", opt | COMMON_OPT_REGEXMATCHING)
}

RUN_AOR_URL(subTitle, url, opt := 0) {
	local cmd := ""
	local browser_exe := TOOLBOX_CHROME_EXE

	if (opt & COMMON_OPT_BROWSER_EDGE) {
		browser_exe := PATH_MSEDGE
	}

	if (opt & COMMON_OPT_APPMODE) {
		cmd := browser_exe . " --app=" . url
	} else {
		cmd := browser_exe . " " . url
	}

	return RUN_AOR_SubWinTitle(subTitle, cmd, opt)
}

RUN_AOR_SubWinTitle(subTitle, cmd, opt := 0) {
	Local subTitleArr := []

	subTitleArr.Push(subTitle)
	
	return RUN_AOR_SubWinTitleArr(subTitleArr, cmd, opt)
}

RUN_AOR_SubWinTitleArr(subTitleArr, cmd, opt := 0) {
	Local ret := True
	Local Title := COMMON_FindWinTitle_Arr(subTitleArr, opt)

	FOCUS_MainDesktop()

	if (!Title) {
		try 
			Run cmd
		catch
			ret := False
	} else {
		WinActivate Title
	}

	return ret
}

RUN_AOR_EXE(exePath, procName := "") {
	;FOCUS_MainDesktop()

	if (!procName) {
		SplitPath(exePath, &procName)
	}

	windows := WinGetList()

	try {
		Loop windows.Length {
			id := windows[A_Index]
			name := WinGetProcessName("ahk_id " id)
		
			if (name == procName) {
				title := WinGetTitle("ahk_id " id)
				WinActivateBottom(title)
				return True
			}
		}
	}

	try
		Run exePath
	catch
		return False

	return True
}

RUN_AOR_GitBash(folderPath) {
	global EXE_FOR_GIT_BASH
	global CMD_FOR_GIT_BASH


	FOCUS_MainDesktop()

	SplitPath folderPath, &folderName
	windows := WinGetList()
	
	Loop windows.Length {
		id := windows[A_Index]
		name := WinGetProcessName("ahk_id " . id)
	
		if (name == EXE_FOR_GIT_BASH) {
			title := WinGetTitle("ahk_id " . id)
			;MsgBox, t: %title%`nfn: %folderName%`nfp: %folderPath%
			if (InStr(title, folderName)) {
				WinActivate title
				return
			}
		}
	}

	try
		Run CMD_FOR_GIT_BASH . folderPath
	catch
	{
		CMD_FOR_GIT_BASH := "C:\Program Files\Git\git-bash.exe --cd="
		EXE_FOR_GIT_BASH := "mintty.exe"

		Run CMD_FOR_GIT_BASH . folderPath
	}
}

RUN_AOR_PowerShell(folderPath) {
	Local exe := ""

	FOCUS_MainDesktop()

	SplitPath folderPath, &folderName
	windows := WinGetList()

	if DirExist("C:\Program Files\PowerShell") {
		exe := "pwsh.exe"
	} else {
		exe := "powershell.exe"
	}
	
	Loop windows.Length {
		id := windows[A_Index]
		name := WinGetProcessName("ahk_id " . id)
	
		if (name == exe) {
			title := WinGetTitle("ahk_id " . id)
			;MsgBox, t: %title%`nfn: %folderName%`nfp: %folderPath%
	        If (InStr(title, "powershell")) {
				WinActivate title
				return
			}
		}
	}
	
	cmd := exe . " -noexit -command `"cd '" . folderPath . "'`""

	run cmd
}

RUN_AOR_Gvim(filePath) {
	FOCUS_MainDesktop()

	SplitPath filePath, &fileName

	windows := WinGetList()
	Loop windows.Length {
		id := windows[A_Index]
		name := WinGetProcessName("ahk_id " . id)

		if (name == "gvim.exe") {
			title := WinGetTitle("ahk_id " . id)
	        If (InStr(title, fileName)) {
				WinActivate title
				return
			}
		}
	}
	
	cmd := "gvim `"" . filePath . "`""

	Run cmd
}

RUN_OpenUrl(url, opt := 0) {
	local tmp := ""
	Local Title := COMMON_FindWinTitle_Arr(chromeSubWinNameRegExArr, COMMON_OPT_MAINMONITOR | COMMON_OPT_REGEXMATCHING)

	FOCUS_MainDesktop()

	if (opt & COMMON_OPT_APPMODE) {
		Run TOOLBOX_CHROME_EXE . " --app=" . url
	} else if (Title) {
		newTabTitleArr := []
		newTabTitleArr.Push("새 탭 - Chrome")

		WinActivate Title
		SendInput "^t"
		if (!COMMON_WinWait_Arr(newTabTitleArr, [], 500)) {
			return
		} 
; if 0
		;SendInput "{blind}{text}" . url
		;SendInput "{Enter}"
; else
		tmp_clip := A_Clipboard
		A_Clipboard := url
		SendInput "^v{Enter}"
		sleep 500
		A_Clipboard := tmp_clip
; endif
	} else {
		Run TOOLBOX_CHROME_EXE . " --new-window " . url
	}

	return
}

