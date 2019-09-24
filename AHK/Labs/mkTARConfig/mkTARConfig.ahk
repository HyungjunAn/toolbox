SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if A_Args.Length() < 2
{
	msg := "This script requires at least 2 parameters but it only received " . A_Args.Length() . "`n"
	msg := msg . "ex) " . A_ScriptName . "<SRC_FILE> <TARGET_FILE>"
	MsgBox, %msg%
    ExitApp
}

global gsSrcFileName := %1%
global gsTargetFileName := %2%

global buffer := []

global TARCmd := ""
global TARExe := ""
global TAROpt := ""

Loop
{
    FileReadLine, line, %gsSrcFileName%, %A_Index%
    if ErrorLevel
        break

	if (!line)
		continue

	n := getTwoString(line, s1, s2)

	if (n == 1)
	{
		TARExe := s1
	}
	else if (n == 2)
	{
		TARCmd := s1
		TAROpt := s2

		cmd := TARCmd . "|" . TARExe . "|" . TAROpt
		buffer.push(cmd)
	}
	else
	{
		MsgBox, Grammar Error: Line %A_Index%
		return
	}
}

FileDelete, %gsTargetFileName%

Loop % buffer.Length()
{
	line := buffer[A_Index]
	FileAppend, %line%`n, %gsTargetFileName%
}

getTwoString(string, ByRef str1, ByRef str2) {
	local bIsFirstStr := True
	local tmpStr := ""
	local ret := 0

	arrString := StrSplit(string, A_Tab)

	Loop % arrString.Length()
	{
		tmpStr := arrString[A_Index]
		if (!tmpStr)
		{
			continue
		}

		if (bIsFirstStr)
		{
			str1 := tmpStr
			bIsFirstStr := False
		}
		else 
		{
			str2 := tmpStr
		}
		ret++
	}
	return ret
}
