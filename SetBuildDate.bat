REM CommandInterpreter: $(COMSPEC)
@echo off
:: Создает .inc файл с константами для использования в проекте,
:: константы содержат дату и время на момент запуска.
:: Использовать перед сборкой, чтобы в программа использовала новые константы.
:: Должен вызываться перед сборкой проекта.
:: В параметр передают путь к файлу куда записать данные, это позволяет создавать
:: такие файлы для любого проекта, указывая разные имена.
:: Принято здаваить имя в начале указывая имя проекта.
:: Пример: QportBuildDate.inc
setlocal enabledelayedexpansion  
setlocal
rem determine project top level directory from command file name
set PRJDIR=%~dp0   
::set me=%~n0
cd %PRJDIR%

set BUILD_DATE_FILE=%~1
if "%BUILD_DATE_FILE%" == "" (
  echo Usage: %~n0 output_file_path/filename.inc 
  echo ERROR output .inc file path not set.
  exit /b 1
) 

echo Create BuildDateFile '%BUILD_DATE_FILE%'

call :GetGurrentDateTime&set BUILD_YEAR=!current_year!&set BUILD_MONTH=!current_month!&set BUILD_DAY=!current_day!&set BUILD_TIME=!current_time!

echo const BUILD_YEAR = %BUILD_YEAR%;> "%BUILD_DATE_FILE%"
:: 3 letter name Apr for April
echo const BUILD_MONTH = '%BUILD_MONTH%';>> "%BUILD_DATE_FILE%"
echo const BUILD_DAY = %BUILD_DAY%;>> "%BUILD_DATE_FILE%"
echo const BUILD_TIME = '%BUILD_TIME%';>> "%BUILD_DATE_FILE%"

echo OK. Created '%BUILD_DATE_FILE%'

goto :EOF
echo Done
exit /b 0

:GetGurrentDateTime
rem GET CURRENT DATE
echo.>"%TEMP%\~.ddf"
makecab /D RptFileName="%TEMP%\~.rpt" /D InfFileName="%TEMP%\~.inf" -f "%TEMP%\~.ddf">nul
for /f "tokens=4,5,6,7" %%a in ('type "%TEMP%\~.rpt"') do (
	if not defined current_date ( 
		set "current_date=%%d-%%a-%%b"
		set "current_time=%%c"	 
    set "current_year=%%d"
    set "current_month=%%a"
    set "current_day=%%b"
	)
)
