-- Nexus Gatekeeper
-- @copyright (c) 2013-20* Júlio C. Oliveira <talk@juliocesar.me>
--
-- @license Attribution-NonCommercial 4.0 International - <https://creativecommons.org/licenses/by-nc/4.0/>
--
-- $Id$
-- Version 2.1.6 - 2017-01-16 05:00 PM


NexusGK = {};
NexusGK.ExstoPlugin = true
AddCSLuaFile()

NexusGK.PrintOnServer = function (message)
  exsto.Print( exsto_CONSOLE_LOGO, COLOR.NAME, "Nexus Gatekeeper", COLOR.NORM, ": "..message)
end

NexusGK.PrintOnServer("Initializing...") 

if SERVER then
  util.AddNetworkString("NexusGK-Notifier")   
  
  AddCSLuaFile("nexus_gatekeeper/core_client.lua")  
  AddCSLuaFile("nexus_gatekeeper/core_shared.lua")
    
  NexusGK.PrintOnServer("Loading Server CORE....")  
  include("nexus_gatekeeper/core_server.lua")   
elseif CLIENT then
  NexusGK.PrintOnServer("Loading Client CORE....") 
  include("nexus_gatekeeper/core_client.lua") 
end

local PLUGIN = exsto.CreatePlugin()

PLUGIN:SetInfo({
  Name = "Nexus GateKeeper V2",
  ID = "nexus_gatekeeper_v2",
  Desc = "Nexus GateKeeper!",
  Owner = "Nexus [BR]"
})

function PLUGIN:Init()  
end
    
function PLUGIN:PlayerInitialSpawn (ply)
  return NexusGK.PlayerInitialSpawn(ply)  
end
  
function PLUGIN:PlayerDisconnected(ply) 
  return NexusGK.PlayerDisconnected(ply)  
end

function PLUGIN:CheckPassword( steamID64, address, serverPassword, userPassword, name)
  return NexusGK.CheckPassword(steamID64, address, serverPassword, userPassword, name)
end

PLUGIN:Register()
