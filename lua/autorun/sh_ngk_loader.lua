-- Nexus Gatekeeper
-- @copyright (c) 2013-20* Júlio C. Oliveira <talk@juliocesar.me>
--
-- @license Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License - <https://creativecommons.org/licenses/by-nc-sa/4.0/>
--
-- $Id$
-- Version 2.1.6 - 2017-01-16 05:00 PM

if SERVER then
  AddCSLuaFile()
  AddCSLuaFile("nexus_gatekeeper/core_shared.lua") 
end

hook.Add("Initialize", "NGKLoader", function ()
  if NexusGK == nil then
    include("nexus_gatekeeper/core_shared.lua")
  end
end)
