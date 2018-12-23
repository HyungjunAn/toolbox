;####################################
; Alarm
;####################################

alarm(sleepTime) {
    h := 40
    y := A_screenHeight // 2 - h // 2
    Gui, Color, Red
    Gui, -Caption +alwaysontop +ToolWindow
    Gui, Font, s15 cWhite, Consolas
    Gui, Add, Text, , !! BREAK !!
    Gui, Show, y%y% NoActivate,
    Sleep, %sleepTime%
    Gui, Destroy
}

m_interval := 30
repeat_n := 5

while True {
    FormatTime, s, , s
    FormatTime, m, , m
    if !Mod(m, m_interval) {
        Loop %repeat_n% {
            alarm(400)
            Sleep, 200
        }
        Sleep % 60000 * (m_interval - 3)
    }
    else
        Sleep % (60 - s) * 1000
}
