REM CommandInterpreter: $(COMSPEC)
@echo off
rem This Script 
rem   Cleans temp files in project directory

rem Script name
set me=%~n0
set SCRIPT_DIR=%~dp0
IF %SCRIPT_DIR:~-1%==\ set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%

rem Usage: Clean [-i]
rem    -i  run in interactive mode 
set MODE=%1

echo %me%: Remove project temp files
echo.

if "%MODE%"=="-i" (
	pause
)
if exist Build (
  pushd Build
  del /s /f /q *.dcu *.exe > nul
  popd
)
del /s /f /q *.~* *.ddp *.rsm *.map *.gid *.drc *.tds *.gid *.cfg-build > nul

echo %me%: DONE
rem Run with -i to pause at the end
if "%MODE%"=="-i" (
	pause
)      
