@echo off
@rem 
@rem Copyright(c) 2015 Leopold Kostal GmbH & Co. KG. Content and presentation
@rem are protected worldwide. Copying, issuing to other parties or any kind of use,
@rem in whole or in part, is prohibited without prior permission. All rights -
@rem including industrial property rights - are reserved.

@echo EventTracer BTF converter
@rem Config
@set IN="Input\Trace.xml"
@set ID="Input\ET_ID.txt"
@set BTF="Output\ET_TraceData.btf"
@set PREEMPT="ON"

@echo.
@echo === Config =========================================================
echo  Parameter list:
echo    Trace In:                %IN%
echo    ET ID file               %ID%
echo    BTF:                     %BTF%
echo    PREEMPT:                 %PREEMPT%
@echo ====================================================================
@echo.

@echo.
echo   ...start build process
@rem convert xml Trace to BTF file
ET_BTFConv ^
        --IN  %IN% ^
        --ID  %ID% ^
        --BTF %BTF% ^
        --PREEMPT %PREEMPT% >log.txt
echo   end.

pause
