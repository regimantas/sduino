@echo off
REM EEZ Studio LVGL 9.40 Compatibility Fixer (Windows Batch version)
REM 
REM This script fixes compatibility issues in EEZ Studio generated code for LVGL 9.40.
REM The main issue is that lv_obj_get_style_opa() now requires an lv_part_t enum 
REM instead of an integer.
REM
REM Usage:
REM   fix-lvgl940.bat <file.cpp> [<file.h>...]
REM   fix-lvgl940.bat --backup <file.cpp> [<file.h>...]

setlocal enabledelayedexpansion

set BACKUP=false
set FILES=

REM Parse arguments
:parse_args
if "%~1"=="" goto check_files
if "%~1"=="--backup" (
    set BACKUP=true
    shift
    goto parse_args
)
if "%~1"=="-b" (
    set BACKUP=true
    shift
    goto parse_args
)
if "%~1"=="--help" (
    goto show_help
)
if "%~1"=="-h" (
    goto show_help
)

REM Add to files list
set FILES=!FILES! "%~1"
shift
goto parse_args

:check_files
if "%FILES%"=="" (
    echo Error: No files specified
    goto show_help
)

REM Process each file
set TOTAL_CHANGES=0
for %%f in (%FILES%) do (
    if not exist %%f (
        echo Error: File not found: %%~f
    ) else (
        call :process_file %%f
    )
)

echo.
if !TOTAL_CHANGES! GTR 0 (
    echo Success: Fixed !TOTAL_CHANGES! instance^(s^)
) else (
    echo No changes were needed
)
goto :eof

:process_file
set FILE=%~1
echo Processing %FILE%...

REM Create backup if requested
if "%BACKUP%"=="true" (
    copy "%FILE%" "%FILE%.bak" >nul
    echo   Backup saved to %FILE%.bak
)

REM Use PowerShell to do the replacement
powershell -Command ^
    "$content = Get-Content '%FILE%' -Raw; ^
     $pattern = 'lv_obj_get_style_opa\(([^,]+),\s*0\s*\)'; ^
     $replacement = 'lv_obj_get_style_opa($1, LV_PART_MAIN)'; ^
     $matches = [regex]::Matches($content, $pattern); ^
     $count = $matches.Count; ^
     $newContent = $content -replace $pattern, $replacement; ^
     Set-Content '%FILE%' $newContent -NoNewline; ^
     Write-Host \"  Made $count replacement(s)\""

REM Update total
for /f "tokens=*" %%a in ('powershell -Command ^
    "$content = Get-Content '%FILE%' -Raw; ^
     $pattern = 'lv_obj_get_style_opa\([^,]+,\s*LV_PART_MAIN\s*\)'; ^
     $matches = [regex]::Matches($content, $pattern); ^
     $matches.Count"') do set CHANGES=%%a

if defined CHANGES (
    set /a TOTAL_CHANGES+=CHANGES
)

goto :eof

:show_help
echo EEZ Studio LVGL 9.40 Compatibility Fixer
echo.
echo Usage: %~nx0 [OPTIONS] ^<file1^> [file2 ...]
echo.
echo Options:
echo     -b, --backup    Create backup files before modifying (.bak extension)
echo     -h, --help      Show this help message
echo.
echo Example:
echo     %~nx0 eez-flow.cpp eez-flow.h
echo     %~nx0 --backup eez-flow.cpp eez-flow.h
echo.
echo What it fixes:
echo     lv_obj_get_style_opa(obj, 0) -^> lv_obj_get_style_opa(obj, LV_PART_MAIN)
exit /b 0
