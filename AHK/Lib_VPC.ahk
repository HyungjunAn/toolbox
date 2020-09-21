global _gsVpcWinTitle := "LGE_VPC - Desktop Viewer"
global _gsVpcTxt := USERPROFILE . "/desktop/vpcTxt"

VPC_IsExistVpc() {
	if (findWindow(_gsVpcWinTitle, False)) {
		return True
	}
	return False
}

VPC_ActivateVpc()
{
	WinActivate, %_gsVpcWinTitle%
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

VPC_FocusOut()
{
	runOrActivateWin("vpcTxt", false, "notepad " . _gsVpcTxt)
}

VPC_SwitchWinIfExist()
{
	IfExist, %_gsVpcTxt%, {
		if (VPC_IsCurrWinVpc()) {
			VPC_FocusOut()
			Send, ^#{left}
		} else {
			Send, ^#{right}
			sleep, 100
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
