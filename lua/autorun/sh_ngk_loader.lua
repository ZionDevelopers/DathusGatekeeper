<<<<<<< HEAD
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
=======
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


if SERVER then
  AddCSLuaFile()
  AddCSLuaFile("nexus_gatekeeper/core_shared.lua") 
end

hook.Add("Initialize", "NGKLoader", function ()
	if NexusGK == nil then
		include("nexus_gatekeeper/core_shared.lua")
	end
end)
>>>>>>> origin/master
