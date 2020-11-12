CoordMode, Pixel, Screen
SetKeyDelay, 200

Loop{
    WinWaitActive Elder Scrolls Online
    Sleep 10
    PixelGetColor, PixelColor, 0, 0, RGB
    if (GetKeyState("F10"))
        Sleep 10
    else if (GetKeyState("F9"))
    {
        if (GetKeyState("6"))
            Send {6 up}
        Send 3
    }
    else
    {
        Switch PixelColor
        {
            Case "0x000000":
                if (GetKeyState("6"))
                    Send {6 up}
            Case "0x000001":
                if (GetKeyState("6"))
                    Send {6 up}
                Send 1
            Case "0x000002":
                if (GetKeyState("6"))
                    Send {6 up}
                Send 2
            Case "0x000003":
                if (GetKeyState("6"))
                    Send {6 up}
                Send 3
            Case "0x000004":
                if (GetKeyState("6"))
                    Send {6 up}
                Send 4
            Case "0x000005":
                if (GetKeyState("6"))
                    Send {6 up}
                Send 5
            Case "0x000006":
                Send {6 down}
            Case "0x000007":
                if (GetKeyState("6"))
                    Send {6 up}
                Send 7
                Sleep 500
            Case "0x000008":
                if (GetKeyState("6"))
                    Send {6 up}
                Send 8
            Case "0x000009":
                if (GetKeyState("6"))
                    Send {6 up}
                Send {9 down}
                Sleep 1500
                Send {9 up}
            Case "0x00000a":
                if (GetKeyState("6"))
                    Send {6 up}
                Send e
                Sleep 2000
                Send e
                Sleep 2000
            Default:
                if (GetKeyState("6"))
                    Send {6 up}
                
        } 
    }   
}
