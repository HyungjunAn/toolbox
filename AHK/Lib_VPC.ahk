global _gsVpcWinTitle := "LGE_VPC - Desktop Viewer"

VPC_IsExistVpc() {
	if (findWindow(_gsVpcWinTitle, True)) {
		return True
	}
	return False
}

VPC_ActivateVpc()
{
	ret := VPC_IsExistVPC()
	if ret
	{
		WinActivate, %_gsVpcWinTitle%
	}
	return ret
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

VPC_ChangeMode2VPC() {
	ret := False
	if (VPC_IsExistVpc()) {
		Suspend, On
		suspend_context()
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

