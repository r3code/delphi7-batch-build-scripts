REM CommandInterpreter: $(COMSPEC)
@echo off
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

set buildTargets=BuildMyApp.bat TestMyApp.bat

:CountBuildTargets
for %%a in (%buildTargets%) do (
   SET /a BuildTargetCount = !BuildTargetCount! + 1
)

:BuildTargets
(for %%a in (%buildTargets%) do (
   setlocal   
   call "%SCRIPT_DIR%\%%a"
   endlocal  
   if errorlevel 1 (
      call :addBuildResult %%a 1
   ) else (
      call :addBuildResult %%a 0   
   )
))

:end
echo:
if !FailedBuildCount! neq 0 (
  echo %me%: FAILED. !FailedBuildCount! of !BuildTargetCount! failed.
  ECHO !BuildResults!
  exit /b 1
)
ECHO %me%: OK. Successfully built !BuildTargetCount! target(s).
ECHO !BuildResults!  
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