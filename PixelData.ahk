CoordMode, Pixel, Screen
global LastPixelColor := "dummy"
global LastActionTime := 0

Loop{
    WinWaitActive Elder Scrolls Online
    PixelGetColor, PixelColor, 0, 0, RGB
    if (not (GetKeyState("F10"))) ; I have F10 bound to several key buttons on my controller. It acts as a kill switch so that, for example, while I'm holding down the Start button to resurect someone, AHK doesn't interfere
    {
        Switch PixelColor
        {
            Case "0x000000": ;DoNothing
                if (GetKeyState("6")) ; 6 is bound to attack, so many of these cases are set to release the 6 key since it might be held down for a heavy attack
                    Send {6 up}
            Case "0x000001": ;Ability 1
                if (GetKeyState("6"))
                    Send {6 up}
                Send 1
            Case "0x000002": ;Ability 2
                if (GetKeyState("6"))
                    Send {6 up}
                Send 2
            Case "0x000003": ;Ability 3
                if (GetKeyState("6"))
                    Send {6 up}
                Send 3
            Case "0x000004": ;Ability 4
                if (GetKeyState("6"))
                    Send {6 up}
                Send 4
            Case "0x000005": ;Ability 5
                if (GetKeyState("6"))
                    Send {6 up}
                Send 5
            Case "0x000006": ;DoHeavyAttack
                Send {6 down}
            Case "0x000007": ;DoRollDodge
                if (GetKeyState("6"))
                    Send {6 up}
                Send 7
            Case "0x000008": ;DoBreakFreeInterrupt
                if (GetKeyState("6"))
                    Send {6 up}
                Send 8
            Case "0x000009": ;DoBlock
                if (GetKeyState("6"))
                    Send {6 up}
                Send {9 down}
                Sleep 1500
                Send {9 up}
            Case "0x00000a": ;ReelInFish
                if (GetKeyState("6"))
                    Send {6 up}
                Send e
                Sleep 2000
                Send e
                Sleep 2000
            Case "0x00000b": ;LightAttack
                Send 6
            Case "0x00000c": ;DoInteract
                if (GetKeyState("6"))
                    Send {6 up}
                Send e
            Case "0x00000d": ;DoSprint
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send g
                    LastActionTime := A_TickCount
                }
            Case "0x00000e": ;DoMountSprint
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 2000) <= A_TickCount )) {
                    Send g
                    LastActionTime := A_TickCount
                }
            Default: ;Same as DoNothing
                if (GetKeyState("6"))
                    Send {6 up}
                
        }
        LastPixelColor := PixelColor
    }   
}
