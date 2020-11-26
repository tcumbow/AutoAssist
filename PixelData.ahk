CoordMode, Pixel, Screen
global LastPixelAction := "dummy"
global LastActionTime := 0

Loop{
    WinWaitActive Elder Scrolls Online
    PixelGetColor, PixelColor, 0, 0, RGB
    PixelRed := SubStr(PixelColor,3,2)
    PixelModifier := SubStr(PixelColor,5,2)
    PixelAction := SubStr(PixelColor,7,2)
    if (not (GetKeyState("F10"))) ; I have F10 bound to several key buttons on my controller. It acts as a kill switch so that, for example, while I'm holding down the Start button to resurect someone, AHK doesn't interfere
    {
        ; if (PixelModifier == "00") {} ;ModPlain
        if (PixelModifier == "01") ;ModHeavyAttack
        {
            if (not GetKeyState("6"))
                Send {6 down}
        }
        else
        {
            if (GetKeyState("6"))
                Send {6 up}
        }
        
        if (PixelModifier == "02") ;ModBlock
        {
            if (not GetKeyState("9"))
                Send {9 down}
        }
        else
        {
            if (GetKeyState("9"))
                Send {9 up}
        }
    
        Switch PixelAction
        {
            Case "00": ;DoNothing

            Case "01": ;Ability 1
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 1
                    LastActionTime := A_TickCount
                }
            Case "02": ;Ability 2
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 2
                    LastActionTime := A_TickCount
                }
            Case "03": ;Ability 3
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 3
                    LastActionTime := A_TickCount
                }
            Case "04": ;Ability 4
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 4
                    LastActionTime := A_TickCount
                }
            Case "05": ;Ability 5
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 5
                    LastActionTime := A_TickCount
                }
            ; Case "06": ;DoHeavyAttack
            ;     Send {6 down}
            Case "07": ;DoRollDodge
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 7
                    LastActionTime := A_TickCount
                }
            Case "08": ;DoBreakFreeInterrupt
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 8
                    LastActionTime := A_TickCount
                }
            ; Case "09": ;DoBlock
            ;     if (GetKeyState("6"))
            ;         Send {6 up}
            ;     Send {9 down}
            ;     Sleep 1500
            ;     Send {9 up}
            Case "0a": ;ReelInFish
                if (GetKeyState("6"))
                    Send {6 up}
                Send e
                Sleep 2000
                Send e
                Sleep 2000
            Case "0b": ;LightAttack
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 6
                    LastActionTime := A_TickCount
                }
            Case "0c": ;DoInteract
                if (GetKeyState("6"))
                    Send {6 up}
                Send e
            Case "0d": ;DoSprint
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send g
                    LastActionTime := A_TickCount
                }
            Case "0e": ;DoMountSprint
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 2000) <= A_TickCount )) {
                    Send g
                    LastActionTime := A_TickCount
                }
            Case "0f": ;DoCrouch
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 2000) <= A_TickCount )) {
                    Send {Ctrl}
                    LastActionTime := A_TickCount
                }
            Case "10": ;DoFrontBar
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send y
                    LastActionTime := A_TickCount
                }
            Case "11": ;DoBackBar
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelAction != PixelAction Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send u
                    LastActionTime := A_TickCount
                }
            Default: ;Same as DoNothing
                if (GetKeyState("6"))
                    Send {6 up}
                
        }
        LastPixelAction := PixelAction
    }   
}
