' call from batch:
' call focus_and_send_key.vbs "my window title" "{ENTER}"

Dim ObjShell :Set ObjShell = CreateObject("Wscript.Shell")
Set objArgs = Wscript.Arguments
' 
If Not objArgs.Count > 0 Then
	Wscript.Echo 'Please pass at least one argument to call this script: script.vbs "windowTitle" "{ENTER}" '
End If

If objArgs.Count > 0 Then
	str = objArgs(0)
	If Len(str) > 0 Then 
		ObjShell.AppActivate(str)
	End If
End If


If objArgs.Count > 1 Then
	
	currentArg = objArgs(1)
	If Len(currentArg) > 0 Then 
		
		' String must be formatted like {ENTER}
		If Not InStr(1, currentArg,"{") Then 
			currentArg = "{" & currentArg
		End If
		If Not InStr(Len(currentArg), "}", currentArg) Then
			currentArg = currentArg & "}"
		End If
		
		ObjShell.SendKeys(currentArg)
		
	End If
  
End If
