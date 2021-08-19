#include lib_common.ahk

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

Global PASTE_PREV	:= 0
Global PASTE_NEXT	:= 1
Global CLIP_COPY	:= 0
Global CLIP_CUT		:= 1

Global curMode := M_NORMAL

VimMode_SetMode(M_NORMAL)

$ESC::
$`::
	Suspend, Permit

	if (!isSupport) {
		SendInput, {Esc}
	} else if (curMode == M_COMMAND) {
		SendInput, {Esc}
	} else if (curMode == M_EDIT) {
		VimMode_SetMode(M_NORMAL)
	} else {
		VimMode_SetMode(M_NORMAL)
		SendInput, {Esc}
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
			SendInput, ^s
		} else if (isGoToLine) {
			if (COMMON_GetActiveWinProcName() == "Code.exe") {
				SendInput, ^g
				sleep, 50
				SendInput, %UserInput%{Enter}
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

$+j::SendInput, {End}{Delete}

$+w::
$w::
	if (isCutReady) {
		SendInput, +^{Right}
		VimMode_Cut()
	} else {
		VimMode_Send("^{Right}")
	}
	return

$b::
	if (isCutReady) {
		SendInput, +^{Left}
		VimMode_Cut()
	} else {
		VimMode_Send("^{Left}")
	}
	return

$0::
$,::VimMode_Send("{Home}")

$$::
$.::VimMode_Send("{End}")

$v:: VimMode_SetMode(M_VISUAL)
$+v:: VimMode_SetMode(M_LINE)

$u::
	SendInput, ^z
	return

$^r::
	SendInput, ^y
	return


; Copy & Cut & Paste
$+p::  VimMode_Paste(PASTE_PREV)
$p::   VimMode_Paste(PASTE_NEXT)

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
		SendInput, +{Right}
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
	SendInput, {Home}
	VimMode_SetMode(M_EDIT)
	return

$+a::
	SendInput, {End}
	VimMode_SetMode(M_EDIT)
	return

$o::
	SendInput, {End}{Enter}
	VimMode_SetMode(M_EDIT)
	return

$+o::
	SendInput, {Home}{Enter}{Up}
	VimMode_SetMode(M_EDIT)
	return

$^p::
	SendInput, ^p
	VimMode_SetMode(M_EDIT)
	return

$^h:: SendInput, ^{Left}
$^j:: SendInput, ^{Down}
$^k:: SendInput, ^{Up}
$^l:: SendInput, ^{Right}

$^d:: SendInput, {PgDn}
$^u:: SendInput, {PgUp}

; Auto Formating
$=::
	if (COMMON_GetActiveWinProcName() == "Code.exe") {
		SendInput, ^k^f
	} else {
		SendInput, =
	}
	return

; Search
$^f::
$/::
	SendInput, ^f
	VimMode_SetMode(M_EDIT)
	return

; Ignore Key
$s::
$t::
$f::
$q::
$e::
$c::
$z:: SendInput, {}

VimMode_Send(key) {
	if (curMode == M_VISUAL) {
		SendInput, +%key%
	} else if (curMode == M_LINE) {
		isUp := False
		tmpLine := curLine + 1

		if (key == "{Up}") {
			isUp := True
			tmpLine := curLine - 1
		}

		if (curLine == 0) {
			if (isUp) {
				SendInput, {End}+{Home}+{Home}
			} else {
				SendInput, {End}{Home}{Home}
			}
		}

		curLine := tmpLine
		SendInput, +%key%

		if (curLine < 0) {
			;
		} else if (curLine > 0) {
			SendInput, +{End}
		} else {
			SendInput, {End}+{Home}+{Home}
		}
	} else {
		SendInput, %key%
	}
}

VimMode_SetMode(mode) {
	curMode := mode
	curLine := 0

	if (curMode == M_EDIT) {
		ExitApp
	} else if (curMode == M_COMMAND) {
		Suspend, on
		VimMode_Notify("Green")
	} else if (curMode == M_VISUAL) {
		Suspend, off
		VimMode_Notify("F39C12")
	} else if (curMode == M_LINE) {
		Suspend, off
		VimMode_Notify("F39C12")
		SendInput, {End}+{Home}+{Home}
	} else {
		isCutReady := False
		Suspend, off
		VimMode_Notify("Red")
	}
}

VimMode_Paste(mode) {
	local backup := ""
	
	if (isCopying) {
		return
	}

	isCopying := True
	backup := Clipboard
	
	if (isLineCopy) {
		if (mode == PASTE_PREV) {
			Send, {End}{Home}{Home}
			Clipboard := backup . "`n"
		} else if (mode == PASTE_NEXT) {
			Send, {End}
			Clipboard := "`n" . backup
		} else {
			MsgBox, Error: Worng Paste Mode!!
			return
		} 
	}

	SendInput, ^v
	sleep, 50
	Clipboard := backup
	isCopying := False
}

VimMode_Cut() {
	_VimMode_Clip(CLIP_CUT)
}

VimMode_Copy() {
	_VimMode_Clip(CLIP_COPY)
}

_VimMode_ClipSendInput(mode) {
	Clipboard := ""

	if (mode == CLIP_COPY) {
		SendInput, ^c
	} else if (mode == CLIP_CUT) {
		SendInput, ^x
	}
	
	ClipWait, 0.5

	if (ErrorLevel) {
		MsgBox, ClipWait Error
	}
}

_VimMode_Clip(mode) {
	isCopying := True

	if (curMode != M_LINE) {
		isLineCopy := False
		_VimMode_ClipSendInput(mode)
		Goto, FINISH
	}

	; curMode is M_LINE
	isLineCopy := True

	if (curLine == 0) {
		SendInput, {End}+{Home}+{Home}
	}

	if (mode == CLIP_COPY) {
		_VimMode_ClipSendInput(mode)

		if (curLine <= 0) {
			SendInput, {Left}
		} else {
			SendInput, {Right}
		}
	} else if (mode == CLIP_CUT) {
		if (curLine <= 0) {
			SendInput, +{Left}
		} else if (curLine > 0) {
			SendInput, +{Right}
		}

		_VimMode_ClipSendInput(mode)

		if (curLine <= 0) {
			Clipboard := removeBeginNewline(Clipboard)
		} else {
			Clipboard := removeEndNewline(Clipboard)
		}
	} else {
		MsgBox, Error: wrong mode!
	}

FINISH:
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
