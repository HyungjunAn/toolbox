;####################################
; Alarm
;####################################

alarm(sleepTime) {
    h := 40
    ;y := A_screenHeight // 2 - h // 2
    ;Gui, Color, Black
    Gui, Color, Red
    Gui, -Caption +alwaysontop +ToolWindow
    Gui, Font, s15 cRed, Consolas
    ;Gui, Font, s15 cWhite, Consolas
    ;Gui, Font, s15 cWhite, Consolas
    Gui, Add, Text, Center, BREAK
    y := A_screenHeight - 40
    Gui, Show, y%y% w100 NoActivate,
    Sleep, %sleepTime%
    Gui, Destroy
}

m_interval 		:= 10
alarm_time 		:= 400
alarm_interval 	:= 200
repeat_n 		:= 10

while True {
    FormatTime, s, , s
    FormatTime, m, , m
    if !Mod(m, m_interval) {
        Loop %repeat_n% {
            alarm(alarm_time)
            Sleep, %alarm_interval%
        }
        Sleep % 60000 * m_interval - ((alarm_time + alarm_interval) * repeat_n + 200)
    }
    else {
        Sleep % (60 - s) * 1000
	}
}
