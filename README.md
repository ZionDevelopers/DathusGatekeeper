![Logo](https://raw.githubusercontent.com/ZionDevelopers/DathusGatekeeper/master/logo.png)

It's a player Country Blocker for Garry's Mod,
Not just that, it's a full set of player join controller,
This is a game addon for [Garry's Mod][] servers, NOT FOR SINGLEPLAYER!

### Setup

Just download this addon by clicking on Download ZIP and extract the addon in ````Steam\SteamApps\common\GarrysMod\garrysmod\addons\```` as usual.

### Workshop Ready!

It's now available via the Steam Workshop! Go to [its Workshop page][workshop].

### Manual Installation

Simply clone this repository into your `addons` folder:

    cd "%programfiles(x86)%/Steam/SteamApps/common/GarrysMod/garrysmod/addons"
    git clone https://github.com/ZionDevelopers/DathusGatekeeper.git DathusGatekeeper


### Server's ConVars
```
Name, Default, Accepted, Description
dgk_whitelist_enabled, 0, 0/1, "Enable or Disable the Dathus' Gatekeeper Server Whitelist"
dgk_whitepass_enabled, 1, 0,1, "Enable or Disable the Dathus' Gatekeeper Server Whitepass"
dgk_countryblocker_enabled, 1, 0/1, "Enable or Disable the Dathus' Gatekeeper Country blocker"
dgk_reservedslots_enabled, 1, 0/1, "Enable or Disable the Dathus' Gatekeeper Reserved Slots for Admins"
dgk_scatman_enabled, 1, 0/1, "Enable or Disable the Dathus' Gatekeeper Server-wide Scatman's mode notification and music play"
```

### IP Database
This addon comes with one, which you can download from Github, but is an outdated one, [GeoIPDatabase][] save as geoip-db.txt on data/dathus_gatekeeper/.

If you manage to find an updated version of GeoIP1 Lite "GeoIPCountryCSV.zip" from maxmind send to us here, The version we got is from 2017-12-06.

### Requirements
You will need an IP database in the right format, And to use all the features you will need to use [ULX][] or [Exsto][].

### License

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
To view a copy of this license, visit [Common Creative's Website][License].

[Garry's Mod]: <http://garrysmod.com/>
[workshop]: <http://steamcommunity.com/sharedfiles/filedetails/?id=734208849>
[Exsto]: <https://github.com/prefanatic/exsto>
[License]: <https://creativecommons.org/licenses/by-nc-sa/4.0/>
[GeoIPDatabase]: <https://raw.githubusercontent.com/ZionDevelopers/DathusGatekeeper/master/data/dathus_gatekeeper/geoip-db.txt>
[ULX]: <https://github.com/TeamUlysses/ulx>
