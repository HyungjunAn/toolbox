#include lib_common.ahk
#include lib_focus.ahk

global chromeSubWinNameArr := []

chromeSubWinNameArr[1] := "- Chrome"
chromeSubWinNameArr[2] := "- Google Chrome"

global PATH_CHROME	:= "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
global PATH_MSEDGE	:= "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
global PATH_FIREFOX	:= "C:\Program Files\Mozilla Firefox\firefox.exe"

RUN_AOR_Chrome(opt := 0) {
	RUN_AOR_SubWinTitleArr(chromeSubWinNameArr, "chrome", opt)
}

RUN_AOR_URL(subTitle, url, opt := 0) {
	local cmd := ""

	if (opt & COMMON_OPT_APPMODE) {
		cmd := PATH_CHROME . " --app=" . url
	} else {
		cmd := PATH_CHROME . " " . url
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

RUN_AOR_EXE(exePath) {
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
	Local Title := COMMON_FindWinTitle_Arr(chromeSubWinNameArr, COMMON_OPT_MAINMONITOR)

	FOCUS_MainDesktop()

	if (opt & COMMON_OPT_APPMODE) {
		Run, %PATH_CHROME% --app=%url%
	} else if (Title) {
		WinActivate, %Title%
		SendInput, ^t
		sleep, 50
		SendInput, ^l
		SendInput, {blind}{text}%url%
		SendInput, {Enter}
		;Run, %PATH_CHROME% %url%
	} else {
		Run, %PATH_CHROME% --new-window %url%
	}

	return
}

