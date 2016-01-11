REM CommandInterpreter: $(COMSPEC)
@echo off
rem Script name
set me=%~n0
rem Path to madExcept Tools
set MadExceptTools=%~1
set ExePath=%~2&set ExeDir=%~dp2&set ExeFileName=%~nx2
set MadExceptSettings=%~3

rem Check vars
if "%MadExceptTools%"=="" echo %me%: [ERROR] Argument MadExceptTools ^
not provided. Write path to madExcept Tools dir. & goto :usage
if "%ExePath%"=="" echo %me%: [ERROR] Argument ExePath not provided. ^
Write full path to Exe. & goto :usage
if "%MadExceptSettings%"=="" echo %me%: [ERROR] Argument MadExceptSettings ^
not provided. Write path to .mes file. & goto :usage
goto :patch


:usage
  echo:
  echo USAGE: 
  echo   %~nx0 MadExceptTools ExePath MadExceptSettings
  echo:
  echo Example: %~nx0^
   "%ProgramFiles%\madCollection\MadExcept\Tools"^
   "C:\project\build\bin\MyApp.exe"^
   "C:\project\Source\Projects\MyApp.mes"
  set errorCode=2
goto :end

:patch
  echo %me%: patching %ExePath%
  echo: 
  IF NOT EXIST "%MadExceptTools%\madExceptPatch.exe"  (
    set ERRSTR=Patcher not found at %MadExceptTools%
    goto error
  )   
  rem MadExceptPatch has an internal check if .map file exists
    
  echo Patching...      
  "%MadExceptTools%\madExceptPatch.exe" "%ExePath%" "%MadExceptSettings%"
  IF ERRORLEVEL 1 (    
    set ErrorCode=1        
    goto error
  )  
  echo:
  echo %me%: OK
  set ErrorCode=0
goto :end

:error
  echo:
  echo %me%: FAIL %ERRSTR%
  echo:   
goto :end
  
:end
  popd
  exit /b %ErrorCode%