if (A_Args.Length() < 1) {
	msg := "This script requires at least 1 parameters but it doesn't received`n"
	msg := msg . "ex) " . A_ScriptName . "<SETTING_NAME>"
	MsgBox, %msg%
    ExitApp
}

settingName := A_Args[1]

Run, ms-settings:%settingsName%
ExitApp
