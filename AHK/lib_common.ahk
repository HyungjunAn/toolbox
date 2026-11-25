FileEncoding "UTF-8"

global COMMON_OPT_NONE := 0
global COMMON_OPT_WAIT := 1
global COMMON_OPT_FULLMATCHING := 2
global COMMON_OPT_MAINMONITOR := 4
global COMMON_OPT_SUBMONITOR := 8
global COMMON_OPT_APPMODE := 16
global COMMON_OPT_REGEXMATCHING := 32
global COMMON_OPT_BROWSER_EDGE := 64

global USERPROFILE			:= EnvGet("USERPROFILE")
global TOOLBOX_ROOT			:= EnvGet("TOOLBOX_ROOT")
global TOOLBOX_ROOT_AHK		:= EnvGet("TOOLBOX_ROOT_AHK")
global TOOLBOX_CHROME_EXE 	:= EnvGet("TOOLBOX_CHROME_EXE")
global TOOLBOX_GOOGLE_DRIVE			:= EnvGet("TOOLBOX_GOOGLE_DRIVE")
global TOOLBOX_ROOT_KEEP	:= EnvGet("TOOLBOX_ROOT_KEEP")

global OFFICE_WORK_ROOT		:= EnvGet("OFFICE_WORK_ROOT")
global OFFICE_LIB_ROOT		:= EnvGet("OFFICE_LIB_ROOT")
global OFFICE_TOOLBOX_ROOT	:= EnvGet("OFFICE_TOOLBOX_ROOT")

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

	subTitleArr.Push(subTitle)

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

	Loop arrString.Length
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

	if ((titleArr.Length && textArr.Length) || (!titleArr.Length && !textArr.Length) || timeout_ms <= 0) {
		MsgBox "Error: wrong param"
		return False
	}

	while (cnt < threshold) {
    	T := WinGetTitle("A")

		if (titleArr.Length) {
			Loop titleArr.Length
			{
				title := titleArr[A_Index]
		
				if (T == title) {
					return true
				}
			}
		} else {
			Loop textArr.Length
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

COMMON_ParseKeyAndDescription(path, space := 0) {
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
			blank := ""
			
			if (space) {
				Loop (space - StrLen(key)) {
					blank := blank . " "
				}
			}
			
			text := text . "[" . blank . key . "] " . description . "`n"
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

COMMON_Paste(str) {
	local tmp := A_Clipboard 
	local pname := WinGetProcessName("A")

	A_Clipboard := str
	
	Switch pname
	{
	Case "ttermpro.exe":
		Send "!v"
	Case "cmd.exe", "MobaXterm.exe", "WindowsTerminal.exe":
		Send "+{Ins}"
	Default:
		Send "^v"
	}

	; sleep to prevent overwriting by assign
	Sleep 100
	A_Clipboard := tmp
}

; ============================================================
; Generic Double Tap Handler
;
; - 원래 키 동작 유지
; - 단독 입력만 Tap으로 인정
; - 다른 키와 조합한 경우 제외
; - modifier / 일반 키 모두 사용 가능
; - Suspend 상태에서도 동작
; ============================================================

RegisterDoubleTap(key, action, interval := 300) {
    state := {
        down: false,
        combined: false,
        lastTap: 0
    }

    targetVK := GetKeyVK(key)
    targetSC := GetKeySC(key)

    ; 좌우 modifier의 일반(generic) vk
    GenericVK := 0
    if (targetVK = 0xA0 || targetVK = 0xA1)
        GenericVK := 0x10
    else if (targetVK = 0xA2 || targetVK = 0xA3)
        GenericVK := 0x11
    else if (targetVK = 0xA4 || targetVK = 0xA5)
        GenericVK := 0x12

    ; ~ : 원래 키 입력 유지
    ; * : modifier 상태와 관계없이 감지
    ; S : Suspend 상태에서도 핫키 활성화
    Hotkey "~*" key, KeyDown, "S"
    Hotkey "~*" key " Up", KeyUp, "S"

    ; 다른 키 입력 감지
    ; I : AHK 스크립트가 주입한 입력은 무시
    ;     (예: main.ahk의 CapsLock->Ctrl 리맵이 보내는 Ctrl이
    ;      "다른 키 입력"으로 오인되어 Tap이 무효화되는 문제 방지)
    input := InputHook("V I")
    input.KeyOpt("{All}", "N")
    input.OnKeyDown := OtherKeyDown
    input.Start()

    KeyDown(*) {
        ; Auto-repeat 무시
        if state.down
            return

        state.down := true
        state.combined := false
    }

    OtherKeyDown(ih, vk, sc) {
        ; 등록된 키 자신의 Down 이벤트는 무시
        ; (sc 비교는 키보드/IME에 따라 달라질 수 있어 vk만 비교하고,
        ;  Shift/Ctrl/Alt는 좌우 구분 없는 일반 vk도 같은 키로 취급)
        if (vk = targetVK || vk = GenericVK)
            return

        ; 첫 번째 Tap과 두 번째 Tap 사이에 다른 키가 입력된 경우
        ; (예: Ctrl > A > Ctrl) 더블탭으로 인정하지 않음
        if !state.down {
            state.lastTap := 0
            return
        }

        ; 등록된 키를 누르고 있는 동안
        ; 다른 키가 눌린 경우 조합키로 판단
        state.combined := true
    }

    RunAction() {
        action.Call()

        ; 안전장치: 물리적으로 떼어진 키가 논리적으로 눌린 채 남았으면 해제
        if (state.down = false && !GetKeyState(key, "P") && GetKeyState(key))
            Send "{" key " up}"
    }

    KeyUp(*) {
        if !state.down
            return

        state.down := false

        ; 다른 키와 조합해서 사용했다면
        ; Tap으로 인정하지 않음
        if state.combined {
            state.lastTap := 0
            return
        }

        now := A_TickCount

        ; 지정된 시간 내 두 번째 Tap
        if (state.lastTap && now - state.lastTap <= interval) {
            state.lastTap := 0
            ; KeyUp 핫키 스레드 안에서 바로 실행하면 AHK가 아직 키가 물리적으로
            ; 눌려 있다고 보고, Send 후 modifier를 "복원"하며 다시 눌러버려
            ; Shift/Ctrl 등이 눌린 채로 남을 수 있다.
            ; 타이머로 분리해 Up 이벤트 처리가 끝난 뒤 실행한다.
            SetTimer(RunAction, -10)
        } else {
            ; 첫 번째 Tap
            state.lastTap := now
        }
    }
}
