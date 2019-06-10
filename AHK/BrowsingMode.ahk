;##############################
; Browsing Mode
;##############################

BlockInput, MouseMove 
flash_notice("Red")

flash_notice(color) {
    Gui, Destroy
    continue_notice(color)
    Sleep, 1000
    Gui, Destroy
}
continue_notice(color) {
    Gui, Color, %color%
    Gui, -Caption +alwaysontop +ToolWindow
    w := 800
    x := A_screenWidth // 2 - w // 2
    Gui, Show, x%x% y0 w%w% h23 NoActivate,
}
mode_suspend() {
    Suspend
    if !A_IsSuspended {
        BlockInput, MouseMove 
        flash_notice("Red")
    }
    else {
        BlockInput, MouseMoveOff 
        continue_notice("Yellow")
    }
}

Numpad4::
NumpadLeft::
LButton::Left

Numpad6::
NumpadRight::
RButton::Right

Numpad1::
NumpadEnd::^Left
Numpad3::
NumpadPgDn::^Right
Numpad7::
NumpadHome::+Left
Numpad9::
NumpadPgUp::+Right

Esc::
Numpad0::
NumpadIns::
MButton::
	Suspend, permit
	mode_suspend()
	return

Numpad8::
NumpadUp::
$WheelUp::ifVolumeProg("{Up}", "{Volume_Up}", "{WheelUp}")

Numpad2::
NumpadDown::
$WheelDown::ifVolumeProg("{Down}", "{Volume_Down}", "{WheelDown}")

ifVolumeProg(arrow_key, volume_key, false_key) {
    if isArrowVolumeProg()
        Send, %arrow_key%
    else if isWheelVolumeProg()
        Send, %volume_key%
    else
        Send, %false_key%
}
isArrowVolumeProg() {
    WinGetTitle, Title, A
    IfInString, Title, ø”√≠«√∑π¿Ã,  return True
    return False
}
isWheelVolumeProg() {
    WinGetTitle, Title, A
    IfInString, Title, ∆Ã«√∑π¿ÃæÓ,  return True
    return False
}

$w::Send, {Up}
$a::Send, {Left}
$s::Send, {Down}
$d::Send, {Right}
$^a::Send, ^{Left}
$^d::Send, ^{Right}
$e::Send, {End}
$q::Send, {Home}
$r::Send, {PgUp}
$f::Send, {PgDn}

;$h::  keySwap_ifInTitle(".pdf - Google Chrome", "{WheelLeft}", "h")
;$j::  keySwap_ifInTitle(".pdf - Google Chrome", "{WheelDown}", "j")
;$k::  keySwap_ifInTitle(".pdf - Google Chrome", "{WheelUp}", "k")
;$l::  keySwap_ifInTitle(".pdf - Google Chrome", "{WheelRight}", "l")
;$d::  keySwap_ifInTitle(".pdf - Google Chrome", "{WheelDown}{WheelDown}{WheelDown}{WheelDown}{WheelDown}", "d")
;$u::  keySwap_ifInTitle(".pdf - Google Chrome", "{WheelUp}{WheelUp}{WheelUp}{WheelUp}{WheelUp}", "u")



