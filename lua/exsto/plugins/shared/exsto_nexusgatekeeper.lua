-- Nexus Gatekeeper
-- Copyright (c) 2013 Nexus [BR] <http://www.nexusbr.net>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- $Id$
-- Version 2.0.5 - 10-11-2013 10:53 PM

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