@echo off
cd /d V:\SteamLibrary\SteamApps\common\GarrysMod\bin
gmad.exe create -folder "D:/Github/DathusGatekeeper" -out "D:/Github/DathusGatekeeper.gma"
gmpublish.exe update -addon "D:/Github/DathusGatekeeper.gma" -id 734208849
pause
