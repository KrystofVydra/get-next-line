@echo off
rem SVN-Id: $Id: make_qac.bat 52032 2017-01-17 13:19:54Z ostwal01 $
rem SVN-Url: $HeadURL: https://debesvn001/kostal/lk_ae_internal/LK/Eclipse/ProjectTemplate/trunk/Tools/Make/make_qac.bat $

rem ##################################################################
rem #
rem # MAKEFILE TEMPLATE AEP2
rem #
rem # See /doc for detailed documentation
rem #
rem # Wrapper for make.exe to start the QA-C check process.
rem ##################################################################

set BUILDMODE=%1
set VERBOSE=%2
set NUM_JOBS=%3
set TARGET=%4

rem Check if the target is a .c file. If so, replace the target
rem with the qac error results file.
set TARGET_MODULE=%TARGET:~0,-2%.c
set TARGET_QAC=%TARGET:~0,-2%.c.err

if %TARGET% == %TARGET_MODULE% ( set TARGET=%TARGET_QAC% )


rem Determine the number of jobs to run in parallel
if "%NUM_JOBS%"=="" (
    rem Use 2 times the number of processors to make sure the CPU is
    rem utilized 100%.
    set /A TMP_NUM_JOBS=2 * %NUMBER_OF_PROCESSORS%
    echo Starting up to %TMP_NUM_JOBS% parallel processes.
    rem Determine the number of jobs to run in parallel
    set NUM_JOBS=--jobs=%NUMBER_OF_PROCESSORS%
) else (
    echo Using make.exe job option: %NUM_JOBS%
)

rem Select silent / verbose mode for make
if "%VERBOSE%" == "VERBOSE_OFF" (
    set VERBOSE=--silent
) else (
    set VERBOSE=
)


rem Start GNU Make with these options:
rem --no-builtin-rules
rem    Turn off GNU make built-in implicite rules
rem --jobs=N
rem    Configure make to run N jobs in parallel
rem --output-sync=line
rem    Forward output of make target scripts line by line, so output
rem    of parallel jobs is not mixed.

%MSYS%\make.exe ^
    --no-builtin-rules ^
    --output-sync=line ^
    %NUM_JOBS% ^
    BUILDMODE=%BUILDMODE% ^
    %VERBOSE% ^
    %TARGET%
