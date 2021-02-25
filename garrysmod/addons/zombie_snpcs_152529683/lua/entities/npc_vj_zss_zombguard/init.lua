AddCSLuaFile("shared.lua")
include('shared.lua')
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/
ENT.Model = {"models/zombie/Zombie_Soldier.mdl"} -- The game will pick a random model from the table when the SNPC is spawned | Add as many as you want
ENT.StartHealth = GetConVarNumber("vj_zss_zombine_h")
ENT.HullType = HULL_WIDE_HUMAN
---------------------------------------------------------------------------------------------------------------------------------------------
ENT.VJ_NPC_Class = {"CLASS_ZOMBIE"} -- NPCs with the same class with be allied to each other
ENT.BloodColor = "Red" -- The blood type, this will determine what it should use (decal, particle, etc.)
ENT.HasMeleeAttack = true -- Should the SNPC have a melee attack?
ENT.MeleeAttackDistance = 30 -- How close does it have to be until it attacks?
ENT.MeleeAttackDamageDistance = 70 -- How far does the damage go?
ENT.SlowPlayerOnMeleeAttack = true -- If true, then the player will slow down
ENT.SlowPlayerOnMeleeAttack_WalkSpeed = 100 -- Walking Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttack_RunSpeed = 100 -- Running Speed when Slow Player is on
ENT.SlowPlayerOnMeleeAttackTime = 5 -- How much time until player's Speed resets
ENT.MeleeAttackBleedEnemy = true -- Should the player bleed when attacked by melee
ENT.MeleeAttackBleedEnemyChance = 3 -- How chance there is that the play will bleed? | 1 = always
ENT.MeleeAttackBleedEnemyDamage = 1 -- How much damage will the enemy get on every rep?
ENT.MeleeAttackBleedEnemyTime = 1 -- How much time until the next rep?
ENT.MeleeAttackBleedEnemyReps = 4 -- How many reps?
ENT.FootStepTimeRun = 0.4 -- Next foot step sound when it is running
ENT.FootStepTimeWalk = 0.6 -- Next foot step sound when it is walking
ENT.HasExtraMeleeAttackSounds = true -- Set to true to use the extra melee attack sounds
	-- ====== Flinching Code ====== --
ENT.CanFlinch = 1 -- 0 = Don't flinch | 1 = Flinch at any damage | 2 = Flinch only from certain damages
ENT.AnimTbl_Flinch = {ACT_FLINCH_PHYSICS} -- If it uses normal based animation, use this
	-- ====== Sound File Paths ====== --
-- Leave blank if you don't want any sounds to play
ENT.SoundTbl_FootStep = {"zsszombine/gear1.wav","zsszombine/gear2.wav","zsszombine/gear3.wav"}
ENT.SoundTbl_Idle = {"zsszombine/idle1.wav","zsszombine/idle2.wav","zsszombine/idle3.wav","zsszombine/idle4.wav","zsszombine/idle5.wav"}
ENT.SoundTbl_Alert = {"zsszombine/alert1.wav","zsszombine/alert2.wav","zsszombine/alert3.wav","zsszombine/alert4.wav","zsszombine/alert5.wav","zsszombine/alert6.wav"}
ENT.SoundTbl_BeforeMeleeAttack = {"zsszombine/attack1.wav","zsszombine/attack2.wav","zsszombine/attack3.wav","zsszombine/attack4.wav"}
ENT.SoundTbl_MeleeAttackMiss = {"zsszombie/miss1.wav","zsszombie/miss2.wav","zsszombie/miss3.wav","zsszombie/miss4.wav"}
ENT.SoundTbl_Pain = {"zsszombine/pain1.wav","zsszombine/pain2.wav","zsszombine/pain3.wav","zsszombine/pain4.wav"}
ENT.SoundTbl_Death = {"zsszombine/die1.wav","zsszombine/die2.wav"}

ENT.GeneralSoundPitch1 = 100
ENT.GeneralSoundPitch2 = 100

-- Custom
ENT.Zombine_GrenadeOut = false
ENT.Zombine_GrenadeMsgCoolDown = 0
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnInitialize()
	self:SetCollisionBounds(Vector(13, 13, 60), Vector(-13, -13, 0))
	
	self.CustomWalkActivites = {VJ_SequenceToActivity(self,"walk_all_grenade")}
	self.CustomRunActivites = {VJ_SequenceToActivity(self,"run_all_grenade")}
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Controller_IntMsg(ply)
	ply:ChatPrint("JUMP: To Pull Grenade")
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnThink_AIEnabled()
	
	if self.Zombine_GrenadeOut == false && ((self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP)) or (self.VJ_IsBeingControlled == false)) then
		if self.VJ_IsBeingControlled == true then
			self.VJ_TheController:PrintMessage(HUD_PRINTCENTER,"Pulling Grenade Out!")
			self.Zombine_GrenadeMsgCoolDown = CurTime() + 3
			self:Zombine_CreateGrenade()
		elseif IsValid(self:GetEnemy()) && self:GetPos():Distance(self:GetEnemy():GetPos()) <= 400 && self:Health() <= 40 then
			self:Zombine_CreateGrenade()
		end
	elseif self.Zombine_GrenadeMsgCoolDown < CurTime() && self.VJ_IsBeingControlled == true && self.VJ_TheController:KeyDown(IN_JUMP) then
		self.VJ_TheController:PrintMessage(HUD_PRINTCENTER,"No More Grenade Left!")
	end
	
	local gren = IsValid(self.Zombine_Grenade)
	if !IsValid(self:GetEnemy()) or self.VJ_IsBeingControlled == true then
		if gren == true then
			self.AnimTbl_Walk = {VJ_SequenceToActivity(self,"walk_all_grenade")}
			self.AnimTbl_Run = {VJ_SequenceToActivity(self,"run_all_grenade")}
		else
			self.AnimTbl_Walk = {ACT_WALK}
			self.AnimTbl_Run = {ACT_RUN}
		end
	else
		local EnemyDistance = self:GetPos():Distance(self:GetEnemy():GetPos())
		if EnemyDistance < 1000 then
			if gren == true then
				self.AnimTbl_Walk = {VJ_SequenceToActivity(self,"run_all_grenade")}
				self.AnimTbl_Run = {VJ_SequenceToActivity(self,"run_all_grenade")}
			else
				self.AnimTbl_Walk = {ACT_RUN}
				self.AnimTbl_Run = {ACT_RUN}
			end
		else
			if gren == true then
				self.AnimTbl_Walk = {VJ_SequenceToActivity(self,"walk_all_grenade")}
				self.AnimTbl_Run = {VJ_SequenceToActivity(self,"walk_all_grenade")}
			else
				self.AnimTbl_Walk = {ACT_WALK}
				self.AnimTbl_Run = {ACT_WALK}
			end
		end
	end
	
	if gren then
		self.AnimTbl_IdleStand = {VJ_SequenceToActivity(self,"idle_grenade")}
	else
		self.AnimTbl_IdleStand = {ACT_IDLE}
	end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:Zombine_CreateGrenade()
	self.Zombine_GrenadeOut = true
	self:VJ_ACT_PLAYACTIVITY("pullgrenade",true,false,true)
	timer.Simple(0.6,function()
		if IsValid(self) then
			self.Zombine_Grenade = ents.Create("npc_grenade_frag")
			self.Zombine_Grenade:SetOwner(self)
			self.Zombine_Grenade:SetParent(self)
			self.Zombine_Grenade:Fire("SetParentAttachment","grenade_attachment",0)
			self.Zombine_Grenade:Spawn()
			self.Zombine_Grenade:Activate()
			self.Zombine_Grenade:Input("SetTimer",self:GetOwner(),self:GetOwner(),3)
			self.Zombine_Grenade.VJHumanNoPickup = true
		end
	end)
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:MultipleMeleeAttacks()
	/*local randattack = math.random(1,3)
	if randattack == 1 then
		self.AnimTbl_MeleeAttack = {"vjseq_attacka","vjseq_attackb","vjseq_attackc","vjseq_attackd"}
		self.TimeUntilMeleeAttackDamage = 1
		self.MeleeAttackDamage = GetConVarNumber("vj_zss_zombine_d")
	elseif randattack == 2 then
		self.AnimTbl_MeleeAttack = {"vjseq_attacke","vjseq_attackf"}
		self.TimeUntilMeleeAttackDamage = 1
		self.MeleeAttackDamage = GetConVarNumber("vj_zss_zombine_d_hard")
	elseif randattack == 3 then*/
		self.AnimTbl_MeleeAttack = {"vjseq_fastattack"}
		self.TimeUntilMeleeAttackDamage = 0.4
		self.MeleeAttackDamage = GetConVarNumber("vj_zss_zombine_d")
	//end
end
---------------------------------------------------------------------------------------------------------------------------------------------
function ENT:CustomOnKilled(dmginfo,hitgroup)
	if IsValid(self.Zombine_Grenade) then
		self.Zombine_Grenade:SetOwner(NULL)
		self.Zombine_Grenade:SetParent(NULL)
		self.Zombine_Grenade:Fire("ClearParent")
		self.Zombine_Grenade:SetMoveType(MOVETYPE_VPHYSICS)
		self.Zombine_Grenade:SetPos(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Pos)
		self.Zombine_Grenade:SetAngles(self:GetAttachment(self:LookupAttachment("grenade_attachment")).Ang)
		local phys = self.Zombine_Grenade:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableGravity(true)
			phys:Wake()
		end
	end
end
/*-----------------------------------------------
	*** Copyright (c) 2012-2018 by DrVrej, All rights reserved. ***
	No parts of this code or any of its contents may be reproduced, copied, modified or adapted,
	without the prior written consent of the author, unless otherwise indicated for stand-alone materials.
-----------------------------------------------*/