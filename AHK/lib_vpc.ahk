#include lib_common.ahk

global _gsVpcWinTitle := "LGE_VPC - Desktop Viewer"

VPC_IsExistVpc() {
	if (COMMON_FindWinTitle(_gsVpcWinTitle)) {
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
	if (VPC_IsExistVPC()) {
		Gui, VPC:Destroy
		WinActivate, %_gsVpcWinTitle%
		VPC_Notify("Red")
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
		tmp := Clipboard
		Clipboard := ""
		cnt := 10

		while (cnt || !Clipboard) {
			SendInput, {RButton}
			sleep, 50
			SendInput, e
			cnt--
		}

		if (InStr(Clipboard, "http") == 1) {
			uri := Clipboard
		}

		Clipboard := tmp
	}

	return uri
}

