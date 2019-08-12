@echo off
if exist "%1" ( 
  mkdir e
  robocopy e "%1" /MIR
  rmdir e
)
