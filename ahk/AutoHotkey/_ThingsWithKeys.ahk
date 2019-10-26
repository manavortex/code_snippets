; Sends a keypress x times. Useful, for example, if computergames don't implement a "buy multiple"-option. -.-
; Call as (_SendIt("Enter", 100)
_SendIt(Key, Times = 1, Interval = 50) {
  Loop, %Times%
  {
    Send, {%Key% down}
    Sleep, %Interval%
    Send, {%Key% up}
    Sleep, %Interval%
  }
  Return
}

; Toggles the state of a key. Useful if games come without a "toggle walk"-feature. (Honestly, it's 2019, get your shit together)
ToggleButton(Key) {
  if GetKeyState(Key)
    SendInput {%Key% up}
  else
    SendInput {%Key% down}
}

toggleAlternate() {
  static t
  t := !t
  Return, t
}

; Alternate keypresses, for example, if you can open the map with m but not close it with ESC. Requires toggleAlternate util function. 
; Will only work for one toggle, every further one will need a new toggleAlternate function.
AlternateKeypress( Key1, Key2 ) {
  if (toggleAlternate())
    _SendIt(Key1)
  else
    _SendIt(Key2)
}
