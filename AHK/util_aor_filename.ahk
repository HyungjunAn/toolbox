#include lib_run.ahk

if (A_Args.Length < 1) {
	msg := "This script requires at least 1 parameters but it doesn't received`n"
	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
	MsgBox msg
    ExitApp
}

fileName := ""
SplitPath(A_Args[1], &fileName)
RUN_AOR_SubWinTitle(fileName, A_Args[1])

ExitApp
