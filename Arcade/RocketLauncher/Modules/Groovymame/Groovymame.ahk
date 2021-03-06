MEmu = Groovymame
MEmuV =  v0.151
MURL = http://www.mame.net/
MAuthor = Stick
MVersion = 2.0.6
MCRC = 
iCRC = 
MID = 
MSystem = "Shmup"
;----------------------------------------------------------------------------
; Notes:
; No need to edit mame.ini and set your rom folder, module sends the rompath for you.
; Command Line Options - http://easyemu.mameworld.info/mameguide/mameguide-options.html
; High Scores DO NOT SAVE when cheats are enabled!
; HLSL Documentation: http://mamedev.org/source/docs/hlsl.txt.html
; MAME 149 is currently bugged and HyperPause support is broken. Emu does not let you alt-tab out. This is a mamedev issue, not an HL one.
; If you use MAME for AAE, create a vector.ini in mame's ini subfolder and paste these HLSL settings in there: http://www.mameworld.info/ubbthreads/showflat.php?Cat=&Number=309968&page=&view=&sb=5&o=&vc=1
;----------------------------------------------------------------------------
StartModule()
FadeInStart()

settingsFile := CheckFile(modulePath . "\" . moduleName . ".ini")

Fullscreen := IniReadCheck(settingsFile, "Settings", "Fullscreen","true",,1)
Videomode := IniReadCheck(settingsFile, "Settings", "Videomode","ddraw",,1)
hideConsole := IniReadCheck(settingsFile, "Settings", "HideConsole","true",,1)	; Hides console window from view if it shows up
pauseMethod := IniReadCheck(settingsFile, "Settings", "PauseMethod",1,,1)	; set the pause method that works better on your machine (preferred methods 1 and 2) 1 = Win7 and Win8 OK - Problems with Win XP, 2 = preferred method for WinXP - Problems in Win7, 3 and 4 = same as 1 and 2, 5 = only use If you have a direct input version of mame, 6 = suspend mame process method, it could crash mame in some computers
bezelMode := IniReadCheck(settingsFile, "Settings", "BezelMode","layout",,1)	; "layout" or "normal"
cheatMode := IniReadCheck(settingsFile, "Settings", "CheatMode","false",,1)
cheatModeKey := IniReadCheck(settingsFile, "Settings", "CheatModeKey",A_Space,,1)	; user defined key to be held down before launching a mame rom.
sysParams := IniReadCheck(settingsFile, systemName, "Params", A_Space,,1)
romParams := IniReadCheck(settingsFile, romName, "Params", A_Space,,1)
mameRomName := IniReadCheck(settingsFile, romName, "MameRomName", A_Space,,1)
Use_Bezels := IniReadCheck(settingsFile, "Settings", "Use_Bezels", "true",,1)
Use_Bezels := IniReadCheck(settingsFile, romName, "Use_Bezels", Use_Bezels,,1)	; default is the system's current setting
Use_Overlays := IniReadCheck(settingsFile, "Settings", "Use_Overlays", "true",,1)
Use_Overlays := IniReadCheck(settingsFile, romName, "Use_Overlays", Use_Overlays,,1)	; default is the system's current setting
Use_Backdrops := IniReadCheck(settingsFile, "Settings", "Use_Backdrops", "true",,1)
Use_Backdrops := IniReadCheck(settingsFile, romName, "Use_Backdrops", Use_Backdrops,,1)	; default is the system's current setting

If bezelEnabled = true
{	ListXMLtable := []
	ListXMLtable := ListXMLInfo(romName)
	If bezelMode = layout
	{	
		useBezels := If (Use_Bezels = "true") ? "-use_bezels" : "-nouse_bezels"
		useOverlays := If (Use_Overlays = "true") ? "-use_overlays" : "-nouse_overlays"
		useBackdrops := If (Use_Backdrops = "true") ? "-use_backdrops" : "-nouse_backdrops"
		BezelStart(romName,ListXMLtable[1],ListXMLtable[2],ListXMLtable[3],ListXMLtable[4])
	} Else {
		useBezels := "-nouse_bezels"
		useOverlays := "-nouse_overlays"
		useBackdrops := "-nouse_backdrops"
		BezelStart(,,ListXMLtable[2])
	}
	
}

; -romload part of 147u2 that shows what roms were checked when missing roms
winstate := If (Fullscreen = "true") ? "Hide UseErrorLevel" : "UseErrorLevel"
fullscreen := If (Fullscreen = "true") ? "-nowindow" : "-window"
videomode := If (Videomode != "" ) ? "-video " . videomode : ""
sysParams := If sysParams != ""  ? sysParams : ""
romParams := If romParams != ""  ? romParams : ""

StringReplace,mameRomPaths,romPathFromIni,|,`"`;`",1	; replace all instances of | to ; in the Rom_Path from Emulators.ini so mame knows where to find your roms
mameRomPaths := "-rompath """ .  (If mameRomName ? romPath : mameRomPaths) . """"	; if using an alt rom, only supply mame with the path to that rom so it doesn't try to use the original rom

If InStr(romParams,"-rompath")
	ScriptError("""-rompath"" is defined as a parameter for " . romName . ". The MAME module fills this automatically so please remove this from Params in the module's settings.")
If InStr(sysParams,"-rompath")
	ScriptError("""-rompath"" is defined as a parameter for " . systemName . ". The MAME module fills this automatically so please remove this from Params in the module's settings.")

If mameRomName {
	FileMove, %romPath%\%romName%%romExtension%, %romPath%\%mameRomName%%romExtension%	; rename rom to match what mame needs
	originalRomName := romName	; store romName from database so we know what to rename it back to later
	romName := mameRomName
	If ErrorLevel
		ScriptError("There was a problem renaming " . romName . "  to " . mameRomName . " in " . romPath . ". Please check you have write permission to this folder/file and you don't already have a file named """ . mameRomName . """ in your rom folder.",8)
	Else	; if rename was successful, set var so we know to move it back later
		fileRenamed = 1
}

If cheatMode = true
{	If cheatModeKey	; if user wants to use a key to enable CheatMode
		cheatEnabled := If XHotkeyAllKeysPressed(cheatModeKey) ? "-cheat" : ""
	Else	; no cheat mode key defined
		cheatEnabled := "-cheat"
}

If hideConsole = true
	SetTimer, HideConsole, 10

Run(executable . A_Space . romName . A_Space . fullscreen . A_Space . cheatEnabled . A_Space . videomode . A_Space . useBezels . A_Space . useOverlays . A_Space . useBackdrops . A_Space . mameRomPaths . A_Space . sysParams . A_Space . romParams, emuPath, winstate)

If(ErrorLevel != 0){
	If (ErrorLevel = 1)
		Error = Failed Validity
	Else If(ErrorLevel = 2)
		Error = Missing Files
	Else If(ErrorLevel = 3)
		Error = Fatal Error
	Else If(ErrorLevel = 4)
		Error = Device Error
	Else If(ErrorLevel = 5)
		Error = Game Does Not Exist
	Else If(ErrorLevel = 6)
		Error = Invalid Config
	Else If ErrorLevel in 7,8,9
		Error = Identification Error
	Else
		Error = MAME Error
	ScriptError("MAME Error - " . Error)
}

WinWait("ahk_class MAME")
WinWaitActive("ahk_class MAME")

BezelDraw()
FadeInExit()
Process("WaitClose", executable)
BezelExit()

If fileRenamed {	; rename file back to alternate name for next launch
	FileMove, %romPath%\%romName%%romExtension%, %romPath%\%originalRomName%%romExtension%
	If ErrorLevel	; if rename was successful, set var so we know to move it back later
		ScriptError("There was a problem renaming " . romName . " back to " . originalRomName)
}

FadeOutExit()
ExitModule()


ListXMLInfo(rom){ ; returns MAME/MESS info about parent rom, orientation angle, resolution
	Global emuFullPath, emuPath
	ListXMLtable := []
	RunWait, % comspec . " /c " . """" . emuFullPath . """" . " -listxml " . rom . " > tempBezel.txt", %emuPath%, Hide
	Fileread, ListxmlContents, %emuPath%\tempBezel.txt
	RegExMatch(ListxmlContents, "s)<game.*name=" . """" . rom . """" . ".*" . "cloneof=" . """" . "[^""""]*", parent)
	RegExMatch(parent,"cloneof=" . """" . ".*", parent)
	RegExMatch(parent,"""" . ".*", parent)
	StringTrimLeft, parent, parent, 1
	RegExMatch(ListxmlContents, "s)<display.*rotate=" . """" . "[0-9]+" . """", angle)
	RegExMatch(angle,"[0-9]+", angle, "-6")
	RegExMatch(ListxmlContents, "s)<display.*width=" . """" . "[0-9]+" . """", width)
	RegExMatch(width,"[0-9]+", width, "-6")
	RegExMatch(ListxmlContents, "s)<display.*height=" . """" . "[0-9]+" . """", Height)
	RegExMatch(Height,"[0-9]+", Height, "-6")
	ListXMLtable[1] := parent
	ListXMLtable[2] := angle
	If (ListXMLtable[2]<>0)
		ListXMLtable[3] := height
	Else
		ListXMLtable[3] := width
	If (ListXMLtable[2]<>0)
		ListXMLtable[4] := width
	Else
		ListXMLtable[4] := height
	FileDelete, %emuPath%\tempBezel.txt
	Return ListXMLtable	
}

HaltEmu:
	If pauseMethod = 1
	{	disableSuspendEmu = true
		disableRestoreEmu = true
		PostMessage,0x211, 1, , , ahk_class MAME
	} Else If pauseMethod = 2
	{	disableSuspendEmu = true
		PostMessage,0x211, 1, , , ahk_class MAME
	} Else If pauseMethod = 3
	{	disableSuspendEmu = true
		disableRestoreEmu = true
		PostMessage,% 0x0400+6, 1, , , ahk_class MAME
	} Else If pauseMethod = 4
	{	disableSuspendEmu = true
		PostMessage,% 0x0400+6, 1, , , ahk_class MAME
	} Else If pauseMethod = 5
	{	disableSuspendEmu = true
		Send, {P down}
		Sleep, 1000
		Send, {P up} 
	}
Return
RestoreEmu:
	If pauseMethod = 1
	{	PostMessage,0x212, 1, , , ahk_class MAME
		WinActivate, ahk_class MAME
	} Else If pauseMethod = 2
	{	PostMessage,0x212, 1, , , ahk_class MAME
		WinActivate, ahk_class MAME
	} Else If pauseMethod = 3
	{	PostMessage,% 0x0400+6, 0, , , ahk_class MAME
		WinActivate, ahk_class MAME
	} Else If pauseMethod = 4
	{	PostMessage,% 0x0400+6, 0, , , ahk_class MAME
		WinActivate, ahk_class MAME
	} Else If pauseMethod = 5
	{	disableSuspendEmu = true
		Send, {P down}
		Sleep, 1000
		Send, {P up} 
		WinActivate, ahk_class MAME
	} Else If pauseMethod = 6
		WinActivate, ahk_class MAME
Return

HideConsole:
	hideConsoleTimer++
	IfWinExist, ahk_class ConsoleWindowClass
	{	Log("Module - HideConsole - Console window found, hiding it out of view.")
		WinSet, Transparent, 0, ahk_class ConsoleWindowClass
		SetTimer, HideConsole, Off
	} Else If hideConsoleTimer >= 200
		SetTimer, HideConsole, Off
Return

CloseProcess:
	FadeOutStart()
	WinClose("ahk_class MAME")
Return
