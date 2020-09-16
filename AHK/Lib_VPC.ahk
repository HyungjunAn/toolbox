global _gsVpcWinTitle := "LGE_VPC - Desktop Viewer"

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

;VPC_SwitchWinIfExist()
;{
;	if (!VPC_IsExistVPC()) {
;		return False
;	}
;
;	if (VPC_IsCurrWinVpc()) {
;		runOrActivateWin("vpc.txt", false, "gvim ~\Desktop\vpc.txt")
;		Send, ^#{Left}
;	} else {
;		Send, ^#{Right}
;		VPC_ActivateVpc()
;	}
;	
;	return True
;}

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
