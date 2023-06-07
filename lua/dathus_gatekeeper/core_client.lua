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

DathusGK.Colors = {
  info = Color(152,251,152),
  spawn = Color(79,217,76),
  error = Color(205,195,16),
  leave = Color(255,0,0)
}

DathusGK.PlayScatman = function()
  -- Check for Scatman's mode
  if GetConvarNumber("dgk_scatman_enabled") == 1 then
    sound.PlayURL ( "https://ia601201.us.archive.org/2/items/ItsScam/Scatman%20John%20-%20I%27m%20A%20scatman.mp3", "3d", function( mp3 ) 
      if IsValid( mp3 ) then    
        mp3:Play()        
        mp3:SetVolume( GetConVarNumber("dgk_scatman_volume") )
        mp3:SetPos( LocalPlayer():GetPos() )
      end
    end )
  end
end

DathusGK.PrintToPlayer = function(player, message, color)
  local text = {}
  table.insert(text, DathusGK.Colors['leave'])
  table.insert(text, "Dathus' Gatekeeper: ")
  
  table.insert(text, color)
  table.insert(text, message)
  chat.AddText(unpack(text))
end

hook.Add("ChatText", "ChatTextHook", function(iIndex, sName, sText, sType)
  if sType == "joinleave" then
    return true
  end 
end)

net.Receive("DathusGK-Notifier", function ()
  local type = net.ReadString()
  local message = net.ReadString()  
  
  if DathusGK.Colors[type] ~= nil then
    DathusGK.PrintToPlayer(LocalPlayer(), message, DathusGK.Colors[type])
    -- Check if the Boss is Comming
    if message == "The Scatman is comming!" then
      -- Play I'm a Scatman
      DathusGK.PlayScatman() 
    end
  end 
end)