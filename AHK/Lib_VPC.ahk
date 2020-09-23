global _gsVpcWinTitle := "LGE_VPC - Desktop Viewer"
global _gsVpcTxt := USERPROFILE . "/desktop/vpcTxt"
global _gsVpcTxtWin := "vpcTxt - Windows ¸Þ¸ðÀå"

VPC_IsExistVpc() {
	if (findWindow(_gsVpcWinTitle, False)) {
		return True
	}
	return False
}

VPC_ActivateVpc()
{
	WinActivate, %_gsVpcWinTitle%
	VPC_Notify("Red", "VPC Activate")
}

VPC_ActivateVpcIfExist()
{
	if (VPC_IsExistVPC()) {
		VPC_ActivateVpc()
		return True
	}
	return False
}

VPC_IsCurrWinVpc()
{
	WinGetTitle, Title, A
	IfInString, Title, %_gsVpcWinTitle%
	{
		return True
	}
	return False
}

VPC_ToggleMode()
{
	IfExist, %_gsVpcTxt%, {
		backC := "Green"
		TEXT := "VPC Mode Off"
		FileDelete, %_gsVpcTxt%
	} else {
		backC := "Red"
		TEXT := "VPC Mode On"
		FileAppend, vpc txt file.`n, %_gsVpcTxt%
	}

	Gui, Color, %backC%
	Gui, -Caption +alwaysontop +ToolWindow
    Gui, Font, s15 cWhite, Consolas
    Gui, Add, Text, , %TEXT%
	Gui, Show, h40 NoActivate,

	Sleep, 500
	Gui, Destroy
}

VPC_Notify(backC, text)
{
	Gui, Destroy
	Gui, Color, %backC%
	Gui, -Caption +alwaysontop +ToolWindow
    Gui, Font, s15 cWhite, Consolas
    Gui, Add, Text, , %text%
	Gui, Show, y0 h40 NoActivate,
}

VPC_FocusOut()
{
	;WinActivate, %_gsVpcTxtWin%
	;runOrActivateWin("vpcTxt", false, "notepad " . _gsVpcTxt)
	VPC_Notify("Green", "VPC Deactivate")
	WinMinimize, %_gsVpcWinTitle%
}

VPC_SwitchWinIfExist()
{
	if (VPC_IsExistVpc()) {
		if (VPC_IsCurrWinVpc()) {
			VPC_FocusOut()
		} else {
			VPC_ActivateVpc()
		}
		return True
	}
	return False
}

VPC_ChangeMode2VPC() {
	ret := False
	if (VPC_IsExistVpc()) {
		Suspend, On
		WinGetTitle, Title, A
		IfNotInString, Title, %_gsVpcWinTitle%, {
			IfNotInString, Title, TypeAndRun, {
				if (Title != recentlyWinTitle1) {
					recentlyWinTitle2 := recentlyWinTitle1
					recentlyWinTitle1 := Title
				}
			}
		}
		WinActivate, %_gsVpcWinTitle%
		ret := True
	}
	return ret
}

VPC_Send(vpcCmd, noneVpcCmd) {
	if VPC_IsCurrWinVpc()
	{
		Send, %vpcCmd%
	}
	else
	{
		Send, %noneVpcCmd%
	}
	return 
}
