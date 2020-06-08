use AppleScript version "2.4" -- Yosemite (10.10) or later
use framework "Foundation"
use framework "AppKit"
use scripting additions

-- IT DOES NOT WORK WITH GIFS APPLE Y
on alfred_script(q)
	
	set q to "PATH_OF_IMAGE" & q
	
	set tmp to the clipboard
	set theImage to current application's NSImage's alloc()'s initWithContentsOfFile:q
	if theImage is missing value then error "Can't read image format"
	set theClip to current application's NSPasteboard's generalPasteboard()
	theClip's clearContents()
	theClip's writeObjects:{theImage}
	
	delay 0.1
	tell application "System Events" to keystroke "v" using command down
	delay 0.2
	set the clipboard to tmp
	
end alfred_script
