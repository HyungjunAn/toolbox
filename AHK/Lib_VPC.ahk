global _gsVpcWinTitle := "LGE_VPC - Desktop Viewer"
global _gsVpcMutex := False

VPC_IsExistVpc() {
	if (findWindow(_gsVpcWinTitle, False)) {
		return True
	}
	return False
}

VPC_ActivateVpc() {
	while (_gsVpcMutex) {
	}
	_gsVpcMutex := True
	Gui, VPC:Destroy
	WinActivate, %_gsVpcWinTitle%
	VPC_Notify("Red")
	_gsVpcMutex := False
}

VPC_ActivateVpcIfExist() {
	if (VPC_IsExistVPC()) {
		VPC_ActivateVpc()
		return True
	}
	return False
}

VPC_IsCurrWinVpc() {
	WinGetTitle, Title, A
	IfInString, Title, %_gsVpcWinTitle%
	{
		return True
	}
	return False
}

VPC_Notify(backC) {
	Gui, VPC:Color, %backC%
	Gui, VPC:-Caption +alwaysontop +ToolWindow
	H := 40
	Y := A_ScreenHeight - H
	Gui, VPC:Show, w400 y%Y% h%H% NoActivate, GUI_VPC_NOTIFIY
}

VPC_FocusOut() {
	while (_gsVpcMutex) {
	}
	_gsVpcMutex := True
	if (VPC_IsCurrWinVpc()) {
		WinMinimize, %_gsVpcWinTitle%
		VPC_Notify("Green")
	}
	_gsVpcMutex := False
}

VPC_SwitchWinIfExist() {
	if (VPC_IsExistVpc()) {
		if (VPC_IsCurrWinVpc()) {
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
