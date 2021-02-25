

--[[
==========================================Civs==================================================
-------------------------------------Legal Notices:---------------------------------------------
Civs is copyright © 2016 by Robert Blackmon; alias Bobbleheadbob.
Do not sell or distribute Civs without permission. That's not cool.
------------------------------------------------------------------------------------------------
CIVS DOWNLOAD: https://scriptfodder.com/scripts/view/2092
CONTACT ME: http://steamcommunity.com/id/bobblackmon/ | http://facepunch.com/member.php?u=438603
================================================================================================
]]

Civs = Civs or {}
include("sh_civs_config.lua")

if SERVER then
	AddCSLuaFile("civs/cl_civs.lua")
	AddCSLuaFile("sh_civs_config.lua")

--	include("civs/sv_civs.lua")
	include("civs/sv_zombies.lua")
else

	include("civs/cl_civs.lua")
end
