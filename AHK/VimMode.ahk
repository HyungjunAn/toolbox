Global isLineCopy := False
Global isBlock := False
Global isCut := False
Global curLine := 0
Global curPName := ""

Global M_EDIT := 0
Global M_VISUAL := 1
Global M_LINE := 2
Global M_NORMAL := 3
Global M_COMMAND := 4

Global isSupport := False

Global curMode := M_NORMAL
Global oldValue := False
Global newValue := False

VimMode_Suspend()

while (1) {
	sleep, 100
	newValue := VimMode_IsSupportedApp()

	if (oldValue != newValue) {
		if (newValue == True && !isBlock) {
			VimMode_SetMode(curMode)
			isSupport := True
		} else {
			VimMode_Suspend()
			isSupport := False
		}
		oldValue := newValue
	}
}

$F1::
	Suspend, Permit
	isBlock := !isBlock

	if (isBlock) {
		VimMode_Notify("White")
		sleep, 300
		VimMode_Suspend()
	} else {
		oldValue := False
	}
	return

$ESC::
$`::
	Suspend, Permit

	if (!isSupport) {
		Send, {Esc}
	} else if (curMode == M_COMMAND) {
		Send, {Esc}
	} else if (A_IsSuspended) {
		Suspend, Off
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

$d::
	if (curMode == M_LINE) {
		Send, ^x{Delete}
		isLineCopy := True
		isCut := False
		VimMode_SetMode(M_NORMAL)
	} else if (isCut) {
		Send, {End}+{Home}+{Home}^x
		
		if (curMode != M_VISUAL) {
			Send, {Delete}
		}
		isLineCopy := True
		isCut := False
		VimMode_SetMode(M_NORMAL)
	} else {
		isCut := True
	}
	return

$x::Delete
$h::VimMode_Send("{Left}")
$j::VimMode_Send("{Down}")
$k::VimMode_Send("{Up}")
$l::VimMode_Send("{Right}")

$+j::Send, {End}{Delete}

$^+p::
	Send, ^+p
	if (curPName == "Code.exe") {
		VimMode_SetMode(M_EDIT)
	}
	return

$+w::
$w::
	if (isCut) {
		Send, +^{Right}^x
		isCut := False
		isLineCopy := False
	} else {
		VimMode_Send("^{Right}")
	}
	return

$b::
	if (isCut) {
		Send, +^{Left}^x
		isCut := False
		isLineCopy := False
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

$y::
	Send, ^c
	if (curMode == M_LINE) {
		isLineCopy := True
	} else {
		isLineCopy := False
	}
	VimMode_SetMode(M_NORMAL)
	return

$+y::
	Send, {Home}+{End}^c
	isLineCopy := True
	VimMode_SetMode(M_NORMAL)
	return

$p::
	if (isLineCopy) {
		Send, {End}{Enter}{End}+{Home}^v
	} else {
		Send, ^v
	}
	return

$+p::
	if (isLineCopy) {
		Send, {End}{Home}{Home}{Enter}{Up}^v
	} else {
		Send, ^v
	}
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

/::Send, ^f
+/::Send, ^+f

; Ignore Key
t::
f::
q::
e::
c::
z:: Send, {}

VimMode_Send(key) {
	if (curMode == M_VISUAL) {
		Send, +%key%
	} else if (curMode == M_LINE) {
		isUp := False
		if (key == "{Up}") {
			isUp := True
		} else if (key == "{Down}") {
			isUp := False
		} else {
			MsgBox, Error
			return
		}

		if (curLine == 0) {
			if (isUp) {
				Send, {End}
			} else {
				Send, {End}{Home}{Home}
			}
		}

		if (isUp) {
			curLine--
		} else {
			curLine++
		}

		Send, +%key%

		if (curLine < 0) {
			Send, +{Home}+{Home}
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
		Suspend, off
		VimMode_Notify("Red")
	}
}

VimMode_Suspend() {
	Suspend, On
	Gui, VimMode:Destroy
}

VimMode_IsSupportedApp() {
	WinGet, curPName, ProcessName, A

	if (curPName == "Code.exe"
			|| curPName == "notepad++.exe") {
		return True
	}
	return False
}

VimMode_Notify(backC)
{
	;Gui, VimMode:Destroy
	Gui, VimMode:Color, %backC%
	Gui, VimMode:-Caption +alwaysontop +ToolWindow
	H := 8
	;Y := A_ScreenHeight - H
	;Y := 100
	Y := 72
	W := A_ScreenWidth
	Gui, VimMode:Show, w%W% y%Y% h%H% NoActivate, VimMode
}
