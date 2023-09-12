@echo off

@call qac_def_host.bat

@set COMSPEC=c:\windows\system32\cmd.exe
@set SHELL=%MINGW%/bin/sh

@cd %~dp0../Make
@%MSYS%\make.exe -r -k qac_read_messages
@pause