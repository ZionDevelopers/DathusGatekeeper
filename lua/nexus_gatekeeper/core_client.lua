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

NexusGK.Colors = {
	info = Color(152,251,152),
	spawn = Color(79,217,76),
	error = Color(205,195,16),
	leave = Color(255,0,0)
}

NexusGK.PlayScatman = function()
	sound.PlayURL ( "https://googledrive.com/host/0B1u99Vmnc0RHYXlPcHFMSEJ5Ym8/garrysmod/sound/nexus_gatekeeper/iam_a_scatman.mp3", "mono", function( mp3 ) 
		if IsValid( mp3 ) then		
			mp3:Play()				
			mp3:SetVolume( 60 )
		end
	end )
end

NexusGK.PrintToPlayer = function(player, message, color)
	local text = {}
	table.insert(text, NexusGK.Colors['leave'])
	table.insert(text, "Nexus Gatekeeper: ")
	
	table.insert(text, color)
	table.insert(text, message)
	chat.AddText(unpack(text))
end

hook.Add("ChatText", "ChatTextHook", function(iIndex, sName, sText, sType)
	if sType == "joinleave" then
		return true
	end	
end)

net.Receive("NexusGK-Notifier", function ()
	local type = net.ReadString()
	local message = net.ReadString()	
	
	if NexusGK.Colors[type] ~= nil then
		NexusGK.PrintToPlayer(LocalPlayer(), message, NexusGK.Colors[type])
		-- Check if the Boss is Comming
		if message == "The Scatman is comming!" then
			-- Play I'm a Scatman
			NexusGK.PlayScatman()	
		end
	end	
end)