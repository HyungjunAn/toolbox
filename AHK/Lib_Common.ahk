#include Lib_VPC.ahk

global isVirtualDesktopLeft := True

openOrActivateUrl(subName, isFullMatching, url, isCancelingFullScreen=false) {
	local cmd := "chrome.exe --app=" . url
	Title := runOrActivateWin(subName, isFullMatching, cmd, isCancelingFullScreen)
	return Title
}

runOrActivateWin(subName, isFullMatching, cmd, isCancelingFullScreen=false) {
	Local interval := 50
	Local check := 0

	focusOnMain()
	Title := findWindow(subName, isFullMatching)

	if (!Title) {
		Run, %cmd%
		while (!Title && check < 1000) {
			Title := findWindow(subName, isFullMatching)
			sleep, %interval%
			check := check + interval
		}
		if !Title {
			return ""
		}
		if isCancelingFullScreen {
			WinActivate, %Title%
			SendInput, #{Down}
			sleep, 200
		}
	}
	
	WinActivate, %Title%
	return Title
}

runOrActivateProc(exePath) {
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
		}
	}

	if (!flag) {
		Run, %exePath%
	}

	return flag
}

findWindow(subName, isFullMatching=True) {
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

getTwoString(string, ByRef str1, ByRef str2) {
	local bIsFirstStr := True
	local tmpStr := ""
	local ret := 0
	local arrString := StrSplit(string, A_Tab)

	Loop % arrString.Length()
	{
		tmpStr := arrString[A_Index]
	
		; comment
		if (InStr(tmpStr, "//") == 1) {
			return ret
		}

		; multiple tab
		if (!tmpStr) {
			continue
		}

		if (bIsFirstStr) {
			str1 := tmpStr
			bIsFirstStr := False
		} else {
			str2 := tmpStr
		}
		ret++
	}
	return ret
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
		sleep 200
	}
}

focusOnMain() {
	VDesktop_left()
	VPC_FocusOut()
}
