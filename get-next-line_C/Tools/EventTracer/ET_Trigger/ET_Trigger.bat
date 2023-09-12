@echo off
@rem 
@rem Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
@rem are protected worldwide. Copying, issuing to other parties or any kind of use,
@rem in whole or in part, is prohibited without prior permission. All rights -
@rem including industrial property rights - are reserved.

@echo ET_connect interface to write ET Trigger var
@rem Config
@set CFG="Input\ET_Trigger_config.xml"

@echo.
@echo === Config =========================================================
echo  Parameter list:
echo    Config:                  %CFG%
@echo ====================================================================
@echo.

@echo.
echo   ...start
@rem Parse interface description and build tea file
ET_Trigger.exe ^
        --CFG %CFG% ^
        --GUI OFF >ET_Trigger_log.txt
echo   end.

pause