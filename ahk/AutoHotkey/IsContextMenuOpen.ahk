
IsContextMenuOpen() {
  
  MouseGetPos, MouseX1, MouseY1                     ; save original mouse position
  MouseMove, 50, -30, 0, R                          ; move cursor up (or down, may need adjustment on your part) - should hover over first context menu entry anyway
  MouseGetPos, MouseX, MouseY                       ; get new mouse position
  
  PixelGetColor, color1, %MouseX1%, %MouseY1%       ; get color under cursor at original position - remove if you wanna hardcode
  PixelGetColor, color2, %MouseX%, %MouseY%         ; get color under cursor at position in context menu
  MouseMove, %MouseX1%, %MouseY1%                   ; reset cursor
  
  ; return not (%color1% == "0xFFFFFFFF")           ; If you want to hardcode that
  return not (%color1% == %color2%)                 ; color is different? 
  
}
