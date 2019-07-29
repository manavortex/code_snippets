
on getPrevious(layerName)
	
	set suffix to the last word of layerName
	set suffixlength to get (length of suffix) + 2
	
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

set allLayerNames to {}
tell application "Adobe Photoshop CC 2018"
	set layerName to name of current layer of current document
	set targetLayerName to layerName
	
	set allLayers to the layers of current document
	repeat with theLayer in allLayers
		set theName to the name of theLayer
		if theName starts with the first word of layerName then set end of allLayerNames to theName
	end repeat
	
	set existingLayer to ""
	repeat while ("" is equal to existingLayer and targetLayerName contains "copy")
		set targetLayerName to my getPrevious(targetLayerName)
		if targetLayerName is equal to layerName then return end
		if allLayerNames contains targetLayerName then set existingLayer to targetLayerName
	end repeat
	if "" is equal to existingLayer then return
	
	--	return layerName & "->" & existingLayer 	
	
	set visible of layer layerName of current document to false
	set visible of layer existingLayer of current document to true
	delay 1
	set visible of layer existingLayer of current document to false
	set visible of layer layerName of current document to true
	
end tell
