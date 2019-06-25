; ===========================================================================
; Run a program or switch to it if already running.
; Courtesy of https://autohotkey.com/board/topic/7129-run-a-program-or-switch-to-an-already-running-instance/
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to SwitchTo.  Programs like
;       MS Outlook might have multiple windows open (main window and email
;       windows).  This parm allows activating a specific window.
; ===========================================================================
#WinActivateForce
SetTitleMatchMode 2          ; Match title of windows by part of the name
; #NoEnv

program_files := "C:\Program Files\"
program_files_x86 := "C:\Program Files\"

; EnvGet, program_files, 		programfiles
; EnvGet, program_files_x86, 	programfiles(x86)

RunOrSwitchTo(Target="", WinTitle="", WinArgs="")
{
	; Get the filename without a path
	SplitPath, Target, TargetNameOnly

	Process, Exist, %TargetNameOnly%
	If ErrorLevel > 0
		PID = %ErrorLevel%
	Else
		Run, %Target%, , , PID

	; SwitchTo by title if given, otherwise use PID.
	If WinTitle <>
	{
		SetTitleMatchMode, 2
		; TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
		WinActivate, %WinTitle%
	}
	Else
	{
		; TrayTip, , Activating PID %PID% (%TargetNameOnly%)
		WinActivate, ahk_pid %PID%
	}
	; SetTimer, WinMax, 300
	; SetTimer, RunOrSwitchToTrayTipOff, 200
}

; Turn off the tray tip
RunOrSwitchToTrayTipOff:
	SetTimer, RunOrSwitchToTrayTipOff, off
	TrayTip
Return

; Turn off the tray tip
WinMax:
	SetTimer, WinMax, off
    
        If WinActive("ahk_exe Console.exe") Or WinActive("ahk_exe Eclipse.exe") 
        { 
            return
        }            
        minMaxStatus := WinGet, OutputVar, MinMax, A
        If minMaxStatus <> 1
        {
            WinMaximize, A
        }
    
Return
