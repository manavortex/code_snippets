; ==========================================================================================
	; Autorun part
; ==========================================================================================


; Matchwindow titles by regex
SetTitleMatchMode(2)
SetTitleMatchMode("slow")
SetControlDelay(-1)


; Send Alt+F4 upon Ctrl+W in those applications:
GroupAdd("CloseWithCtrlW", "Greenshot")
GroupAdd("CloseWithCtrlW", "ahk_exe     	cmd.exe")
GroupAdd("CloseWithCtrlW", "ahk_exe 	  	explorer.exe")
GroupAdd("CloseWithCtrlW", "ahk_exe     	i_view64.exe")		; IrfanView
GroupAdd("CloseWithCtrlW", "ahk_exe 	  	notepad.exe")		  ; notepad
GroupAdd("CloseWithCtrlW", "ahk_exe 	  	regedit.exe")		  ; regedit
GroupAdd("CloseWithCtrlW", "ahk_exe 	  	taskmgr.exe")		  ; TaskManager
GroupAdd("CloseWithCtrlW", "ahk_exe     	WinMergeU.exe")		; WinMerge
GroupAdd("CloseWithCtrlW", "ahk_class 	FM")					      ; 7zip
GroupAdd("CloseWithCtrlW", "ahk_class 	TfcSearchForm")		  ; FreeCommander search form

; Send special characters for writing
GroupAdd("WritingWithScissoirs", "ahk_exe Discord.exe")
GroupAdd("WritingWithScissoirs", "ahk_exe Evernote.exe")
GroupAdd("WritingWithScissoirs", "Google")
GroupAdd("WritingWithScissoirs", "Word")
GroupAdd("WritingWithScissoirs", "Notepad")

GroupAdd("WritingWithScissoirs_Ignore", "ahk_exe sublime_text.exe")


SetWorkingDir A_ScriptDir

GroupAdd("EditAhkFile", "Notepad++")
GroupAdd("EditAhkFile", "ahk_class 		Notepad")


GroupAdd("FreeCommander", "ahk_exe          FreeCommander.exe")

GroupAdd("Outlook", "ahk_exe                OUTLOOK.EXE")

DetectHiddenWindows(true)

; automatically overwrite this script upon launching
#SingleInstance force
; #NoEnv
Persistent

; PleasantNotify("AutoHotkey reloaded", "" , 330, 80, "b r", "2")

#Include  "AutoHotkey\RunOrSwitchTo.ahk"

; #Include %A_ScriptDir%\AutoHotkey\PleasantNotify.ahk
; #Include %A_ScriptDir%\AutoHotkey\Notepad++.ahk
; #Include %A_ScriptDir%\AutoHotkey\OpenSettingsWithCtrlComma.ahk
; #Include %A_ScriptDir%\AutoHotkey\GamingFunctions.ahk 
#Include "AutoHotkey\Photoshop.ahk"
; #Include %A_ScriptDir%\AutoHotkey\ClickBackgroundWindow.ahk 
; #Include %A_ScriptDir%\AutoHotkey\EldenRing.ahk 
; #Include %A_ScriptDir%\AutoHotkey\chrome.ahk 



; ------------------------------------------------------------------------------------------
; Disable insert, keep num lock and caps lock state
; ------------------------------------------------------------------------------------------



Capslock::<
+Capslock::>


+Numpad0::Delete
SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
#SC01B::return                                                                               ; disable screen magnifier  because I hate it
!Shift::return                                                                               ; disable input lang switch because I hate it
#Shift::return                                                                               ; disable input lang switch because I hate it
~LAlt Up::return                                                                             ; don't go to window menu thingy with alt


SendMode("Input") 		; Recommended for new scripts due to its superior speed and reliability 

; ==========================================================================================
; Autorun part end
return
; ==========================================================================================



; ------------------------------------------------------------------------------------------
  ; Windows-H will minimize, Windows-M will maximize current window
; ------------------------------------------------------------------------------------------
#HotIf !WinActive("ahk_exe cheatengine-x86_64.exe",)
  #m::MinMax()
  #h::WinMinimize("A")
#HotIf !WinActive(, )

#HotIf !WinActive("ahk_exe eclipse.exe", )
    #h::    WinMinimize("A")
#HotIf !WinActive(, )

#HotIf WinActive("ahk_exe blender.exe",)
   ^+!s::Send("{f20}")
#HotIf 
 


; Japanese letters
!^Numpad1::Send("{U+0100}") ;Ā
!Numpad1::Send("{U+0101}") ;ā

!^Numpad2::Send("{U+14c}")  ;Ō
!Numpad2::Send("{U+14d}")  ;ō

!^Numpad3::Send("{U+16a}")  ;Ū
!Numpad3::Send("{U+16b}")  ;ū


 
#HotIf WinActive("ahk_group WritingWithScissoirs", )
	
	#HotIf !WinActive("ahk_exe notepad++.exe", )
    #HotIf !WinActive("ahk_exe sublime_text.exe", )
      !SC035::      Send("{U+2014}")  	;—  - this does work
      !.::      Send("…")
      ; :*?:--::—
      :*?:...::…
      !^a::      Send("{U+0100}") ;Ā
      !a::      Send("{U+0101}") ;ā
    #HotIf !WinActive(, )
	#HotIf !WinActive(, )
	
	#HotIf WinActive(".txt", )
		!SC035::		Send("{U+2014}")  	;—  - this does work
		!.::		Send("…")
		:*?:--::—
		:*?:...::…
		!^a::		Send("{U+0100}") ;Ā
		!a::		Send("{U+0101}") ;ā
	#HotIf
	

	!^o::	Send("{U+14c}")  ;Ō
	!o::	Send("{U+14d}")  ;ō
	
	!+u::	Send("{U+16a}")  ;Ū
	!u::	Send("{U+16b}")   ;Ū
	
	; !.::Send,  {U+2026}  ;…
	
	^+1::	Send("¡")
	^+ß::	Send("¿")
	
#HotIf



; ------------------------------------------------------------------------------------------
; --------------------- ! is alt ^ is ctrl # is windows + is shift  ------------------------
; ------------------------------------------------------------------------------------------

MinMax()
{
    WinState := WinGetMinMax("A")
    if (WinState = 0) {
        WinMaximize("A")
        return
    }
    WinRestore("A")
}


#HotIf WinActive("ahk_exe explorer.exe", )
	 !d::	 Send("{f4}")
	 ^l::!d
#HotIf

#HotIf WinActive("ahk_exe Photoshop.exe", )
	^+y::	Send("^+{i}")
	~Esc::SendKeyToSpecificWindow("Layer Style", "Esc")
#HotIf

; #d::SetDefaultKeyboard(0x407)


; ------------------------------------------------------------------------------------------
; windows+key opens program
; requires RunOrSwitchTo.ahk to be loaded
; ------------------------------------------------------------------------------------------

#n::RunOrSwitchTo("C:\Program Files (x86)\Notepad++\notepad++.exe", "Notepad++")                            ; win+n         notepad++ 
#+n::RunOrSwitchTo("C:\Program Files (x86)\Evernote\Evernote\Evernote.exe") ; , "ahk.exe Evernote.exe")                            ; win+n         notepad++ 
; #c::RunOrSwitchTo("C:\01_apps\cmder\Cmder.exe", "ahk_exe ConEmu64.exe")                              ; win+c         console
#c::RunOrSwitchTo("C:\01_apps\Console2\Console.exe", "Console", " -t Console")                               ; win+c         console
; #f::RunOrSwitchTo("C:\Program Files\Google\Chrome\Application\chrome.exe", "Google Chrome")           ; win+f         firefox
#f::RunOrSwitchTo("C:\Program Files\Firefox Developer Edition\firefox.exe", "Firefox Developer Edition")  ; win+f         firefox
#+x::RunOrSwitchTo("%programfiles%\Microsoft Office\Office16\EXCEL.exe")                                    ; win+shift+x   excel
#e::RunOrSwitchTo("C:\Program Files\FreeCommander XE\FreeCommander.exe", "FreeCommander")
; #+e::RunOrSwitchTo("E:\Program Files\Microsoft VS Code\Code.exe", "ahk_exe Code.exe")
; #^e::RunOrSwitchTo("E:\Program Files\Noesis\Noesis.exe", "ahk_exe Noesis.exe")                              
#+f::RunOrSwitchTo("D:\Games\Frosty\00_modmanager\FrostyModManager.exe", "ahk_exe FrostyModManager.exe")
; #+^p::RunOrSwitchTo("C:\Program Files\Adobe\Adobe Photoshop 2021\Photoshop.exe", "ahk_exe Photoshop.exe")
#+m::RunOrSwitchTo("C:\Users\mana\AppData\Local\GPMDP_3\Update.exe", "ahk_exe Google Play Music Desktop Player.exe")
#s::RunOrSwitchTo("C:\Program Files\Sublime Text\sublime_text.exe", "ahk_exe sublime_text.exe")

#d::SwitchToDiscord()


#HotIf !WinActive("ahk_exe blender.exe", )
; #g::               ;win+g         disable game bar, do nothing          
#HotIf !WinActive(, )

#HotIf WinActive("ahk_exe blender.exe", )
  +!^s:: {
    KeyWait("Control")  ; Wait for both Control and Alt to be released.
    KeyWait("Alt")
    KeyWait("Shift")
    Send("{ f20 }")
  }    
#HotIf

#HotIf WinActive("ahk_exe Evernote.exe", )
  ^!v::  Send("${^+{v}]")
#HotIf

; ------------------------------------------------------------------------------------------
; alt-shift-d opens download folder
; opens explorer on c drive
; ------------------------------------------------------------------------------------------
; !+d::Run, explore "%USERPROFILE%\Downloads"
; #+g::Run, explore "%USERPROFILE%\git" 
   

; ------------------------------------------------------------------------------------------
; close with ctrl-w
; ------------------------------------------------------------------------------------------
#HotIf WinActive("ahk_group CloseWithCtrlW", )
	^w::Send("!{F4}")
#HotIf

#HotIf WinActive("ahk_exe cmd.exe", )
    esc::Send("!{F4}")
#HotIf

; Same hotkeys in VisualMerge and WinMerge
#HotIf WinActive("Visual Merge", )
	!Down::F8
	!Up::F7
#HotIf

#HotIf WinActive("ahk_exe WinMergeU.exe", )
    !^+Right::ControlClick("x528 y10", "A", , "M")
    !^+Left:: ControlClick("x528 y14", "A", , "M")
    +Tab::F6
#HotIf


; ------------------------------------------------------------------------------------------
; Send a sequence of key presses. Call like SendWithSleeps( "h-Down-Down-Down-Enter" )
; ------------------------------------------------------------------------------------------
SendWithSleeps( string, delay:=100 ) {
	pos := 0
	Loop Parse, string, "`"-`""
	{
		Send("{ " StrReplace(A_LoopField, "minus", "-") " }")
		Sleep(delay)
	}
}
; ------------------------------------------------------------------------------------------
; reload with ctrl+(alt/shift)+(y/r) in notepad and notepad++
; ------------------------------------------------------------------------------------------

#HotIf WinActive("ahk_group EditAhkFile", )
; ------------------------------------------------------------------------------------------
ReloadThis() 
{	
	Reload()
	Sleep(1000) ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
	msgResult := MsgBox("The script could not be reloaded. Would you like to open it for editing?", "", 2)
	if (msgResult = "Yes")
		Edit()
	return 
}
	^!r::ReloadThis()
	^+r::ReloadThis()
#HotIf
+f12::ReloadThis()

; ------------------------------------------------------------------------------------------
; enable extra mouse buttons in 7zip
; ------------------------------------------------------------------------------------------
#HotIf WinActive("ahk_class FM", )
	XButton1::Backspace
	XButton2::Enter
#HotIf

; ------------------------------------------------------------------------------------------
; winmerge: replace with ctrl+r
; ------------------------------------------------------------------------------------------
#HotIf WinActive("ahk_exe WinMergeU.exe", )
	^r::^h
#HotIf

; ------------------------------------------------------------------------------------------
; Firefox
; ------------------------------------------------------------------------------------------
#HotIf WinActive("ahk_exe firefox.exe", )
	^y::^+h
#HotIf

; ------------------------------------------------------------------------------------------
; OneNote
; ------------------------------------------------------------------------------------------
 #HotIf WinActive("ahk_exe ONENOTE.EXE", )
	^+f::	Send("^{ e }")
 #HotIf

; ------------------------------------------------------------------------------------------
; Notepad++
; ------------------------------------------------------------------------------------------
 #HotIf WinActive("ahk_exe notepad++.exe", )
	^d::	Send("^+{ d }")
	^+h::	Send("^+{ f }")
  !Up::Send "^+{Up}"
  !Down::Send "^+{Down}"
 #HotIf

; ------------------------------------------------------------------------------------------
; Explorer
; ------------------------------------------------------------------------------------------
#HotIf WinActive("ahk_exe explorer.exe", )
	!g::
{
