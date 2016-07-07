REM CommandInterpreter: $(COMSPEC)
@echo off
set StartTime=%time%
title
setlocal EnableDelayedExpansion
set LF=^


rem this two empty lines a required to newline hack 

rem Script name
set me=%~n0
set SCRIPT_DIR=%~dp0
IF %SCRIPT_DIR:~-1%==\ set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

SET /a BuildTargetCount=0
SET /a FailedBuildCount=0
SET BuildResults=

set buildTargets=%SCRIPT_DIR%\BuildTargets.txt

:CountBuildTargets
echo %me%: Targets to build:
for /F "usebackq delims=" %%i IN ("%buildTargets%") DO (
   SET /a BuildTargetCount = !BuildTargetCount! + 1
   echo %me%: - %%i
)
echo %me%: Target count=%BuildTargetCount%
echo.

:BuildTargets
SET /a TargetNo=0
for /F "usebackq delims=" %%i IN ("%buildTargets%") DO (   
   set /a TargetNo=!TargetNo!+1        
   echo %me%: == Start build[!TargetNo!/%BuildTargetCount%]: %%i ==   
   if !FailedBuildCount! neq 0 (
      Title Build Target !TargetNo!/%BuildTargetCount%, failed !FailedBuildCount! - %%i   
   ) else (
      Title Build Target !TargetNo!/%BuildTargetCount% - %%i 
   )
   setlocal           
   call "%SCRIPT_DIR%\%%i"   
   endlocal         
   if errorlevel 1 (
      call :addBuildResult %%i 1
   ) else (
      call :addBuildResult %%i 0   
   )
   echo %me%: == Finished build[!TargetNo!/%BuildTargetCount%]: %%i ==
)

:end
echo:
if !FailedBuildCount! neq 0 (
  title %me% - FAILED
  echo %me%: FAILED. !FailedBuildCount! of !BuildTargetCount! failed.
  ECHO !BuildResults! 
  call :printTimings
  exit /b 1
)
title %me% - OK
ECHO %me%: OK. Built !BuildTargetCount! target(s).
ECHO !BuildResults! 
call :printTimings 
exit /b 0


rem Functions

rem addBuildResult %errorlevel% %testname%
:addBuildResult
if %2 neq 0 (
  SET "BuildResults=!BuildResults! !LF!# %1: FAIL"  
  SET /a FailedBuildCount = !FailedBuildCount! + 1
) else (
  SET "BuildResults=!BuildResults! !LF!* %1: OK"
)
goto :eof



:printTimings
   ECHO.
   ECHO %me%: -- Time report --
   ECHO %me%: Started  %StartTime%
   ECHO %me%: Finished %time%
goto:EOF