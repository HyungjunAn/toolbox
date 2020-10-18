Global isLineCopy := False
Global isBlock := False
Global isCut := False
Global curLine := 0
Global VIM_CMD := ""

Global M_EDIT := 0
Global M_VISUAL := 1
Global M_LINE := 2
Global M_NORMAL := 3

Global curMode := M_NORMAL
Global oldValue := False
Global newValue := False

while (1) {
	sleep, 100

	newValue := VimMode_IsSupportedApp()
	if (oldValue == False && newValue == True && !isBlock) {
		VimMode_SetMode(curMode)
	} else if (oldValue == True && newValue == False) {
		VimMode_Suspend()
	}
	oldValue := newValue
}

$F1::
	Suspend, Toggle
	if (A_IsSuspended) {
		Gui, VimMode:Destroy
	} else {
		VimMode_SetMode(M_NORMAL)
	}
	isBlock := A_IsSuspended
	return

$ESC::
$`::
	Suspend, Permit

	if (!VimMode_IsSupportedApp()) {
		Send, {Esc}
	} else if (!isBlock && A_IsSuspended) {
		Suspend, Off
		VimMode_SetMode(M_NORMAL)
	} else {
		VimMode_SetMode(M_NORMAL)
		Send, {Esc}
	}
	return

$+`;:: VimMode_SetMode(M_COMMAND)

Enter::
	if (curMode == M_COMMAND) {
		if (VIM_CMD == "save") {
			Send, ^s
		}
		VimMode_SetMode(M_NORMAL)
	} else {
		Send, {Enter}
	}
	return 

d::
	if (isCut) {
		Send, {Home}+{End}^x{Delete}
		isLineCopy := True
	}
	isCut := !isCut
	return

x::Delete
h::VimMode_Send("{Left}")
j::VimMode_Send("{Down}")
k::VimMode_Send("{Up}")
l::VimMode_Send("{Right}")


+w::
w::
	if (curMode == M_COMMAND) {
		VIM_CMD := "save"
	} else if (isCut) {
		Send, +^{Right}^x
		isCut := False
		isLineCopy := False
	} else {
		VimMode_Send("^{Right}")
	}
	return

b::
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

v:: VimMode_SetMode(M_VISUAL)
+v:: VimMode_SetMode(M_LINE)

u::
	Send ^z
	return

^r::
	Send ^y
	return

$y::
	Send, ^c
	isLineCopy := False
	VimMode_SetMode(M_NORMAL)
	return

$+y::
	Send, {Home}+{End}^c
	isLineCopy := True
	VimMode_SetMode(M_NORMAL)
	return

$p::
	if (isLineCopy) {
		Send, {End}{Enter}^v
	} else {
		Send, ^v
	}
	return

$+p::
	if (isLineCopy) {
		Send, {Home}{Enter}{Up}^v
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

VimMode_Send(key) {
	if (curMode == M_VISUAL) {
		Send, +%key%
	} else if (curMode == M_LINE) {
		if (key == "{Up}") {
			if (curLine == 0) {
				Send, {End}
			}
			curLine--
		} else if (key == "{Down}") {
			if (curLine == 0) {
				Send, {Home}
			}
			curLine++
		}
		Send, +%key%
	} else {
		Send, %key%
	}
}

VimMode_SetMode(mode) {
	curMode := mode
	curLine := 0

	if (curMode == M_EDIT) {
		VimMode_Suspend()
	} else if (curMode == M_VISUAL || curMode == M_LINE) {
		Suspend, off
		VimMode_Notify("F39C12")
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
	WinGet, PName, ProcessName, A

	if (PName == "Code.exe"
			|| PName == "notepad++.exe") {
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