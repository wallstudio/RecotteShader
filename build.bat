@echo off

set COMPILER="C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x64\fxc.exe"
set ZIP_FILENAME="recotte_shader.zip"
set ZIP_WOKING_DIR="RecotteShader"


@REM Clan
for /r %%i in (effects\*.cso) do (
    del /Q %%i
)
for /r %%i in (text\*.cso) do (
    del /Q %%i
)
for /r %%i in (transitions\*.cso) do (
    del /Q %%i
)
del %ZIP_FILENAME%
rd /S /Q %ZIP_WOKING_DIR%


@REM Build
for /r %%i in (effects\*.hlsl) do (
    %COMPILER% /T ps_4_0 "%%i" /Fo "%%~dpni.cso" /Fc "shader_asm\effects\%%~nxi"
)
for /r %%i in (text\*.hlsl) do (
    %COMPILER% /T ps_4_0 "%%i" /Fo "%%~dpni.cso" /Fc "shader_asm\text\%%~nxi"
)
for /r %%i in (transitions\*.hlsl) do (
    %COMPILER% /T ps_4_0 "%%i" /Fo "%%~dpni.cso" /Fc "shader_asm\transitions\%%~nxi"
)


@REM Pack
mkdir %ZIP_WOKING_DIR%
copy README.md %ZIP_WOKING_DIR%\README.md
copy LICENSE %ZIP_WOKING_DIR%\LICENSE
xcopy lib %ZIP_WOKING_DIR%\lib\
xcopy effects %ZIP_WOKING_DIR%\effects\
xcopy text %ZIP_WOKING_DIR%\text\
xcopy transitions %ZIP_WOKING_DIR%\transitions\
PowerShell.exe -Command Compress-Archive -Path %ZIP_WOKING_DIR% -DestinationPath %ZIP_FILENAME%
rd /S /Q %ZIP_WOKING_DIR%