
LaunchProgramIfNotRunning(Target, WinTitle, Args)
{	
	if (WinExist(WinTitle))
		return
	
	; Process returns the PID of a matching process exists, or 0 otherwise	
	ErrorLevel := WinWait(WinTitle, , 3)
	
	MsgBox(ErrorLevel)
	
    OutputDebug("[" A_ScriptName "] RunOrSwitchTo: " Target ", " WinTitle)
	
	ClassID := ''
	
	; Get the PID and the class if the process is already running
	if (ErrorLevel > 0)
	{
		PID := ErrorLevel
		ClassID := WinGetClass("ahk_pid " PID)
	}
	; Run the program if the process is not already running
	Else
	{
		if (Args = "") 
		{
			RunWait("`"" Target "`"", , , &PID)
		}
		else 
		{
			RunWait("`"" Target "`" `"" Args "`"", , , &PID)
		}
	}	
	
	Return PID	
}


RunOrSwitchTo(Target, WinTitle := "", Args := "")
{	
	; Get the filename without a path
	SplitPath(Target, &TargetNameOnly)
	
	if (WinTitle == "")
	{	
		WinTitle := TargetNameOnly
	}
	
	ClassID := LaunchProgramIfNotRunning(Target, WinTitle, Args)

	; Activate by title if it exists 
	SetTitleMatchMode(2)	
	if (WinActive(WinTitle))
	{
		WinActivateBottom(WinTitle)
	}
	Else
	{
		WinActivate(WinTitle)
	}	
	
	
	if WinActive("ahk_exe Console.exe")
	return
	if WinActive("ahk_exe ConEmu64.exe")
	return
	
	; maximize window
	WinState := WinGetMinMax("A")
	
    if ( WinState = 0) {
		WinMaximize("A")
		return
	}
    ; WinRestore, A   
}
