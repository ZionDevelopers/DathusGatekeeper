<<<<<<< HEAD
-- Nexus Gatekeeper
-- @copyright (c) 2013-20* Júlio C. Oliveira <talk@juliocesar.me>
--
-- @license Attribution-NonCommercial 4.0 International - <https://creativecommons.org/licenses/by-nc/4.0/>
--
-- $Id$
-- Version 2.1.5 - 30-07-2016 10:53 PM

NexusGK.db = ""
NexusGK.dataFolder = "nexus_gatekeeper"
NexusGK.iplist = {}
NexusGK.adminList = {}
NexusGK.whitelist = {}
NexusGK.banList = {}
NexusGK.countryWhitelist = ""
NexusGK.countryWhitelistFile = NexusGK.dataFolder.."/country-whitelist.txt"
NexusGK.geoIpFile = NexusGK.dataFolder.."/geoip-db.txt"
NexusGK.whitelistFile = NexusGK.dataFolder.."/whitelist.txt"
NexusGK.whitepassFile =  NexusGK.dataFolder.."/whitepass-list.txt"
NexusGK.whitepass = ""

CreateConVar( "ngk_whitelist_enabled", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Nexus Gatekeeper Server Whitelist" )
CreateConVar( "ngk_whitepass_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Nexus Gatekeeper Server Whitepass" )
CreateConVar( "ngk_countryblocker_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Nexus Gatekeeper Country blocker" )
CreateConVar( "ngk_reservedslots_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Nexus Gatekeeper Reserved Slots for Admins" )

NexusGK.NotifyAll = function (message, type)
	net.Start("NexusGK-Notifier")
	net.WriteString(type)
	net.WriteString(message)
	net.Broadcast()
end	
	
function round(num)
  return tonumber(string.format("%." .. 2 .. "f", num))
end

if not file.Exists(NexusGK.dataFolder, "DATA") then
	file.CreateDir(NexusGK.dataFolder)
end

local started = os.clock()

NexusGK.PrintOnServer("Loading GeoIP DB ("..round(file.Size(NexusGK.geoIpFile, "DATA")/1024/1024).." MB - "..os.date( "%d/%m/%y %I:%M:%S %p", file.Time( NexusGK.geoIpFile, "DATA" ) )..")...")
	
if not file.Exists(NexusGK.geoIpFile, "DATA") then
	NexusGK.PrintOnServer("ERROR "..NexusGK.geoIpFile.." not found!")
	NexusGK.db = {}
else
	NexusGK.db = string.Explode("\n", file.Read(NexusGK.geoIpFile, "DATA"))
end	

for i=1, table.Count(NexusGK.db) do
	NexusGK.iplist[i] = string.Explode(",", NexusGK.db[i])
end
		
NexusGK.PlayerInitialSpawn = function (ply)
	NexusGK.NotifyAll(ply:GetName().." has spawned on the server.", "spawn" )
end
	
NexusGK.PlayerDisconnected = function (ply) 
	NexusGK.NotifyAll( ply:GetName().." has left the server.", "leave" ) 
end

NexusGK.PopulateAdminsNBans = function ()
	if exsto ~= nil then
		-- Loading Ban List From Exsto
		exsto.BanDB:GetAll( function( q, data )		
			for _, ban in ipairs( data ) do				
				NexusGK.banList[ban.SteamID] = true				
			end
		end)
		
		-- Loading User List From Exsto
		exsto.UserDB:GetAll( function( q, data )		
			for _, user in ipairs( data ) do
				if user.Rank == "admin" or user.Rank == "superadmin" or user.Rank == "srv_owner" then				
					NexusGK.adminList[user.SteamID] = true
				end
			end
		end)
	end	
end

NexusGK.CheckPassword = function (steamID64, address, serverPassword, userPassword, name)	
	local steamID = util.SteamIDFrom64(steamID64)
	local country = ""
	local clientIP = 0
	
	--- WHITE LIST
	if not file.Exists(NexusGK.whitelistFile, "DATA") then			
		NexusGK.PrintOnServer("ERROR "..NexusGK.whitelistFile.." not found!")
		NexusGK.whitelist = "STEAM_0:0:11418796 //Nexus [BR]\r\n"
		file.Write(NexusGK.whitelistFile, NexusGK.whitelist)
	else
		NexusGK.whitelist = file.Read(NexusGK.whitelistFile, "DATA")
	end	
	
	--- COUNTRY LIST	
	if not file.Exists(NexusGK.countryWhitelistFile, "DATA") then		
		NexusGK.countryWhitelist = "Brazil\r\n"
		file.Write(NexusGK.countryWhitelistFile, NexusGK.countryWhitelist)
	else
		NexusGK.countryWhitelist = file.Read(NexusGK.countryWhitelistFile, "DATA")
	end	
	
	--- WHITE PASS
	if not file.Exists(NexusGK.whitepassFile, "DATA") then		
		NexusGK.whitepass = "STEAM_0:0:11418796 //Nexus [BR]\r\n"
		file.Write(NexusGK.whitepassFile, NexusGK.whitepass)
	else
		NexusGK.whitepass = file.Read(NexusGK.whitepassFile, "DATA")
	end	
	
	clientIP = string.match(address, "([0-9,.]+)")
	
	if string.find(NexusGK.whitepass, steamID) and GetConVarNumber("ngk_whitepass_enabled") == 1 then
		return true
	end
	
	-- Populate Admins and Bans
	NexusGK.PopulateAdminsNBans()	
		
	if string.find(NexusGK.whitepass, steamID) and GetConVarNumber("ngk_whitepass_enabled") == 1 or string.find(clientIP, "192.168.") or clientIP == "127.0.0.1" then
		NexusGK.NotifyAll("The Scatman is comming!", "error")
		NexusGK.PrintOnServer("I'm a Scatman!")
		return true
	end
				
	if serverPassword ~= "" and serverPassword ~= userPassword then
		return false, "NGK: Invalid Password"
	end	
	
	if GetConVarNumber("ngk_whitelist_enabled") == 1 and not string.find(NexusGK.whitelist, steamID) then
		NexusGK.NotifyAll("Kicking "..name.." because he is not on whitelist", "error")
		NexusGK.PrintOnServer("Kicking "..name.." because he is not on whitelist")
		return false, "NGK: Sorry, You are not on whitelist!"
	end
	
	local players = player.GetAll()
	local playersN = #players
	local dropLast = nil
		
	-- There is no need to drop anybody if the server isn't full
	if playersN == game.MaxPlayers() and NexusGK.adminList[steamID] ~= nil and GetConVarNumber("ngk_reservedslots_enabled") == 1 then	
		-- If the Last Player Connected is Admin
		for p = playersN, 1, -1 do
			if not players[p]:IsAdmin() then
				dropLast = players[p]
				break
			end
		end
		
		-- If dropLast is Valid
		if dropLast:IsValid() then
			NexusGK.NotifyAll("Kicking "..dropLast:Name().." to "..name.." enter", "leave")
			NexusGK.PrintOnServer("Kicking "..dropLast:Name().." to "..name.." enter")
			dropLast:Kick("NGK: Sorry, Reserved Slot")
		end
	end
	
	local ip = string.Explode(".", clientIP)
	local decimal = (ip[1]*16777216) + (ip[2]*65536) + (ip[3]*256) + ip[4]		
	
	for k in pairs(NexusGK.iplist) do
		if decimal >= tonumber(string.sub(NexusGK.iplist[k][3],2,tonumber(string.len(NexusGK.iplist[k][3])-1))) and decimal <= tonumber(string.sub(NexusGK.iplist[k][4],2,tonumber(string.len(NexusGK.iplist[k][4])-1))) then
			country = string.sub(NexusGK.iplist[k][6],2,string.len(NexusGK.iplist[k][6])-1)				
			break -- no need for further check.
		end
	end		
	
	-- If Country are OK
	if country ~= "" then
		-- If this player are from a not allowed country
		if not string.find(NexusGK.countryWhitelist, country) and GetConVarNumber("ngk_countryblocker_enabled") == 1 then		
			NexusGK.NotifyAll(name.." tried connect from "..country.." but was Kicked!", "error" )
			NexusGK.PrintOnServer(name.."  tried connect from "..country.." but was Kicked!")
			return false, "NGK: This server has blocked players from your country!"
		-- if player is Brazilian
		else
			if NexusGK.banList[steamID] == nil then
				NexusGK.NotifyAll( name.." connecting from "..country..".", "info" )
				NexusGK.PrintOnServer(name.." connecting from "..country)
				return true
			else
				NexusGK.NotifyAll( "Nexus Gatekeeper: "..name.." tried to connect from "..country.." but he are banned!", "error" )
				NexusGK.PrintOnServer(name.." tried to connect from "..country.." but he is banned!")
				return false, "NGK: You cannot enter, Because you are banned!"
			end
		end
	-- If Fail
	else
		NexusGK.PrintOnServer("Failed to get "..name.." location")
		return false, "NGK: Sorry, we are unable to locate your country, so you cannot enter!"
	end	
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

NexusGK.db = ""
NexusGK.dataFolder = "nexus_gatekeeper"
NexusGK.iplist = {}
NexusGK.adminList = {}
NexusGK.whitelist = {}
NexusGK.banList = {}
NexusGK.countryWhitelist = ""
NexusGK.countryWhitelistFile = NexusGK.dataFolder.."/country-whitelist.txt"
NexusGK.geoIpFile = NexusGK.dataFolder.."/geoip-db.txt"
NexusGK.whitelistFile = NexusGK.dataFolder.."/whitelist.txt"
NexusGK.whitepassFile =  NexusGK.dataFolder.."/whitepass-list.txt"
NexusGK.whitepass = ""

CreateConVar( "ngk_whitelist_enabled", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Nexus Gatekeeper Server Whitelist" )
CreateConVar( "ngk_whitepass_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Nexus Gatekeeper Server Whitepass" )
CreateConVar( "ngk_countryblocker_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Nexus Gatekeeper Country blocker" )
CreateConVar( "ngk_reservedslots_enabled", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Enable or Disable the Nexus Gatekeeper Reserved Slots for Admins" )

NexusGK.NotifyAll = function (message, type)
	net.Start("NexusGK-Notifier")
	net.WriteString(type)
	net.WriteString(message)
	net.Broadcast()
end	
	
function round(num)
  return tonumber(string.format("%." .. 2 .. "f", num))
end

if not file.Exists(NexusGK.dataFolder, "DATA") then
	file.CreateDir(NexusGK.dataFolder)
end

local started = os.clock()

NexusGK.PrintOnServer("Loading GeoIP DB ("..round(file.Size(NexusGK.geoIpFile, "DATA")/1024/1024).." MB - "..os.date( "%d/%m/%y %I:%M:%S %p", file.Time( NexusGK.geoIpFile, "DATA" ) )..")...")
	
if not file.Exists(NexusGK.geoIpFile, "DATA") then
	NexusGK.PrintOnServer("ERROR "..NexusGK.geoIpFile.." not found!")
	NexusGK.db = {}
else
	NexusGK.db = string.Explode("\n", file.Read(NexusGK.geoIpFile, "DATA"))
end	

for i=1, table.Count(NexusGK.db) do
	NexusGK.iplist[i] = string.Explode(",", NexusGK.db[i])
end
		
NexusGK.PlayerInitialSpawn = function (ply)
	NexusGK.NotifyAll(ply:GetName().." has spawned on the server.", "spawn" )
end
	
NexusGK.PlayerDisconnected = function (ply) 
	NexusGK.NotifyAll( ply:GetName().." has left the server.", "leave" ) 
end

NexusGK.PopulateAdminsNBans = function ()
	if exsto ~= nil then
		-- Loading Ban List From Exsto
		exsto.BanDB:GetAll( function( q, data )		
			for _, ban in ipairs( data ) do				
				NexusGK.banList[ban.SteamID] = true				
			end
		end)
		
		-- Loading User List From Exsto
		exsto.UserDB:GetAll( function( q, data )		
			for _, user in ipairs( data ) do
				if user.Rank == "admin" or user.Rank == "superadmin" or user.Rank == "srv_owner" then				
					NexusGK.adminList[user.SteamID] = true
				end
			end
		end)
	end	
end

NexusGK.CheckPassword = function (steamID64, address, serverPassword, userPassword, name)	
	local steamID = util.SteamIDFrom64(steamID64)
	local country = ""
	local clientIP = 0
	
	--- WHITE LIST
	if not file.Exists(NexusGK.whitelistFile, "DATA") then			
		NexusGK.PrintOnServer("ERROR "..NexusGK.whitelistFile.." not found!")
		NexusGK.whitelist = "STEAM_0:0:11418796 //Nexus [BR]\r\n"
		file.Write(NexusGK.whitelistFile, NexusGK.whitelist)
	else
		NexusGK.whitelist = file.Read(NexusGK.whitelistFile, "DATA")
	end	
	
	--- COUNTRY LIST	
	if not file.Exists(NexusGK.countryWhitelistFile, "DATA") then		
		NexusGK.countryWhitelist = "Brazil\r\n"
		file.Write(NexusGK.countryWhitelistFile, NexusGK.countryWhitelist)
	else
		NexusGK.countryWhitelist = file.Read(NexusGK.countryWhitelistFile, "DATA")
	end	
	
	--- WHITE PASS
	if not file.Exists(NexusGK.whitepassFile, "DATA") then		
		NexusGK.whitepass = "STEAM_0:0:11418796 //Nexus [BR]\r\n"
		file.Write(NexusGK.whitepassFile, NexusGK.whitepass)
	else
		NexusGK.whitepass = file.Read(NexusGK.whitepassFile, "DATA")
	end	
	
	clientIP = string.match(address, "([0-9,.]+)")
	
	if string.find(NexusGK.whitepass, steamID) and GetConVarNumber("ngk_whitepass_enabled") == 1 then
		return true
	end
	
	-- Populate Admins and Bans
	NexusGK.PopulateAdminsNBans()	
		
	if string.find(NexusGK.whitepass, steamID) and GetConVarNumber("ngk_whitepass_enabled") == 1 or string.find(clientIP, "192.168.") or clientIP == "127.0.0.1" then
		NexusGK.NotifyAll("The Scatman is comming!", "error")
		NexusGK.PrintOnServer("I'm a Scatman!")
		return true
	end
				
	if serverPassword ~= "" and serverPassword ~= userPassword then
		return false, "NGK: Invalid Password"
	end	
	
	if GetConVarNumber("ngk_whitelist_enabled") == 1 and not string.find(NexusGK.whitelist, steamID) then
		NexusGK.NotifyAll("Kicking "..name.." because he is not on whitelist", "error")
		NexusGK.PrintOnServer("Kicking "..name.." because he is not on whitelist")
		return false, "NGK: Sorry, You are not on whitelist!"
	end
	
	local players = player.GetAll()
	local playersN = #players
	local dropLast = nil
		
	-- There is no need to drop anybody if the server isn't full
	if playersN == game.MaxPlayers() and NexusGK.adminList[steamID] ~= nil and GetConVarNumber("ngk_reservedslots_enabled") == 1 then	
		-- If the Last Player Connected is Admin
		for p = playersN, 1, -1 do
			if not players[p]:IsAdmin() then
				dropLast = players[p]
				break
			end
		end
		
		-- If dropLast is Valid
		if dropLast:IsValid() then
			NexusGK.NotifyAll("Kicking "..dropLast:Name().." to "..name.." enter", "leave")
			NexusGK.PrintOnServer("Kicking "..dropLast:Name().." to "..name.." enter")
			dropLast:Kick("NGK: Sorry, Reserved Slot")
		end
	end
	
	local ip = string.Explode(".", clientIP)
	local decimal = (ip[1]*16777216) + (ip[2]*65536) + (ip[3]*256) + ip[4]		
	
	for k in pairs(NexusGK.iplist) do
		if decimal >= tonumber(string.sub(NexusGK.iplist[k][3],2,tonumber(string.len(NexusGK.iplist[k][3])-1))) and decimal <= tonumber(string.sub(NexusGK.iplist[k][4],2,tonumber(string.len(NexusGK.iplist[k][4])-1))) then
			country = string.sub(NexusGK.iplist[k][6],2,string.len(NexusGK.iplist[k][6])-1)				
			break -- no need for further check.
		end
	end		
	
	-- If Country are OK
	if country ~= "" then
		-- If this player are from a not allowed country
		if not string.find(NexusGK.countryWhitelist, country) and GetConVarNumber("ngk_countryblocker_enabled") == 1 then		
			NexusGK.NotifyAll(name.." tried connect from "..country.." but was Kicked!", "error" )
			NexusGK.PrintOnServer(name.."  tried connect from "..country.." but was Kicked!")
			return false, "NGK: This server has blocked players from your country!"
		-- if player is Brazilian
		else
			if NexusGK.banList[steamID] == nil then
				NexusGK.NotifyAll( name.." connecting from "..country..".", "info" )
				NexusGK.PrintOnServer(name.." connecting from "..country)
				return true
			else
				NexusGK.NotifyAll( "Nexus Gatekeeper: "..name.." tried to connect from "..country.." but he are banned!", "error" )
				NexusGK.PrintOnServer(name.." tried to connect from "..country.." but he is banned!")
				return false, "NGK: You cannot enter, Because you are banned!"
			end
		end
	-- If Fail
	else
		NexusGK.PrintOnServer("Failed to get "..name.." location")
		return false, "NGK: Sorry, we are unable to locate your country, so you cannot enter!"
	end	
>>>>>>> origin/master
end