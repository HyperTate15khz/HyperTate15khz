;----------------------------------------------------------------------------
; MAME
; MAME .143
; by BBB & djvj
; 1.1
;
; Notes:
;----------------------------------------------------------------------------

FadeInStart()

Run, %executable% %romName%, %emuPath%, Hide UseErrorLevel

If(ErrorLevel != 0){
		If (ErrorLevel = 1){
			Error = Failed Validity
		}Else If(ErrorLevel = 2){
			Error = Missing Files
		}Else If(ErrorLevel = 3){
			Error = Fatal Error
		}Else If(ErrorLevel = 4){
			Error = Device Error
		}Else If(ErrorLevel = 5){
			Error = Game Does Not Exist
		}Else If(ErrorLevel = 6){
			Error = Invalid Config
		}Else If(ErrorLevel = 7 || ErrorLevel = 8 || ErrorLevel = 9){
			Error = Identification Error
		}Else{
			Error = Mame Error
		}
		MsgBox Mame Error - %Error%
	}

WinWait, MAME ahk_class MAME
WinWaitActive, MAME ahk_class MAME

FadeInExit()

Process, WaitClose, %executable%

FadeOutExit()

WinActivate, Hyperspin

ExitApp


CloseProcess:
	FadeOutStart()
	WinClose, MAME ahk_class MAME
Return
