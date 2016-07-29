@echo off
cd /d "G:\SteamLibrary\SteamApps\common\GarrysMod\bin"
gmad.exe create -folder "D:\Github\NexusGatekeeper" -out "D:\Github\NexusGatekeeper.gma"
gmpublish create -addon "D:\Github\NexusGatekeeper.gma" -changes "Change it later"
REM -id "106516163"
pause