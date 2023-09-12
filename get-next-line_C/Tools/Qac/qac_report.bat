@echo off

@call qac_def_host.bat

@set COMSPEC=c:\windows\system32\cmd.exe
@set SHELL=%MINGW%/bin/sh

@cd ../Make
@%MSYS%\make -r -s qac_report_all_rebuild
@pause
