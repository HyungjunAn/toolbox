Global isCopying := False
Global isLineCopy := False
Global isBlock := False
Global isCutReady := False
Global curLine := 0
Global curPName := ""
Global curWTitle := ""

Global M_EDIT := 0
Global M_VISUAL := 1
Global M_LINE := 2
Global M_NORMAL := 3
Global M_COMMAND := 4

Global isSupport := False
Global curMode := M_NORMAL

VimMode_MainLoop("", "", "")

$!^b::
	Suspend, Permit
	isBlock := !isBlock

	if (isBlock) {
		isSupport := False
		VimMode_Notify("White")
		sleep, 300
		VimMode_Suspend()
	} else {
		isSupport := True
		VimMode_SetMode(curMode)
	}
	return

$ESC::
$`::
	Suspend, Permit

	if (!isSupport) {
		Send, {Esc}
	} else if (curMode == M_COMMAND) {
		Send, {Esc}
	} else if (curMode == M_EDIT) {
		VimMode_SetMode(M_NORMAL)
	} else {
		VimMode_SetMode(M_NORMAL)
		Send, {Esc}
	}
	return

$+`;::
	VimMode_SetMode(M_COMMAND)
	InputBox, UserInput, :, , , 40, 100
	;Input, UserInput, L5, {Enter}
	if (!ErrorLevel) {
		isGoToLine := false
		if UserInput is integer
			isGoToLine := true

		if (UserInput == "w" || UserInput == "W") {
			Send, ^s
		} else if (isGoToLine) {
			if (curPName == "Code.exe") {
				Send, ^g
				sleep, 50
				Send, %UserInput%
				sleep, 50
				Send, {Enter}
			}
		} else {
			MsgBox, bad command!!
		}
	}
	VimMode_SetMode(M_NORMAL)
	return


$h::VimMode_Send("{Left}")
$j::VimMode_Send("{Down}")
$k::VimMode_Send("{Up}")
$l::VimMode_Send("{Right}")

$+j::Send, {End}{Delete}

$!+s::
	Send, !+s
	if (curPName == "Code.exe") {
		VimMode_SetMode(M_EDIT)
	}
	return

$!+k::
	Send, !+k
	if (curPName == "Code.exe") {
		VimMode_SetMode(M_EDIT)
	}
	return


$^+p::
	Send, ^+p
	if (curPName == "Code.exe") {
		VimMode_SetMode(M_EDIT)
	}
	return

$+w::
$w::
	if (isCutReady) {
		Send, +^{Right}
		VimMode_Cut()
	} else {
		VimMode_Send("^{Right}")
	}
	return

$b::
	if (isCutReady) {
		Send, +^{Left}
		VimMode_Cut()
	} else {
		VimMode_Send("^{Left}")
	}
	return

,::VimMode_Send("{Home}")
.::VimMode_Send("{End}")

$v:: VimMode_SetMode(M_VISUAL)
$+v:: VimMode_SetMode(M_LINE)

$u::
	Send ^z
	return

$^r::
	Send ^y
	return


; Copy & Cut & Paste
$+p::
$p::
	if (isLineCopy) {
		Send, {End}
	}
	VimMode_Paste()
	return

$d::
	if (curMode == M_NORMAL && !isCutReady) {
		isCutReady := True
		return
	}

	if (isCutReady) {
		VimMode_SetMode(M_LINE)
	}
	
	VimMode_Cut()
	return

$x::
	if (curMode != M_VISUAL && curMode != M_LINE) {
		Send, +{Right}
	}

	VimMode_Cut()
	return

$y:: VimMode_Copy()

$+y::
	VimMode_SetMode(M_LINE)
	VimMode_Copy()
	return


; Edit Mode
$i::
	VimMode_SetMode(M_EDIT)
	return

$+i::
	Send, {Home}
	VimMode_SetMode(M_EDIT)
	return

$+a::
	Send, {End}
	VimMode_SetMode(M_EDIT)
	return

$o::
	Send, {End}{Enter}
	VimMode_SetMode(M_EDIT)
	return

$+o::
	Send, {Home}{Enter}{Up}
	VimMode_SetMode(M_EDIT)
	return

$^p::
	Send, ^p
	VimMode_SetMode(M_EDIT)
	return

$^h:: Send, ^{Left}
$^j:: Send, ^{Down}
$^k:: Send, ^{Up}
$^l:: Send, ^{Right}

$^d:: Send, {PgDn}
$^u:: Send, {PgUp}

; Auto Formating
$=::
	if (curPName == "Code.exe") {
		Send, ^k^f
	} else {
		Send, =
	}
	return

; Search
$^f::
$/::
	Send, ^f
	VimMode_SetMode(M_EDIT)
	return

; Ignore Key
$s::
$t::
$f::
$q::
$e::
$c::
$z:: Send, {}

VimMode_Send(key) {
	if (curMode == M_VISUAL) {
		Send, +%key%
	} else if (curMode == M_LINE) {
		isUp := False
		tmpLine := curLine + 1

		if (key == "{Up}") {
			isUp := True
			tmpLine := curLine - 1
		}

		if (curLine == 0) {
			if (isUp) {
				Send, {End}+{Home}+{Home}
			} else {
				Send, {End}{Home}{Home}
			}
		}

		curLine := tmpLine
		Send, +%key%

		if (curLine < 0) {
			;
		} else if (curLine > 0) {
			Send, +{End}
		} else {
			Send, {End}+{Home}+{Home}
		}
	} else {
		Send, %key%
	}
}

VimMode_SetMode(mode) {
	curMode := mode
	curLine := 0

	if (curMode == M_EDIT) {
		VimMode_Suspend()
	} else if (curMode == M_COMMAND) {
		Suspend, on
		VimMode_Notify("Green")
	} else if (curMode == M_VISUAL) {
		Suspend, off
		VimMode_Notify("F39C12")
	} else if (curMode == M_LINE) {
		Suspend, off
		VimMode_Notify("F39C12")
		Send, {End}+{Home}+{Home}
	} else {
		isCutReady := False
		Suspend, off
		VimMode_Notify("Red")
	}
}

VimMode_Paste() {
	if (isCopying) {
		return
	}

	Send, ^v
}

VimMode_Cut() {
	_VimMode_Clip("^x")
}

VimMode_Copy() {
	_VimMode_Clip("^c")
}

_VimMode_Clip(sendStr) {
	isCopying := True
	Clipboard := ""
	isLineCopy := False

	if (curMode == M_LINE) {
		isLineCopy := True

		if (curLine == 0) {
			Send, {End}+{Home}+{Home}+{Left}
		} else if (curLine < 0) {
			Send, +{Left}
		} else if (curLine > 0) {
			Send, {Right}+{Home}+{Home}
			Loop %curLine% {
				Send, +{Up}
			}
			Send, +{Left}
		}
	}

	Send, %sendStr%
	
	if (curMode == M_LINE) {
		Send, {Right}
	}

	ClipWait, 0.5

	if (ErrorLevel) {
		MsgBox, ClipWait Error
	}

	VimMode_SetMode(M_NORMAL)
	isCopying := False
}

VimMode_Suspend() {
	Suspend, On
	Gui, VimMode:Destroy
}

VimMode_Notify(backC) {
	;Gui, VimMode:Destroy
	Gui, VimMode:Color, %backC%
	Gui, VimMode:-Caption +alwaysontop +ToolWindow
    WinGetPos, X, Y, W, H, A

	;H := 8
	;;Y := A_ScreenHeight - H
	;;Y := 100
	;Y := 72
	;W := A_ScreenWidth
	;Gui, VimMode:Show, w%W% y%Y% h%H% NoActivate, VimMode

	H := 40
	d := W / 4
	X := X + d
	W := W - 2 * d

	;d := 30
	;X := X + W - d
	;W := d

	Gui, VimMode:Show, w%W% y%Y% x%X% h%H% NoActivate, VimMode

}

VimMode_IsSupport() {
	if (curPName == "Code.exe" || curPName == "firefox.exe") {
		return True
	}

	;if (curPName == "msedge.exe" && InStr(curWTitle, "Boost Note")) {
	;	return True
	;}

	return False
}

VimMode_MainLoop(hWinEventHook, vEvent, hWnd) {
	DetectHiddenWindows, On
	WinGet, curPName, ProcessName, A
    WinGetTitle, curWTitle, A
	;ToolTip, %curPName%

	if (!isBlock && VimMode_IsSupport()) {
		VimMode_SetMode(curMode)
		isSupport := True
	} else {
		VimMode_Suspend()
		isSupport := False
	}

	;EVENT_SYSTEM_FOREGROUND := 0x3
	static _ := DllCall("user32\SetWinEventHook", UInt,0x3, UInt,0x3, Ptr,0, Ptr, RegisterCallback("VimMode_MainLoop"), UInt,0, UInt,0, UInt,0, Ptr)
}
