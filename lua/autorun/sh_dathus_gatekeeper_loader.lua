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

if SERVER then
  AddCSLuaFile()
  AddCSLuaFile("dathus_gatekeeper/core_shared.lua") 
end

hook.Add("Initialize", "DGKLoader", function ()
  if DathusGK == nil then
    include("dathus_gatekeeper/core_shared.lua")
  end
end)
