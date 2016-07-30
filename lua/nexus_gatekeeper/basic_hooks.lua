-- Nexus Gatekeeper
-- @copyright (c) 2013-20* Júlio C. Oliveira <talk@juliocesar.me>
--
-- @license Attribution-NonCommercial 4.0 International - <https://creativecommons.org/licenses/by-nc/4.0/>
--
-- $Id$
-- Version 2.1.5 - 30-07-2016 10:53 PM

hook.Add("PlayerInitialSpawn", "NexusGK-InitialSpawn", NexusGK.PlayerInitialSpawn)	
hook.Add("PlayerDisconnected", "NexusGK-Leave", NexusGK.PlayerDisconnected)
hook.Add("CheckPassword", "NexusGK-Checker", NexusGK.CheckPassword)