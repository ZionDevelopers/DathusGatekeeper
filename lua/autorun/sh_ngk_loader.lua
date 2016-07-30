-- Nexus Gatekeeper
-- @copyright (c) 2013-20* Júlio C. Oliveira <talk@juliocesar.me>
--
-- @license Attribution-NonCommercial 4.0 International - <https://creativecommons.org/licenses/by-nc/4.0/>
--
-- $Id$
-- Version 2.1.5 - 30-07-2016 10:53 PM


if SERVER then
  AddCSLuaFile()
  AddCSLuaFile("nexus_gatekeeper/core_shared.lua") 
end

hook.Add("Initialize", "NGKLoader", function ()
	if NexusGK == nil then
		include("nexus_gatekeeper/core_shared.lua")
	end
end)
