GroupAdd,              CloseWithCtrlW, Greenshot
GroupAdd,              CloseWithCtrlW, ahk_exe 	   taskmgr.exe
GroupAdd,              CloseWithCtrlW, ahk_exe 	   explorer.exe
GroupAdd,              CloseWithCtrlW, ahk_exe 	   notepad.exe			; notepad
GroupAdd,              CloseWithCtrlW, ahk_exe 	   regedit.exe			; regedit
GroupAdd,              CloseWithCtrlW, ahk_class   FM				        ; 7zip
GroupAdd,              CloseWithCtrlW, ahk_class   TfcSearchForm		; FreeCommander search form
GroupAdd,              CloseWithCtrlW, ahk_class   IMWindowClass    ; LYNC chat window
GroupAdd,              CloseWithCtrlW, ahk_exe     WinMergeU.exe    ; WinMerge
GroupAdd,              CloseWithCtrlW, ahk_exe     cmd.exe          ; cmd

#IfWinActive ,ahk_group CloseWithCtrlW
	^w::Send, !{F4}
#IfWinActive
