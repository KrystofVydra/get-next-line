@echo off

@call qac_def_host.bat

@set COMSPEC=%MSYS%\sh.exe

@cd ..\make
@%MSYS%\make -r -s qac_modulelist
@pause


