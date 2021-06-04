set RECOTTE="C:\Program Files\RecotteStudio"
set RECOTTE=%RECOTTE:"=%


set CURRENT_DIR=%~dp0
openfiles > nul
if errorlevel 1 (
    PowerShell.exe -Command Start-Process \"%~f0\" -ArgumentList %CURRENT_DIR% -Verb runas
    exit
)
cd %RECOTTE%
set PROJECT=%1
set PROJECT=%PROJECT:"=%

REM rem [Lib]
set FILE_NAME=lib
del effects\%FILE_NAME%.lua
cmd /c mklink effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"

REM rem [ShaderEffects]
set FILE_NAME=uh_effect
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_ctr
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_edge
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_nv
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_2bc
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_softB
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_bloom
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_rim
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_rotate
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"
set FILE_NAME=uh_effect_rotate2
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"

REM rem [SimpleEffects]
set FILE_NAME=uh_effect_exp3D
del effects\effects\%FILE_NAME%.lua
del effects\effects\%FILE_NAME%.png
cmd /c mklink effects\effects\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\effects\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"

REM rem [Transitions]
set FILE_NAME=uh_dummy
del effects\transitions\%FILE_NAME%.lua
del effects\transitions\%FILE_NAME%.png
cmd /c mklink effects\transitions\%FILE_NAME%.lua "%PROJECT%\%FILE_NAME%.lua"
cmd /c mklink effects\transitions\%FILE_NAME%.png "%PROJECT%\%FILE_NAME%.png"

REM rem [Shader]
set FILE_NAME=uh_effect
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"
set FILE_NAME=uh_effect_ctr
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"
set FILE_NAME=uh_effect_edge
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"
set FILE_NAME=uh_effect_nv
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"
set FILE_NAME=uh_effect_2bc
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"
set FILE_NAME=uh_effect_softB
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"
set FILE_NAME=uh_effect_bloom
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"
set FILE_NAME=uh_effect_rim
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"
set FILE_NAME=uh_effect_rotate
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"

set FILE_NAME=uh_dummy
del effects\%FILE_NAME%.cso
cmd /c mklink effects\%FILE_NAME%.cso "%PROJECT%\dst\%FILE_NAME%.cso"

pause