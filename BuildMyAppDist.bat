REM CommandInterpreter: $(COMSPEC)
@echo off
rem Script name
set me=%~n0
set SCRIPT_DIR=%~dp0
IF %SCRIPT_DIR:~-1%==\ set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%


:SetGeneralsettings
set ProjectName=MyApp


:SetPathToProjectFiles
set ProjectResources=%SCRIPT_DIR%\Resources
set Sources=%SCRIPT_DIR%\Source


:startBuild
echo:
echo %me% - Check all files ready to be publised then build
echo -------------------------------------------------------------------------------
echo: 


:CheckChangelogUpdated
echo CheckChangelogUpdated...
setlocal
call "%SCRIPT_DIR%\CheckChangelogUpdated.bat" "%ProjectResources%\versioninfo\MyAppVersionInfo.rc" "%SCRIPT_DIR%\doc\Changelog.txt"
endlocal
if errorlevel 1 ( 
  set ERRSTR=CheckChangelogUpdated failed
  goto :error
)

:buildProject
setlocal
call "%SCRIPT_DIR%\BuildMyApp.bat"
endlocal
if errorlevel 1 ( 
  set ERRSTR=Build Error
  goto :error
)

:allOK
rem When all OK
echo:
echo:
echo -------------------------------------------------------------------------------
echo %me%: OK
echo ===============================================================================
echo:
set errorCode=0
goto :end


:error
  echo:
  echo #############################################################################
  echo %me%: FAIL %ERRSTR%
  echo =============================================================================
  set errorCode=1
goto :end


:end
  exit /b %errorCode% 