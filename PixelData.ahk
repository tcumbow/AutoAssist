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
                if (GetKeyState("9"))
                    Send {9 up}
                if (GetKeyState("6")) ; 6 is bound to attack, so many of these cases are set to release the 6 key since it might be held down for a heavy attack
                    Send {6 up}
            Case "0x000001": ;Ability 1
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 1
                    LastActionTime := A_TickCount
                }
            Case "0x000002": ;Ability 2
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 2
                    LastActionTime := A_TickCount
                }
            Case "0x000003": ;Ability 3
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 3
                    LastActionTime := A_TickCount
                }
            Case "0x000004": ;Ability 4
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 4
                    LastActionTime := A_TickCount
                }
            Case "0x000005": ;Ability 5
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 5
                    LastActionTime := A_TickCount
                }
            Case "0x000006": ;DoHeavyAttack
                if (GetKeyState("9"))
                    Send {9 up}
                Send {6 down}
            Case "0x000007": ;DoRollDodge
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 7
                    LastActionTime := A_TickCount
                }
            Case "0x000008": ;DoBreakFreeInterrupt
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 8
                    LastActionTime := A_TickCount
                }
            Case "0x000009": ;DoBlock
                if (GetKeyState("6"))
                    Send {6 up}
                if (not GetKeyState("9")) {
                    Send {9 down}
                    Sleep 1500
                    Send {9 up}
                }
            Case "0x00000a": ;ReelInFish
                if (GetKeyState("6"))
                    Send {6 up}
                Send e
                Sleep 2000
                Send e
                Sleep 2000
            Case "0x00000b": ;LightAttack
                if (GetKeyState("9"))
                    Send {9 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send 6
                    LastActionTime := A_TickCount
                }
            Case "0x00000c": ;DoInteract
                if (GetKeyState("9"))
                    Send {9 up}
                if (GetKeyState("6"))
                    Send {6 up}
                Send e
            Case "0x00000d": ;DoSprint
                if (GetKeyState("9"))
                    Send {9 up}
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send g
                    LastActionTime := A_TickCount
                }
            Case "0x00000e": ;DoMountSprint
                if (GetKeyState("9"))
                    Send {9 up}
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 2000) <= A_TickCount )) {
                    Send g
                    LastActionTime := A_TickCount
                }
            Case "0x00000f": ;DoCrouch
                if (GetKeyState("9"))
                    Send {9 up}
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 2000) <= A_TickCount )) {
                    Send {Ctrl}
                    LastActionTime := A_TickCount
                }
            Case "0x000010": ;DoFrontBar
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send y
                    LastActionTime := A_TickCount
                }
            Case "0x000011": ;DoBackBar
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 200) <= A_TickCount )) {
                    Send u
                    LastActionTime := A_TickCount
                }
            Case "0x000012": ;DoLongBlock
                if (GetKeyState("6"))
                    Send {6 up}
                if (LastPixelColor != PixelColor Or ((LastActionTime + 500) <= A_TickCount )) {
                    if (not GetKeyState("9"))
                            Send {9 down}
                    LastActionTime := A_TickCount
                }
            Default: ;Same as DoNothing
                if (GetKeyState("9"))
                    Send {9 up}
                if (GetKeyState("6"))
                    Send {6 up}
                
        }
        LastPixelColor := PixelColor
    }   
}
