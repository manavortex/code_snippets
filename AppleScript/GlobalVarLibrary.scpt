-- use varStorage : script "GlobalVarLibrary"

on writeVar(theName, theVar)
	do shell script "echo " & theVar & " > /tmp/" & theName & ".txt"
end writeVar

on readVar(theName)
	try
		return do shell script "cat /tmp/" & theName & ".txt"
	end try
	return ""
end readVar
