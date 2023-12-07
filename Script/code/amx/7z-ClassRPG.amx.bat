@echo off

set b32=0
set b64=0

set b64path="c:\Program Files\7-Zip\7z.exe"
set b32path="c:\Program Files (x86)\7-Zip\7z.exe"

set path=""

echo Checking paths...
echo x32 = %b32path%
echo x64 = %b64path%

if exist %b64path% (
    echo x64 found
    set path=%b64path%
) else (
    if exist %b32path% (
        echo x32 found
        set path=%b32path%
    )
)

if %path% == "" (
    echo 7zip not found
    pause
)

CALL %path% a ClassRPG.7z ClassRPG.amx
