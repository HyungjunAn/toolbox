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

	VPC_FocusOut()
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
			Send, #{Down}
			sleep, 200
		}
	}
	
	WinActivate, %Title%
	return Title
}

runOrActivateProc(exePath) {
	VPC_FocusOut()
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
	VPC_FocusOut()

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
	VPC_FocusOut()

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
		Send, ^#{right}
	} else {
		Send, ^#{left}
	}
	isVirtualDesktopLeft := !isVirtualDesktopLeft
}

VDesktop_left() {
	if (isVirtualDesktopLeft == False) {
		Send, ^#{left}
		isVirtualDesktopLeft := True
		sleep 200
	}
}
