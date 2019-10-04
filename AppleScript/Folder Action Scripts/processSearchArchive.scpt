-- put into ~/Library/Scripts/Folder Action Scripts
-- ctrl-click on download folder, Services, Folder Action Setup

on addinon adding folder items to theAttachedFolder after receiving theNewItems

	tell application "Finder"
		
		-- Loop through the newly detected items
		repeat with _item in theNewItems
			
			set _thepath to POSIX path of (_item as alias)
			if _thepath starts with "SearchOok" then
				if _thepath ends with ".zip" then
					do shell script "/usr/bin/unzip -d $HOME/Downloads " & _thepath
					do shell script "rm " & _thepath
				else if _thepath ends with ".txt" then
					tell application "Sublime Text" to open _thepath
				end if
			end if
			
		end repeat
	end tell
end adding folder items to
