@echo off
if exist %1\%1.obj del %1\%1.obj
if exist %1\%1.exe del %1\%1.exe
@echo %1\%1
.\bin\ml /c /coff /Cp /Cx /Fo.\%1\%1.obj /Fl.\%1\%1.lst /Zi /Zd .\%1\%1.asm
@echo %1\%1
.\BIN\link /SUBSYSTEM:CONSOLE /LIBPATH:.\LIB /OUT:.\%1\%1.exe /MAP:.\%1\%1.map /PDB:.\%1\%1.pdb .\%1\%1.obj
@echo %1\%1