/*--------------------------------------------------
	=============== Autorun File ===============
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
------------------ Addon Information ------------------
local PublicAddonName = "Zombie SNPCs"
local AddonName = "Zombie"
local AddonType = "SNPC"
local AutorunFile = "autorun/vj_zss_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "Zombies"
	
	-- Regular
	VJ.AddNPC("Slow Zombie 1","npc_vj_zss_zombie1",vCat)
	VJ.AddNPC("Slow Zombie 2","npc_vj_zss_zombie2",vCat)
	VJ.AddNPC("Slow Zombie 3","npc_vj_zss_zombie3",vCat)
	VJ.AddNPC("Slow Zombie 4","npc_vj_zss_zombie4",vCat)
	VJ.AddNPC("Slow Zombie 5","npc_vj_zss_zombie5",vCat)
	VJ.AddNPC("Slow Zombie 6","npc_vj_zss_zombie6",vCat)
	VJ.AddNPC("Slow Zombie 7","npc_vj_zss_zombie7",vCat)
	VJ.AddNPC("Slow Zombie 8","npc_vj_zss_zombie8",vCat)
	VJ.AddNPC("Slow Zombie 9","npc_vj_zss_zombie9",vCat)
	VJ.AddNPC("Slow Zombie 10","npc_vj_zss_zombie10",vCat)
	VJ.AddNPC("Slow Zombie 11","npc_vj_zss_zombie11",vCat)
	VJ.AddNPC("Slow Zombie 12","npc_vj_zss_zombie12",vCat)
	VJ.AddNPC("Zombie Panic 1","npc_vj_zss_zp1",vCat)
	VJ.AddNPC("Zombie Panic 2","npc_vj_zss_zp2",vCat)
	VJ.AddNPC("Zombie Panic 3","npc_vj_zss_zp3",vCat)
	VJ.AddNPC("Zombie Panic 4","npc_vj_zss_zp4",vCat)
	VJ.AddNPC("Fast Zombie 1","npc_vj_zss_zombfast1",vCat)
	VJ.AddNPC("Fast Zombie 2","npc_vj_zss_zombfast2",vCat)
	VJ.AddNPC("Fast Zombie 3","npc_vj_zss_zombfast3",vCat)
	VJ.AddNPC("Fast Zombie 4","npc_vj_zss_zombfast4",vCat)
	VJ.AddNPC("Fast Zombie 5","npc_vj_zss_zombfast5",vCat)
	VJ.AddNPC("Fast Zombie 6","npc_vj_zss_zombfast6",vCat)
	
	-- MISC
	VJ.AddNPC("Crabless Zombie","npc_vj_zss_czombie",vCat)
	VJ.AddNPC("Crabless Zombie Torso","npc_vj_zss_czombietors",vCat)
	VJ.AddNPC("Crabless Zombine","npc_vj_zss_zombguard",vCat)
	VJ.AddNPC("Crabless Poison Zombie","npc_vj_zss_cpzombie",vCat)
	VJ.AddNPC("Crabless Fast Zombie","npc_vj_zss_cfastzombie",vCat)
	VJ.AddNPC("Zombie Boss","npc_vj_zss_zboss",vCat)
	VJ.AddNPC("Mini Zombie Boss","npc_vj_zss_zminiboss",vCat)
	VJ.AddNPC("Zombie Hulk","npc_vj_zss_zhulk",vCat)
	VJ.AddNPC("Burnzie","npc_vj_zss_burnzie",vCat)
	VJ.AddNPC("Draggy","npc_vj_zss_draggy",vCat)
	VJ.AddNPC("UnDead Stalker","npc_vj_zss_undeadstalker",vCat)

	--custom
	VJ.AddNPC("Zombie C1Boss", "npc_vj_zss_c1boss",vCat)
	VJ.AddNPC("Zombie Medic", "npc_vj_zss_zmedic",vCat)
	VJ.AddNPC("Zombie C2Boss", "npc_vj_zss_c2boss", vCat)
	
	-- Spawners
	VJ.AddNPC("Random Slow Zombie","sent_vj_zss_zombierand",vCat)
	VJ.AddNPC("Random Fast Zombie","sent_vj_zss_fastrand",vCat)
	VJ.AddNPC("Random Zombie Panic","sent_vj_zss_zprand",vCat)
	VJ.AddNPC("Random Regular Zombie","sent_vj_zss_randregularz",vCat)
	VJ.AddNPC("Random Fast Zombie Spawner","sent_vj_zss_fastrand_spawner",vCat)
	VJ.AddNPC("Random Slow Zombie Spawner","sent_vj_zss_zombierand_spawner",vCat)
	VJ.AddNPC("Random Zombie Panic Spawner","sent_vj_zss_zprand_spawner",vCat)
	VJ.AddNPC("Random Regular Zombie Spawner","sent_vj_zss_randregular_spawner",vCat)
	VJ.AddNPC("Random Zombie","sent_vj_zss_allrand",vCat)
	VJ.AddNPC("Random Zombie Spawner","sent_vj_zss_allrand_spawner",vCat)
	VJ.AddNPC("C1Boss Zombie Spawner", "sent_vj_zss_c1boss_spawner",vCat)

	-- ConVars --
	VJ.AddConVar("vj_zss_slowz_h",150)
	VJ.AddConVar("vj_zss_slowz_d",20)
	VJ.AddConVar("vj_zss_slowz_d_hard",30)

	VJ.AddConVar("vj_zss_fastz_h",150)
	VJ.AddConVar("vj_zss_fastz_d",20)
	VJ.AddConVar("vj_zss_fastz_d_leap",15)

	VJ.AddConVar("vj_zss_zps_h",200)
	VJ.AddConVar("vj_zss_zps_d",35)

	VJ.AddConVar("vj_zss_zombine_h",200)
	VJ.AddConVar("vj_zss_zombine_d",35)
	VJ.AddConVar("vj_zss_zombine_d_hard",45)

	VJ.AddConVar("vj_zss_hlzombie_h",150)
	VJ.AddConVar("vj_zss_hlzombie_d",20)
	VJ.AddConVar("vj_zss_hlzombie_d_hard",30)

	VJ.AddConVar("vj_zss_hlzombietors_h",60)
	VJ.AddConVar("vj_zss_hlzombietors_d",20)

	VJ.AddConVar("vj_zss_poisonz_h",250)
	VJ.AddConVar("vj_zss_poisonz_d",40)

	VJ.AddConVar("vj_zss_hulk_h",600)
	VJ.AddConVar("vj_zss_hulk_d",65)

	VJ.AddConVar("vj_zss_zboss_h",850)
	VJ.AddConVar("vj_zss_zboss_d",70)
	VJ.AddConVar("vj_zss_zboss_d_hard",80)

	VJ.AddConVar("vj_zss_zbossmini_h",500)
	VJ.AddConVar("vj_zss_zbossmini_d",55)
	VJ.AddConVar("vj_zss_zbossmini_d_hard",65)

	VJ.AddConVar("vj_zss_burnzie_h",300)
	VJ.AddConVar("vj_zss_burnzie_d",20)

	VJ.AddConVar("vj_zss_draggy_h",350)
	VJ.AddConVar("vj_zss_draggy_d",20)

	VJ.AddConVar("vj_zss_undeadstalker_h",300)
	VJ.AddConVar("vj_zss_undeadstalker_d",20)

-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end