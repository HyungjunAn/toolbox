#include Lib_VPC.ahk
		
global PATH_CHROME	:= "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
global PATH_MSEDGE	:= "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
global PATH_FIREFOX	:= "C:\Program Files\Mozilla Firefox\firefox.exe"

global isVirtualDesktopLeft := True

COMMON_ROA_URL(subName, url) {
	local cmd := PATH_CHROME . " --app=" . url
	return COMMON_ROA_Cmd_SubName(subName, cmd)
}

COMMON_ROA_CMD_SubNameArr(subNameArr, cmd) {
	Local ret := True
	local Title := ""

	focusOnMain()

	Loop % subNameArr.Length()
	{
		Title := findWindow(subNameArr[A_Index], False)

		if (Title) {
			break
		}
	}

	if (!Title) {
		RunWait, %cmd%
		if (ErrorLevel) {
			ret := False
		}
	} else {
		WinActivate, %Title%
	}

	return ret
}

COMMON_ROA_CMD_SubName(subName, cmd) {
	Local ret := True
	Local Title := findWindow(subName, False)

	focusOnMain()

	if (!Title) {
		RunWait, %cmd%
		if (ErrorLevel) {
			ret := False
		}
	} else {
		WinActivate, %Title%
	}

	return ret
}

COMMON_ROA_EXE(exePath) {
	focusOnMain()
	flag := False
	SplitPath, exePath, procName
	WinGet windows, List
	
	Loop %windows% {
		id := windows%A_Index%
		WinGet, name, ProcessName, ahk_id %id%
	
		if (name == procName) {
			WinGetTitle, title, ahk_id %id%
			WinActivate, %title%
			flag := True
			break
		}
	}

	if (!flag) {
		Run, %exePath%
	}

	return flag
}

findWindow(subName, isFullMatching := True) {
    WinGet windows, List
    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%
		if (isFullMatching) {
        	if (Title == subName) {
            	return %Title%
        	}
		}
		else {
        	IfInString, Title, %subName%, {
            	return %Title%
        	}
		}
    }
    return ""
}

runOrActivateGitBash(folderPath) {
	focusOnMain()

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

runOrActivateGvim(filePath) {
	focusOnMain()

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

COMMON_StrSplit(string, delimiters, commentPrefix := "//") {
	local tmpStr := ""
	local arrString := StrSplit(string, delimiters)
	local retString := []

	Loop % arrString.Length()
	{
		tmpStr := arrString[A_Index]
	
		; comment
		if (InStr(tmpStr, commentPrefix) == 1) {
			break
		}

		; multiple
		if (!tmpStr) {
			continue
		}

		retString.Push(tmpStr)
	}
	return retString
}

VDesktop_toggle() {
	if (isVirtualDesktopLeft) {
		SendInput, ^#{right}
	} else {
		SendInput, ^#{left}
	}
	isVirtualDesktopLeft := !isVirtualDesktopLeft
}

VDesktop_left() {
	if (isVirtualDesktopLeft == False) {
		SendInput, ^#{left}
		isVirtualDesktopLeft := True
	}
}

focusOnMain() {
	VPC_FocusOut()
	VDesktop_left()
}

removeBeginNewline(str) {
	local n := 0
	
	if (SubStr(str, 1, 2) == "`r`n") {
		n := 2
	} else if (SubStr(str, 1, 1) == "`n") {
		n := 1
	} else {
		return str
	}

	return SubStr(str, 1 + n)
}

removeEndNewline(str) {
	local n := 0

	if (SubStr(str, -1) == "`r`n") {
		n := 2
	} else if (SubStr(str, 0) == "`n") {
		n := 1
	} else {
		return str
	}

	return SubStr(str, 1, StrLen(str) - n)
}

openUrl(url, appMode := False) {
	local tmp := ""

	focusOnMain()

	if (appMode) {
		Run, %PATH_CHROME% --app=%url%
	} else {
		Run, %PATH_CHROME% %url%
	}

	return

;	flag := False
;	SplitPath, PATH_CHROME, procName
;	WinGet windows, List
;	
;	Loop %windows% {
;		id := windows%A_Index%
;		WinGet, name, ProcessName, ahk_id %id%
;	
;		if (name == procName) {
;			WinGetTitle, title, ahk_id %id%
;			WinActivate, %title%
;			flag := True
;			break
;		}
;	}
;
;	if (flag) {
;		SendInput, ^t
;		sleep, 50
;		tmp := Clipboard
;		Clipboard := url
;		SendInput, ^v
;		sleep, 200
;		SendInput, {Enter}
;		Clipboard := tmp
;	} else {
;		Run, %PATH_CHROME% %url%
;	}
;
;	return
}

COMMON_WinWait(title, text, timeout_ms) {
	static interval := 50

	local T := ""
	local cnt := 0
	local threshold := timeout_ms / interval
	
	if ((title && text) || (!title && !text) || timeout_ms <= 0) {
		MsgBox, Error: wrong param
		return False
	}

	if (title) {
		while (T != title && cnt < threshold) {
    		WinGetTitle, T, A
			cnt++
			sleep, %interval%
		}
	} else {
		while (!InStr(T, text) && cnt < threshold) {
    		WinGetTitle, T, A
			cnt++
			sleep, %interval%
		}
	}

	return (cnt < threshold)
}

COMMON_IsEmpty(Dir) {
   Loop %Dir%\*.*, 0, 1
      return FALSE
   return TRUE
}

COMMON_GetActiveExplorerPath() {
	explorerHwnd := WinActive("ahk_class CabinetWClass")
	if (explorerHwnd)
	{
		for window in ComObjCreate("Shell.Application").Windows
		{
			if (window.hwnd==explorerHwnd)
			{
				return window.Document.Folder.Self.Path
			}
		}
	}

	return ""
}

COMMON_GetSelectedItemPath() {
	hwnd := WinExist("A")
	for Window in ComObjCreate("Shell.Application").Windows  
	    if (window.hwnd == hwnd) {
	        Selection := Window.Document.SelectedItems
	        for Items in Selection
	            return Items.path
	    }
	return ""	
}

COMMON_GetActiveWinProcName() {
    WinGet, p_name, ProcessName, A
	return p_name
}

;COMMON_ChangeResolution(32,1920,1080,60)
;COMMON_ChangeResolution(32,1360,768, 60)

COMMON_ChangeResolution( cD, sW, sH, rR ) {
  VarSetCapacity(dM,156,0), NumPut(156,2,&dM,36)
  DllCall("EnumDisplaySettingsA", UInt,0, UInt,-1, UInt,&dM ), 
  NumPut(0x5c0000,dM,40)
  NumPut(cD,dM,104), NumPut(sW,dM,108), NumPut(sH,dM,112), NumPut(rR,dM,120)
  Return DllCall("ChangeDisplaySettingsA", UInt,&dM, UInt,0 )
}
