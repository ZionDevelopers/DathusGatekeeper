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

DathusGK.db = ""
DathusGK.dataFolder = "dathus_gatekeeper"
DathusGK.iplist = {}
DathusGK.adminList = {}
DathusGK.whitelist = {}
DathusGK.banList = {}
DathusGK.countryWhitelist = ""
DathusGK.countryWhitelistFile = DathusGK.dataFolder.."/country-whitelist.txt"
DathusGK.geoIpFile = DathusGK.dataFolder.."/geoip-db.txt"
DathusGK.whitelistFile = DathusGK.dataFolder.."/whitelist.txt"
DathusGK.whitepassFile =  DathusGK.dataFolder.."/whitepass-list.txt"
DathusGK.whitepass = ""

CreateConVar( "dgk_whitelist_enabled", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Dathus' Gatekeeper Server Whitelist" )
CreateConVar( "dgk_whitepass_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Dathus' Gatekeeper Server Whitepass" )
CreateConVar( "dgk_countryblocker_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Dathus' Gatekeeper Country blocker" )
CreateConVar( "dgk_reservedslots_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Dathus' Gatekeeper Reserved Slots for Admins" )

DathusGK.NotifyAll = function (message, type)
  net.Start("DathusGK-Notifier")
  net.WriteString(type)
  net.WriteString(message)
  net.Broadcast()
end 
  
function round(num)
  return tonumber(string.format("%." .. 2 .. "f", num))
end

if not file.Exists(DathusGK.dataFolder, "DATA") then
  file.CreateDir(DathusGK.dataFolder)
end

local started = os.clock()

DathusGK.PrintOnServer("Loading GeoIP DB ("..round(file.Size(DathusGK.geoIpFile, "DATA")/1024/1024).." MB - "..os.date( "%d/%m/%y %I:%M:%S %p", file.Time( DathusGK.geoIpFile, "DATA" ) )..")...")
  
if not file.Exists(DathusGK.geoIpFile, "DATA") then
  DathusGK.PrintOnServer("ERROR "..DathusGK.geoIpFile.." not found!")
  DathusGK.db = {}
else
  DathusGK.db = string.Explode("\n", file.Read(DathusGK.geoIpFile, "DATA"))
end 

for i=1, table.Count(DathusGK.db) do
  DathusGK.iplist[i] = string.Explode(",", DathusGK.db[i])
end
    
DathusGK.PlayerInitialSpawn = function (ply)
  DathusGK.NotifyAll(ply:GetName().." has spawned on the server.", "spawn" )
end
  
DathusGK.PlayerDisconnected = function (ply) 
  DathusGK.NotifyAll( ply:GetName().." has left the server.", "leave" ) 
end

DathusGK.PopulateAdminsNBans = function ()
  if exsto ~= nil then
    -- Loading Ban List From Exsto
    exsto.BanDB:GetAll( function( q, data )   
      for _, ban in ipairs( data ) do       
        DathusGK.banList[ban.SteamID] = true       
      end
    end)
    
    -- Loading User List From Exsto
    exsto.UserDB:GetAll( function( q, data )    
      for _, user in ipairs( data ) do
        if user.Rank == "admin" or user.Rank == "superadmin" or user.Rank == "srv_owner" then       
          DathusGK.adminList[user.SteamID] = true
        end
      end
    end)
  end 
end

DathusGK.CheckPassword = function (steamID64, address, serverPassword, userPassword, name) 
  local steamID = util.SteamIDFrom64(steamID64)
  local country = ""
  local clientIP = 0
  
  --- WHITE LIST
  if not file.Exists(DathusGK.whitelistFile, "DATA") then      
    DathusGK.PrintOnServer("ERROR "..DathusGK.whitelistFile.." not found!")
    DathusGK.whitelist = "STEAM_0:0:11418796 //Dathus [BR]\r\n"
    file.Write(DathusGK.whitelistFile, DathusGK.whitelist)
  else
    DathusGK.whitelist = file.Read(DathusGK.whitelistFile, "DATA")
  end 
  
  --- COUNTRY LIST  
  if not file.Exists(DathusGK.countryWhitelistFile, "DATA") then   
    DathusGK.countryWhitelist = "Brazil\r\n"
    file.Write(DathusGK.countryWhitelistFile, DathusGK.countryWhitelist)
  else
    DathusGK.countryWhitelist = file.Read(DathusGK.countryWhitelistFile, "DATA")
  end 
  
  --- WHITE PASS
  if not file.Exists(DathusGK.whitepassFile, "DATA") then    
    DathusGK.whitepass = "STEAM_0:0:11418796 //Dathus [BR]\r\n"
    file.Write(DathusGK.whitepassFile, DathusGK.whitepass)
  else
    DathusGK.whitepass = file.Read(DathusGK.whitepassFile, "DATA")
  end 
  
  clientIP = string.match(address, "([0-9,.]+)")
  
  if string.find(DathusGK.whitepass, steamID) and GetConVarNumber("dgk_whitepass_enabled") == 1 then
    return true
  end
  
  -- Populate Admins and Bans
  DathusGK.PopulateAdminsNBans() 
    
  if string.find(DathusGK.whitepass, steamID) and GetConVarNumber("dgk_whitepass_enabled") == 1 or string.find(clientIP, "192.168.") or clientIP == "127.0.0.1" then
    DathusGK.NotifyAll("The Scatman is comming!", "error")
    DathusGK.PrintOnServer("I'm a Scatman!")
    return true
  end
        
  if serverPassword ~= "" and serverPassword ~= userPassword then
    return false, "DGK: Invalid Password"
  end 
  
  if GetConVarNumber("dgk_whitelist_enabled") == 1 and not string.find(DathusGK.whitelist, steamID) then
    DathusGK.NotifyAll("Kicking "..name.." because he is not on whitelist", "error")
    DathusGK.PrintOnServer("Kicking "..name.." because he is not on whitelist")
    return false, "DGK: Sorry, You are not on whitelist!"
  end
  
  local players = player.GetAll()
  local playersN = #players
  local dropLast = nil
    
  -- There is no need to drop anybody if the server isn't full
  if playersN == game.MaxPlayers() and DathusGK.adminList[steamID] ~= nil and GetConVarNumber("dgk_reservedslots_enabled") == 1 then 
    -- If the Last Player Connected is Admin
    for p = playersN, 1, -1 do
      if not players[p]:IsAdmin() then
        dropLast = players[p]
        break
      end
    end
    
    -- If dropLast is Valid
    if dropLast:IsValid() then
      DathusGK.NotifyAll("Kicking "..dropLast:Name().." to "..name.." enter", "leave")
      DathusGK.PrintOnServer("Kicking "..dropLast:Name().." to "..name.." enter")
      dropLast:Kick("DGK: Sorry, Reserved Slot")
    end
  end
  
  local ip = string.Explode(".", clientIP)
  local decimal = (ip[1]*16777216) + (ip[2]*65536) + (ip[3]*256) + ip[4]    
  
  for k in pairs(DathusGK.iplist) do
    if decimal >= tonumber(string.sub(DathusGK.iplist[k][3],2,tonumber(string.len(DathusGK.iplist[k][3])-1))) and decimal <= tonumber(string.sub(DathusGK.iplist[k][4],2,tonumber(string.len(DathusGK.iplist[k][4])-1))) then
      country = string.sub(DathusGK.iplist[k][6],2,string.len(DathusGK.iplist[k][6])-1)       
      break -- no need for further check.
    end
  end   
  
  -- If Country are OK
  if country ~= "" then
    -- If this player are from a not allowed country
    if not string.find(DathusGK.countryWhitelist, country) and GetConVarNumber("dgk_countryblocker_enabled") == 1 then   
      DathusGK.NotifyAll(name.." tried connect from "..country.." but was Kicked!", "error" )
      DathusGK.PrintOnServer(name.."  tried connect from "..country.." but was Kicked!")
      return false, "DGK: This server has blocked players from your country!"
    -- if player is allowed
    else
      if DathusGK.banList[steamID] == nil then
        DathusGK.NotifyAll( name.." connecting from "..country..".", "info" )
        DathusGK.PrintOnServer(name.." connecting from "..country)
        return true
      else
        DathusGK.NotifyAll( "Dathus Gatekeeper: "..name.." tried to connect from "..country.." but he are banned!", "error" )
        DathusGK.PrintOnServer(name.." tried to connect from "..country.." but he is banned!")
        return false, "DGK: You cannot enter, Because you are banned!"
      end
    end
  -- If Fail
  else
    DathusGK.PrintOnServer("Failed to get "..name.." location")
    return false, "DGK: Sorry, we are unable to locate your country, so you cannot enter!"
  end 
end
