#include lib_vpc.ahk

global bVirtualDesktopLeft := True

VDesktop_toggle() {
	if (bVirtualDesktopLeft) {
		SendInput, ^#{right}
	} else {
		SendInput, ^#{left}
	}
	bVirtualDesktopLeft := !bVirtualDesktopLeft
}

VDesktop_left() {
	if (bVirtualDesktopLeft == False) {
		SendInput, ^#{left}
		bVirtualDesktopLeft := True
	}
}

focusOnMain() {
	VPC_FocusOut()
	VDesktop_left()
}

