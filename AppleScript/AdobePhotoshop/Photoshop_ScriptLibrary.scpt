
-- put into ~/Library/Script\ Libraries
-- use as set currentTool to script "Photoshop_ScriptLibrary"'s toggleCurrentTool("lassoTool", "eraserTool")


on writeVar(theName, theVar)
	do shell script "echo " & theVar & " > /tmp/" & theName & ".txt"
end writeVar
on readVar(theName)
	try
		return do shell script "cat /tmp/" & theName & ".txt"
	end try
	return ""
end readVar

on getLastTool()
	return readVar("_lastTool")
end getLastTool

on setLastTool(arg)
	writeVar("_lastTool", arg)
end setLastTool

-- WIP
on getGroupPath()
	set thelayer to ""
	tell application "Adobe Photoshop 2020" to tell the current document
		set thelayer to current layer
	end tell
	return thelayer
end getGroupPath

on getCurrentTool()
	tell application "Adobe Photoshop 2020" to return current tool
end getCurrentTool


on getCurrentLayerName()
	tell application "Adobe Photoshop 2020" to tell the current document to return the name of current layer
end getCurrentLayerName

on setLayerVisibility(theName, theVisibility)
	try
		tell application "Adobe Photoshop 2020" to tell the current document
			set visible of the layer theName to theVisibility
		end tell
	end try
end setLayerVisibility

-- toggles layer visibility. If hidden, show - if visible, hide
on toggleLayerVisibility(theName)
	tell application "Adobe Photoshop 2020" to tell the current document
		set theVisibility to visible of layer theName
	end tell
	setLayerVisibility(theName, not (theVisibility))
end toggleLayerVisibility

on deselect()
	tell application "Adobe Photoshop 2020" to tell the current document to deselect
	setFeathered(false)
end deselect


on cut()
	try
		tell application "Adobe Photoshop 2020" to tell the current document to cut
		setFeathered(false)
	end try
end cut

on toggleCurrentTool(tool1, tool2)
	setFeathered(false)
	set currentTool to getCurrentTool()
	setLastTool(currentTool)
	tell application "Adobe Photoshop 2020"
		if currentTool is equal to tool1 then
			set currentTool to tool2
		else
			set currentTool to tool1
		end if
		set current tool to currentTool
	end tell
	return currentTool
end toggleCurrentTool

on selectLastTool()
	set currentTool to getCurrentTool()
	set lastTool to getLastTool()
	if currentTool is equal to lastTool then return
	toggleCurrentTool(lastTool, currentTool)
end selectLastTool

on getAllLayers(layerName)
	set allLayerNames to {}
	tell application "Adobe Photoshop 2020"
		set allLayers to the layers of current document
		repeat with thelayer in allLayers
			set theName to the name of thelayer
			if theName starts with the first word of layerName then set end of allLayerNames to theName
		end repeat
	end tell
	return allLayerNames
end getAllLayers


on getPrevLayer(targetLayerName, currentLayer)
	set currentLayerId to id of currentLayer
	tell application "Adobe Photoshop 2020"
		return the first art layer of the current document whose name is targetLayerName and id is not currentLayerId
		return the first art layer of the current document whose name is targetLayerName
	end tell
end getPrevLayer

on getPrevious(layerName)
	
	set suffix to the last word of layerName
	set suffixlength to get (length of suffix) + 2
	log "getPrevious(" & layerName & "), suffix: " & suffix
	
	-- remove the last word from the layer name. Unless we're dealing with numbered copies
	set targetLayerName to (text 1 thru (-1 * suffixlength)) of layerName
	
	-- first: Check if layer name ends in number. If number > 2, we want the layer with the next-smaller number
	-- WIP copy 16 -> WIP copy 15
	-- WIP copy 1 -> WIP copy 
	-- second: If the layer does not end in a number, 
	try
		set thenumber to (suffix as number)
		if thenumber is greater than 2 then set targetLayerName to targetLayerName & " " & thenumber - 1
	on error -- if layer doesn't end in a number: remove "copy"
		if layerName ends with "copy" then set targetLayerName to text 1 thru -6 of layerName
	end try
	return targetLayerName
	
end getPrevious

on getPreviousLayer(currentLayer)
	return getPrevLayer((getPrevious(name of currentLayer)), currentLayer)
end getPreviousLayer

on getFeathered()
	return "true" is equal to readVar("feathered")
end getFeathered

on setFeathered(b)
	writeVar("feathered", b)
end setFeathered

on isOnLayerMask()
	try
		set windowName to ""
		tell application "System Events" to tell process "Adobe Photoshop CC 2019"
			tell (1st window whose value of attribute "AXMain" is true)
				set windowName to value of attribute "AXTitle"
			end tell
		end tell
	end try
	return windowName contains "Layer Mask"
end isOnLayerMask

on isSelected()
	try
		tell application "Adobe Photoshop 2020" to tell current document
			set props to properties of selection
			if bounds of props is not equal to missing value then return true
		end tell
	end try
	return false
end isSelected

on tryFeather(forceOverride)
	if (getFeathered() and not forceOverride) or not isSelected() then return
	try
		tell application "Adobe Photoshop 2020" to tell current document
			feather selection by 5
		end tell
		setFeathered(true)
	on error
		setFeathered(false)
	end try
end tryFeather


on tryBlur(_radius)
	if not isSelected() then return end
	try
		tell application "Adobe Photoshop 2020" to tell current document
			filter current layer using gaussian blur with options {radius:_radius}
		end tell
	end try
end tryBlur
