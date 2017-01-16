-- Nexus Gatekeeper
-- @copyright (c) 2013-20* Júlio C. Oliveira <talk@juliocesar.me>
--
-- @license Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License - <https://creativecommons.org/licenses/by-nc-sa/4.0/>
--
-- $Id$
-- Version 2.1.6 - 2017-01-16 05:00 PM

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