Global isLineCopy := False
Global isBlock := False
Global isVisual := False
Global isLineVisual := False
Global isCommand := False
Global isCut := False
Global curLine := 0
Global VIM_CMD := ""

Suspend, on

$F1::
	Suspend, Toggle
	if (A_IsSuspended) {
		isBlock := True
		Gui, VimMode:Destroy
	} else {
		isBlock := False
		VimMode_SetVisualMode(False)
	}
	return

$ESC::
$`::
	Suspend, Permit
	WinGet, PName, ProcessName, A
	if (isBlock
			|| PName == "gvim.exe"
			|| PName == "mintty.exe") {
		VimMode_Suspend()
		Send, {ESC}
	} else if (!A_IsSuspended) {
		Send, {ESC}
	} else {
		Suspend, Off
		VimMode_SetVisualMode(False)
	}
	return

$+`;:: isCommand := True

Enter::
	if (isCommand) {
		if (VIM_CMD == "save") {
			Send, ^s
		}

		isCommand := False
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
h::VimMode_SendVisual("{Left}")
j::VimMode_SendVisual("{Down}")
k::VimMode_SendVisual("{Up}")
l::VimMode_SendVisual("{Right}")

+w::
w::
	if (isCommand) {
		VIM_CMD := "save"
	} else if (isCut) {
		Send, +^{Right}^x
		isCut := False
		isLineCopy := False
	} else {
		VimMode_SendVisual("^{Right}")
	}
	return

b::
	if (isCut) {
		Send, +^{Left}^x
		isCut := False
		isLineCopy := False
	} else {
		VimMode_SendVisual("^{Left}")
	}
	return

,::VimMode_SendVisual("{Home}")
.::VimMode_SendVisual("{End}")

v:: VimMode_SetVisualMode(!isVisual)
+v:: VimMode_SetVisualMode(!isVisual, !isLineVisual)

u::Send ^z
^r::Send ^y

$y::
	Send, ^c
	isLineCopy := False
	VimMode_SetVisualMode(False)
	return

$+y::
	Send, {Home}+{End}^c
	isLineCopy := True
	VimMode_SetVisualMode(False)
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

; Suspend
$i::
	VimMode_Suspend()
	return
$+i::
	Send, {Home}
	VimMode_Suspend()
	return
$+a::
	Send, {End}
	VimMode_Suspend()
	return
$o::
	Send, {End}{Enter}
	VimMode_Suspend()
	return
$+o::
	Send, {Home}{Enter}{Up}
	VimMode_Suspend()
	return

VimMode_SendVisual(key)
{
	if (isVisual) {
		if (isLineVisual && key == "{Up}") {
			if (curLine == 0) {
				Send, {End}
			}
			curLine--
		} else if (isLineVisual && key == "{Down}") {
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

VimMode_SetVisualMode(visual, lineVisual := False)
{
	isVisual := visual
	isLineVisual := lineVisual
	isCommand := False
	curLine := 0

	if (isVisual) {
		VimMode_Notify("F39C12")
	} else {
		VimMode_Notify("Red")
	}
}

VimMode_Suspend()
{
	Suspend, On
	Gui, VimMode:Destroy
}

VimMode_Notify(backC)
{
	Gui, VimMode:Destroy
	Gui, VimMode:Color, %backC%
	Gui, VimMode:-Caption +alwaysontop +ToolWindow
	H := 8
	;Y := A_ScreenHeight - H
	;Y := 100
	Y := 72
	W := A_ScreenWidth
	Gui, VimMode:Show, w%W% y%Y% h%H% NoActivate, VimMode
}
