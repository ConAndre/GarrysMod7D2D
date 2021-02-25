AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/props_junk/popcan01a.mdl"} -- The models it should spawn with | Picks a random one from the table
ENT.EntitiesToSpawn = {
	{EntityName = "NPC1",SpawnPosition = {vForward=0,vRight=0,vUp=50},Entities = {"npc_vj_zss_c1boss"}},
	--{EntityName = "NPC2",SpawnPosition = {vForward=0,vRight=50,vUp=0},Entities = {"npc_vj_zss_zombie1","npc_vj_zss_zombie2","npc_vj_zss_zombie3","npc_vj_zss_zombie4","npc_vj_zss_zombie5","npc_vj_zss_zombie6","npc_vj_zss_zombie7","npc_vj_zss_zombie8","npc_vj_zss_zombie9","npc_vj_zss_zombie10","npc_vj_zss_zombie11","npc_vj_zss_zombie12","npc_vj_zss_zombfast1","npc_vj_zss_zombfast2","npc_vj_zss_zombfast3","npc_vj_zss_zombfast4","npc_vj_zss_zombfast5","npc_vj_zss_zombfast6","npc_vj_zss_cfastzombie","npc_vj_zss_zp1","npc_vj_zss_zp2","npc_vj_zss_zp3","npc_vj_zss_zp4"}},
	--{EntityName = "NPC3",SpawnPosition = {vForward=100,vRight=50,vUp=0},Entities = {"npc_vj_zss_zombie1","npc_vj_zss_zombie2","npc_vj_zss_zombie3","npc_vj_zss_zombie4","npc_vj_zss_zombie5","npc_vj_zss_zombie6","npc_vj_zss_zombie7","npc_vj_zss_zombie8","npc_vj_zss_zombie9","npc_vj_zss_zombie10","npc_vj_zss_zombie11","npc_vj_zss_zombie12","npc_vj_zss_zombfast1","npc_vj_zss_zombfast2","npc_vj_zss_zombfast3","npc_vj_zss_zombfast4","npc_vj_zss_zombfast5","npc_vj_zss_zombfast6","npc_vj_zss_cfastzombie","npc_vj_zss_zp1","npc_vj_zss_zp2","npc_vj_zss_zp3","npc_vj_zss_zp4"}},
	--{EntityName = "NPC4",SpawnPosition = {vForward=100,vRight=-50,vUp=0},Entities = {"npc_vj_zss_zombie1","npc_vj_zss_zombie2","npc_vj_zss_zombie3","npc_vj_zss_zombie4","npc_vj_zss_zombie5","npc_vj_zss_zombie6","npc_vj_zss_zombie7","npc_vj_zss_zombie8","npc_vj_zss_zombie9","npc_vj_zss_zombie10","npc_vj_zss_zombie11","npc_vj_zss_zombie12","npc_vj_zss_zombfast1","npc_vj_zss_zombfast2","npc_vj_zss_zombfast3","npc_vj_zss_zombfast4","npc_vj_zss_zombfast5","npc_vj_zss_zombfast6","npc_vj_zss_cfastzombie","npc_vj_zss_zp1","npc_vj_zss_zp2","npc_vj_zss_zp3","npc_vj_zss_zp4"}},
	--{EntityName = "NPC5",SpawnPosition = {vForward=0,vRight=-50,vUp=0},Entities = {"npc_vj_zss_zombie1","npc_vj_zss_zombie2","npc_vj_zss_zombie3","npc_vj_zss_zombie4","npc_vj_zss_zombie5","npc_vj_zss_zombie6","npc_vj_zss_zombie7","npc_vj_zss_zombie8","npc_vj_zss_zombie9","npc_vj_zss_zombie10","npc_vj_zss_zombie11","npc_vj_zss_zombie12","npc_vj_zss_zombfast1","npc_vj_zss_zombfast2","npc_vj_zss_zombfast3","npc_vj_zss_zombfast4","npc_vj_zss_zombfast5","npc_vj_zss_zombfast6","npc_vj_zss_cfastzombie","npc_vj_zss_zp1","npc_vj_zss_zp2","npc_vj_zss_zp3","npc_vj_zss_zp4"}},
}
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted, 
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.

-----------------------------------------------*/

function ENT:SpawnAnEntity(keys,values,initspawn)






	local k = keys
	local v = values
	local initspawn = initspawn or false
	local overridedisable = false
	local hasweps = false
	local wepslist = {}
	local isplayernearormob = false
	local isThisNull = false 
	if initspawn == true then overridedisable = true end
	if self.VJBaseSpawnerDisabled == true && overridedisable == false then return end
	
	local getthename = v.EntityName
	local spawnpos = v.SpawnPosition
	local theMobSpawned = VJ_PICK(v.Entities)
	local getthename = ents.Create(theMobSpawned)

	local pos = self:GetPos() +self:GetForward()*spawnpos.vForward +self:GetRight()*spawnpos.vRight +self:GetUp()*spawnpos.vUp
	
	getthename:SetPos(pos + Vector(0, 0, 5))

	local PreventNearPlayerOrDupeSpawn = ents.FindInSphere( pos, 600 )
	for i = 1, #PreventNearPlayerOrDupeSpawn do
		if  PreventNearPlayerOrDupeSpawn[i]:IsPlayer() || PreventNearPlayerOrDupeSpawn[i]:GetClass() == "zm_healer" then
			--print("Hey i tried to create a zombie near a player/existing zombie!")
			isplayernearormob = true
			break 
		else 
			isplayernearormob = false
		end
	end
	if !isplayernearormob  then
		getthename:SetAngles(self:GetAngles())
		getthename:Spawn()
		getthename:Activate()
	else 
		getthename:Remove()
	end

	if v.WeaponsList != nil && VJ_PICK(v.WeaponsList) != false && VJ_PICK(v.WeaponsList) != NULL && VJ_PICK(v.WeaponsList) != "None" && VJ_PICK(v.WeaponsList) != "none" then hasweps = true wepslist = v.WeaponsList end
	if hasweps == true then
		local randwep = VJ_PICK(v.WeaponsList) -- Kharen zenkme zad e
		if randwep == "default" then
			getthename:Give(VJ_PICK(list.Get("NPC")[getthename:GetClass()].Weapons))
		else
			getthename:Give(randwep)
		end
	end
	if initspawn == false then table.remove(self.CurrentEntities,k) end
	table.insert(self.CurrentEntities,k,{EntityName=v.EntityName,SpawnPosition=v.SpawnPosition,Entities=v.Entities,TheEntity=getthename,WeaponsList=wepslist,Dead=false/*NextTimedSpawnT=CurTime()+self.TimedSpawn_Time*/})	
	
	if isplayernear && IsValid(v.TheEntity) then 
		for k,v in ipairs(self.CurrentEntities) do
			if IsValid(v.TheEntity) && v.TheEntity then v.TheEntity:Remove() end
		end
	end

	self:SpawnEntitySoundCode()
	if self.VJBaseSpawnerDisabled == true && overridedisable == true then getthename:Remove() return end
	self:CustomOnEntitySpawn(v.EntityName,v.SpawnPosition,v.Entities,TheEntity)
	timer.Simple(0.1,function() if IsValid(self) then if self.SingleSpawner == true then self:DoSingleSpawnerRemove() end end end)
end