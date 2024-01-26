FileEncoding "UTF-8"

#include lib_run.ahk

suspendOn() {
	Suspend true
}

suspendOff() {
	Suspend false
	FOCUS_MainDesktop()
}

suspendOn()

#SuspendExempt
$#Tab::
{
	if (A_IsSuspended) {
		suspendOff()
	} else {
		suspendOn()
	}

	SendInput "#{Tab}"
}

#SuspendExempt False

$h:: Send "{Left}"
$j:: Send "{Down}"
$k:: Send "{Up}"
$l:: Send "{Right}"

$,::
$d::
$x:: Send "{Delete}"

$Enter::
{
	suspendOn()
	Send "{Enter}"
}

$`::
$ESC::
{
	suspendOn()
	Send "{ESC}"
}
