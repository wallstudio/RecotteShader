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
copy uh_effect_nv.lua dst\effects\
copy uh_effect_nv.png dst\effects\
copy uh_effect_2bc.lua dst\effects\
copy uh_effect_2bc.png dst\effects\
copy uh_effect_softB.lua dst\effects\
copy uh_effect_softB.png dst\effects\
copy uh_effect_bloom.lua dst\effects\
copy uh_effect_bloom.png dst\effects\
copy uh_effect_rim.lua dst\effects\
copy uh_effect_rim.png dst\effects\
copy uh_effect_rotate.lua dst\effects\
copy uh_effect_rotate.png dst\effects\
copy uh_effect_rotate2.lua dst\effects\
copy uh_effect_rotate2.png dst\effects\

copy uh_effect_exp3D.lua dst\effects\
copy uh_effect_exp3D.png dst\effects\

copy uh_dummy.lua dst\transitions\
copy uh_dummy.png dst\transitions\
copy lib.lua dst\

%COMPILER% /T ps_4_0 uh_effect.hlsl /Fo dst\uh_effect.cso /Fc shader_asm\uh_effect.hlsl
%COMPILER% /T ps_4_0 uh_effect_ctr.hlsl /Fo dst\uh_effect_ctr.cso /Fc shader_asm\uh_effect_ctr.hlsl
%COMPILER% /T ps_4_0 uh_effect_edge.hlsl /Fo dst\uh_effect_edge.cso /Fc shader_asm\uh_effect_edge.hlsl
%COMPILER% /T ps_4_0 uh_effect_nv.hlsl /Fo dst\uh_effect_nv.cso /Fc shader_asm\uh_effect_nv.hlsl
%COMPILER% /T ps_4_0 uh_effect_2bc.hlsl /Fo dst\uh_effect_2bc.cso /Fc shader_asm\uh_effect_2bc.hlsl
%COMPILER% /T ps_4_0 uh_effect_softB.hlsl /Fo dst\uh_effect_softB.cso /Fc shader_asm\uh_effect_softB.hlsl
%COMPILER% /T ps_4_0 uh_effect_bloom.hlsl /Fo dst\uh_effect_bloom.cso /Fc shader_asm\uh_effect_bloom.hlsl
%COMPILER% /T ps_4_0 uh_effect_rim.hlsl /Fo dst\uh_effect_rim.cso /Fc shader_asm\uh_effect_rim.hlsl
%COMPILER% /T ps_4_0 uh_effect_rotate.hlsl /Fo dst\uh_effect_rotate.cso /Fc shader_asm\uh_effect_rotate.hlsl

%COMPILER% /T ps_4_0 uh_dummy.hlsl /Fo dst\uh_dummy.cso /Fc shader_asm\uh_dummy.hlsl
