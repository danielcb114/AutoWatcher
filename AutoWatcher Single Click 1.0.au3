#include <MsgBoxConstants.au3>
#include <IE.au3>

Global $g_bPaused = False

HotKeySet("{PAUSE}", "HotKeyPressed")
HotKeySet("{ESC}", "HotKeyPressed")

;Constants
;The title of the window that gets focused onto. Must be typed exactly Recommend copying from the window Tool
$WindowTitle = "Program Workshop - Google Chrome"
;This defines the x coordinate of the "approve all" button on the screen
Global $XCord = 1874
;This defines the y coordinate of the "approve all" button on the screen
Global $YCord = 299
;This defines how long the program will wait for quick, simple operations (milliseconds)
Global $MinorWait = 600
;This defines how long the program will wait for longer, but still quick operations (milliseconds)
Global $MajorWait = 800
;This defines how long the program will wait for a page to load after opening it(before clicking)(milliseconds)
Global $Wait = 2000

;Program Start
Global $NumLinks = InputBox("","How many links would you like the program to watch? (needs to be exact)")

Global $Links[$NumLinks]


MsgBox(0,"Setup Instructions","Navigate to the 'test delivery' section of the website and open the tabs that you would like to watch by control clicking. Make sure you're using Google Chrome and remain on the test delivery tab(the first tab). When you are ready, press 'OK'. Press ESC to exit")

;This brings the window into focus; if this isn't here, the user will have to click the window to get it to focus before the program begins collecting links
WinActivate($WindowTitle)
;move to the first tab
Send("^{TAB}")

For $i = 0 To $NumLinks - 1
   Sleep($MajorWait)
   ;select the title bar with alt D
   Send("!d")
   Sleep($MinorWait)
   ;copy the title bar
   Send("^c")
   ;get it from the clipboard
   $Links[$i] = ClipGet()
   ;Close the window
   Sleep($MinorWait)
   Send("^w")
   Sleep($MajorWait)
Next

;initialize the counter variable for the while loop
Global $Inc = 0

While 1
   If $Inc = $NumLinks Then
	  $Inc = 0
   EndIf
	;open a new tab
	Send("^t")
	Sleep($MinorWait)
	;select the address bar
	Sleep($MinorWait)
	Send("!d")
	;send the relevant link, wait for it to load
	ClipPut($Links[$Inc])
	Sleep($Wait)
	$Inc = $Inc + 1
	Send("^v")
	Sleep($MajorWait)
	Send("{ENTER}")
	Sleep($Wait)
	MouseClick("primary", $XCord, $YCord)
	Sleep($Wait / 2)
	Send("^w")
	Sleep($MinorWait)
WEnd

Func HotKeyPressed()
    Switch @HotKeyPressed ; The last hotkey pressed.
        Case "{PAUSE}" ; String is the {PAUSE} hotkey.
            $g_bPaused = Not $g_bPaused
            While $g_bPaused
                Sleep(100)
                ToolTip('Script is "Paused"', 0, 0)
            WEnd
            ToolTip("")

        Case "{ESC}" ; String is the {ESC} hotkey.
            Exit

        Case "+!d" ; String is the Shift-Alt-d hotkey.
            MsgBox($MB_SYSTEMMODAL, "", "This is a message.")

    EndSwitch
EndFunc   ;==>HotKeyPressed
