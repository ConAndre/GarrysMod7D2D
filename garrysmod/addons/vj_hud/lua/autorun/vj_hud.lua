/*--------------------------------------------------
	=============== VJ HUD ===============
	*** Copyright (c) 2012-2019 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
--------------------------------------------------*/
if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
/*----------------------------------------------------------
	-- Screen Information --
Down = Positive
Up = Negative
Right = Positive
Left = Negative
----------------------------------------------------------*/

if (SERVER) then
	util.AddNetworkString("vj_hud_godmode")
	net.Receive("vj_hud_godmode",function(len,pl)
		ent = net.ReadEntity()
		if IsValid(ent) then
			ent:SetNWBool("vj_hud_godmode", ent:HasGodMode())
		end
	end)
	
	util.AddNetworkString("vj_hud_trgethealth")
	net.Receive("vj_hud_trgethealth",function(len,pl)
		me = net.ReadEntity()
		ent = net.ReadEntity()
		if IsValid(me) && IsValid(ent) then
			me:SetNWInt("vj_hud_trhealth", ent:Health())
			me:SetNWInt("vj_hud_trmaxhealth", ent:GetMaxHealth())
			if ent:IsNPC() then
				me:SetNWInt("vj_hud_tr_npc_disposition", ent:Disposition(me))
				
				if ent.IsVJBaseSNPC == true then
					me:SetNWInt("vj_hud_tr_npc_boss", ent.VJ_IsHugeMonster)
				else
					me:SetNWInt("vj_hud_tr_npc_boss", false)
				end
			end
		end
	end)
end

if (!CLIENT) then return end -- Asorme verch, minag CLIENT abranknere gashkhadi

local mat_crossh1 = Material("Crosshair/vj_crosshair1.vtf")
local mat_crossh2 = Material("Crosshair/vj_crosshair2.vtf")
local mat_crossh3 = Material("Crosshair/vj_crosshair3.vtf")
local mat_crossh4 = Material("Crosshair/vj_crosshair4.vtf")
local mat_crossh5 = Material("Crosshair/vj_crosshair5.vtf")
local mat_crossh6 = Material("Crosshair/vj_crosshair6.vtf")
local mat_crossh7 = Material("Crosshair/vj_crosshair7.vtf")
local mat_crossh8 = Material("Crosshair/vj_crosshair8.vtf")
local mat_crossh9 = Material("Crosshair/vj_crosshair9.vtf")
local mat_flashlight = Material("vj_hud/flashlight.png")
local mat_grenade = Material("vj_hud/grenade.png")
local mat_secondary = Material("vj_hud/secondary.png")
local mat_health = Material("vj_hud/hp.png")
local mat_armor = Material("vj_hud/armor.png")
local mat_knife = Material("vj_hud/knife.png")
local mat_skull = Material("vj_hud/skull.png")
local mat_kd = Material("vj_hud/kd.png")
local mat_run = Material("vj_hud/running.png")
local mat_fps = Material("vj_hud/fps.png")
local mat_ping = Material("vj_hud/ping.png")
local mat_car = Material("vj_hud/car.png")
local mat_boss = Material("vj_hud/boss.png")

LocalPlayer():SetNWBool("vj_hud_godmode", false)
LocalPlayer():SetNWInt("vj_hud_trhealth", 0)
LocalPlayer():SetNWInt("vj_hud_trmaxhealth", 0)
LocalPlayer():SetNWInt("vj_hud_tr_npc_disposition", D_NU)
LocalPlayer():SetNWInt("vj_hud_tr_npc_boss", false)

-- As function-en mechi abranknere 24 jam ge vazen
local hud_enabled = GetConVarNumber("vj_hud_enabled")
local function VJHUD_RunVariables()
	hud_enabled = GetConVarNumber("vj_hud_enabled")
	hud_unitsystem = GetConVarNumber("vj_hud_metric")
end
hook.Add("HUDPaint", "VJ HUD - Variables", VJHUD_RunVariables)

function VJ_ConvertToRealUnit(pos)
    local result;
	if hud_unitsystem == 1 then
		result = math.Round((pos / 16) / 3.281).." M"
	else
		result = math.Round(pos / 16).." FT"
	end
	return result
end

-- Hide HL2 Elements ---------------------------------------------------------------------------------------------------------------------------------------------
local GMOD_HUD = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
}
local GMOD_Crosshair = {
	["CHudCrosshair"] = true
}
local function HUDShouldDraw(name)
	if GetConVarNumber("vj_hud_disablegmod") == 1 then
		if (GMOD_HUD[name]) then return false end
	end
	if GetConVarNumber("vj_hud_disablegmodcross") == 1 then
		if (GMOD_Crosshair[name]) then return false end
	end
end
hook.Add("HUDShouldDraw", "Hide Garry's Mod HUD", HUDShouldDraw)

-- Crosshair ---------------------------------------------------------------------------------------------------------------------------------------------
function VJHUD_Crosshair()
	local ply = LocalPlayer()
	if !ply:Alive() or hud_enabled == 0 or GetConVarNumber("vj_hud_ch_enabled") == 0 then return end
	if ply:InVehicle() && GetConVarNumber("vj_hud_ch_invehicle") == 0 then return end
	
	local size = GetConVarNumber("vj_hud_ch_crosssize")
	local garmir = GetConVarNumber("vj_hud_ch_r")
	local ganach = GetConVarNumber("vj_hud_ch_g")
	local gabouyd = GetConVarNumber("vj_hud_ch_b")
	local opacity = GetConVarNumber("vj_hud_ch_opacity")
	local mat = GetConVarNumber("vj_hud_ch_mat")
	
	if mat == 0 then
		surface.SetMaterial(mat_crossh1)
	elseif mat == 1 then
		surface.SetMaterial(mat_crossh2)
	elseif mat == 2 then
		surface.SetMaterial(mat_crossh3)
	elseif mat == 3 then
		surface.SetMaterial(mat_crossh4)
	elseif mat == 4 then
		surface.SetMaterial(mat_crossh5)
	elseif mat == 5 then
		surface.SetMaterial(mat_crossh6)
	elseif mat == 6 then
		surface.SetMaterial(mat_crossh7)
	elseif mat == 7 then
		surface.SetMaterial(mat_crossh8)
	elseif mat == 8 then
		surface.SetMaterial(mat_crossh9)
	end
	surface.SetDrawColor(garmir, ganach, gabouyd, opacity)
	surface.DrawTexturedRect(ScrW() / 2 - size / 2, ScrH() / 2 - size / 2, size, size)
	
	//surface.DrawTexturedRect(ScrW() / ply:GetAimVector().x, ScrH() / ply:GetAimVector().y, size, size)
	//surface.DrawCircle(ScrW() / ply:GetAimVector().x, ScrH() / ply:GetAimVector().y, 100, {garmir, ganach, gabouyd, opacity})
end
hook.Add("HUDPaint","VJ HUD - Crosshair",VJHUD_Crosshair)

-- Ammo Area ---------------------------------------------------------------------------------------------------------------------------------------------
function VJHUD_Ammo()
	local ply = LocalPlayer()
	if !ply:Alive() or hud_enabled == 0 or GetConVarNumber("vj_hud_ammo") == 0 then return end
	if ply:InVehicle() && GetConVarNumber("vj_hud_ammo_invehicle") == 0 then return end
	
	if (ply:GetActiveWeapon() == NULL or ply:GetActiveWeapon() == "Camera") then
		//local nowep_blinka = math.abs(math.sin(CurTime() * 6) * 200)
		//local nowep_blinkb = math.abs(math.sin(CurTime() * 6) * 255)
		//draw.RoundedBox(8, ScrW()-355, ScrH()-70, 330, 35, Color(150, 0, 0, nowep_blinka))
		//draw.SimpleText("Ammo - No Weapon Detected!", "VJFont_Trebuchet24_Medium", ScrW()-340, ScrH()-66, Color(255, 153, 0, nowep_blinkb), 0, 0)
		return 
	end
	
	-- Poon abranknere
	draw.RoundedBox(1, ScrW()-195, ScrH()-130, 180, 95, Color(0, 0, 0, 150))
	local curwep = ply:GetActiveWeapon() -- Current weapon your holding
	local mag_left = curwep:Clip1() -- How much ammunition you have inside the current magazine
	local mag_extra = ply:GetAmmoCount(curwep:GetPrimaryAmmoType()) -- How much ammunition you have outside the current magazine
	local sec_ammo = ply:GetAmmoCount(curwep:GetSecondaryAmmoType()) -- How much ammunition you have for your secondary fire
	//draw.SimpleText("Weapons - "..table.Count(ply:GetWeapons()),"VJFont_Trebuchet24_Small", ScrW()-340, ScrH()-95, Color(255, 255, 255, 150), 0, 0) -- Kani had zenk oones
	surface.SetMaterial(mat_flashlight)
	/*if ply:FlashlightIsOn() then -- Kouyne pokh e yete pil-e pats e
		surface.SetDrawColor(255, 255, 255, 150)
	else
		surface.SetDrawColor(255, 255, 255, 50)
	end*/
	
	if ply:FlashlightIsOn() then -- Yete player-in pile pats-e
		surface.SetDrawColor(0, 255, 255, 255)
		surface.DrawTexturedRectRotated(ScrW()-230, ScrH()-55, 35, 35, 90)
		draw.RoundedBox(1, ScrW()-260, ScrH()-75, 60, 40, Color(0, 0, 0, 150))
	end

	-- Kani had nernag oones
	surface.SetMaterial(mat_grenade)
	surface.SetDrawColor(0, 255, 255, 150)
	surface.DrawTexturedRect(ScrW()-95, ScrH()-70, 25, 25)
	draw.SimpleText(ply:GetAmmoCount("grenade"),"VJFont_Trebuchet24_MediumLarge", ScrW()-70, ScrH()-70, Color(0, 255, 255, 150), 0, 0)
	
	if curwep:IsWeapon() then
		local wepname = curwep:GetPrintName()
		if string.len(wepname) > 22 then
			wepname = string.sub(curwep:GetPrintName(),1,20).."..."
		end
		draw.SimpleText(wepname,"VJFont_Trebuchet24_Small", ScrW()-185, ScrH()-125, Color(225, 255, 255, 150), 0, 0)
	end
	
	local hasammo = true
	local ammo_not_use = false -- Does it use ammo? = true for things like gravity gun or physgun
	local ammo_pri = mag_left.." / "..mag_extra
	local ammo_pri_c = Color(0, 255, 0, 150)
	local ammo_sec = sec_ammo
	local ammo_sec_c = Color(0, 255, 255, 150)
	local empty_blink = math.abs(math.sin(CurTime() * 4) * 255)
	local max_ammo = curwep:GetMaxClip1()
	
	if max_ammo == nil or max_ammo == 0 or max_ammo == -1 then max_ammo = false end
	if mag_left <= 0 && mag_extra <= 0 then hasammo = false end
	
	if max_ammo != false then // If the current weapon has a proper clip size, then continue...
		local perc_left = math.Clamp((mag_left / max_ammo) * 255, 2, 255) -- Find the percentage of the mag left in respect to the max ammo (proportional) | Clamp at min: 2, max: 255
		if perc_left <= 127.5 then // 127.5  = 50% of 255
			ammo_pri_c = Color(255, 40 + perc_left, 0, 255)
		end
	end
		
	if hasammo == true && mag_left <= 0 then -- Mag is empty but has reserve
		ammo_pri = "--- / "..mag_extra
		ammo_pri_c = Color(255, 0, 0, empty_blink)
	end
	if mag_left == -1 && curwep:GetSecondaryAmmoType() == -1 then -- Uses primary only with no ammo reserve, ex: "weapon_rpg" or "weapon_frag"
		ammo_pri = mag_extra
		ammo_pri_c = Color(0, 255, 0, 150)
		ammo_sec = "---"
		ammo_sec_c = Color(255, 100, 0, 150)
	end
	if curwep:GetPrimaryAmmoType() == -1 then -- Weapons that use secondary as primary, ex: "weapon_slam"
		ammo_pri = sec_ammo
		ammo_sec = "---"
		ammo_sec_c = Color(255, 100, 0, 150)
	end
	if curwep:GetPrimaryAmmoType() == -1 && curwep:GetSecondaryAmmoType() == -1 then -- Doesn't use ammo
		ammo_not_use = true
		ammo_pri = "---"
		ammo_pri_c = Color(255, 100, 0, 150)
		ammo_sec = "---"
		ammo_sec_c = Color(255, 100, 0, 150)
	elseif hasammo == false then -- Primary empty!
		ammo_pri = "Empty!"
		ammo_pri_c = Color(255, 0, 0, empty_blink)
	end
	if curwep:GetSecondaryAmmoType() == -1 then -- Doesn't use secondary ammo
		ammo_sec = "---"
		ammo_sec_c = Color(255, 100, 0, 150)
	elseif sec_ammo == 0 then -- Secondary Empty!
		ammo_sec = "Empty!"
		ammo_sec_c = Color(255, 0, 0, empty_blink)
	end
	local ammo_pri_len = string.len(ammo_pri)
	local ammo_pri_pos = 110
	if ammo_pri_len > 1 then
		ammo_pri_pos = ammo_pri_pos + (6.5*ammo_pri_len)
	end
	draw.SimpleText(ammo_pri, "VJFont_Trebuchet24_Large", ScrW()-ammo_pri_pos, ScrH()-108, ammo_pri_c, 0, 0)
	surface.SetMaterial(mat_secondary)
	surface.SetDrawColor(ammo_sec_c)
	surface.DrawTexturedRect(ScrW()-190, ScrH()-70, 25, 25)
	draw.SimpleText(ammo_sec, "VJFont_Trebuchet24_MediumLarge", ScrW()-163, ScrH()-70, ammo_sec_c, 0, 0)
	
	-- Reloading bar
	if ammo_not_use == false then
		local model_vm = ply:GetViewModel()
		if ply:GetActiveWeapon().CW_VM then model_vm = ply:GetActiveWeapon().CW_VM end -- For CW 2.0 weapons
		if (model_vm:GetSequenceActivity(model_vm:GetSequence()) == ACT_VM_RELOAD or string.match(model_vm:GetSequenceName(model_vm:GetSequence()), "reload") != nil) then
			local anim_perc = math.ceil(model_vm:GetCycle() * 100) -- Get the percentage of how long it will take until it finished reloading
			local anim_dur = model_vm:SequenceDuration() - (model_vm:SequenceDuration() * model_vm:GetCycle()) -- Get the number of seconds until it finishes reloading
			anim_dur = string.format("%.1f",math.Round(anim_dur,1)) -- Round to 1 decimal point and format it to keep a 0 ( if applicable)
			if anim_perc < 100 then
				draw.RoundedBox(8, ScrW()-195, ScrH()-160, 180, 25, Color(0,255,255,40))
				draw.RoundedBox(8, ScrW()-195, ScrH()-160, math.Clamp(anim_perc,0,100)*1.8, 25, Color(0,255,255,160))
				draw.RoundedBox(8, ScrW()-195, ScrH()-160, 180, 25, Color(0, 0, 0, 150))
				draw.SimpleText(anim_dur.."s ("..anim_perc.."%)","VJFont_Trebuchet24_SmallMedium", ScrW()-137, ScrH()-156, Color(225, 255, 255, 150), 0, 0)
			end
		end
	end
end
hook.Add("HUDPaint","VJ HUD - Ammo",VJHUD_Ammo)

-- Health Area ---------------------------------------------------------------------------------------------------------------------------------------------
local lerp_hp = 0
local lerp_armor = 0

function VJHUD_Health()
	local ply = LocalPlayer()
	if hud_enabled == 0 then return end
	if !ply:Alive() then -- Meradz tsootsage
		local deadhealth_blinka = math.abs(math.sin(CurTime() * 6) * 200)
		local deadhealth_blinkb = math.abs(math.sin(CurTime() * 6) * 255)
		draw.RoundedBox(8, 70, ScrH()-80, 142, 30, Color(150, 0, 0, deadhealth_blinka))
		draw.SimpleText("USER DEAD", "VJFont_Trebuchet24_Medium", 85, ScrH()-77, Color(255, 255, 0, deadhealth_blinkb),0,0)
	elseif GetConVarNumber("vj_hud_health") == 1 then
		draw.RoundedBox(1, 15, ScrH()-130, 245, 95, Color(0, 0, 0, 150))
		local hp_r = 0
		local hp_g = 255
		local hp_b = 0
		local hp_blink = math.abs(math.sin(CurTime() * 2) * 255)
		lerp_hp = Lerp(5*FrameTime(),lerp_hp,ply:Health())
		lerp_armor = Lerp(5*FrameTime(),lerp_armor,ply:Armor())
		net.Start("vj_hud_godmode")
		net.WriteEntity(ply)
		net.SendToServer()
		if ply:GetNWBool("vj_hud_godmode") == true then
			hp_r = 255
			hp_g = 102
			hp_b = 255
			draw.RoundedBox(8, 15, ScrH()-160, 155, 25, Color(0, 0, 0, 150))
			draw.SimpleText("God Mode Enabled!","VJFont_Trebuchet24_SmallMedium",25,ScrH()-156,Color(hp_r,hp_g,hp_b,255),0,0)
		else
			local warning = 0
			if lerp_hp <= 35 then
				hp_blink = math.abs(math.sin(CurTime() * 4) * 255)
				hp_r = 255
				hp_g = 0 + (5*ply:Health())
				warning = 1
			end
			if lerp_hp <= 20 then -- Low Health Warning
				hp_blink = math.abs(math.sin(CurTime() * 6) * 255)
				warning = 2
			end
			if warning == 1 then
				draw.RoundedBox(8, 15, ScrH()-160, 180, 25, Color(150, 0, 0, math.abs(math.sin(CurTime() * 4) * 200)))
				draw.SimpleText("WARNING: Low Health!","VJFont_Trebuchet24_SmallMedium",25,ScrH()-156,Color(255,153,0,math.abs(math.sin(CurTime() * 4) * 255)),0,0)
			elseif warning == 2 then
				draw.RoundedBox(8, 15, ScrH()-160, 220, 25, Color(150, 0, 0, math.abs(math.sin(CurTime() * 6) * 200)))
				draw.SimpleText("WARNING: Death Imminent!","VJFont_Trebuchet24_SmallMedium",25,ScrH()-156,Color(255,153,0,math.abs(math.sin(CurTime() * 6) * 255)),0,0)
			end
		end
		
		-- Aroghchoutyoun
		surface.SetMaterial(mat_health)
		surface.SetDrawColor(Color(hp_r, hp_g, hp_b, hp_blink))
		surface.DrawTexturedRect(22, ScrH()-127, 40, 45)
		draw.SimpleText(string.format("%.0f", lerp_hp).."%", "VJFont_Trebuchet24_Medium", 70, ScrH()-128, Color(hp_r, hp_g, hp_b, 255), 0, 0)
		draw.RoundedBox(0, 70, ScrH()-105, 180, 15, Color(hp_r,hp_g,hp_b,40))
		draw.RoundedBox(0, 70, ScrH()-105, math.Clamp(lerp_hp,0,100)*1.8,15, Color(hp_r,hp_g,hp_b,255))
		surface.SetDrawColor(hp_r,hp_g,hp_b,255)
		surface.DrawOutlinedRect( 70, ScrH()-105,180,15)
		
		-- Bashbanelik
		surface.SetMaterial(mat_armor)
		surface.SetDrawColor(Color(0, 255, 255, 150))
		surface.DrawTexturedRect(22, ScrH()-80, 40, 40)
		draw.SimpleText(string.format("%.0f", lerp_armor).."%","VJFont_Trebuchet24_Medium",70,ScrH()-83,Color(0,255,255,160),0,0)
		draw.RoundedBox(0, 70, ScrH()-60, 180, 15, Color(0,255,255,40))
		draw.RoundedBox(0, 70, ScrH()-60, math.Clamp(lerp_armor,0,100)*1.8,15, Color(0,255,255,160))
		surface.SetDrawColor(0,150,150,255)
		surface.DrawOutlinedRect( 70, ScrH()-60,180,15)
	end
end
hook.Add("HUDPaint","VJ HUD - Health",VJHUD_Health)

-- Player Information Area ---------------------------------------------------------------------------------------------------------------------------------------------
local next_fps = 0

function VJHUD_LocalPlayerInformation()
	local ply = LocalPlayer()
	if !ply:Alive() or hud_enabled == 0 or GetConVarNumber("vj_hud_playerinfo") == 0 then return end
	draw.RoundedBox(1, 260, ScrH()-130, 200, 95, Color(0, 0, 0, 150))
	//draw.RoundedBox( 8, ScrW()*0.01, ScrH()*0.01, 128, 46, Color( 125, 125, 125, 125 ) )
	//draw.RoundedBox( 8, ScrW()-1665, ScrH()-235, 185, 150, Color( 0, 0, 0, 150 ) )
	//draw.RoundedBox( 8, ScrW()-1665, ScrH()-235, 185, 40, Color( 0, 0, 0, 100 ) )
	/*if ply:IsAdmin() then
	draw.SimpleText("Admin: Yes","VJFont_Trebuchet24_Tiny", 160, ScrH()-137, Color(255, 255, 255, 150), 0, 0) else
	draw.SimpleText("Admin: No","VJFont_Trebuchet24_Tiny", 160, ScrH()-137, Color(255, 255, 255, 150), 0, 0) end
	if GetConVarNumber("sv_Cheats") == 1 then
	draw.SimpleText("Cheats: On","VJFont_Trebuchet24_Tiny", 160, ScrH()-124, Color(255, 255, 255, 150), 0, 0) else
	draw.SimpleText("Cheats: Off","VJFont_Trebuchet24_Tiny", 160, ScrH()-124, Color(255, 255, 255, 150), 0, 0) end
	if GetConVarNumber("ai_disabled") == 0 then
	draw.SimpleText("NPC AI: On","VJFont_Trebuchet24_Tiny", 160, ScrH()-111, Color(255, 255, 255, 150), 0, 0) else
	draw.SimpleText("NPC AI: Off","VJFont_Trebuchet24_Tiny", 160, ScrH()-111, Color(255, 255, 255, 150), 0, 0) end
	if GetConVarNumber("ai_ignoreplayers") == 1 then
	draw.SimpleText("IgnorePly: On","VJFont_Trebuchet24_Tiny", 160, ScrH()-98, Color(255, 255, 255, 150), 0, 0) else
	draw.SimpleText("IgnorePly: Off","VJFont_Trebuchet24_Tiny", 160, ScrH()-98, Color(255, 255, 255, 150), 0, 0) end*/
	/*if GetConVarNumber("ai_serverragdolls") == 1 then
	draw.SimpleText("Cropses: On","VJFont_Trebuchet24_Tiny", 160, ScrH()-90, Color(255, 255, 255, 150), 0, 0) else
	draw.SimpleText("Cropses: Off","VJFont_Trebuchet24_Tiny", 160, ScrH()-90, Color(255, 255, 255, 150), 0, 0) end*/
	//draw.SimpleText("Team: "..team.GetName( ply:Team() ),"VJFont_Trebuchet24_Tiny", 20, 842, Color(255, 255, 255, 150), 0, 0)
	//draw.SimpleText("Map: "..game.GetMap(), "VJFont_Trebuchet24_Tiny", 30, ScrH()-143, Color(255, 255, 255, 150),0,0)
	//draw.SimpleText("Gamemode: "..gmod.GetGamemode().Name, "VJFont_Trebuchet24_Tiny", 30, ScrH()-130, Color(255, 255, 255, 150),0,0)
	
	//draw.SimpleText(os.date("%a,%I:%M:%S %p"), "VJFont_Trebuchet24_SmallMedium", 330, ScrH()-125, Color(0, 255, 255, 150),0,0)
	//draw.SimpleText(os.date("%m/%d/20%y"), "VJFont_Trebuchet24_SmallMedium", 350, ScrH()-110, Color(0, 255, 255, 150),0,0)
	
	surface.SetMaterial(mat_knife)
	surface.SetDrawColor(Color(255, 255, 255, 150))
	surface.DrawTexturedRect(260, ScrH()-125, 28, 28)
	draw.SimpleText(ply:Frags(), "VJFont_Trebuchet24_Medium", 293, ScrH()-125, Color(255, 255, 255, 150),100,100)
	
	surface.SetMaterial(mat_skull)
	surface.SetDrawColor(Color(255, 255, 255, 150))
	surface.DrawTexturedRect(260, ScrH()-95, 28, 28)
	draw.SimpleText(ply:Deaths(), "VJFont_Trebuchet24_Medium", 293, ScrH()-93, Color(255, 255, 255, 150),100,100)
	
	local kd;
	if ply:Frags() == 0 && ply:Deaths() == 0 then
		kd = 0
	elseif ply:Deaths() == 0 then
		kd = ply:Frags()
	else
		kd = math.Round(ply:Frags()/ply:Deaths(),2)
	end
	if kd < 0 then kd = 0 end
	if kd > 10 then kd = math.Round(kd,1) end
	surface.SetMaterial(mat_kd)
	surface.SetDrawColor(Color(255, 255, 255, 150))
	surface.DrawTexturedRect(260, ScrH()-65, 28, 28)
	draw.SimpleText(kd, "VJFont_Trebuchet24_Medium", 293, ScrH()-63, Color(255, 255, 255, 150),100,100)
	
    local speed;
	if hud_unitsystem == 1 then
		speed = math.Round((ply:GetVelocity():Length() * 0.04263382283) * 1.6093).."KPH"
	else
		speed = math.Round(ply:GetVelocity():Length() * 0.04263382283).."MPH"
	end
	surface.SetMaterial(mat_run)
	surface.SetDrawColor(Color(255, 255, 255, 150))
	surface.DrawTexturedRect(340, ScrH()-125, 28, 28)
	draw.SimpleText(speed, "VJFont_Trebuchet24_Medium", 373, ScrH()-125, Color(255, 255, 255, 150),100,100)

	if CurTime() > next_fps then
		fps = tostring(math.ceil(1/FrameTime()))
		next_fps = CurTime() + 0.5
	end
	surface.SetMaterial(mat_fps)
	surface.SetDrawColor(Color(255, 255, 255, 150))
	surface.DrawTexturedRect(340, ScrH()-95, 28, 28)
	draw.SimpleText(fps.."fps", "VJFont_Trebuchet24_Medium", 373, ScrH()-93, Color(255, 255, 255, 150),0,0)
	
	surface.SetMaterial(mat_ping)
	surface.SetDrawColor(Color(255, 255, 255, 150))
	surface.DrawTexturedRect(340, ScrH()-65, 28, 28)
	draw.SimpleText(ply:Ping().."ms", "VJFont_Trebuchet24_Medium", 373, ScrH()-63, Color(255, 255, 255, 150),0,0)
	
	if IsValid(ply:GetVehicle()) then
		draw.RoundedBox(1, 320, ScrH()-160, 140, 30, Color(0, 0, 0, 150))
		local speedcalc = ply:GetVehicle():GetVelocity():Length()
		if IsValid(ply:GetVehicle():GetParent()) then
			speedcalc = ply:GetVehicle():GetParent():GetVelocity():Length()
		end
		local speed;
		if hud_unitsystem == 1 then
			speed = math.Round((speedcalc * 0.04263382283) * 1.6093).."KPH"
		else
			speed = math.Round(speedcalc * 0.04263382283).."MPH"
		end
		surface.SetMaterial(mat_car)
		surface.SetDrawColor(Color(255, 255, 255, 150))
		surface.DrawTexturedRect(320, ScrH()-170, 50, 50)
		draw.SimpleText(speed, "VJFont_Trebuchet24_Medium", 373, ScrH()-155, Color(255, 255, 255, 150),100,100)
	end
end
hook.Add("HUDPaint","VJ HUD - Local Player Information",VJHUD_LocalPlayerInformation)


local dayspassed = 0


-- Compass Area ---------------------------------------------------------------------------------------------------------------------------------------------
function VJHUD_Compass()
	local ply = LocalPlayer()
	if !ply:Alive() or hud_enabled == 0 or GetConVarNumber("vj_hud_compass") == 0 then return end

	draw.RoundedBox(1, ScrW() / 2.16, 10, 160, 60, Color(0, 0, 0, 150))

	local trace = util.TraceLine(util.GetPlayerTrace(ply))
	local split = string.Explode(" ", tostring(ply:GetAngles()))
	local ang = tonumber(split[2])
--	local comp_dir = "Unknown!"
--	if ang >= -18 and ang <= 18 then
--		comp_dir = "N"
--	elseif ang >= 162 and ang < 862 then
--		comp_dir = "S"
--	elseif ang <= -162 and ang > -862 then
--		comp_dir = "S"
--	elseif ang == 180 or ang == -862 then
--		comp_dir = "S"
--	elseif ang >= 72 and ang <= 108 then
--		comp_dir = "W"
--	elseif ang <= -72 and ang >= -108 then
--		comp_dir = "E"
--	elseif ang > 18 and ang < 72 then
--		comp_dir = "NW"
--	elseif ang > 108 and ang < 162 then
--		comp_dir = "SW"
--	elseif ang < -18 and ang > -72 then
--		comp_dir = "NE"
--	elseif ang < -108 and ang > -162 then
--		comp_dir = "SE"
--	end

	local CurTimeVar = CurTime()*196 --15 mins a day
	local TimeTable = string.FormattedTime(CurTimeVar)
	local TimeTableH = TimeTable["h"]
	local TimeTableM = TimeTable["m"]


	if TimeTableH >= 24 * (dayspassed > 0 && dayspassed or 1) then
		dayspassed = dayspassed + 1
	end
	
	if TimeTableH > 0 && math.mod(dayspassed , 7) == 0 && dayspassed != 0 then 
		draw.SimpleText("Day: "..dayspassed, "VJFont_Trebuchet24_Large", ScrW() / 1.955, 26, Color(255, 0, 0, 255), 1, 1)
	else
		draw.SimpleText("Day: "..dayspassed, "VJFont_Trebuchet24_Large", ScrW() / 1.955, 26, Color(255, 255, 255, 255), 1, 1)
	end
    --local distrl = VJ_ConvertToRealUnit(ply:GetPos():Distance(trace.HitPos))
	--local distrllen = string.len(tostring(distrl))
  	--local move_ft = 0
	--if distrllen > 4 then
	--	move_ft = move_ft - (0.007*(distrllen-4))
	--end

	if TimeTableH < 24 then 
		if TimeTableM < 10 then
			draw.SimpleText("Time: "..TimeTableH..":0"..TimeTableM, "VJFont_Trebuchet24_Small", ScrW() / 2.05, 40, Color(100, 255, 255, 200), 0, 0)
		else
			draw.SimpleText("Time: "..TimeTableH..":"..TimeTableM, "VJFont_Trebuchet24_Small", ScrW() / 2.05, 40, Color(100, 255, 255, 200), 0, 0)
		end
	elseif TimeTableM < 10 then
		draw.SimpleText("Time: "..math.floor(TimeTableH/dayspassed)..":0"..TimeTableM, "VJFont_Trebuchet24_Small", ScrW() / 2.05, 40, Color(100, 255, 255, 200), 0, 0)
	else
		draw.SimpleText("Time: "..math.floor(TimeTableH/dayspassed)..":"..TimeTableM, "VJFont_Trebuchet24_Small", ScrW() / 2.05, 40, Color(100, 255, 255, 200), 0, 0)
	end
	--local dist = math.Round(ply:GetPos():Distance(trace.HitPos),2)
	--local distlen = string.len(tostring(dist))
	--if distlen >= 7 then
	--	dist = math.Round(ply:GetPos():Distance(trace.HitPos))
	--	distlen = string.len(tostring(dist))
	--end
  	--local move_wu = 0
	--if distlen > 1 then
	--	move_wu = move_wu - (0.007*(distlen-1))
	--end


	--draw.SimpleText("Test: "..CurTimeVar, "VJFont_Trebuchet24_Tiny", ScrW()/ 2, 55, Color(0, 255, 255, 255), 0, 0)
end
hook.Add("HUDPaint","VJ HUD - Compass",VJHUD_Compass)

-- Trace Information ---------------------------------------------------------------------------------------------------------------------------------------------
local lerp_trace_hp = 0
local lerp_trace_hp_entid = 0

function VJHUD_TraceInformation()
	local ply = LocalPlayer()
	if !ply:Alive() or hud_enabled == 0 or GetConVarNumber("vj_hud_trace") == 0 then return end
	local trace = util.TraceLine(util.GetPlayerTrace(ply))
	
	if IsValid(trace.Entity) then
		local ent = trace.Entity
		if !ent:IsNPC() && !ent:IsPlayer() && GetConVarNumber("vj_hud_trace_limited") == 1 then return end -- Yete limited option terver e, mi sharnager
		if IsValid(ply:GetVehicle()) then -- Yete marte otoyi mechne...
			if ent == ply:GetVehicle() then return end -- Yete oton trace-in abrankne, mi sharnager
			if IsValid(ply:GetVehicle():GetParent()) then 
				if ent == ply:GetVehicle():GetParent() then return end -- Yete otonin dznokhke trace-in abrankne, mi sharnager
			end
		end
		//ent:LocalToWorld(ent:OBBCenter()):ToScreen() -- Asiga kordzadze yete meshtegh goozesne tenel
		local pos = ent:LocalToWorld(ent:OBBMaxs()):ToScreen()
		if (pos.visible) then
			local distft = VJ_ConvertToRealUnit(ply:GetPos():Distance(trace.HitPos))
			local dist = math.Round(ply:GetPos():Distance(trace.HitPos),2)
			//local extra_info = ""
			net.Start("vj_hud_trgethealth")
			net.WriteEntity(ply)
			net.WriteEntity(ent)
			net.SendToServer()
		--	draw.SimpleText(distft.."("..dist.." WU)", "VJFont_Trebuchet24_SmallMedium", pos.x, pos.y - 26, Color(0, 255, 255, 255), 0, 0)
			if ent:IsNPC() then 
				draw.SimpleText(language.GetPhrase(ent:GetClass()), "VJFont_Trebuchet24_Medium", pos.x, pos.y + 6, Color(255, 255, 255, 255), 0, 0)
			end
		--	draw.SimpleText(tostring(ent), "VJFont_Trebuchet24_Small", pos.x, pos.y + 10, Color(255, 255, 255, 200), 0, 0)
			
			if ent:IsNPC() then -- NPC-ineroon hamar minag:
				-- Disposition
				local ent_disp = ply:GetNWInt("vj_hud_tr_npc_disposition")
				if ent_disp == 1 then
					draw.SimpleText("Enemy", "VJFont_Trebuchet24_SmallMedium",pos.x, pos.y + 50, Color(255, 0, 0, 255), 0, 0)
				elseif ent_disp == 2 then
					draw.SimpleText("Frightened", "VJFont_Trebuchet24_SmallMedium",pos.x, pos.y + 50, Color(255, 150, 0, 255), 0, 0)
				elseif ent_disp == 3 then
					draw.SimpleText("Friendly", "VJFont_Trebuchet24_SmallMedium",pos.x, pos.y + 50, Color(0, 255, 0, 255), 0, 0)
				elseif ent_disp == 4 then
					draw.SimpleText("Neutral", "VJFont_Trebuchet24_SmallMedium",pos.x, pos.y + 50, Color(255, 150, 0, 255), 0, 0)
				else
					draw.SimpleText("Unknown", "VJFont_Trebuchet24_SmallMedium",pos.x, pos.y + 50, Color(255, 255, 255, 255), 0, 0)
				end
				
				-- Boss Icon
				local ent_monster = ply:GetNWInt("vj_hud_tr_npc_boss")
				if ent_monster == true then
					surface.SetMaterial(mat_boss)
					surface.SetDrawColor(Color(255, 0, 0, 255))
					surface.DrawTexturedRect(pos.x - 30, pos.y + 27, 26, 26)
				end
			end
			
			local ent_hp = ply:GetNWInt("vj_hud_trhealth")
			local ent_hpm = ply:GetNWInt("vj_hud_trmaxhealth")
			if !ent:IsWorld() && !ent:IsVehicle() && ent:Health() != 0 then
				if lerp_trace_hp_entid != ent:EntIndex() then lerp_trace_hp = ent_hpm end
				lerp_trace_hp_entid = ent:EntIndex()
				lerp_trace_hp = Lerp(8*FrameTime(),lerp_trace_hp,ent_hp)
				local hp_box = (190*math.Clamp(lerp_trace_hp,0,ent_hpm))/ent_hpm
				local hp_num = (surface.GetTextSize(ent_hp.."/"..ent_hpm))/2
				local hp_numformat = "/"..ent_hpm
				
				if ent:IsPlayer() then
					hp_box = math.Clamp(lerp_trace_hp,0,100)*1.9
					hp_num = (surface.GetTextSize((ent_hp.."/100")))/2
					hp_numformat = "%"
				end

				draw.RoundedBox(1,pos.x,pos.y+30,190,20,Color(0,255,255,50))
				surface.SetDrawColor(0,255,255,150)
				surface.DrawOutlinedRect(pos.x,pos.y+30,190,20)
				draw.RoundedBox(1,pos.x,pos.y+30,hp_box,20,Color(0,255,255,150))
				draw.SimpleText(string.format("%.0f", lerp_trace_hp)..hp_numformat, "VJFont_Trebuchet24_Small",(pos.x+105)-hp_num,pos.y+31,Color(255,255,255,255))
			end
		end
	end
	
	-- Vari abranknere hin en, asiga veri goghme user-in trace-in masin ge tsetsen e
	/*
	draw.RoundedBox(1, 16, 10, 260, 90, Color(0, 0, 0, 150))
	local TypePos = 80
	local HealthPos = 95
	local tr_pos = trace.Entity:GetPos()
	tr_pos.x = math.Round(tr_pos.x,2)
	tr_pos.y = math.Round(tr_pos.y,2)
	tr_pos.z = math.Round(tr_pos.z,2)
	local ModelDir = tostring(trace.Entity:GetModel())
	local Position = math.Round(tr_pos.x,2).." "..math.Round(tr_pos.y,2).." "..math.Round(tr_pos.z,2)//tostring(tr_pos)
	local Angles = tostring(trace.Entity:GetAngles())
	
	if trace.Entity == NULL then
		local void_blinka = math.abs(math.sin(CurTime() * 6) * 200)
		local void_blinkb = math.abs(math.sin(CurTime() * 6) * 255)
		draw.RoundedBox(8, 16, 125, 185, 25, Color(150, 0, 0, void_blinka))
		draw.SimpleText("WARNING: Out Of World!","VJFont_Trebuchet24_Small",25,130,Color(255,153,0,void_blinkb),0,0)
		draw.SimpleText("File: Void", "VJFont_Trebuchet24_Tiny", 25, 20, Color( 255, 255, 255, 150 ),0,0)
		draw.SimpleText("Class: Void", "VJFont_Trebuchet24_Tiny", 25, 30, Color( 255, 255, 255, 150 ),0,0)
		draw.SimpleText("Position: Void", "VJFont_Trebuchet24_Tiny", 25, 40, Color( 255, 255, 255, 150 ),0,0)
		draw.SimpleText("Angles: Void", "VJFont_Trebuchet24_Tiny", 25, 50, Color( 255, 255, 255, 150 ),0,0)
		draw.SimpleText("Water level: Void", "VJFont_Trebuchet24_Tiny", 25, 60, Color( 255, 255, 255, 150 ),0,0)
		draw.SimpleText("Distance: Void", "VJFont_Trebuchet24_Tiny", 25, 70, Color( 255, 255, 255, 150 ),0,0)
		draw.SimpleText("Type: Void", "VJFont_Trebuchet24_Small", 24, TypePos, Color( 0, 255, 255, 150 ),0,0)
		draw.SimpleText("Health: Void", "VJFont_Trebuchet24_Small", 25, HealthPos, Color( 0, 255, 255, 150 ),0,0)
		return
	end
	
	draw.SimpleText(ModelDir, "VJFont_Trebuchet24_Small", 25, 20, Color( 255, 255, 255, 150 ),0,0)
	//draw.SimpleText("Class: "..trace.Entity:GetClass().." (Index: "..trace.Entity:EntIndex()..")", "VJFont_Trebuchet24_Tiny", 25, 30, Color( 255, 255, 255, 150 ),0,0)
	draw.SimpleText("Position: "..Position, "VJFont_Trebuchet24_Tiny", 25, 40, Color( 255, 255, 255, 150 ),0,0)
	draw.SimpleText("Angles: "..Angles, "VJFont_Trebuchet24_Tiny", 25, 50, Color( 255, 255, 255, 150 ),0,0)
	//draw.SimpleText("Water level: "..trace.Entity:WaterLevel().." | Local: "..ply:WaterLevel(), "VJFont_Trebuchet24_Tiny", 25, 60, Color( 255, 255, 255, 150 ),0,0)
	local codedistanceft = math.Round(ply:GetPos():Distance(trace.HitPos) /12)
	local codedistancewu = math.Round(ply:GetPos():Distance(trace.HitPos),2)
	//if trace.Entity:IsWorld() then
	draw.SimpleText("Distance: "..codedistanceft.." Feet | "..codedistancewu.." Unit", "VJFont_Trebuchet24_Tiny", 25, 70, Color( 255, 255, 255, 150 ),0,0) //else
	//draw.SimpleText("Distance: "..codedistanceft.." FT | "..codedistancewu.." WU", "VJFont_Trebuchet24_Tiny", 25, 70, Color( 255, 255,2550, 150 ),0,0) end
	//draw.SimpleText("Water level: "..trace.Entity:GetModelScale(), "VJFont_Trebuchet24_Tiny", 25, 70, Color( 255, 255, 255, 255 ),0,0)
	
	if trace.Entity:IsWorld() then
	draw.SimpleText("Type: World", "VJFont_Trebuchet24_Small", 24, TypePos, Color( 0, 255, 255, 150 ),0,0)
	elseif trace.Entity:IsPlayer() then
	draw.SimpleText("Type: Player", "VJFont_Trebuchet24_Small", 24, TypePos, Color( 0, 255, 255, 150 ),0,0)
	elseif trace.Entity:IsNPC() then
	draw.SimpleText("Type: NPC", "VJFont_Trebuchet24_Small", 24, TypePos, Color( 0, 255, 255, 150 ),0,0)
	elseif trace.Entity:IsVehicle() then
	draw.SimpleText("Type: Vehicle", "VJFont_Trebuchet24_Small", 24, TypePos, Color( 0, 255, 255, 150 ),0,0)
	elseif trace.Entity:IsWeapon() then
	draw.SimpleText("Type: Weapon", "VJFont_Trebuchet24_Small", 24, TypePos, Color( 0, 255, 255, 150 ),0,0)
	//elseif trace.Entity:IsBot() then
	//draw.SimpleText("Type: Bot", "VJFont_Trebuchet24_Small", 24, TypePos, Color( 0, 255, 255, 150 ),0,0)
	else
	draw.SimpleText("Type: Prop", "VJFont_Trebuchet24_Small", 24, TypePos, Color( 0, 255, 255, 150 ),0,0)
	end
	
	// draw.RoundedBox(1, ScrW()-355, ScrH()-100, 320, 65, Color(0, 0, 0, 150))

	if trace.Entity:IsWorld() or trace.Entity:IsVehicle() or trace.Entity:Health() == 0 then
	draw.SimpleText("Health: N/A", "VJFont_Trebuchet24_Small", 25, HealthPos, Color( 0, 255, 255, 150 ),0,0)
	else
	draw.SimpleText("Health:", "VJFont_Trebuchet24_Small", 25, HealthPos, Color( 0, 255, 255, 150 ),0,0)
	draw.RoundedBox(1,75,95,190,15,Color(0,255,255,70))
	if trace.Entity:IsPlayer() then
	draw.RoundedBox(1,75,95,math.Clamp(trace.Entity:Health(),0,100)*1.9,15, Color(0,255,255,100)) else
	draw.RoundedBox(1,75,95,(190*math.Clamp(trace.Entity:Health(),0,trace.Entity:GetNWInt("vj_hud_maxhealth")))/trace.Entity:GetNWInt("vj_hud_maxhealth"),15,Color(0,255,255,100)) end
	if trace.Entity:IsPlayer() then
	draw.SimpleText((trace.Entity:Health().."%"), "VJFont_Trebuchet24_Small",170-(surface.GetTextSize((trace.Entity:Health().."/100")))/2,94,Color(255,255,255,255)) else
	draw.SimpleText((trace.Entity:Health().."/"..trace.Entity:GetNWInt("vj_hud_maxhealth")), "VJFont_Trebuchet24_Small",170-(surface.GetTextSize((trace.Entity:Health().."/"..trace.Entity:GetNWInt("vj_hud_maxhealth"))))/2,94,Color(255,255,255,255)) end
	//draw.SimpleText(trace.Entity:Health(), "VJFont_Trebuchet24_Small", 200, 78, Color( 0, 255, 255, 150 ),0,0)
	end*/
end
hook.Add("HUDPaint","VJ HUD - Trace Information",VJHUD_TraceInformation)

-- Proximity Scanner ---------------------------------------------------------------------------------------------------------------------------------------------
local AbranknerVorKedne = {
	-- Barz Abrankner --
	gmod_button={Anoon = "Button",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(255, 255, 255, 150)},
	edit_sky={Anoon = "Sky Editor",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(255, 255, 255, 150)},
	edit_sun={Anoon = "Sun Editor",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(255, 255, 255, 150)},
	edit_fog={Anoon = "Fog Editor",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(255, 255, 255, 150)},
	
	-- Aroghchoutyoun yev Bashbanelik --
	item_healthkit={Anoon = "Health Kit",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(0, 255, 0, 150)},
	item_healthvial={Anoon = "Health Vial",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(0, 255, 0, 150)},
	item_battery={Anoon = "Suit Battery",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(0, 255, 0, 150)},
	item_suitcharger={Anoon = "Suit Charger",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(0, 255, 0, 150)},
	item_healthcharger={Anoon = "Health Charger",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(0, 255, 0, 150)},
	item_suit={Anoon = "HEV Suit",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(0, 255, 0, 150)},
	
	-- Panpousht --
	item_ammo_ar2={Anoon = "AR2 Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_ar2_large={Anoon = "Large AR2 Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_pistol={Anoon = "Pistol Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_pistol_large={Anoon = "Large Pistol Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_box_buckshot={Anoon = "Shotgun Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_357={Anoon = ".357 Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_357_large={Anoon = "Large .357 Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_smg1={Anoon = "SMG Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_smg1_large={Anoon = "Large SMG Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_ar2_altfire={Anoon = "Combine Ball Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_crossbow={Anoon = "Crossbow Bolts Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_ammo_smg1_grenade={Anoon = "SMG Grenade Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	item_rpg_round={Anoon = "RPG Ammo",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},
	-- Vdankavor --
	combine_mine={Anoon = "Mine!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	prop_combine_ball={Anoon = "Combine Ball!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	npc_rollermine={Anoon = "RollerMine!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	grenade_helicopter={Anoon = "Bomb!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	npc_grenade_frag={Anoon = "Grenade!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	obj_vj_grenade={Anoon = "Grenade!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	fas2_thrown_m67={Anoon = "Grenade!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	doom3_grenade={Anoon = "Grenade!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	cw_grenade_thrown={Anoon = "Grenade!",Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 400,DariKouyn = Color(255, 0, 0, -1)},
	--Custom--
	ix_item={Anoon = "Test" ,Negar = "negar/negar",DariDesag = "VJFont_Trebuchet24_Medium",Heravorutyoun = 300,DariKouyn = Color(0, 255, 255, 150)},


}

	
local function VJHUD_ProximityScanner()
	local ply = LocalPlayer()
	if !ply:Alive() or hud_enabled == 0 or GetConVarNumber("vj_hud_scanner") == 0 then return end
	local kouyne_pes = math.abs(math.sin(CurTime() * 5) * 255)
	for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 320)) do
		local v = AbranknerVorKedne[ent:GetClass()]
		if v then
			local pos = ent:LocalToWorld(ent:OBBCenter()):ToScreen()
			if math.Round(ply:GetPos():Distance(ent:GetPos())) < v.Heravorutyoun then
				local kouyne_poon_pare = v.DariKouyn
				if v.DariKouyn.a == -1 then kouyne_poon_pare = Color(v.DariKouyn.r, v.DariKouyn.g, v.DariKouyn.b, kouyne_pes) end
				if ply:IsLineOfSightClear(ent:GetPos()) then 
					if ent:GetClass() == "ix_item" then 
							draw.SimpleText(ent:GetItemTable().name, v.DariDesag,pos.x + 1, pos.y + 1, kouyne_poon_pare, 0, 0)
					else
						draw.SimpleText(v.Anoon, v.DariDesag,pos.x + 1, pos.y + 1, kouyne_poon_pare, 0, 0)
						-- Hin abrank (Goghme negar ge tsetsen e
						//surface.SetTexture(surface.GetTextureID(v.Negar))
						//surface.SetDrawColor(Color(255, 255, 255, 255))
						//surface.DrawTexturedRect(pos.x-(20), pos.y-(20), 25, 25)
					end
				end
			end
		end
	end
end
hook.Add("HUDPaint", "VJ HUD - Proximity Scanner", VJHUD_ProximityScanner)

