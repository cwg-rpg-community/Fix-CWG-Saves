@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Fix CWG Saves

echo ============================================================
echo                       Fix CWG Saves
echo ============================================================
echo.
echo  This will modify your CWG save folder:
echo    - A backup of CWG2 will be made in CustomMapData
echo    - The ACCOUNT_* and LEGACY_* files in CWG2 will be deleted (this will not break your save data)
echo    - ACCOUNT_VERIFY_*, HERO_*, ENTITLEMENT_*, AND SETTINGS_* files are KEPT (not deleted)
echo.
set "ANSWER="
set /p "ANSWER=Are you okay with your save folder being modified? [y/N]: "
if /I "%ANSWER%"=="Y" goto :confirmed
if /I "%ANSWER%"=="YES" goto :confirmed
echo.
echo Cancelled. No changes were made.
echo.
pause
exit /b 0

:confirmed
echo.

:: ------------------------------------------------------------
:: 1. Make sure Warcraft III is not running
:: ------------------------------------------------------------
set "WC3RUNNING="
for %%P in ("Warcraft III.exe" "War3.exe" "Frozen Throne.exe") do (
    tasklist /FI "IMAGENAME eq %%~P" /NH 2>nul | find /I "%%~P" >nul && set "WC3RUNNING=%%~P"
)
if defined WC3RUNNING goto :wc3_running
echo [OK] Warcraft III is not running.

:: ------------------------------------------------------------
:: 2. Find the current user's Documents folder
::    (works even if Documents is moved or synced to OneDrive)
:: ------------------------------------------------------------
::    (UTF-8 is forced so names with accents or non-Latin
::     characters are not garbled; falls back to %USERPROFILE%)
set "DOCS="
chcp 65001 >nul
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "[Console]::OutputEncoding=[Text.Encoding]::UTF8; [Environment]::GetFolderPath('MyDocuments')"`) do set "DOCS=%%D"
if not exist "%DOCS%\" set "DOCS=%USERPROFILE%\Documents"
if not exist "%DOCS%\" goto :no_docs
echo [OK] Documents folder: "%DOCS%"

:: ------------------------------------------------------------
:: 3. Check Warcraft III \ CustomMapData \ CWG2
:: ------------------------------------------------------------
set "WC3DIR=%DOCS%\Warcraft III"
set "CMDDIR=%WC3DIR%\CustomMapData"
set "CWGDIR=%CMDDIR%\CWG2"

if not exist "%WC3DIR%\" goto :no_wc3
echo [OK] Found "Warcraft III" folder.

if not exist "%CMDDIR%\" goto :no_cmd
echo [OK] Found "CustomMapData" folder.

if not exist "%CWGDIR%\" goto :no_cwg
echo [OK] Found "CWG2" folder.
echo.

:: ------------------------------------------------------------
:: 4. Back up CWG2 to CustomMapData\CWG2-backupYYYYMMDD
:: ------------------------------------------------------------
set "TODAY="
for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "Get-Date -Format yyyyMMdd"`) do set "TODAY=%%T"
if not defined TODAY goto :no_date

set "BACKUPNAME=CWG2-backup%TODAY%"
if not exist "%CMDDIR%\%BACKUPNAME%\" goto :do_backup

:: A backup from today already exists - keep it and add the time
for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "Get-Date -Format HHmmss"`) do set "NOW=%%T"
set "BACKUPNAME=CWG2-backup%TODAY%-%NOW%"
echo [INFO] A backup from today already exists, using "%BACKUPNAME%" instead.

:do_backup
set "BACKUPDIR=%CMDDIR%\%BACKUPNAME%"
echo Backing up CWG2 to "%BACKUPNAME%" ...
robocopy "%CWGDIR%" "%BACKUPDIR%" /E /COPY:DAT /R:1 /W:1 /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 goto :backup_failed
if not exist "%BACKUPDIR%\" goto :backup_failed
echo [OK] Backup created: "%BACKUPDIR%"
echo.

:: ------------------------------------------------------------
:: 5. Delete ACCOUNT_* and LEGACY_* files inside CWG2
::    IMPORTANT: ACCOUNT_VERIFY_* files are KEPT (not deleted).
:: ------------------------------------------------------------
set /a FOUND=0
set "DELFAILED="
for %%F in ("%CWGDIR%\ACCOUNT_*" "%CWGDIR%\LEGACY_*") do (
    set "FNAME=%%~nxF"
    if /I "!FNAME:~0,15!"=="ACCOUNT_VERIFY_" (
        echo [KEEP] !FNAME!
    ) else (
        set /a FOUND+=1
        del /F /Q "%%~fF" 2>nul
        if exist "%%~fF" set "DELFAILED=1"
    )
)

if %FOUND%==0 (
    echo [INFO] No ACCOUNT_* or LEGACY_* files to delete ^(ACCOUNT_VERIFY_* files are kept^).
    goto :finished
)

if defined DELFAILED goto :delete_failed
echo [OK] Deleted %FOUND% ACCOUNT_*/LEGACY_* file^(s^) from CWG2 ^(ACCOUNT_VERIFY_* kept^).

:finished
echo.
echo ============================================================
echo  DONE!
echo.
echo  NEXT STEP: Launch Warcraft III and run the CWG map in
echo  MULTIPLAYER, in a SOLO lobby - host it with just yourself.
echo.
echo  IF THIS DOESN'T WORK, RESTORE THE BACKUP:
echo    1. Close Warcraft III.
echo    2. Go to: "%CMDDIR%"
echo    3. Delete the "CWG2" folder.
echo    4. Rename "%BACKUPNAME%" to "CWG2".
echo ============================================================
echo.
pause
exit /b 0

:: ------------------------------------------------------------
:: Error handlers
:: ------------------------------------------------------------
:wc3_running
echo [ERROR] Warcraft III is currently running ^(%WC3RUNNING%^).
echo         Please close Warcraft III completely and run this file again.
goto :fail

:no_docs
echo [ERROR] Could not find your Documents folder.
goto :fail

:no_wc3
echo [ERROR] No "Warcraft III" folder was found in:
echo         "%DOCS%"
goto :fail

:no_cmd
echo [ERROR] No "CustomMapData" folder was found in:
echo         "%WC3DIR%"
goto :fail

:no_cwg
echo [ERROR] No "CWG2" folder was found in:
echo         "%CMDDIR%"
goto :fail

:no_date
echo [ERROR] Could not determine today's date. No changes were made.
goto :fail

:backup_failed
echo [ERROR] The backup could not be created. No files were deleted.
goto :fail

:delete_failed
echo [ERROR] Some ACCOUNT_* or LEGACY_* files could not be deleted.
echo         Make sure Warcraft III is closed and the files are not read-only,
echo         then try again. Your backup is safe at:
echo         "%BACKUPDIR%"
goto :fail

:fail
echo.
pause
exit /b 1
