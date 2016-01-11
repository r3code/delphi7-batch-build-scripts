REM CommandInterpreter: $(COMSPEC)
@echo off
rem This Script 
rem - builds Delphi DUnit Test for the Project; 
rem - run tests and returns test result as exit code. 

rem Script name
set me=%~n0
set SCRIPT_DIR=%~dp0
IF %SCRIPT_DIR:~-1%==\ set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%


:SetGeneralsettings
set ProjectName=TestMyApp


:SetPathToProjectFiles
set Sources=%SCRIPT_DIR%\Source
set SourceIncludings=%Sources%;^
%Sources%\logger


:SetPathToUsedLibs 
rem Create new named var for a new lib path and add to INCLUDE_DIRS below
set D7Lib=%ProgramFiles%\borland\delphi7\lib
rem MadExcept
set MadCollection=%ProgramFiles%\madCollection
set MadExcept=%MadCollection%\madExcept\Delphi 7
set MadBasic=%MadCollection%\madBasic\Delphi 7
set MadDisasm=%MadCollection%\MadDisasm\Delphi 7
rem DUnit Test Framework
set DUnit=%DelphiCommonLibs%\DUnit\DUnit-9.3\src\
rem Add your lib vars below

rem END SetPathToUsedLibs


:startBuild
echo:
echo %me%
echo -------------------------------------------------------------------------------
echo:


:compileProject
set PROJECT_FILE=%SCRIPT_DIR%\Projects\%ProjectName%.dpr
set DEFINED_CONDITIONALS=DUNIT_CONSOLE_MODE

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
rem NOTE: -CC Console Target
set COMP_DIRECTIVE=-B -Q -W- -H- -CC ^
-$A8 -$D- -$J- -$L- -$O- -$Q- -$R- -$Y- -$C- -$I- -$B- -$P+ -$H+
set SRC_DIRS=%SourceIncludings%
rem Place INCLUDE_DIRS values in alphabetical order 
set INCLUDE_DIRS=%D7Lib%;%DUnit%;%MadExcept%;%MadBasic%;%MadDisasm%;^
%SuperObject%;%RegExpr%;%SRC_DIRS%
set BIN_DIR=%SCRIPT_DIR%\Build\bin
set DCU_DIR=%SCRIPT_DIR%\Build\dcu
set Resources=%SCRIPT_DIR%\Resources

rem USAGE: 
rem   Compile.bat PROJECT_FILE DEFINED_CONDITIONALS COMP_DIRECTIVE SRC_DIRS INCLUDE_DIRS Resources BIN_DIR DCU_DIR
setlocal
call "%SCRIPT_DIR%\Compile.bat" "%PROJECT_FILE%" "%DEFINED_CONDITIONALS%" "%COMP_DIRECTIVE%" "%SRC_DIRS%" "%INCLUDE_DIRS%" "%Resources%" "%BIN_DIR%" "%DCU_DIR%"
endlocal
if errorlevel 1  ( 
  set ERRSTR=Compilation failed
  goto error
)


:runTest
echo:
echo %me%: Run testing...
"%BIN_DIR%\%ProjectName%.exe"
if errorlevel 1  ( 
  set ERRSTR=Test failed
  goto error
)


:allOk
rem When all OK
echo:
echo -------------------------------------------------------------------------------
echo %me%: OK - Built and Tested
echo ===============================================================================
echo:
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
  