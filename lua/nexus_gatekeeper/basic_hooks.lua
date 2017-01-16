-- Nexus Gatekeeper
-- @copyright (c) 2013-20* Júlio C. Oliveira <talk@juliocesar.me>
--
-- @license Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License - <https://creativecommons.org/licenses/by-nc-sa/4.0/>
--
-- $Id$
-- Version 2.1.6 - 2017-01-16 05:00 PM

hook.Add("PlayerInitialSpawn", "NexusGK-InitialSpawn", NexusGK.PlayerInitialSpawn)  
hook.Add("PlayerDisconnected", "NexusGK-Leave", NexusGK.PlayerDisconnected)
hook.Add("CheckPassword", "NexusGK-Checker", NexusGK.CheckPassword)
