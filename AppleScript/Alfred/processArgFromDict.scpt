on alfred_script(q)

	set themap to { ¬
		|shrug|:"¯\\_(ツ)_/¯", ¬
		|haha|:"hahaha_no" ¬
	}


	set thefolder to (do shell script "$pwd")


	try
    	set theRecord to get getRecordValue(q, themap)
		set thefullpath to thefolder & theRecord & ".jpg"
		set thescript to "/bin/test -e " & quoted form of thefullpath & " ; echo $?"
		if (do shell script "/bin/test -e " & quoted form of thefullpath & " ; echo $?") is "0" then	return thefullpath 
		return theRecord
	end try

end alfred_script

to getRecordValue(theKey, theList)
   run script "on run{theKey,theList}
   return (" & theKey & " of theList )
end" with parameters {theKey, theList}
end getRecordValue
