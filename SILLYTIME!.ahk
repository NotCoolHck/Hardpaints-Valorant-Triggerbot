#NoEnv
#SingleInstance force
#Persistent
boxSize := 3
sensitivity := 50
targetColor := 0xFEFE40
clickDelay := 150
holdKey := "SPACE"
currentMode := "lightmode"
Gui, +LastFound +AlwaysOnTop +Resize
Gui, Margin, 6, 6
Gui, Add, Text, x100 y5 vgitHubText, THIS IS A FREE PRODUCT ON GITHUB
Gui, Add, Text, x20 y30 vSelectModeText, Select Mode:
Gui, Add, GroupBox, x10 y10 w280 h130 vHardInThePaintText, HardinthePaint
Gui, Add, DropDownList, x20 y50 w100 h120 vModeChoice gChangeMode, lightmode|darkmode
Gui, Add, Button, x20 y160 w120 h30 gClickMode, Constant Clicking
Gui, Add, Button, x150 y160 w120 h30 gHoldMode, Hold Mode
Gui, Add, Button, x20 y200 w120 h30 gTurnOff, Turn Off
Gui, Add, Button, x150 y200 w120 h30 gTerminate, Exit Script
Gui, Add, Text, x20 y240 vBoxSizeText, Box Size:
Gui, Add, Edit, x150 y240 w120 vBoxSize, %boxSize%
Gui, Add, Text, x20 y270 vSensitivityText, Sensitivity:
Gui, Add, Edit, x150 y270 w120 vSensitivity, %sensitivity%
Gui, Add, Text, x20 y300 vTargetColorText, Target Color:
Gui, Add, Edit, x150 y300 w120 vTargetColor, %targetColor%
Gui, Add, Text, x20 y330 vClickDelayText, Click Delay (ms):
Gui, Add, Edit, x150 y330 w120 vClickDelay, %clickDelay%
Gui, Add, Text, x20 y360 vHoldKeyText, Hold Key:
Gui, Add, Edit, x150 y360 w120 vHoldKey, %holdKey%
Gui, Add, Button, x90 y400 w150 h30 gApplySettings, Apply Settings
Gui, Add, Text, x10 y440 w280 vStatus, Status: Not started
Gui, Add, Text,vToggleGUIText, Toggle GUI with .
Gui, Add, Button, gMinMaxButton, Minimize
Gui, +AlwaysOnTop
Gui, Show, w300 h510, AHK Script GUI
WinSet, Style, -0xC00000, AHK Script GUI
GuiControlGet, hWnd, HWND, AHK Script GUI
DragHandler(hWnd)
ChangeMode:
ControlGet, currentMode, List, ModeChoice
GuiColorChange()
return
ClickMode:
GuiControl,, Status, Status: Constant Mode
SetTimer, HoldMode, Off
SetTimer, ClickLoop, 1
return
HoldMode:
GuiControl,, Status, Status: Hold Mode
SetTimer, ClickLoop, Off
SetTimer, HoldLoop, 1
return
TurnOff:
GuiControl,, Status, Status: Turned Off
SetTimer, ClickLoop, Off
SetTimer, HoldLoop, Off
return
Terminate:
SoundBeep, 300, 200
SoundBeep, 200, 200
Sleep 400
ExitApp
ApplySettings:
Gui, Submit, NoHide
GuiColorChange()
return
ClickLoop:
PixelSearch()
if !(ErrorLevel){
if !GetKeyState("LButton"){
Click, %FoundX%, %FoundY%
Sleep, %clickDelay%
}
}
return
HoldLoop:
if GetKeyState(holdKey, "P"){
PixelSearch()
if !(ErrorLevel){
if !GetKeyState("LButton"){
Click, %FoundX%, %FoundY%
Sleep, %clickDelay%
}
}
}
return
#if toggle
*~$LButton::
Sleep 1
While GetKeyState("LButton", "P"){
Click
Sleep 1
}
return
#if
PixelSearch() {
global boxSize, sensitivity, targetColor, clickDelay
startX := A_ScreenWidth // 2 - boxSize
startY := A_ScreenHeight // 2 - boxSize
endX := A_ScreenWidth // 2 + boxSize
endY := A_ScreenHeight // 2 + boxSize
PixelSearch, FoundX, FoundY, startX, startY, endX, endY, targetColor, sensitivity, Fast RGB
if !(ErrorLevel){
if !GetKeyState("LButton"){
Click, FoundX, FoundY
Sleep clickDelay
}
}
return
}
GuiColorChange() {
global currentMode, listBoxID
GuiControlGet, listBoxID, Hwnd, ListBox1
if (listBoxID) {
GuiControl, Hide, % "hwnd" listBoxID
}
GuiControlGet, currentText, , ModeChoice
if (currentText == "lightmode") {
Gui, Color, white
Gui, Font, cBlack
GuiControl, Font, % "SelectModeText"
GuiControl, Font, % "BoxSizeText"
GuiControl, Font, % "SensitivityText"
GuiControl, Font, % "TargetColorText"
GuiControl, Font, % "ClickDelayText"
GuiControl, Font, % "HoldKeyText"
GuiControl, Font, % "Status"
GuiControl, Font, % "HardInThePaintText"
GuiControl, Font, % "ToggleGUIText"
GuiControl, Font, % "gitHubText"
}
else if (currentText == "darkmode") {
Gui, Color, black
Gui, Font, cWhite
GuiControl, Font, % "SelectModeText"
GuiControl, Font, % "BoxSizeText"
GuiControl, Font, % "SensitivityText"
GuiControl, Font, % "TargetColorText"
GuiControl, Font, % "ClickDelayText"
GuiControl, Font, % "HoldKeyText"
GuiControl, Font, % "Status"
GuiControl, Font, % "HardInThePaintText"
GuiControl, Font, % "ToggleGUIText"
GuiControl, Font, % "gitHubText"
}
Gui, Submit, NoHide
GuiControl, +BackgroundTrans, ModeChoice
Gui, Submit, NoHide
GuiControl, Choose, ModeChoice, % currentMode
GuiControl, Show, ModeChoice
GuiControl, , Status
Gui +LastFound
return
}
.::
if (GuiVisible := !GuiVisible)
Gui, % (GuiVisible) ? "Show" : "Hide"
return
MinMaxButton:
WinMinimize, AHK Script GUI
return
DragHandler(hWnd) {
MouseGetPos, GuiX, GuiY
WinGetPos, WinX, WinY, WinW, WinH, % "ahk_id " hWnd
xOffset := GuiX - WinX
yOffset := GuiY - WinY
Loop {
MouseGetPos, CurrX, CurrY
if (GetKeyState("LButton") = 0) {
Break
}
WinMove, % "ahk_id " hWnd, , CurrX - xOffset, CurrY - yOffset
}
}
