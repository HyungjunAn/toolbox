global COMMON_OPT_NONE := 0
global COMMON_OPT_WAIT := 1
global COMMON_OPT_FULLMATCHING := 2
global COMMON_OPT_MAINMONITOR := 4
global COMMON_OPT_SUBMONITOR := 8
global COMMON_OPT_APPMODE := 16
global COMMON_OPT_REGEXMATCHING := 32

global USERPROFILE			:= EnvGet("USERPROFILE")
global TOOLBOX_ROOT			:= EnvGet("TOOLBOX_ROOT")
global TOOLBOX_ROOT_AHK		:= EnvGet("TOOLBOX_ROOT_AHK")
global TOOLBOX_CHROME_EXE 	:= EnvGet("TOOLBOX_CHROME_EXE")
global TOOLBOX_GOOGLE_DRIVE			:= EnvGet("TOOLBOX_GOOGLE_DRIVE")
global TOOLBOX_ROOT_BLOG_POSTS		:= EnvGet("TOOLBOX_ROOT_BLOG_POSTS")
global TOOLBOX_ROOT_NOTE_ENGLISH	:= EnvGet("TOOLBOX_ROOT_NOTE_ENGLISH")


global OFFICE_LIB_ROOT		:= EnvGet("OFFICE_LIB_ROOT")
global OFFICE_SETTING_ROOT	:= EnvGet("OFFICE_SETTING_ROOT")

COMMON_IsBrowser() {
	p_name := COMMON_GetActiveWinProcName()

    return (p_name == "chrome.exe" || p_name == "firefox.exe")
}

COMMON_IsOffice() {
	return (A_UserName == "hyungjun.an")
}

COMMON_GUI_BlinkActiveWin(color := "F39C12", interval := 60) {
    WinGetPos &x1, &y1, &w1, &h1, "A"

	w2 := w1 * 2 // 3
	h2 := h1 // 32

	x2 := x1 + (w1 - w2) // 2
	y2 := y1 + (h1 - h2) // 2

	
	Gui Color, color
	Gui "-Caption +alwaysontop +ToolWindow"
	Gui "Show", "x" . x2 . " y" . y2 . " w" . w2 . " h" . h2 . " NoActivate"

	Sleep interval
	Gui "Destroy"
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
			sleep 20
		}
	}

	if (Title) {
		WinActivate Title
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
	local x := 0

    windows := WinGetList()

	DetectHiddenWindows true

    Loop windows.Length {
    	id := windows[A_Index]
    	WinGetPos &x, , , , "ahk_id " . id
    	Title := WinGetTitle("ahk_id " . id)

		if (x != -32000) {
			if ((opt & COMMON_OPT_MAINMONITOR) && (x < -border || x > A_ScreenWidth - border)) {
				continue
			} else if ((opt & COMMON_OPT_SUBMONITOR) && (-border < x && x < A_ScreenWidth - border)) {
				continue
			}
		}

		Loop subTitleArr.Length
		{
			subTitle := subTitleArr[A_Index]

			if (subTitle == "") {
				continue
			} else if ((opt & COMMON_OPT_FULLMATCHING) && Title == subTitle) {
				return Title
			} else if ((opt & COMMON_OPT_REGEXMATCHING) && RegExMatch(Title, subTitle)) {
				return Title
			} else if (!(opt & COMMON_OPT_FULLMATCHING) && InStr(Title, subTitle)) {
				return Title
			}
		}
    }

	DetectHiddenWindows false

    return ""
}

COMMON_StrSplit(string, delimiters, commentPrefix := "//") {
	local tmpStr := ""
	local arrString := StrSplit(string, delimiters)
	local retString := []

	Loop arrString.Length()
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
	local titleArr := []
	local textArr := []

	if (title)
		titleArr[1] := title

	if (title)
		textArr[1] := text

	return COMMON_WinWait_Arr(titleArr, textArr, timeout_ms)
}

COMMON_WinWait_Arr(titleArr, textArr, timeout_ms) {
	static interval := 50

	local T := ""
	local cnt := 0
	local threshold := timeout_ms / interval

	if ((titleArr.Length() && textArr.Length()) || (!titleArr.Length() && !textArr.Length()) || timeout_ms <= 0) {
		MsgBox "Error: wrong param"
		return False
	}

	while (cnt < threshold) {
    	WinGetTitle T, "A"

		if (titleArr.Length()) {
			Loop titleArr.Length()
			{
				title := titleArr[A_Index]
		
				if (T == title) {
					return true
				}
			}
		} else {
			Loop textArr.Length()
			{
				text := textArr[A_Index]
		
				if (InStr(T, text)) {
					return true
				}
			}
		}

		cnt++
		sleep interval
	}

	return false
}

COMMON_IsEmpty(Dir) {
	Loop Files, Dir . "\*.*", "FD"
		return FALSE
	return TRUE
}

COMMON_GetActiveExplorerPath() {
	explorerHwnd := WinActive("ahk_class CabinetWClass")

	if (explorerHwnd)
	{
		for window in ComObject("Shell.Application").Windows
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
	for Window in ComObject("Shell.Application").Windows  
	    if (window.hwnd == hwnd) {
	        Selection := Window.Document.SelectedItems
	        for Items in Selection
	            return Items.path
	    }
	return ""	
}

COMMON_GetActiveWinProcName() {
    return  WinGetProcessName("A")
}

COMMON_ParseKeyAndDescription(path) {
	Local description := ""
	Local key := ""
	Local text := ""

	Loop Read, path
	{
		if (SubStr(A_LoopReadLine, 1, 1) == ";") {
			description := SubStr(A_LoopReadLine, 2)
		} else if (InStr(A_LoopReadLine, "::")) {
			key := RegExReplace(A_LoopReadLine, "^\$``?(.*)::", "$1")
		} else {
			description := ""
			key := ""
		}
	
		if (key != "" && description != "") {
			text := text . "[" . key . "] " . description . "`n"
		}
	}

	text := SubStr(text, 1, StrLen(text) - 1)

	return text
}

COMMON_Sleep(ms) {
	local ms_interval := 10
	local i := 0
	local n := ms // ms_interval
	while (!A_IsSuspended && i != n) {
		i++
		Sleep ms_interval
	}
}
