#include lib_common.ahk

global _gsVpcWinTitle := "LGE_VPC - Desktop Viewer"

VPC_IsExistVpc() {
	if (COMMON_FindWinTitle(_gsVpcWinTitle)) {
		return True
	}
	return False
}

VPC_IsCurWinVpc() {
	Title := WinGetTitle("A")
	If (InStr(Title, _gsVpcWinTitle))
	{
		return True
	}
	return False
}

VPC_ActivateVpc() {
       if (VPC_IsExistVPC()) {
               WinActivate _gsVpcWinTitle
               return True
       }
       return False
}

VPC_FocusOut() {
       if (VPC_IsCurWinVpc()) {
               MsgBox , , "T0.001"
               WinMinimize _gsVpcWinTitle
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
		return False
	}
}

VPC_GetMouseOverUri() {
	local uri := ""

	if (COMMON_IsOffice() && VPC_IsCurWinVpc()) {
		tmp := A_Clipboard
		A_Clipboard := ""
		cnt := 10

		while (cnt && !A_Clipboard) {
			SendInput "{RButton}"
			sleep 50
			SendInput "e"
			sleep 50
			cnt--
		}

		if (InStr(A_Clipboard, "http") == 1) {
			uri := A_Clipboard
		}

		A_Clipboard := tmp
	}

	return uri
}

