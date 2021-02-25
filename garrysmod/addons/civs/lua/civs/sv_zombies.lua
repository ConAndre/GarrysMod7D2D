util.AddNetworkString("seventh_night")


local zedTablenEXT = {
	"nb_shambler",
	"nb_seeker",
	"nb_type3",
	"nb_hulk_infested",
	"nb_shambler",
	"nb_ghoul",
	"nb_type2",
	"nb_zombine",
	"nb_seeker_slow",
	"nb_infested",

}



local zedTable = {
"npc_vj_zss_cpzombie",
"npc_vj_zss_czombie",
"npc_vj_zss_czombietors",
"npc_vj_zss_draggy",
"npc_vj_zss_zombguard",
"npc_vj_zss_zombie1",
"npc_vj_zss_zombie2",
"npc_vj_zss_zombie3",
"npc_vj_zss_zombie4",
"npc_vj_zss_zombie5",
"npc_vj_zss_zombie6",
"npc_vj_zss_zombie7",
"npc_vj_zss_zombie8",
"npc_vj_zss_zombie9",
"npc_vj_zss_zombie10",
"npc_vj_zss_zombie11",
"npc_vj_zss_zombie12",
"npc_vj_zss_zp1",
"npc_vj_zss_zp2",
"npc_vj_zss_zp3",
"npc_vj_zss_zp4",
"npc_vj_zss_undeadstalker",
"npc_vj_zss_zombguard",
"npc_vj_zss_cfastzombie",
"npc_vj_zss_zminiboss",
"npc_vj_zss_zombfast1",
"npc_vj_zss_zombfast2",
"npc_vj_zss_zombfast3",
"npc_vj_zss_zombfast4",
"npc_vj_zss_zombfast5",
-- "npc_vj_zss_zboss",
"npc_vj_zss_burnzie",
"npc_vj_zss_undeadstalker",
"npc_vj_zss_zhulk",
-- "npc_vj_zss_c2boss",
}



local zedTableRedNight = {
"npc_vj_zss_cfastzombie",
"npc_vj_zss_zminiboss",
"npc_vj_zss_zombfast1",
"npc_vj_zss_zombfast2",
"npc_vj_zss_zombfast3",
"npc_vj_zss_zombfast4",
"npc_vj_zss_zombfast5",
"npc_vj_zss_zboss",
"npc_vj_zss_burnzie",
"npc_vj_zss_undeadstalker",
"npc_vj_zss_zhulk",
"npc_vj_zss_c2boss",
}



function table.RandomSeq(tbl)
	local rand = math.random( 1, #tbl )
	return tbl[rand], rand
end


print("Loaded Civs")
ServerLog("Loaded Zombies\n")


local function IsPlayerInRange(pos) 
	local playerinrange = false
	local testprop = ents.Create("prop_physics")
	--testprop:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
	testprop:SetPos(pos)
	local playerTableP = ents.FindInSphere( pos, 1500 )
	for i = 1, #playerTableP do
	if playerTableP[i]:IsPlayer() then
		--print("Hey i tried to spawn near a player!")
		playerinrange = true
		break
	end
	end
	--if playerinrange then
	--	testprop:SetModel("models/props_c17/gravestone002a.mdl")
	--end

	--testprop:Spawn()
	testprop:Remove()
	return playerinrange
end 



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
		
		if IsPlayerInRange(newpos + Vector(0,0,100)) then return false end
		return newpos + Vector(0,0,50) -- added vector to prevent spawning in ground and falling under map (mojave)
		
	else
		return false
	end
end

local isRedNight = false
local CurTimeVar = CurTime()*196
local TimeTable = string.FormattedTime(CurTimeVar)
local TimeTableH = TimeTable["h"]
local DayFromHours = 1


function Civs.Populate()

	//Delete civs which nobody can see:
	local deleted = 0
	local count = 0
	local max = math.min(Civs.CivsPerPlayer * #player.GetAll(), Civs.MaxCivs)
	local mode = Civs.DespawnMode or 1
	for k,bot in pairs(Civs.GetAll()) do
		if bot:GetNWBool("deletethisguy") then -- allowremove tag to prevent spawner zombs from delete and count 
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

			local class = table.Random(zedTable)
			
			if isRedNight then 
				class = table.Random(zedTableRedNight)	
			end

			local bot = ents.Create(class)
			if bot:IsValid() then
				bot:SetPos(pos)
				bot:SetAngles(Angle(0, math.random(-180,180), 0))
				bot:SetNWBool("deletethisguy", true)
				bot:Spawn()
				bot:Activate()

				added = added + 1
			end
		end
		
	end
	
	print("Added "..added.." and removed "..deleted.." Zombies from the world. ("..(count-deleted)+added.." exist in total.)")
	
end


function Civs.GetAll()
	return ents.FindByClass("npc_vj_zss*")
end


timer.Create("Zombs_Autospawn",Civs.SpawnInterval,0, function()
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




hook.Add( "PlayerSpawnedProp", "deletingpropsondamage", function(ply, model, ent)
	if IsValid(ent) then
		local spawnHealth = math.Clamp(ent:GetPhysicsObject():GetMass() * (ent:OBBMins():Distance(ent:OBBMaxs())) / 100,200,800)
		ent:SetHealth(spawnHealth)
		ent:SetMaxHealth(spawnHealth)
		ent:SetNWEntity( "ownerof", ply )
		
	end
end)


hook.Add( "EntityTakeDamage", "deletingpropsondamagehelp", function( target, dmginfo )

	if(target:GetClass() == "prop_door_rotating" && !dmginfo:GetAttacker():IsPlayer() ) then dmginfo:SetDamage(9999) end

	if ( target:GetClass() == "prop_physics"  && !dmginfo:GetAttacker():IsPlayer()   ) then
		target:SetHealth(target:Health() - dmginfo:GetDamage())
		
		if target:Health() <= 0 then
			target:EmitSound("ceiling_tile.Break", 75,100, 1, CHAN_AUTO) 
			target:EmitSound("Metal_Box.Break", 75,100, 1, CHAN_AUTO) 
			target:EmitSound("GlassBottle.Break", 75,100, 1, CHAN_AUTO) 
			target:EmitSound("Pottery.Break", 75,100, 1, CHAN_AUTO) 
			if target:GetNWEntity("ownerof"):IsPlayer() then 
				target:GetNWEntity("ownerof"):ChatNotify("A "..tostring(dmginfo:GetAttacker():GetName()).. " has broken your prop!")
			end
			target:Remove()
			
		end
	end

end )

hook.Add("PlayerInitialSpawn","zombies_initspawn", function()
	if #player.GetAll() == 1 then
		if Civs.AutoPopulate then
			Civs.Populate()
		end
	end
end)
