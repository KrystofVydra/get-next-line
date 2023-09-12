@echo off
@rem 
@rem Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
@rem are protected worldwide. Copying, issuing to other parties or any kind of use,
@rem in whole or in part, is prohibited without prior permission. All rights -
@rem including industrial property rights - are reserved.

@echo ET_connect interface to read trace data
@rem Config
@set MODE="DBG"
@set XML="Output\Trace.xml"
@set CFG="Input\ET_connect_config.xml"
:: PRC options
::                                          FULL    PRE    POST    TEST    CONV
::Pre-Testing(Download+Run)                 X       X
::Testing(Testing + control ET)             X                      XML
::Post Testing(Stop + Read Trace data)      X              X               X
::Shutdown(close WinIDEA GUI)               X              X
@set PRC="FULL"

@echo.
@echo === Config =========================================================
echo  Parameter list:
echo    Mode:                    %MODE%
echo    Trace[xml]:              %XML%
echo    Config:                  %CFG%
echo    Process:                 %PRC%
@echo ====================================================================
@echo.

@echo.
echo   ...start build process
@rem Parse interface description and build tea file
ET_connect.exe ^
        --MODE %MODE% ^
        --XML %XML% ^
        --CFG %CFG% ^
        --PRC %PRC% ^
        --GUI ON >ET_connect_log.txt
echo   end.

pause