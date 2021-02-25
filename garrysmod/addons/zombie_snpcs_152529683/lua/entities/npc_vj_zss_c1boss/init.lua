AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/zombie/classic_gal_boss.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.VJ_IsHugeMonster = true
ENT.StartHealth = 500
ENT.HullType = HULL_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDistance = 32 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 110 -- How far does the damage go?
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 5 -- How much time until player's Speed resets
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.FootStepTimeRun = 0.8 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.8 -- Next foot step sound when it is walking

	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
	-- ====== Call For Help Variables ====== --
ENT.CallForHelp = true -- Does the SNPC call for help?
ENT.CallForHelpDistance = 4000 -- -- How far away the SNPC's call for help goes | Counted in World Units


--movement
ENT.DisableWandering = true -- Disables wandering when the SNPC is idle
--


-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"zsszombie/foot1.wav","zsszombie/foot2.wav","zsszombie/foot3.wav","zsszombie/foot4.wav"}
ENT.SoundTbl_Idle = {"zsszombie/zombie_idle1.wav","zsszombie/zombie_idle2.wav","zsszombie/zombie_idle3.wav","zsszombie/zombie_idle4.wav","zsszombie/zombie_idle5.wav","zsszombie/zombie_idle6.wav"}
ENT.SoundTbl_Alert = {"zsszombie/zombie_alert1.wav","zsszombie/zombie_alert2.wav","zsszombie/zombie_alert3.wav","zsszombie/zombie_alert4.wav"}
ENT.SoundTbl_MeleeAttack = {"zsszombie/zombie_attack_1.wav","zsszombie/zombie_attack_2.wav","zsszombie/zombie_attack_3.wav","zsszombie/zombie_attack_4.wav","zsszombie/zombie_attack_5.wav","zsszombie/zombie_attack_6.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"zsszombie/miss1.wav","zsszombie/miss2.wav","zsszombie/miss3.wav","zsszombie/miss4.wav"}
ENT.SoundTbl_Pain = {"zsszombie/zombie_pain1.wav","zsszombie/zombie_pain2.wav","zsszombie/zombie_pain3.wav","zsszombie/zombie_pain4.wav","zsszombie/zombie_pain5.wav","zsszombie/zombie_pain6.wav","zsszombie/zombie_pain7.wav","zsszombie/zombie_pain8.wav"}
ENT.SoundTbl_Death = {"zsszombie/zombie_die1.wav","zsszombie/zombie_die2.wav","zsszombie/zombie_die3.wav","zsszombie/zombie_die4.wav","zsszombie/zombie_die5.wav","zsszombie/zombie_die6.wav"}

-- Custom
ENT.ZBoss_NextMiniBossSpawnT = 0
ENT.ZBoss_AlreadySpawned = false
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply)
	ply:ChatPrint("JUMP: Spawn Mini Zombie Bosses")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	--self:SetModelScale(1, 0)
end
---------------------------------------------------------------------------------------------------------------------------------------------

ENT.HasItemDropsOnDeath = true -- Should it drop items on death?
ENT.ItemDropsOnDeathChance = 5 -- If set to 1, it will always drop it
ENT.ItemDropsOnDeath_EntityList = {
"m9k_m3",
"m9k_contender",
"m9k_ammo_pistol",
"m9k_ammo_smg",
"m9k_ammo_buckshot",
"m9k_ammo_sniper_rounds",
"m9k_deagle",
"m9k_usc",
"m9k_mp9",
"m9k_m92beretta",
}
---------------------------------------------------------------------------------------------------------------------------------------------


function ENT:CustomOnThink()
	if self:IsOnFire() then
		self.AnimTbl_Walk = {ACT_WALK_ON_FIRE}
		self.AnimTbl_Run = {ACT_WALK_ON_FIRE}
		self.AnimTbl_IdleStand = {ACT_IDLE_ON_FIRE}
	else
		self.AnimTbl_Walk = {ACT_WALK}
		self.AnimTbl_Run = {ACT_RUN}
		self.AnimTbl_IdleStand = {ACT_IDLE}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	if IsValid(self:GetEnemy()) && CurTime() > self.ZBoss_NextMiniBossSpawnT then
		if !IsValid(self.MiniBoss1) && !IsValid(self.MiniBoss2) && self.ZBoss_AlreadySpawned == false && ((self.VJ_IsBeingControlled == false) or (self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP))) then
			if self.VJ_IsBeingControlled == true then
				self.VJ_TheController:PrintMessage(HUD_PRINTCENTER,"Spawning Mini Zombie Bosses! Cooldown: 20 seconds!")
			end
			self.ZBoss_AlreadySpawned = true
			self:VJ_ACT_PLAYACTIVITY("vjseq_releasecrab",true,1.5,false)
			ParticleEffect("aurora_shockwave_debris",self:GetPos(),Angle(0,0,0),nil)
			ParticleEffect("aurora_shockwave",self:GetPos(),Angle(0,0,0),nil)
			self.carnocustomsd1 = CreateSound(self, Sound("vj_bossz_call.wav")) self.carnocustomsd1:SetSoundLevel(80)
			self.carnocustomsd1:PlayEx(1,80)
			
			self.MiniBoss1 = ents.Create("npc_vj_zss_zombguard")
			self.MiniBoss1:SetPos(self:GetPos() +self:GetRight()*60 + Vector(0,0,55))
			self.MiniBoss1:SetAngles(self:GetAngles())
			self.MiniBoss1.DisableWandering = true -- Disables wandering when the SNPC is idle
			self.MiniBoss1:SetOwner(self)
			self.MiniBoss1:Spawn()
			self.MiniBoss1:SetModelScale(.8, 0)
			self.MiniBoss1:SetNoDraw(true)
			timer.Simple(0.3,function() if IsValid(self.MiniBoss1) then self.MiniBoss1:SetNoDraw(false) end end)
			self.MiniBoss1:VJ_ACT_PLAYACTIVITY("vjseq_canal5aattack",true,0.6,true,0,{SequenceDuration=0.6})
			
			self.MiniBoss2 = ents.Create("npc_vj_zss_zombguard")
			self.MiniBoss2:SetPos(self:GetPos() +self:GetRight()*-60 + Vector(0, 0, 55))
			self.MiniBoss2:SetAngles(self:GetAngles())
			self.MiniBoss2:SetOwner(self)
			self.MiniBoss2.DisableWandering = true -- Disables wandering when the SNPC is idle
			self.MiniBoss2:Spawn()
			self.MiniBoss2:SetModelScale(.8, 0)
			self.MiniBoss2:SetNoDraw(true)
			timer.Simple(0.3,function() if IsValid(self.MiniBoss2) then self.MiniBoss2:SetNoDraw(false) end end)
			self.MiniBoss2:VJ_ACT_PLAYACTIVITY("vjseq_canal5aattack",true,0.6,true,0,{SequenceDuration=0.6})

			self.MiniBoss3 = ents.Create("zm_healer")
			self.MiniBoss3:SetPos(self:GetPos() +self:GetForward()*-200 + Vector(0, 0, 55))
			self.MiniBoss3:SetAngles(self:GetAngles())
			self.MiniBoss3:SetOwner(self)
			self.MiniBoss3:Spawn()
			self.MiniBoss3:SetModelScale(1, 0)
			self.MiniBoss3:SetNoDraw(true)
			timer.Simple(0.3,function() if IsValid(self.MiniBoss3) then self.MiniBoss3:SetNoDraw(false) end end)
			--self.MiniBoss3:VJ_ACT_PLAYACTIVITY("vjseq_canal5aattack",true,0.6,true,0,{SequenceDuration=0.6})

			self.MiniBoss4 = ents.Create("zm_healer")
			self.MiniBoss4:SetPos(self:GetPos() + self:GetForward()*-200  + self:GetRight()*-200 + Vector(0, 0, 55))
			self.MiniBoss4:SetAngles(self:GetAngles())
			self.MiniBoss4:SetOwner(self)
			self.MiniBoss4:Spawn()
			self.MiniBoss4:SetModelScale(1, 0)
			self.MiniBoss4:SetNoDraw(true)
			timer.Simple(0.3,function() if IsValid(self.MiniBoss4) then self.MiniBoss4:SetNoDraw(false) end end)
			--self.MiniBoss4:VJ_ACT_PLAYACTIVITY("vjseq_canal5aattack",true,0.6,true,0,{SequenceDuration=0.6})

			self.MiniBoss5 = ents.Create("zm_healer")
			self.MiniBoss5:SetPos(self:GetPos() + self:GetForward()*-200  + self:GetRight()*200 + Vector(0, 0, 55))
			self.MiniBoss5:SetAngles(self:GetAngles())
			self.MiniBoss5:SetOwner(self)
			self.MiniBoss5:Spawn()
			self.MiniBoss5:SetModelScale(1, 0)
			self.MiniBoss5:SetNoDraw(true)
			timer.Simple(0.3,function() if IsValid(self.MiniBoss5) then self.MiniBoss5:SetNoDraw(false) end end)

			self.MiniBoss6 = ents.Create("npc_vj_zss_zombfast1")
			self.MiniBoss6:SetPos(self:GetPos() +self:GetRight()*-150  + self:GetForward()*-200 + Vector(0, 0, 155))
			self.MiniBoss6:SetAngles(self:GetAngles())
			self.MiniBoss6:SetOwner(self)
			self.MiniBoss6.DisableWandering = true -- Disables wandering when the SNPC is idle
			self.MiniBoss6:Spawn()
			self.MiniBoss6:SetModelScale(0.7, 0)
			self.MiniBoss6:SetNoDraw(true)
			timer.Simple(0.3,function() if IsValid(self.MiniBoss6) then self.MiniBoss6:SetNoDraw(false) end end)
			self.MiniBoss6:VJ_ACT_PLAYACTIVITY("vjseq_canal5aattack",true,0.6,true,0,{SequenceDuration=0.6})

			self.MiniBoss7 = ents.Create("npc_vj_zss_zombfast1")
			self.MiniBoss7:SetPos(self:GetPos() +self:GetRight()*150  + self:GetForward()*-200 + Vector(0, 0, 155))
			self.MiniBoss7:SetAngles(self:GetAngles())
			self.MiniBoss7:SetOwner(self)
			self.MiniBoss7.DisableWandering = true -- Disables wandering when the SNPC is idle
			self.MiniBoss7:Spawn()
			self.MiniBoss7:SetModelScale(0.7, 0)
			self.MiniBoss7:SetNoDraw(true)
			timer.Simple(0.3,function() if IsValid(self.MiniBoss7) then self.MiniBoss7:SetNoDraw(false) end end)
			self.MiniBoss7:VJ_ACT_PLAYACTIVITY("vjseq_canal5aattack",true,0.6,true,0,{SequenceDuration=0.6})
			
			self.ZBoss_AlreadySpawned = false
			self.ZBoss_NextMiniBossSpawnT = CurTime() + 20
			self.MinionsMade = 7
		end
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	local randattack = math.random(1,2)
	if randattack == 1 then
		self.AnimTbl_MeleeAttack = {"vjseq_attacka","vjseq_attackb","vjseq_attackc","vjseq_attackd"}
		self.TimeUntilMeleeAttackDamage = 1
		self.MeleeAttackDamage = GetConVarNumber("vj_zss_zbossmini_d")
	elseif randattack == 2 then
		self.AnimTbl_MeleeAttack = {"vjseq_attacke","vjseq_attackf"}
		self.TimeUntilMeleeAttackDamage = 1
		self.MeleeAttackDamage = GetConVarNumber("vj_zss_zboss_d_hard")
	end
end

/*-----------------------------------------------



	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/