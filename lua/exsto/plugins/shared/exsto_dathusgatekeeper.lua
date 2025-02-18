--[[

Dathus' Gatekeeper by Dathus [BR] is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
----------------------------------------------------------------------------------------------------------------------------
Copyright (c) 2014 - 2025 - Dathus [BR] <http://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US> .
----------------------------------------------------------------------------------------------------------------------------

$Id$
Version 2.2

]]--


DathusGK = {};
-- Dathus' Gatekeeper version
DathusGK.version = "2.2.2"
DathusGK.ExstoPlugin = true
AddCSLuaFile()

Msg( "\n/====================================\\\n")
Msg( "||        Dathus' Gatekeeper        ||\n" )
Msg( "||----------------------------------||\n" )
loadingLog("Version " .. DathusGK.version)
loadingLog("Updated on 2023-06-24 10:00 AM")
Msg( "\\====================================/\n\n" )

DathusGK.PrintOnServer = function (message)
  exsto.Print( exsto_CONSOLE_LOGO, COLOR.NAME, "Dathus' Gatekeeper", COLOR.NORM, ": "..message)
end

DathusGK.PrintOnServer("Initializing...") 

if SERVER then
  util.AddNetworkString("DathusGK-Notifier")   
  
  AddCSLuaFile("dathus_gatekeeper/core_client.lua")  
  AddCSLuaFile("dathus_gatekeeper/core_shared.lua")
    
  DathusGK.PrintOnServer("Loading Server CORE....")  
  include("dathus_gatekeeper/core_server.lua")   
elseif CLIENT then
  DathusGK.PrintOnServer("Loading Client CORE....") 
  include("dathus_gatekeeper/core_client.lua") 
end

local PLUGIN = exsto.CreatePlugin()

PLUGIN:SetInfo({
  Name = "Dathus' GateKeeper V2",
  ID = "dathus_gatekeeper_v2",
  Desc = "Dathus' GateKeeper!",
  Owner = "Dathus [BR]"
})

function PLUGIN:Init()  
end
    
function PLUGIN:PlayerInitialSpawn (ply)
  return DathusGK.PlayerInitialSpawn(ply)  
end
  
function PLUGIN:PlayerDisconnected(ply) 
  return DathusGK.PlayerDisconnected(ply)  
end

function PLUGIN:CheckPassword( steamID64, address, serverPassword, userPassword, name)
  return DathusGK.CheckPassword(steamID64, address, serverPassword, userPassword, name)
end

PLUGIN:Register()
