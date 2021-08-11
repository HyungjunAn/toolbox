#include lib_common.ahk
#include lib_focus.ahk

global chromeSubWinNameArr := []

chromeSubWinNameArr[1] := "- Chrome"
chromeSubWinNameArr[2] := "- Google Chrome"

global PATH_CHROME	:= "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
global PATH_MSEDGE	:= "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
global PATH_FIREFOX	:= "C:\Program Files\Mozilla Firefox\firefox.exe"

COMMON_AOR_Chrome(opt := 0) {
	COMMON_AOR_SubWinTitleArr(chromeSubWinNameArr, "chrome", opt)
}

COMMON_AOR_URL(subTitle, url, opt := 0) {
	local cmd := ""

	if (opt & COMMON_OPT_APPMODE) {
		cmd := PATH_CHROME . " --app=" . url
	} else {
		cmd := PATH_CHROME . " " . url
	}

	return COMMON_AOR_SubWinTitle(subTitle, cmd, opt)
}

COMMON_AOR_SubWinTitle(subTitle, cmd, opt := 0) {
	Local subTitleArr := []

	subTitleArr[1] := subTitle
	
	return COMMON_AOR_SubWinTitleArr(subTitleArr, cmd, opt)
}

COMMON_AOR_SubWinTitleArr(subTitleArr, cmd, opt := 0) {
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

COMMON_AOR_EXE(exePath) {
	FOCUS_MainDesktop()
	SplitPath, exePath, procName
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

COMMON_AOR_GitBash(folderPath) {
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

COMMON_AOR_Gvim(filePath) {
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

COMMON_OpenUrl(url, opt := 0) {
	local tmp := ""
	Local Title := COMMON_FindWinTitle_Arr(chromeSubWinNameArr, COMMON_OPT_MAINMONITOR)

	FOCUS_MainDesktop()

	if (opt & COMMON_OPT_APPMODE) {
		Run, %PATH_CHROME% --app=%url%
	} else if (Title) {
		WinActivate, %Title%
		Run, %PATH_CHROME% %url%
	} else {
		Run, %PATH_CHROME% --new-window %url%
	}

	return
}

