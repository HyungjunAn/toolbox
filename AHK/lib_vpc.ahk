#include lib_common.ahk

global _gsVpcWinTitle := "LGE_VPC - Desktop Viewer"

VPC_IsExistVpc() {
	if (COMMON_FindWinTitle(_gsVpcWinTitle, False)) {
		return True
	}
	return False
}

VPC_IsCurWinVpc() {
	WinGetTitle, Title, A
	IfInString, Title, %_gsVpcWinTitle%
	{
		return True
	}
	return False
}

VPC_ActivateVpc() {
	Gui, VPC:Destroy
	WinActivate, %_gsVpcWinTitle%
	VPC_Notify("Red")
}

VPC_ActivateVpcIfExist() {
	if (VPC_IsExistVPC()) {
		VPC_ActivateVpc()
		return True
	}
	return False
}

VPC_Notify(backC) {
	Gui, VPC:Color, %backC%
	Gui, VPC:-Caption +alwaysontop +ToolWindow
	H := 40
	Y := A_ScreenHeight - H
	Gui, VPC:Show, w200 y%Y% h%H% NoActivate, GUI_VPC_NOTIFIY
}

VPC_FocusOut() {
	if (VPC_IsCurWinVpc()) {
		MsgBox, , , , 0.001
		WinMinimize, %_gsVpcWinTitle%
		VPC_Notify("39E114")
	}
}

VPC_Switch() {
	if (VPC_IsExistVpc()) {
		if (VPC_IsCurWinVpc()) {
			VPC_FocusOut()
		} else {
			VPC_ActivateVpc()
		}
		return True
	} else {
		Gui, VPC:Destroy
		return False
	}
}

VPC_GetMouseOverUri() {
	local uri := ""

	if (VPC_IsCurWinVpc()) {
		SendInput, {RButton}
		tmp := Clipboard
		Clipboard := ""
		sleep, 50
		SendInput, e
		sleep, 50

		if (InStr(Clipboard, "http") == 1) {
			uri := Clipboard
		}

		Clipboard := tmp
	}

	return uri
}

