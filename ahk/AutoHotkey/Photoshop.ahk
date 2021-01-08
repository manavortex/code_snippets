#IfWinActive, ahk_exe Photoshop.exe
	f2::
		Send !{l}
		Sleep, 50
		Send {down 8}
		Send {Enter}
		Return
		
	!f1::!f2
	
	
	^down::RunPhotoshopAction("Move One Layer", "Select Backward Layer")
	^up::RunPhotoshopAction("Move One Layer", "Select Forward Layer")
	
	Numpad1::buttonPress(1)
	!Numpad1::buttonPress(1)
	
	Numpad2::buttonPress(2)
	!Numpad2::buttonPress(2)
	
	Numpad3::buttonPress(3)
	!Numpad3::buttonPress(3)
	
	Numpad4::buttonPress(4)
	!Numpad4::buttonPress(4)
	

#IfWinActive

buttonPress(buttonNumber)
{
	Try
	{
		if GetKeyState("Alt")
			SendInput {"Alt" up}

		currentTool := getPsTool()
		
		Switch buttonNumber
		{
			case 1:
				if GetKeyState("F20")
					Send ^{z}
				else
					toggleCurrentTool("lassoTool", "eraserTool")
			case 2:
				if GetKeyState("F20")
				{
					if (currentTool = "lassoTool")
						Send ^{x}
					else
						Send {Tab}
				}			
				else 
					SendInput {>}
			case 3:
				if GetKeyState("F20")
				{				
					if (currentTool = "lassoTool")
						Send ^{d}
					else
						_nextTool = "rotateTool"
						if (currentTool = "rotateTool")
							currentTool = "paintbrushTool"
							
					toggleCurrentTool(%currentTool%, "rotateTool")
						
				}			
				else 
					SendInput {<}
			case 4:
				if GetKeyState("F20")
					Send ^{z}
				else
					toggleCurrentTool("paintbrushTool", "eraserTool")
		}	
		}	
}


RunPhotoshopAction(actionSetName, actionName)
{
	Try
	{
		app := ComObjActive("Photoshop.Application")
		doc = app.activeDocument
		app.doAction(actionName, actionSetName)

	}
}

toggleCurrentTool(tool1, tool2)
{
	Try
	{
		currentTool := getPsTool()
		
		if (currentTool = tool1) 
		{
			setPsTool( tool2 )
		}
		else 
		{
			setPsTool( tool1 )
		}		
	}		
}

getPsTool() { ; http://stackoverflow.com/questions/29109677/photoshop-javascript-how-to-get-set-current-tool
	Try
	{
		app := ComObjActive("Photoshop.Application")
		actRef := ComObjCreate("Photoshop.ActionReference")

		actRef.putEnumerated( app.charIDToTypeID("capp")
							, app.charIDToTypeID("Ordn")
							, app.charIDToTypeID("Trgt") )

		ActionDescriptor := app.executeActionGet(actRef)
		tool_id  := ActionDescriptor.getEnumerationType( app.stringIDToTypeID("tool") )
		tool_str := app.typeIDToStringID(tool_id)
		return tool_str
	}
}

setPsTool(tool) { ; https://autohotkey.com/boards/viewtopic.php?p=23679#p23679
	Try
	{
		app := ComObjActive("Photoshop.Application")
			desc9 := ComObjCreate("Photoshop.ActionDescriptor")
				ref7 := ComObjCreate("Photoshop.ActionReference")
				ref7.putClass( app.stringIDToTypeID(tool) )
			desc9.putReference( app.charIDToTypeID("null"), ref7 )
			app.executeAction( app.charIDToTypeID("slct"), desc9, psDisplayNoDialogs := 3 )
	}
}
