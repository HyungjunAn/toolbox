#include lib_vpc.ahk

global bVirtualDesktopMain := True

FOCUS_VDesktop_toggle() {
	if (bVirtualDesktopMain) {
		FOCUS_VDesktop_Sub()
	} else {
		FOCUS_VDesktop_Main()
	}
	bVirtualDesktopMain := !bVirtualDesktopMain
}

FOCUS_VDesktop_Main() {
	SendInput "^#{left}"
	bVirtualDesktopMain := True
}

FOCUS_VDesktop_Sub() {
	;to prevent confused key input
	Sleep 100

	SendInput "^#{right}"
	bVirtualDesktopMain := False
}

FOCUS_MainDesktop() {
	VPC_FocusOut()
	FOCUS_VDesktop_Main()
}
