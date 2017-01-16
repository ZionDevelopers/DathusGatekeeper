-- Nexus Gatekeeper
-- @copyright (c) 2013-20* Júlio C. Oliveira <talk@juliocesar.me>
--
-- @license Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License - <https://creativecommons.org/licenses/by-nc-sa/4.0/>
--
-- $Id$
-- Version 2.1.6 - 2017-01-16 05:00 PM

AddCSLuaFile()

NexusGK = {};
NexusGK.started = os.clock()

NexusGK.ExstoPlugin = false
NexusGK.BasicPlugin = true

local firstLog = true

NexusGK.PrintOnServer = function (message)
  if not firstLog then
    print("Nexus Gatekeeper: "..message)
  else
    print("\r\nNexus Gatekeeper: "..message)
    firstLog = false  
  end
end

NexusGK.PrintOnServer("Initializing...") 

if SERVER then
  -- Add Tag to Pool
  util.AddNetworkString("NexusGK-Notifier") 
  -- Send Lua to Client
  AddCSLuaFile("nexus_gatekeeper/core_client.lua")  
    
  NexusGK.PrintOnServer("Loading Server CORE....")  
  -- Load Server Core 
  include("nexus_gatekeeper/core_server.lua")   
  -- Include Basic Hooks
  include("nexus_gatekeeper/basic_hooks.lua")
elseif CLIENT then
  NexusGK.PrintOnServer("Loading Client CORE....") 
  include("nexus_gatekeeper/core_client.lua") 
end

NexusGK.PrintOnServer("Loading Complete in  "..math.Round(os.clock() - NexusGK.started, 2) .. " seconds! \r\n") 
