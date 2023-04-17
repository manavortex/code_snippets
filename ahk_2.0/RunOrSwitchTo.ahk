RunOrSwitchTo(Target, WinTitle := "", Args := "")
{
	; Get the filename without a path
	SplitPath(Target, &TargetNameOnly)
	
	; Process returns the PID of a matching process exists, or 0 otherwise
	ErrorLevel := ProcessExist(TargetNameOnly)
	
    OutputDebug("[" A_ScriptName "] RunOrSwitchTo: " Target ", " WinTitle)
	
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
	
	; At least one app  wouldn't always become the active window after using Run, so we always force a window activate.
	; Activate by title if given, otherwise use class ID. Activating by class ID appears more robust for switching than using PID.
	if (WinTitle != "")
	{
		SetTitleMatchMode(2)
		ErrorLevel := WinWait(WinTitle, , 3) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
		
		if WinActive(WinTitle)
		{
			WinActivateBottom(WinTitle)
		}
		Else
		{
			WinActivate(WinTitle)
		}	
		MMX := WinGetMinMax(WinTitle)
		if (MMX = -1)
			WinMaximize(WinTitle)
	}
	Else
	{
		ErrorLevel := WinWait("ahk_class " ClassID, , 3) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
		if WinActive("ahk_class " ClassID)
		{
			WinActivateBottom("ahk_class " ClassID)
		}
		Else
		{
			WinActivate("ahk_class " ClassID)
		}
			
		MMX := WinGetMinMax(%ClassID%())
		if (MMX = -1)
			WinMaximize("ahk_class " ClassID)
	}

	WinState := WinGetMinMax("A")
	if WinActive("ahk_exe Console.exe")
			return
    if ( WinState = 0) {
			WinMaximize("A")
			return
		}
    ; WinRestore, A   
}
