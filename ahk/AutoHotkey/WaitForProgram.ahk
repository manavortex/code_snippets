if WinExist("ahk_exe KeePass.exe")
{
    WinActivate  ; Uses the last found window.
    WinMaximize
} 
else
{
    WinWaitActive, ahk_exe KeePass.exe, , 60
    if ErrorLevel
    {
      Goto, EndApp
    }
    WinMaximize
    
}


EndApp:
Run C:\Users\YOURUSER\Documents\AutoHotkey.ahk ;for some reason this crashes occasionally
ExitApp
return
