FileEncoding "UTF-8"

if (A_Args.Length < 1) {
	msg := "This script requires at least 1 parameters but it doesn't received`n"
	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
	MsgBox msg
    ExitApp
}

tmp := A_Clipboard 
A_Clipboard := FileRead(A_Args[1])
pname := WinGetProcessName("A")

Switch pname
{
Case "ttermpro.exe":
	Send "!v"
Case "cmd.exe", "MobaXterm.exe", "WindowsTerminal.exe":
	Send "+{Ins}"
Default:
	Send "^v"
}

; sleep to prevent overwriting by assign
Sleep 100
A_Clipboard := tmp
ExitApp
