REM CommandInterpreter: $(COMSPEC)
@echo off
rem Script name
set me=%~n0
rem Compiller path
if "%Delphi7Bin%"=="" (
  set ERRSTR=Delphi Delphi7Bin ENV var not set. Set it
  goto :error
)
set DCC32=%Delphi7Bin%\dcc32.exe

rem DPR filepath
set PROJECT_FILE=%~1&set PROJECT_FILE_DIR=%~dp1&set PROJECT_FILE_NAME=%~nx1
rem Conditional defines for compiler
set DEFINED_CONDITIONALS=%~2
rem Compiler directives
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
set COMP_DIRECTIVE=%~3
rem Semicolumn devided path list
set SRC_DIRS=%~4
rem INCLUDE libs dir semicolumn devided path list
set INCLUDE_DIRS=%~5
rem Path to RC files
set RESOURCE_DIRS=%~6
rem Path to directory for compiled files (exe, bpl, dll, etc.)
set BIN_DIR=%~7
rem Path to directory for DCU files
set DCU_DIR=%~8

:echo PROJECT_FILE %PROJECT_FILE%
:echo PROJECT_FILE_DIR %PROJECT_FILE_DIR%
:echo PROJECT_FILE_NAME %PROJECT_FILE_NAME%
:echo DEFINED_CONDITIONALS %DEFINED_CONDITIONALS%
:echo COMP_DIRECTIVE %COMP_DIRECTIVE%
:echo SRC_DIRS %SRC_DIRS%
:echo:
:echo INCLUDE_DIRS %INCLUDE_DIRS%
:echo:
:echo RESOURCE_DIRS %RESOURCE_DIRS%
:echo:
:echo BIN_DIR %BIN_DIR%
:echo:
:echo DCU_DIR %DCU_DIR%


rem Check vars
if "%~1"=="" echo %me%: [ERROR] Argument PROJECT_FILE not provided & goto :usage
if "%~2"=="" echo %me%: [ERROR] Argument DEFINED_CONDITIONALS not provided & goto :usage
if "%~3"=="" echo %me%: [ERROR] Argument COMP_DIRECTIVE not provided & goto :usage
if "%~4"=="" echo %me%: [ERROR] Argument SRC_DIRS not provided & goto :usage
if "%~5"=="" echo %me%: [ERROR] Argument INCLUDE_DIRS not provided & goto :usage
if "%~6"=="" echo %me%: [ERROR] Argument RESOURCE_DIRS not provided & goto :usage
if "%~7"=="" echo %me%: [ERROR] Argument BIN_DIR not provided & goto :usage
if "%~8"=="" echo %me%: [ERROR] Argument DCU_DIR not provided & goto :usage
goto :compile


:usage
  echo:
  echo USAGE: 
  echo   %~nx0 PROJECT_FILE DEFINED_CONDITIONALS COMP_DIRECTIVE SRC_DIRS INCLUDE_DIRS RESOURCE_DIRS BIN_DIR DCU_DIR
  echo:
  echo Example: %~nx0^
   "C:\project\test.dpr"^
   "RELEASE;FastMM4;madExcept"^
   "-$A8 -$D- -$J- -$L- -$O- -$Q- -$R- -$Y- -$C- -$I- -$B- -$P+ -$H+"^
   "C:\project\source"^
   "D:\Libs"^
   "C:\project\resources"^
   "C:\project\build\bin\"^
   "C:\project\build\dcu\"^  
   set errorCode=2
goto :end


:compile
  echo %me%: compilling %PROJECT_FILE_NAME%
  echo: 
  IF NOT EXIST "%DCC32%" (
    set ERRSTR=Delphi Compiler NOT FOUND at %DCC32%
    goto error
  )   
  
  pushd "%PROJECT_FILE_DIR%"     
  
  call :ClearTempCfg
  call :HideOriginalCfg        
  echo:
  echo Compilling the code...              
  "%DCC32%" %COMP_DIRECTIVE% ^
   -U"%INCLUDE_DIRS%" -R"%RESOURCE_DIRS%" -I"%INCLUDE_DIRS%" ^
   -E"%BIN_DIR%" -LE"%DCU_DIR%" -LN"%DCU_DIR%" -N0"%DCU_DIR%" ^
   -D%DEFINED_CONDITIONALS% %PROJECT_FILE_NAME%    
  IF errorlevel 1 (  
    call :RestoreCfg        
    set errorCode=1        
    goto error
  )  
  call :RestoreCfg     
  call :ClearDcu    
  echo:
  echo %me%: OK  
  set errorCode=0    
goto :end


:error
  echo:
  echo:
  echo %me%: FAIL %ERRSTR%
  echo: 
goto :end
  
:end
  popd
  exit /b %errorCode%
  
rem ----------------------------------------------------------------------------
rem Functions
rem ----------------------------------------------------------------------------
  
:ClearTempCfg
  echo Clear temp *.cfg-build files
  IF EXIST *.cfg-build del /q *.cfg-build 
GOTO:EOF


:HideOriginalCfg    
  echo Hide original *.cfg files
  IF EXIST *.cfg ren *.cfg *.cfg-build
GOTO:EOF
 

:RestoreCfg    
  echo Restore original *.cfg files
  IF EXIST *.cfg-build ren *.cfg-build *.cfg   
GOTO:EOF


:ClearDcu    
  echo Remove *.dcu files
  IF EXIST *.dcu del /s /f /q *.dcu %DCU_DIR% 1>nul
GOTO:EOF