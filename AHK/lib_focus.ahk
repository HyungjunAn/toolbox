#include lib_vpc.ahk

global bVirtualDesktopLeft := True

FOCUS_VDesktop_toggle() {
	if (bVirtualDesktopLeft) {
		SendInput, ^#{right}
	} else {
		SendInput, ^#{left}
	}
	bVirtualDesktopLeft := !bVirtualDesktopLeft
}

FOCUS_VDesktop_left() {
	if (bVirtualDesktopLeft == False) {
		SendInput, ^#{left}
		bVirtualDesktopLeft := True
	}
}

FOCUS_MainDesktop() {
	VPC_FocusOut()
	FOCUS_VDesktop_left()
}
