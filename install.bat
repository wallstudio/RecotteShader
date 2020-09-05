set RECOTTE="C:\Program Files\RecotteStudio"


set CURRENT_DIR=%~dp0
openfiles > nul
if errorlevel 1 (
    PowerShell.exe -Command Start-Process \"%~f0\" -ArgumentList %CURRENT_DIR% -Verb runas
    exit
)
cd %CURRENT_DIR%


echo %date% %time% >> "%RECOTTE:"=%\uh_install.txt"
xcopy /s /y .\dst\* "%RECOTTE:"=%\effects\" >> "%RECOTTE:"=%\uh_install.txt"
echo. >> "%RECOTTE:"=%\uh_install.txt"

call notepad "%RECOTTE:"=%\uh_install.txt"