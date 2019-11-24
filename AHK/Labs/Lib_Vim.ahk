;///////////////////////////////////////////////////////////////
;		Initializing
;///////////////////////////////////////////////////////////////
Global _insert 	:= 0
Global _command	:= 1
Global _visual	:= 2

Global VIM_curMode := _command

;///////////////////////////////////////////////////////////////
;		Function Define
;///////////////////////////////////////////////////////////////
VIM_IsSupportProgram()
{
    WinGetTitle, T, A
	if (InStr(T, " - Notepad++"))
	{
		return True
	}
	return False
}

VIM_ChangeMode_Command()
{
	ret := False
	if (VIM_IsSupportProgram() && VIM_curMode != _command) {
		VIM_curMode := _command
		ret := True
	}
	VIM_GUI()
	return ret
}

VIM_ChangeMode_Insert()
{
	ret := False
	if (VIM_IsSupportProgram() && VIM_curMode = _command) {
		VIM_curMode := _insert
		ret := True
	}
	VIM_GUI()
	return ret
}

VIM_ChangeMode_Visual()
{
	ret := False
	if (VIM_IsSupportProgram() && VIM_curMode = _command) {
		VIM_curMode := _visual
		ret := True
	}
	VIM_GUI()
	return ret
}

VIM_SendKey(key1, key2)
{
	if (VIM_curMode = _insert || !VIM_IsSupportProgram()) {
		Send, %key1%
	} else if (VIM_curMode = _visual) {
		Send, +%key2%
	} else {
		Send, %key2%
	}
}

VIM_GUI()
{
	h := 40
	w := 400
	y := A_ScreenHeight - h
	c := "Red"

	if (VIM_curMode != _insert) {
		if (VIM_curMode = _visual) {
			c := "Blue"
		}
		Gui, Color, %c%
		Gui, -Caption +alwaysontop +ToolWindow
		Gui, Show, y%y% w%w% h%h% NoActivate,
	} else {
		Gui, Destroy
	}
	return
}

; must in main.ahk

; Mode Change
$ESC::
$`::
	if (!VIM_ChangeMode_Command()) {
		Send, {ESC}
	}
	return

$i:: 
	if (!VIM_ChangeMode_Insert()) {
		Send, i
	}
	return

$v:: 
	if (!VIM_ChangeMode_Visual()) {
		Send, v
	}
	return

; Moving
$h::VIM_SendKey("h", "{Left}")
$l::VIM_SendKey("l", "{Right}")
$j::VIM_SendKey("j", "{Down}")
$k::VIM_SendKey("k", "{Up}")

$w::VIM_SendKey("w", "^{Right}")
$b::VIM_SendKey("b", "^{Left}")

$,::VIM_SendKey(",", "{Home}")
$.::VIM_SendKey(".", "{End}")

; Copy & Paste & Delete
$y::
	if (VIM_curMode = _visual && VIM_ChangeMode_Command()) {
		Send, ^c
	} else {
		Send, y
	}
	return

$d::
	if (VIM_curMode = _visual && VIM_ChangeMode_Command()) {
		Send, ^x
	} else {
		Send, d
	}
	return

$p::
	if (VIM_curMode = _command && VIM_IsSupportProgram()) {
		Send, ^v
	} else {
		Send, p
	}
	return

$^c::
	if (VIM_curMode = _visual) {
		VIM_ChangeMode_Command()
	}
	Send, ^c
	return

$^x::
	if (VIM_curMode = _visual) {
		VIM_ChangeMode_Command()
	}
	Send, ^x
	return

$x::
	if (VIM_curMode = _insert || !VIM_IsSupportProgram()) {
		Send, x
	} else {
		VIM_ChangeMode_Command()
		Send, {Delete}
	}
	return
