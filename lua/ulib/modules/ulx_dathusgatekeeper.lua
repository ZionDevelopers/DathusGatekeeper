--[[

Dathus' Gatekeeper by Dathus [BR] is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
----------------------------------------------------------------------------------------------------------------------------
Copyright (c) 2014 - 2026 - Dathus [BR] <http://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US> .
----------------------------------------------------------------------------------------------------------------------------

$Id$
Version 2.2

]]--


DathusGK = {};
DathusGK.ULXPlugin = true
-- Dathus' Gatekeeper version
DathusGK.version = "2.2.2"
AddCSLuaFile()

local firstLog = true

Msg( "\n/====================================\\\n")
Msg( "||        Dathus' Gatekeeper        ||\n" )
Msg( "||----------------------------------||\n" )
loadingLog("Version " .. DathusGK.version)
loadingLog("Updated on 2023-06-24 10:00 AM")
Msg( "\\====================================/\n\n" )

DathusGK.PrintOnServer = function (message)
  if not firstLog then
    print("Dathus' Gatekeeper: "..message)
  else
    print("\r\nDathus' Gatekeeper: "..message)
    firstLog = false  
  end
end

DathusGK.PrintOnServer("Initializing...") 

if SERVER then
  util.AddNetworkString("DathusGK-Notifier")   
  
  AddCSLuaFile("dathus_gatekeeper/core_client.lua")  
  AddCSLuaFile("dathus_gatekeeper/core_shared.lua")
    
  DathusGK.PrintOnServer("Loading Server CORE....")  
  include("dathus_gatekeeper/core_server.lua")   
  
  hook.Add("PlayerInitialSpawn", "DathusGK-InitialSpawn", DathusGK.PlayerInitialSpawn)  
  hook.Add("PlayerDisconnected", "DathusGK-Leave", DathusGK.PlayerDisconnected)
  hook.Add("CheckPassword", "DathusGK-Checker", DathusGK.CheckPassword)
elseif CLIENT then
  DathusGK.PrintOnServer("Loading Client CORE....") 
  include("dathus_gatekeeper/core_client.lua") 
end

