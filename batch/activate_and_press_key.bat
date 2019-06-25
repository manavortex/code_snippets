REM usage: call activate_and_press_key.bat "myWindow" "{ENTER}"
REM or see https://github.com/manavortex/code_snippets/blob/master/vbs/focus_and_send_key.vbs


if ["%~1"] equ [""] (
	echo Please call script with argument "window title"
	goto :eof
)

set pr=%~1
set pr=!pr:"=!

set tmpfile="%tmp%\focus.vbs"

echo Dim ObjShell :Set ObjShell = CreateObject("Wscript.Shell") > %tmpfile%
echo ObjShell.AppActivate("!pr!") >> %tmpfile%

if not ["%~2"] equ [""] (
	set pr=%~2
	set pr=!pr:"=!
	
	ECHO WScript.Sleep 1000>>%tmpfile%
	echo ObjShell.SendKeys "!pr!" >> %tmpfile%
)

call "%tmp%\focus.vbs"
del "%tmp%\focus.vbs"

goto :eof 
