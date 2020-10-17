Global isLineCopy := False
Global isBlock := False
Global isVisual := False
Global isLineVisual := False
Global curLine := 0

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
	if (!isBlock && PName != "gvim.exe") {
		Suspend, Off
		VimMode_SetVisualMode(False)
	} else {
		VimMode_Suspend()
	}
	Send, {ESC}
	return

x::Delete
h::VimMode_SendVisual("{Left}")
j::VimMode_SendVisual("{Down}")
k::VimMode_SendVisual("{Up}")
l::VimMode_SendVisual("{Right}")
w::VimMode_SendVisual("^{Right}")
b::VimMode_SendVisual("^{Left}")
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
	H := 15
	;Y := A_ScreenHeight - H
	Y := 100
	Gui, VimMode:Show, w600 y%Y% h%H% NoActivate, VimMode
}
