@echo off
if exist %1\%1.obj del %1\%1.obj
if exist %1\%1.exe del %1\%1.exe
@echo %1\%1
.\bin\ml /c /coff /Cp /Cx /Fo.\%1\%1.obj /Fl.\%1\%1.lst /Zi /Zd .\%1\%1.asm