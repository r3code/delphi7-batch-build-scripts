REM CommandInterpreter: $(COMSPEC)
@echo off
rem Script name
set me=%~n0
rem Compiller path
if "%Delphi7Bin%"=="" (
  set ERRSTR=Delphi Delphi7Bin ENV var not set. Set it
  goto :error
)
set BRCC32=%Delphi7Bin%\BRCC32.exe

rem Resource
set ResourcePath=%~1&set ResourceDir=%~dp1&set Resource=%~nx1
set IncludeDirs=%~2
set CompiledResPath=%~3

rem Check vars
if "%ResourcePath%"=="" echo %me%: [ERROR] Argument ResourcePath not provided & goto :usage
if "%IncludeDirs%"=="" echo %me%: Include dirs not provided, use current
if "%CompiledResPath%"=="" (
  SET "CompiledResPath=%ResourcePath%"
  CALL SET CompiledResPath=%%CompiledResPath:.rc=.res%%   
  echo Used default CompiledResPath %CompiledResPath% 
)
goto :compile


:usage
  echo:
  echo USAGE: 
  echo   %~nx0 ResourcePath [IncludeDirs] [CompiledResPath]
  echo   By default a compiled resource placed in the Resource directory 
  echo:
  echo Example: %~nx0^
   "C:\project\resources\VersionInfo.rc"^
   "C:\project\resources\VersionInfo.res"^     
  echo    or %~nx0 "C:\project\resources\MainIcon.rc"
  echo    will create MainIcon.res 
  set errorCode=1
goto :end


:compile
  if EXIST "%CompiledResPath%" (
    echo %me%: Clear existing compiled resource
    del /s /f /q "%CompiledResPath%"
  ) 
  echo %me%: compilling %Resource%
  echo: 
  IF NOT EXIST "%BRCC32%" (
    set ERRSTR=Delphi Resource Compiler NOT FOUND at %BRCC32%
    goto error
  )   
  
  pushd "%ResourceDir%" 
  
  echo:
  echo Compilling Resource...   
  "%BRCC32%" -c1251 -l1049 -i"%IncludeDirs%" -fo"%CompiledResPath%" "%ResourcePath%"   
  IF errorlevel 1 (  
    set errorCode=1        
    goto error
  )   
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
