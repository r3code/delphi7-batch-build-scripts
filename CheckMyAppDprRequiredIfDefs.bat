@echo off

:: Check if Changelog.txt has a record for version set in VersionInfo.rc
:: %1 - path to dpr file
call :checkChangelogUpdated "%~1" "%~2"
goto :EOF

:checkChangelogUpdated
setlocal enabledelayedexpansion
set DPR_FILE=%~1

echo Check RunCid required IFDEFs

if "%~1"=="" (
  echo Param #1 not set - No DPR file path set
  exit /b 1 
)


if NOT EXIST "%DPR_FILE%" (
  echo DPR file '%DPR_FILE%' not exist
  exit /b 1 
)

call :CheckFastMMIfDef
if errorlevel 1 (
  echo [ERROR] IFDEF for FastMM  invalid or not found. It MUST be first unit in DPR file and wrapped in $IFDEF Debug
  exit /b 1
)


call :CheckMadExceptIfDef
if errorlevel 1 (
  echo [ERROR] IFDEF for MadExcept invalid or not found. It MUST be madExcept units in DPR file and wrapped in $IFDEF madExcept
  exit /b 1
)


echo Check RunCid required IFDEFs: OK
exit /b 0




:CheckFastMMIfDef
set TEXT_LINE=

SET MATCH_FLAGS=
SET /A LINE_NO=0
SET /A LAST_MATCHED_LINE_NO=0
SET /A EXPECTED_NEXT_LINE_NO=0

for /f "tokens=*" %%i in ('type "!DPR_FILE!"') do (
  SET /A LINE_NO=!LINE_NO!+1 
	set TEXT_LINE=%%i
  
  if "!MATCH_FLAGS!"=="UI" (   
    for /f "tokens=*" %%i in ('echo "!TEXT_LINE!" ^| find /I "FastMM"') do ( 
      echo - FastMM Found 
      SET MATCH_FLAGS=!MATCH_FLAGS!F
      SET /A EXPECTED_NEXT_LINE_NO=!LAST_MATCHED_LINE_NO!+1
     
      if !EXPECTED_NEXT_LINE_NO! neq !LINE_NO! ( 
        echo ERROR FastMM not first after IfDef
        exit /b 1
      )
      if "!MATCH_FLAGS!"=="UIF" ( 
        exit /b 0
      )
      exit /b 1
    )
  )
     
  if "!MATCH_FLAGS!"=="U" (
    for /f "tokens=*" %%i in ('echo "!TEXT_LINE!" ^| find /I "$IFDEF"') do ( 
      echo - $IFDEF Found
      SET MATCH_FLAGS=!MATCH_FLAGS!I
      SET /A EXPECTED_NEXT_LINE_NO=!LAST_MATCHED_LINE_NO!+1
      if !EXPECTED_NEXT_LINE_NO! neq !LINE_NO! (
        echo ERROR IfDef not first after uses
        exit /b 1
      ) 
      SET /A LAST_MATCHED_LINE_NO=!LINE_NO!
    ) 
  )  
   
  if not "!MATCH_FLAGS!"=="U" (
    for /f "tokens=*" %%i in ('echo "!TEXT_LINE!" ^| find /I "uses"') do ( 
      echo - USES_FOUND Found
      SET MATCH_FLAGS=!MATCH_FLAGS!U
      SET /A LAST_MATCHED_LINE_NO=!LINE_NO!
    )  
  )
)
if not  "!MATCH_FLAGS!"=="UIF" (
  exit /b 1
)
goto :eof



:CheckMadExceptIfDef
set TEXT_LINE=

SET MATCH_FLAGS=
SET /A LINE_NO=0
SET /A LAST_MATCHED_LINE_NO=0
SET /A EXPECTED_NEXT_LINE_NO=0

for /f "tokens=*" %%i in ('type "!DPR_FILE!"') do (
  SET /A LINE_NO=!LINE_NO!+1 
	set TEXT_LINE=%%i
  
  if "!MATCH_FLAGS!"=="I" (
rem found subsring if after replacement the replaced left string 
rem NOT remains the same, matching string replaced to NONE
    if NOT "!TEXT_LINE!"=="!TEXT_LINE:madExcept,=!" (
      echo - madExcept Unit Found 
      SET MATCH_FLAGS=!MATCH_FLAGS!F
      SET /A EXPECTED_NEXT_LINE_NO=!LAST_MATCHED_LINE_NO!+1
     
      if !EXPECTED_NEXT_LINE_NO! neq !LINE_NO! ( 
        echo ERROR madExcept not first after $IfDef madExcept
        exit /b 1
      )
      if "!MATCH_FLAGS!"=="IF" ( 
        exit /b 0
      )
    )    
  )
   
  if not "!MATCH_FLAGS!"=="I" (    
    if NOT "!TEXT_LINE!"=="!TEXT_LINE:$IFDEF madExcept=!" (
      echo - $IFDEF madExcept Found
      SET MATCH_FLAGS=!MATCH_FLAGS!I
      SET /A LAST_MATCHED_LINE_NO=!LINE_NO!
    )  
  )
)
if not  "!MATCH_FLAGS!"=="IF" (
  exit /b 1
)
goto :eof

rem %~1 text, %~2 - subtext 
rem Case Insensitive, not working with strings containing '=' '~'
:containsText
SET TEXT=%~1
SET SUBTEXT=%~2
if NOT "%TEXT%"=="%TEXT:!SUBTEXT!=%" (
   
  echo containsText !TEXT!, !SUBTEXT! TRUE
  echo !TEXT_LINE!
  
)

goto :eof