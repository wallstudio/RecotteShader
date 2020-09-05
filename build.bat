set COMPILER="C:\Program Files (x86)\Windows Kits\10\bin\10.0.18362.0\x64\fxc.exe"

rd /s /q dst
mkdir dst
mkdir dst\effects
mkdir dst\transitions

copy uh_effect.lua dst\effects\
copy uh_effect.png dst\effects\
copy uh_effect_ctr.lua dst\effects\
copy uh_effect_ctr.png dst\effects\
copy uh_effect_edge.lua dst\effects\
copy uh_effect_edge.png dst\effects\
copy uh_dummy.lua dst\transitions\
copy uh_dummy.png dst\transitions\

%COMPILER% /T ps_4_0 uh_effect.hlsl /Fo dst\uh_effect.cso /Fc shader_asm\uh_effect.hlsl
%COMPILER% /T ps_4_0 uh_effect_ctr.hlsl /Fo dst\uh_effect_ctr.cso /Fc shader_asm\uh_effect_ctr.hlsl
%COMPILER% /T ps_4_0 uh_effect_edge.hlsl /Fo dst\uh_effect_edge.cso /Fc shader_asm\uh_effect_edge.hlsl
%COMPILER% /T ps_4_0 uh_dummy.hlsl /Fo dst\uh_dummy.cso /Fc shader_asm\uh_dummy.hlsl