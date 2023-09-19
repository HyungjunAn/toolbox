#include lib_common.ahk
#include lib_focus.ahk

global chromeSubWinNameRegExArr := []

chromeSubWinNameRegExArr[1] := "- Chrome$"
chromeSubWinNameRegExArr[2] := "- Google Chrome$"

global PATH_MSEDGE	:= "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
global PATH_FIREFOX	:= "C:\Program Files\Mozilla Firefox\firefox.exe"

RUN_AOR_Chrome(opt := 0) {
	RUN_AOR_SubWinTitleArr(chromeSubWinNameRegExArr, "chrome", opt | COMMON_OPT_REGEXMATCHING)
}

RUN_AOR_URL(subTitle, url, opt := 0) {
	local cmd := ""

	if (opt & COMMON_OPT_APPMODE) {
		cmd := TOOLBOX_CHROME_EXE . " --app=" . url
	} else {
		cmd := TOOLBOX_CHROME_EXE . " " . url
	}

	return RUN_AOR_SubWinTitle(subTitle, cmd, opt)
}

RUN_AOR_SubWinTitle(subTitle, cmd, opt := 0) {
	Local subTitleArr := []

	subTitleArr[1] := subTitle
	
	return RUN_AOR_SubWinTitleArr(subTitleArr, cmd, opt)
}

RUN_AOR_SubWinTitleArr(subTitleArr, cmd, opt := 0) {
	Local ret := True
	Local Title := COMMON_FindWinTitle_Arr(subTitleArr, opt)

	FOCUS_MainDesktop()

	if (!Title) {
		Run, %cmd%
		if (ErrorLevel) {
			ret := False
		}
	} else {
		WinActivate, %Title%
	}

	return ret
}

RUN_AOR_EXE(exePath, procName := "") {
	FOCUS_MainDesktop()

	if (!procName) {
		SplitPath, exePath, procName
	}

	WinGet windows, List
	
	Loop %windows% {
		id := windows%A_Index%
		WinGet, name, ProcessName, ahk_id %id%
	
		if (name == procName) {
			WinGetTitle, title, ahk_id %id%
			WinActivate, %title%
			return True
		}
	}

	Run, %exePath%

	if (ErrorLevel) {
		return False
	}

	return True
}

RUN_AOR_GitBash(folderPath) {
	FOCUS_MainDesktop()

	SplitPath, folderPath, folderName
	WinGet windows, List
	
	Loop %windows% {
		id := windows%A_Index%
		WinGet, name, ProcessName, ahk_id %id%
	
		if (name == "mintty.exe") {
			WinGetTitle, title, ahk_id %id%
			;MsgBox, t: %title%`nfn: %folderName%`nfp: %folderPath%
	        IfInString, title, %folderName%, {
				WinActivate, %title%
				return
			}
		}
	}
	
	Run, C:\Program Files\Git\git-bash.exe --cd="%folderPath%"
}

RUN_AOR_PowerShell(folderPath) {
	Local exe := ""

	FOCUS_MainDesktop()

	SplitPath, folderPath, folderName
	WinGet windows, List

	ifExist, C:\Program Files\PowerShell, {
		exe := "pwsh.exe"
	} else {
		exe := "powershell.exe"
	}
	
	Loop %windows% {
		id := windows%A_Index%
		WinGet, name, ProcessName, ahk_id %id%
	
		if (name == exe) {
			WinGetTitle, title, ahk_id %id%
			;MsgBox, t: %title%`nfn: %folderName%`nfp: %folderPath%
	        IfInString, title, powershell, {
				WinActivate, %title%
				return
			}
		}
	}
	
	Run, %exe% -noexit -command "cd %folderPath%"
}

RUN_AOR_Gvim(filePath) {
	FOCUS_MainDesktop()

	SplitPath, filePath, fileName

	WinGet windows, List
	Loop %windows% {
		id := windows%A_Index%
		WinGet, name, ProcessName, ahk_id %id%

		if (name == "gvim.exe") {
			WinGetTitle, title, ahk_id %id%
	        IfInString, title, %fileName%, {
				WinActivate, %title%
				return
			}
		}
	}
	
	Run, gvim "%filePath%"
}

RUN_OpenUrl(url, opt := 0) {
	local tmp := ""
	Local Title := COMMON_FindWinTitle_Arr(chromeSubWinNameRegExArr, COMMON_OPT_MAINMONITOR | COMMON_OPT_REGEXMATCHING)

	FOCUS_MainDesktop()

	if (opt & COMMON_OPT_APPMODE) {
		Run, %TOOLBOX_CHROME_EXE% --app=%url%
	} else if (Title) {
		newTabTitleArr := []
		newTabTitleArr[1] := "╩У ег - Chrome"

		WinActivate, %Title%
		SendInput, ^t
		if (!COMMON_WinWait_Arr(newTabTitleArr, [], 500)) {
			return
		} 
		SendInput, {blind}{text}%url%
		SendInput, {Enter}
		;Run, %TOOLBOX_CHROME_EXE% %url%
	} else {
		Run, %TOOLBOX_CHROME_EXE% --new-window %url%
	}

	return
}

