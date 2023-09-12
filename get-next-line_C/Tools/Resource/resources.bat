@echo off
@rem 
@rem Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
@rem are protected worldwide. Copying, issuing to other parties or any kind of use,
@rem in whole or in part, is prohibited without prior permission. All rights -
@rem including industrial property rights - are reserved.

@rem automatic analysis of resources
@echo automatic analysis of resources
@rem Config
@set CFG="settings\resource_config.xml"

@echo.
@echo === Config =========================================================
echo  File list:
echo    Config:                  %CFG%
@echo ====================================================================
@echo.

@echo.
echo   ...start resource analysis
@rem Parse and analyze GHS map file
resource.exe  ^
        --CFG %CFG% >log.txt
echo   end.

pause