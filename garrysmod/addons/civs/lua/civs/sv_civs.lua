
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

Civs.Gamemode = engine.ActiveGamemode()

Civs.CivClasses = Civs.CivClasses or {} --DLC adds to this. {class_name = chance_to_spawn, class_name2 = chance_to_spawn}



--[[
	'pos' should be the origin of crime, usually the criminal's position.
	'criminal' should be the player commiting the heinous crime.
	'reason' should be the key of an entry in Civs.Wanted; "shoot", "murder", "hurt". You can add more and use this to trigger them.
]]
function Civs.CausePanic(pos, criminal, reason)
	local entlist = ents.FindInSphere(pos, Civs.AlertDist)
	for k,v in pairs(entlist) do
		if v:GetClass():find("npc_civ") then
			v:FreakOut(pos, criminal, reason)
		end
	end
	
end
function table.RandomSeq(tbl)
	local rand = math.random( 1, #tbl )
	return tbl[rand], rand
end


print("Loaded Civs")
ServerLog("Loaded Civs\n")

util.AddNetworkString("Civs_Ragdoll")
util.AddNetworkString("Civs_PoliceBeacon")


local function RandomOutsideSpot()
	local ply = table.RandomSeq(player.GetAll())
	if IsValid(ply) then
		
		local newpos
		local fail = true
		
		local i = 1
		while fail and i<300 do
			newpos = VectorRand()
			newpos.z = 0
			newpos = ply:GetPos() + newpos * math.random(Civs.SpawnDist/2, Civs.SpawnDist)
			fail = not util.IsInWorld(newpos)		
			
			if not fail then
				local a = navmesh.GetNearestNavArea(newpos)
				fail = fail or not IsValid(a)
				fail = fail or a:IsUnderwater()
				fail = fail or a:HasAttributes(NAV_MESH_AVOID)
				
				if not fail then
					newpos = a:GetRandomPoint()+Vector(0,0,3)
					fail = fail or not bit.band( util.PointContents( newpos ), CONTENTS_EMPTY ) == CONTENTS_EMPTY
					
					if not fail then
						local hull = {}
						-- local hull = {mask=MASK_NPCSOLID}
						local traces = {}
						local offsets = {Vector(-16,-16,-8),Vector(-16,16,-8),Vector(16,-16,-8),Vector(16,16,-8)}
						for i=1, 4 do
							if not fail then
								hull.start = newpos + offsets[i]
								hull.endpos = hull.start+Vector(0,0,16000)
								
								traces[i] = util.TraceLine(hull)
								
								fail = fail or traces[i].HitEntity
								if Civs.OutsideOnly then
									fail = fail or not traces[i].HitSky
								end
							end
						end
					end
				end
			end
			i=i+1
		end
		
		if i>=300 then return false end
		
		return newpos
		
	else
		return false
	end
end

function Civs.Populate()

	//Delete civs which nobody can see:
	local deleted = 0
	local count = 0
	local max = math.min(Civs.CivsPerPlayer * #player.GetAll(), Civs.MaxCivs)
	local mode = Civs.DespawnMode or 1
	for k,bot in pairs(Civs.GetAll()) do
		count = count + 1
		if mode <= 1 then
			local nearby = ents.FindInPVS(bot)
			if #nearby == 0 then
				bot:Remove()
				deleted = deleted + 1
				continue
			end
		elseif mode >= 2 then
			local vis = false
			for k2,v in pairs(player.GetAll())do
				vis = vis or !bot:IsLineOfSightClear(v)
				-- vis = vis or !util.TraceLine({start=bot:GetPos(),endpos=v:GetPos(),filter={bot,v}}).Hit
			end
			if vis then
				bot:Remove()
				deleted = deleted + 1
				continue
			end
		end
			
		if bot:Health() <= 0 then
			bot:Remove()
			deleted = deleted + 1
		end
		
	end
	
	local added = 0
	for i=1, math.random(0, max - (count-deleted)) do
		
		local pos = RandomOutsideSpot()
		
		if pos then
			local class = "npc_civ"
			local cur = 1
			local ran = math.Rand(0,1)
			for k,v in pairs(Civs.CivClasses) do
				if v >= ran and v < cur then
					class = k
					cur = v
				end
			end
			
			local bot = ents.Create(class)
			if bot:IsValid() then
				bot:SetPos(pos)
				bot:SetAngles(Angle(0, math.random(-180,180), 0))
				bot:Spawn()
				bot:Activate()
				
				added = added + 1
			end
		end
	end
	
	print("Added "..added.." and removed "..deleted.." Civs from the world. ("..(count-deleted)+added.." exist in total.)")
	
end
timer.Create("Civs_Autospawn",Civs.SpawnInterval,0, function()
    local count = #player.GetAll()
    local limit = Civs.PlayerLimit or -1
    
	if (limit == -1 or (limit > count and count > 0)) then
		if Civs.AutoPopulate then
			Civs.Populate()
		end
	else //nobody online.
		for k,v in pairs(Civs.GetAll()) do
			if (not v.Persistent) then
				v:Remove()
			end
		end
	end
end)
hook.Add("PlayerInitialSpawn","Civs_initspawn", function()
	if #player.GetAll() == 1 then
		if Civs.AutoPopulate then
			Civs.Populate()
		end
	end
end)

hook.Add("EntityFireBullets","Civ Freakout",function(ent, bullet)
	if ent:IsPlayer() then
		local trace = util.QuickTrace(bullet.Src, bullet.Dir, ent)
		local hitpos = trace.HitPos
		local shootpos = bullet.Src
		if isvector(hitpos) then
			
			local entlist1 = ents.FindInSphere(hitpos, Civs.AlertDist)
			local entlist2 = ents.FindInSphere(shootpos, Civs.AlertDist)
			
			for k,v in pairs(entlist1) do
				if v:GetClass():find("npc_civ") then
					v:FreakOut(shootpos, ent,"shoot")
				end
			end
			for k,v in pairs(entlist2) do
				if v:GetClass():find("npc_civ") then
					v:FreakOut(shootpos, ent,"shoot")
				end
			end
			
		end
	end
end)

hook.Add("PlayerHurt","Civs_PlayerHurt", function(ply, attacker)
	if ply:IsValid() and attacker:IsValid() then
		if attacker:IsPlayer() and attacker!=ply and (not Civs.IsCop(attacker)) then
			local entlist1 = ents.FindInSphere(ply:GetPos(), Civs.AlertDist)
			for k,v in pairs(entlist1) do
				if v:GetClass():find("npc_civ") then
					v:FreakOut(attacker:GetPos(), attacker,"hurt")
				end
			end
		elseif attacker:GetClass():find("npc_civ") and (not attacker:GetClass():find("cop")) then
			local entlist1 = ents.FindInSphere(ply:GetPos(), Civs.AlertDist)
			for k,v in pairs(entlist1) do
				if v:GetClass():find("npc_civ") then
					v:FreakOut(attacker:GetPos(), attacker,"hurt")
				end
			end
		end
	end
end)


function Civs.GetAll()
	return ents.FindByClass("npc_civ*")
end

function Civs.RemoveAll()
	for k,v in pairs(Civs.GetAll()) do
		v:Remove()
	end
end

hook.Add("CanTool","NoCivModify",function(ply,trace)
    if trace.Entity and IsValid(trace.Entity) and trace.Entity:GetClass():lower():find("npc_civ") and not ply:IsAdmin() then
        return false
    end
end)
hook.Add( "PhysgunPickup", "NoCivModify", function( ply, ent )
    if ( (not ply:IsAdmin()) and ent:GetClass():lower():find("npc_civ") ) then
        return false
    end
end )