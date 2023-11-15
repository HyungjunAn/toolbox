FileEncoding "UTF-8"

if (A_Args.Length < 1) {
	msg := "This script requires at least 1 parameters but it doesn't received`n"
	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
	MsgBox msg
    ExitApp
}

f := A_Args[1]
tmp := A_Clipboard 
A_Clipboard := FileRead(f)

pname := WinGetProcessName("A")

Switch pname
{
Case "cmd.exe", "MobaXterm.exe", "ttermpro.exe", "WindowsTerminal.exe":
	Send "+{Insert}"
Default:
	Send "^v"
}

A_Clipboard := tmp
ExitApp
