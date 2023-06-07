--[[

Dathus' Gatekeeper by Dathus [BR] is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
----------------------------------------------------------------------------------------------------------------------------
Copyright (c) 2014 - 20** Dathus [BR] <http://www.juliocesar.me> <http://steamcommunity.com/profiles/76561197983103320>

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit <http://creativecommons.org/licenses/by-nc-sa/4.0/deed.en_US> .
----------------------------------------------------------------------------------------------------------------------------

$Id$
Version 2.2

]]--

AddCSLuaFile()

DathusGK = {};
-- Dathus' Gatekeeper version
DathusGK.version = "2.2.1"
DathusGK.started = os.clock()

DathusGK.ExstoPlugin = false
DathusGK.BasicPlugin = true

local firstLog = true

Msg( "\n/====================================\\\n")
Msg( "||        Dathus' Gatekeeper        ||\n" )
Msg( "||----------------------------------||\n" )
loadingLog("Version " .. DathusGK.version)
loadingLog("Updated on 2023-06-07 08:00 AM")
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
  -- Add Tag to Pool
  util.AddNetworkString("DathusGK-Notifier") 
  -- Send Lua to Client
  AddCSLuaFile("dathus_gatekeeper/core_client.lua")  
    
  DathusGK.PrintOnServer("Loading Server CORE....")  
  -- Load Server Core 
  include("dathus_gatekeeper/core_server.lua")   
  -- Include Basic Hooks
  include("dathus_gatekeeper/basic_hooks.lua")
elseif CLIENT then
  DathusGK.PrintOnServer("Loading Client CORE....") 
  include("dathus_gatekeeper/core_client.lua") 
end

DathusGK.PrintOnServer("Loading Complete in  "..math.Round(os.clock() - DathusGK.started, 2) .. " seconds! \r\n") 
