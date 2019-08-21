use varStorage : script "GlobalVarLibrary"
-- put into ~/Library/Script\ Libraries
-- use as set currentTool to script "Photoshop_ScriptLibrary"'s toggleCurrentTool("lassoTool", "eraserTool")


on getCurrentTool()
	tell application "Adobe Photoshop CC 2018" to return current tool
end getCurrentTool

on deselect()
	tell application "Adobe Photoshop CC 2018" to tell the current document to deselect
	setFeathered(false)
end deselect

on toggleCurrentTool(tool1, tool2)
	setFeathered(false)
	set currentTool to tool1
	tell application "Adobe Photoshop CC 2018"
		if current tool is equal to currentTool then set currentTool to tool2
		set current tool to currentTool
	end tell
	return currentTool
end toggleCurrentTool

on getAllLayers(layerName)
	set allLayerNames to {}
	tell application "Adobe Photoshop CC 2018"
		set allLayers to the layers of current document
		repeat with theLayer in allLayers
			set theName to the name of theLayer
			if theName starts with the first word of layerName then set end of allLayerNames to theName
		end repeat
	end tell
	return allLayerNames
end getAllLayers


on getPrevLayer(targetLayerName, currentLayer)
	set currentLayerId to id of currentLayer
	tell application "Adobe Photoshop CC 2018"
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
	return "true" is equal to varStorage's readVar("feathered")
end getFeathered

on setFeathered(b)
	varStorage's writeVar("feathered", b)
end setFeathered

on tryFeather()
	if getFeathered() then return
	try
		tell application "Adobe Photoshop CC 2018" to tell current document to feather selection by 5
		setFeathered(true)
	on error
		setFeathered(false)
	end try
end tryFeather


on tryBlur(_radius)
	try
		
		tell application "Adobe Photoshop CC 2018" to tell current document
			set props to properties of selection
			if bounds of props is equal to missing value then return end
			filter current layer using gaussian blur with options {radius:_radius}
		end tell
	end try
end tryBlur
