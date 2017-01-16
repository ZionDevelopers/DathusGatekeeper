@echo off
cd /d G:\SteamLibrary\SteamApps\common\GarrysMod\bin
gmad.exe create -folder "D:/Github/NexusGatekeeper" -out "D:/Github/NexusGatekeeper.gma"
gmpublish.exe update -addon "D:/Github/NexusGatekeeper.gma" -id 734208849
pause
