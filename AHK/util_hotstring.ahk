FileEncoding UTF-8

if (A_Args.Length() < 1) {
	msg := "This script requires at least 1 parameters but it doesn't received`n"
	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
	MsgBox, %msg%
    ExitApp
}

file := A_Args[1]

tmp := Clipboard 
FileRead, Clipboard, %file%

WinGet, pname, ProcessName, A

Switch pname
{
Case "cmd.exe", "MobaXterm.exe", "ttermpro.exe", "WindowsTerminal.exe":
	Send, +{Insert}
Default:
	Send, ^v
}

Clipboard := tmp
ExitApp
