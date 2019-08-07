
set targetLayerName to ""

on removeCopy(targetLayerName)
	set suffix to the last word of targetLayerName
	set suffixlength to get (length of suffix) + 1
	return (text 1 thru (-1 * (suffixlength + 1)) of targetLayerName)
end removeCopy

on getPrevLayer(targetLayerName, currentLayer)
	log "getPrevLayer"
	set currentLayerId to id of currentLayer
	tell application "Adobe Photoshop CC 2018"
		return the first art layer of the current document whose name is targetLayerName and id is not currentLayerId
		return the first art layer of the current document whose name is targetLayerName
	end tell
	
end getPrevLayer

tell application "Adobe Photoshop CC 2018"
	
	set currentLayer to current layer of current document
	set layerName to name of currentLayer
	set targetLayerName to layerName
	
	if targetLayerName ends with "copy" then
		set targetLayerName to my removeCopy(layerName)
	else
		-- if it's numeric: select next lower layer
		try
			set suffix to the last word of layerName
			set suffixlength to get (length of suffix) + 2
			
			set targetLayerName to (text 1 thru (-1 * suffixlength) of layerName)
			
			
			if suffix as number is greater than 2 then set targetLayerName to targetLayerName & " " & thenumber - 1
		end try
		
		if targetLayerName ends with "copy" then set targetLayerName to my removeCopy(targetLayerName)
		
	end if
	
	set targetlayer to my getPrevLayer(targetLayerName, currentLayer)
	
	set visible of currentLayer to false
	set visible of targetlayer to true
	delay 1
	set visible of targetlayer to false
	set visible of currentLayer to true
end tell
