;##############################
; Using Windows Like Vim
;##############################
line_copy := False

noticeCommandModeOn()

;$!^v::
~$!^a::
~#v::
    Suspend, Permit
    ExitApp
    
$#d::  
    Suspend, off
    noticeCommandModeOn()
    Send, #d
    return

$#Tab::  
    Suspend, off
    noticeCommandModeOn()
    Send, #{Tab}
    return

;------------------------------
; About ESC
;------------------------------
$ESC::
$`::
    Suspend, Permit
    if isVimStyleProgram() {
        Send {ESC}
    }
    else if isCommandMode() {
        Send {ESC}
        allVisualModeOff("True")
    }
    else {
        Suspend, Off
        noticeCommandModeOn()
    }
    return

;------------------------------
; Change into Edit Mode
;------------------------------
$i:: editModeOn("", "i")
$+i::editModeOn("{Home}", "+i")
$+a::editModeOn("{End}", "+a")

$o::
    if isCommandMode() {
        Send, {End}{Enter}
        Suspend, On
        Gui, Destroy
    }
    else
        Send, o
    return

$+o::
    if isCommandMode() {
        Send, {Home}{Enter}{Left}
        Suspend, On
        Gui, Destroy
    }
    else
        Send, +o
    return

$m:: editModeOn("{AppsKey}", "m")
$^f::editModeOn("^f", "^f")
$#r::editModeOn("#r", "#r")

;------------------------------
; Modification
;------------------------------
$y::
    ifCommandMode("^c", "y")
    allVisualModeOff("False")
    line_copy := False
    return

$+y::
    ifCommandMode("{End}+{Home}+{Home}^c{Home}{Home}", "+y")
    line_copy := True
    return

$p::
    if line_copy
        ifCommandMode("{End}{Enter}{Home}^v{Home}{Home}", "p")
    else
        ifCommandMode("^v", "p")
    return

$+p::
    if line_copy
        ifCommandMode("{Home}{Home}^v{Enter}{Up}{Home}{Home}", "+p")
    else
        ifCommandMode("^v", "p")
    return
    
$d::
    if (A_PriorHotkey = "$d" and A_TimeSincePriorHotkey < 200)
    {
        ifCommandMode("{End}+{Home}+{Home}^x{Del}", "d")
        line_copy = True
    }
    else
    {
        ifCommandMode("^x", "d")
        line_copy = False
    }
    allVisualModeOff("False")
    return

$u:: ifCommandMode("^z",  "u")
$^r::ifCommandMode("^+z", "^r")

$v:: visualModeOn("v")
$+v::lineVisualModeOn("+v")

$x:: ifCommandMode("{Del}", "x")
$/:: ifCommandMode("^f", "/")
$s:: ifCommandMode("{F2}", "s")

$+;:: ifCommandMode("", ":")

;------------------------------
; Moving
;------------------------------
$h::moving("{Left}", "h")
$j::moving("{Down}", "j")
$k::moving("{Up}", "k")
$l::moving("{Right}", "l")

$w::
    if (A_PriorHotkey = "$+;" and A_TimeSincePriorHotkey < 200)
        ifCommandMode("^s", "w")
    else
        moving("^{Right}", "w")
    return
$b::moving("^{Left}", "b")

$0::moving("{Home}", "0")
$$::moving("{End}", "$")

;------------------------------
; Function Decl
;------------------------------
isVimStyleProgram() {
    WinGetTitle, Title, A

    IfInString, Title, GVIM,                return True
    IfInString, Title, Visual Studio Code,  return True
    IfInString, Title, @,                   return True
    IfInString, Title, cmd,                 return True
    IfInString, Title, Xshell,              return True
    return False
}
isCommandMode() { 
    return !isVimStyleProgram() and !A_IsSuspended
}
isVisualMode() { 
    return getkeystate("capslock","t") 
}
visualModeOn(key) {
    if isCommandMode()
        SetCapslockState, on
    else
        Send, %key%
}
isLineVisualMode() { 
    return getkeystate("scrolllock","t")
}
lineVisualModeOn(key) {
    if isCommandMode() {
        SetScrolllockState, on
        Send, {Home}+{End}
    }
    else
        Send, %key%
}
allVisualModeOff(cond) {
    if (isCommandMode() or %cond%) {
        SetCapslockState, off
        SetScrolllockState, off
    }
}
editModeOn(key1, key2) {
    if isCommandMode() {
        Send, %key1%
        Suspend, on
        Gui, Destroy
    }
    else
        Send, %key2%
}
ifCommandMode(key1, key2) {
    if isCommandMode() {
        allVisualModeOff("False")
        Send, %key1%
    }
    else
        Send, %key2%
}
moving(key1, key2) {
    if isCommandMode() {
        if isVisualMode()
            Send, +%key1%
        else if isLineVisualMode()
            Send, +%key1%+{End}
        else
            Send, %key1%
    }
    else
        Send, %key2%
}

noticeCommandModeOn() {
    Gui, Color, Red
    Gui, -Caption +alwaysontop +ToolWindow
    ;Gui, Show, y0 w1980 h4 NoActivate,
    Gui, Show, y1020 w1980 h20 NoActivate,
}
