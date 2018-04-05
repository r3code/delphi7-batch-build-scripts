@echo off

:: Check if Changelog.txt has a record for version set in VersionInfo.rc
:: Changelog.txt MUST have record in a format of A.B.C matching MAJOR.MINOR.RELEASE in VersionInfo.rc 

call :checkChangelogUpdated "%~1" "%~2"

goto :EOF

:checkChangelogUpdated
setlocal enabledelayedexpansion
set rcfile=%~1
set rcfiledir=%~dp1
set rcfilename=%~nx1

set changelog=%~2
set changelogDir=%~dp2
set changelogFile=%~nx2

if "%~1"=="" (
  echo Param #1 not set - No Vesrion Resource file path set
  exit /b 1 
)

if "%~2"=="" (
  echo Param #2 not set - No Vesrion Changelog file path set
  exit /b 1 
)

if NOT EXIST "%rcfile%" (
  echo Vesrion Resource file '%rcfile%' not exist
  exit /b 1 
)
if NOT EXIST "%changelog%" (
  echo Vesrion Changelog file '%changelog%' not exist
  exit /b 1 
)

:: parse Version from RC file
pushd "%rcfiledir%"
set VERSION=
set SHORT_VERSION=
for /f "eol=; tokens=1,2,3,4,5,6 delims=, " %%i in (%rcfilename%) do (
    if "%%i"=="FILEVERSION" (
      set MAJOR_VERSION=%%j
      set MINOR_VERSION=%%k
      set RELEASE_VERSION=%%l
      set BUILD_VERSION=%%m
      set VERSION=!MAJOR_VERSION!.!MINOR_VERSION!.!RELEASE_VERSION!.!BUILD_VERSION!
      set SHORT_VERSION=!MAJOR_VERSION!.!MINOR_VERSION!.!RELEASE_VERSION!
    )
)
popd
if "%VERSION%"=="" (
  echo Error Version Resource file does not contain version info
  exit /b 1
) else (
  echo RC-file '%rcfilename%' Version Info: %VERSION% 
)

:: try find version in Changelog file
pushd "%changelogDir%"
for /F "delims=, tokens=1*" %%f in (%changelogFile%) do (
  ::echo --- %%f
  SET LINE=%%f
rem  echo !LINE!
rem trick to check string contains
rem replace substring in string, it only replace if substring found
rem so if no substring in string, then result string contains the same string
rem else result doesn't match original string
  SET SUBSTRING_REMOVED=!LINE:%SHORT_VERSION%=!
rem  echo !SUBSTRING_REMOVED!
  if NOT "!LINE!"=="!SUBSTRING_REMOVED!" (
    popd
    echo LINE FOUND: !LINE!
    echo OK: Changelog file '%changelogFile%' has '!SHORT_VERSION!' record
    exit /b 0 && goto :EOF
  )
)
popd
echo ERROR: Changelog file '%changelogFile%' does not have '!SHORT_VERSION!' record
exit /b 1  && goto :EOF

