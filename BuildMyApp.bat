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
set SourceIncludings=%Sources%;%Sources%\util;%Sources%\logger;^
%Sources%\lib\synapse-r203-private1512


:SetPathToUsedLibs 
rem Create new named var for a new lib path and add to INCLUDE_DIRS below
rem Lib path
set D7Lib=%ProgramFiles%\borland\delphi7\lib
rem MadExcept
set MadCollection=%ProgramFiles%\madCollection
set MadExcept=%MadCollection%\madExcept\Delphi 7
set MadBasic=%MadCollection%\madBasic\Delphi 7
set MadDisasm=%MadCollection%\MadDisasm\Delphi 7
rem Add your lib vars below

rem END SetPathToUsedLibs


:startBuild
echo:
echo %me%
echo -------------------------------------------------------------------------------
echo:


:compileResources
echo Compile Resources...
setlocal
call "%SCRIPT_DIR%\CompileResource.bat" "%ProjectResources%\versioninfo\MyAppVersionInfo.rc"
endlocal
if errorlevel 1 ( 
  set ERRSTR=Resources Compilation failed
  goto error
)

set PROJECT_FILE=%SCRIPT_DIR%\Projects\%ProjectName%.dpr


echo CheckMyAppDprRequiredIfDefs...
setlocal
call "%SCRIPT_DIR%\CheckMyAppDprRequiredIfDefs.bat" "%PROJECT_FILE%"
endlocal
if errorlevel 1 ( 
  set ERRSTR=CheckMyAppDprRequiredIfDefs failed
  goto error
)

:compileProject
rem Compile params

set DEFINED_CONDITIONALS=Release;madExcept

: A8 Aligned record fields ON  
: C- Assretions OFF
: D- Debug information OFF          
: J- Writeable structured consts (OFF)
: L  Local debug symbols 
: O- Optimization OFF
: Q- Integer overflow checking OFF
: R- Range checking OFF
: Y  Symbol reference info
: W- Stack frames OFF
: I- I/O Checks OFF
rem Release
set COMP_DIRECTIVE=-B -Q -W- -H- -GD ^
-$A8 -$D- -$J- -$L- -$O- -$Q- -$R- -$Y- -$C- -$I- -$B- -$P+ -$H+
set SRC_DIRS=%SourceIncludings%
rem Add required lib's vars below
set INCLUDE_DIRS=%D7Lib%;%MadExcept%;%MadBasic%;%MadDisasm%;%SRC_DIRS%
set BIN_DIR=%SCRIPT_DIR%\Build\bin
set DCU_DIR=%SCRIPT_DIR%\Build\dcu
set RESOURCE_DIRS=%INCLUDE_DIRS%;%ProjectResources%

rem USAGE: 
rem   Compile.bat PROJECT_FILE DEFINED_CONDITIONALS COMP_DIRECTIVE SRC_DIRS INCLUDE_DIRS RESOURCE_DIRS BIN_DIR DCU_DIR
setlocal
call "%SCRIPT_DIR%\Compile.bat" "%PROJECT_FILE%" "%DEFINED_CONDITIONALS%" "%COMP_DIRECTIVE%" "%SRC_DIRS%" "%INCLUDE_DIRS%" "%RESOURCE_DIRS%" "%BIN_DIR%" "%DCU_DIR%"
endlocal
if errorlevel 1  ( 
  set ERRSTR=Compilation failed
  goto error
)


:madExceptPatchBinary
rem MadExceptPatching tool madExceptPatch File.exe
set MADEXTOOLS_DIR=%ProgramFiles%\madCollection\madExcept\Tools

rem USAGE: 
rem   MadExceptPatchExe.bat MadExceptTools ExePath MadExceptSettings
setlocal
call "%SCRIPT_DIR%\MadExceptPatchExe.bat" "%MADEXTOOLS_DIR%" ^
"%BIN_DIR%\%ProjectName%.exe" "%SCRIPT_DIR%\Projects\%ProjectName%.mes"
endlocal
if errorlevel 1 ( 
  set ERRSTR=MadExcept Patch failed
  goto error
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