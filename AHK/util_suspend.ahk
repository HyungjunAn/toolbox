if (A_Args.Length() < 1) {
	msg := "This script requires at least 1 parameters but it doesn't received`n"
	msg := msg . "ex) " . A_ScriptName . "<FILE_NAME>"
	MsgBox, %msg%
    ExitApp
}

if (A_Args[1] == "suspend") {
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
} else {
	DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
}
