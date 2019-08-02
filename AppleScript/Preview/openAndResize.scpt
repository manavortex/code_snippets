on getWindowList()
	set WindowList to {}
	try
		tell application "System Events" to set WindowList to get the name of every window of process "Preview"
	end try
	return WindowList
end getWindowList

set thebounds to {1560, 900, 2115, 1197}
tell application "Preview"
	set WindowList to my getWindowList()
	if WindowList does not contain "eraserTool.png" then open alias "Users:manavortex:Dropbox:01_pngs:eraserTool.png"
	if WindowList does not contain "lassoTool.png" then open alias "Users:manavortex:Dropbox:01_pngs:lassoTool.png"
	if WindowList does not contain "paintbrushTool.png" then open alias "Users:manavortex:Dropbox:01_pngs:paintbrushTool.png"
	
	repeat with windowTitle in my getWindowList()
		set (bounds of first window whose name contains windowTitle) to thebounds
	end repeat
end tell

