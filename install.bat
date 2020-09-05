set RECOTTE_STUDIO="C:\Program Files\RecotteStudio"

set DST_DIR=%~dp0dst
openfiles > nul
if errorlevel 1 (
    PowerShell.exe -Command Start-Process \"%~f0\" -ArgumentList %DST_DIR% -Verb runas
    exit
)

echo %date% %time% >> "%RECOTTE_STUDIO:"=%\uh_install.txt"
xcopy /s /y %1\* "%RECOTTE_STUDIO:"=%\effects\" >> "%RECOTTE_STUDIO:"=%\uh_install.txt"
echo. >> "%RECOTTE_STUDIO:"=%\uh_install.txt"

REM call notepad "%RECOTTE_STUDIO:"=%\uh_install.txt"