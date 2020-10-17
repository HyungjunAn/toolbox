Global isLineCopy := False
Global isVisual := False

Suspend, on

$F1::
	Suspend, Toggle
	if (A_IsSuspended) {
		Gui, VimMode:Destroy
	} else {
		VimMode_SetVisualMode(False)
	}
	return

x::Delete
h::VimMode_SendIfVisual("+{Left}", "{Left}")
j::VimMode_SendIfVisual("+{Down}", "{Down}")
k::VimMode_SendIfVisual("+{Up}", "{Up}")
l::VimMode_SendIfVisual("+{Right}", "{Right}")
w::VimMode_SendIfVisual("+^{Right}", "^{Right}")
b::VimMode_SendIfVisual("+^{Left}", "^{Left}")
,::VimMode_SendIfVisual("+{Home}", "{Home}")
.::VimMode_SendIfVisual("+{End}", "{End}")

v:: VimMode_SetVisualMode(!isVisual)

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

VimMode_SendIfVisual(key_visual, key_noneVisual)
{
	if (isVisual) {
		Send, %key_visual%
	} else {
		Send, %key_noneVisual%
	}
}

VimMode_SetVisualMode(mode)
{
	isVisual := mode

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
