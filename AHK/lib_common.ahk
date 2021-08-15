global COMMON_OPT_NONE := 0
global COMMON_OPT_WAIT := 1
global COMMON_OPT_FULLMATCHING := 2
global COMMON_OPT_MAINMONITOR := 4
global COMMON_OPT_SUBMONITOR := 8
global COMMON_OPT_APPMODE := 16

COMMON_GUI_BlinkActiveWin(color := "F39C12", interval := 60) {
    WinGetPos, x1, y1, w1, h1, A

	w2 := w1 * 2 // 3
	h2 := h1 // 32

	x2 := x1 + (w1 - w2) // 2
	y2 := y1 + (h1 - h2) // 2

	
	Gui, Color, %color%
	Gui, -Caption +alwaysontop +ToolWindow
	Gui, Show, x%x2% y%y2% w%w2% h%h2% NoActivate,

	Sleep, %interval%
	Gui, Destroy
}

COMMON_Activate_SubWinTitle(subTitle, opt := 0) {
	local subTitleArr := []

	subTitleArr[1] := subTitle

	return COMMON_Activate_SubWinTitleArr(subTitleArr, opt)
}

COMMON_Activate_SubWinTitleArr(subTitleArr, opt := 0) {
	local Title := ""
	local cnt := 0

	Title := COMMON_FindWinTitle_Arr(subTitleArr, False)

	if (opt & COMMON_OPT_WAIT) {
		while (!Title && cnt < 100) {
			Title := COMMON_FindWinTitle_Arr(subTitleArr)
			cnt++
			sleep, 20
		}
	}

	if (Title) {
		WinActivate, %Title%
		return True
	} else {
		return False
	}
}

COMMON_FindWinTitle(subTitle, opt := 0) {
	local subTitleArr := []

	subTitleArr[1] := subTitle

	return COMMON_FindWinTitle_Arr(subTitleArr, opt)
}

COMMON_FindWinTitle_Arr(subTitleArr, opt := 0) {
	local subTitle := ""
	local border := 20

    WinGet windows, List

    Loop %windows% {
    	id := windows%A_Index%
    	WinGetTitle Title, ahk_id %id%

    	WinGetPos, X, , , , %Title%

		if ((opt & COMMON_OPT_MAINMONITOR) && (X < -border || X > A_ScreenWidth - border)) {
			continue
		} else if ((opt & COMMON_OPT_SUBMONITOR) && (-border < X && X < A_ScreenWidth - border)) {
			continue
		}

		Loop % subTitleArr.Length()
		{
			subTitle := subTitleArr[A_Index]

			if (subTitle == "") {
				continue
			} else if ((opt & COMMON_OPT_FULLMATCHING) && Title == subTitle) {
				return Title
			} else if (!(opt & COMMON_OPT_FULLMATCHING) && InStr(Title, subTitle)) {
				return Title
			}
		}
    }

    return ""
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
