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

AddCSLuaFile()

ENT.Base            = "base_nextbot"
ENT.Spawnable       = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Gender")
end
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

ENT.VJ_NPC_Class = {"CLASS_ANTLION"}

function ENT:Initialize()
	
	if SERVER then
		self:SetGender(util.SharedRandom("Civ"..self:EntIndex(), 0, 1) < .5 and "male" or "female")
		local index = math.floor(util.SharedRandom("Civ"..self:EntIndex(), 1, #Civs.Models[self:GetGender()]))
		self:SetModel( Civs.Models[self:GetGender()][index].mdl );
		self.Anims = Civs.Models[self:GetGender()][index].anims
	end
	
	self:SetHealth(Civs.Health)
	self:AddEFlags(EFL_DONTBLOCKLOS + EFL_FORCE_CHECK_TRANSMIT)
	
	if SERVER then
		self:SetName("Civ"..self:EntIndex())
		
		self:SetSolid(SOLID_BBOX)
		
		self:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			
		if not Civs.NoCollide then
			timer.Simple(3, function()
				if self:IsValid() then
					self:SetSolidMask(MASK_NPCSOLID)
					self:SetCollisionGroup(COLLISION_GROUP_NPC)
				end
				
			end)
		end
	else
		self:SetIK(false)
	end
	self:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,72) )
	
	self.Toughness = Civs.Health - Civs.Toughness + math.random(-Civs.Toughness/3,Civs.Toughness/3)
	self.Money = math.random(Civs.CashMin, Civs.CashMax)
	
	self.FreakingOut = false
	self.TriedToOpen = false
	self.Loitering = false
	self.LoiterStart = CurTime()
	self.FearPoint = Vector(0,0,0)
	self.LastPos = {self:GetPos()}
	self.StuckCount = 0
	self.NextExcuseMe = CurTime()
	self.Attacker = NULL
end


function ENT:BodyUpdate()
	
	local act = self:GetActivity()

	if ( act == ACT_RUN || act == ACT_HL2MP_RUN || act == ACT_WALK || act == ACT_HL2MP_WALK || act == ACT_HL2MP_RUN_MELEE ) then

		self:BodyMoveXY()

	end
	
	-- self:FrameAdvance()
	
	for p, ply in pairs( player.GetAll() ) do
		if ( ply:EyePos():DistToSqr( self:EyePos() ) <= 3600 ) then
			self:SetEyeTarget( ply:EyePos() )
			return
		end
	end
	
	self:SetEyeTarget(self:GetPos() + self:GetForward() * 1000)

end


function ENT:RunBehaviour()
	
    while ( true ) do
		
		if not self:IsValid() then
			coroutine.yield()
		end
		
		if self.FreakingOut then
		
			self:RunAndHide(self.FearPoint)
			self.FearPoint = Vector(0,0,0)
			
		else
			-- walk somewhere random
			self:StartActivity( ACT_WALK )                            -- walk anims
			self.loco:SetDesiredSpeed( Civs.WalkSpeed )                        -- walk speeds
			self.loco:SetStepHeight( Civs.StepHeight )
			self.loco:SetJumpHeight( 40 )
			self.loco:SetMaxYawRate( 360 )
			self.loco:SetDeathDropHeight( Civs.StepHeight )
			
			-- local newpos = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 1000
			-- local fail = not util.IsInWorld(newpos)
			
			-- newpos = util.QuickTrace(newpos,Vector(0,0,1),self).HitPos
			-- fail = fail and not bit.band( util.PointContents( newpos ), CONTENTS_EMPTY ) == CONTENTS_EMPTY
			
			-- while fail do
			-- -- while (not util.IsInWorld( newpos )) do
				-- newpos = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 1000
				-- fail = not util.IsInWorld(newpos)
				-- newpos = util.QuickTrace(newpos,Vector(0,0,1),self).HitPos
				-- fail = fail and not bit.band( util.PointContents( newpos ), CONTENTS_EMPTY ) == CONTENTS_EMPTY
			-- end
			local result = self:WalkTo( {pos = self:FindNewDestination()} ) -- walk to a random place
			
			self:StartActivity( ACT_IDLE )        -- revert to idle activity
			
			if result == "ok" and math.Rand(0,1) > Civs.LoiterChance then
				
				self.Loitering = true
				self.LoiterStart = CurTime()
				while CurTime() < self.LoiterStart + Civs.LoiterTime and self.Loitering and (not self.FreakingOut) do
					
					local iSeq = self:LookupSequence( self.Anims.idle )
					if ( iSeq > 0 ) then self:ResetSequence( iSeq ) end
					coroutine.yield()
					
				end
				
				self.Loitering = false
				
			end
			
		end
		
		coroutine.yield()
		
    end
end

function ENT:OnInjured(dmginfo)
	
	hook.Run("Civ_TakeDamage", self, dmginfo)
	
	// This may be moved in the future.
	self:EmitSound(table.RandomSeq(Civs.HurtSounds[self:GetGender()]),80, 100, 1, CHAN_VOICE)
	
	if Civs.DmgStopsCalls then
		self:InterruptPoliceCall()
	end
	
	if dmginfo:GetAttacker():IsPlayer() then
		self:FreakOut(dmginfo:GetAttacker():GetPos(),dmginfo:GetAttacker(), "hurt")
		-- print(self:Health(), self.Toughness)
		if !Civs.KillRequired and self:Health() < self.Toughness then
			self:ThrowMoney(dmginfo:GetAttacker())
		end
	end
	
end

function ENT:OnKilled(dmginfo)

	hook.Run( "Civ_Killed", self, dmginfo )
	
	if CLIENT then
		if IsValid(self.CallProg) then
			self.CallProg:Remove()
		end
	end
	
	self:InterruptPoliceCall()
	
	self:ThrowMoney(dmginfo:GetAttacker())
	
	//This may be moved in the future.
	self:EmitSound(table.RandomSeq(Civs.HurtSounds[self:GetGender()]),75, 100, 1, CHAN_VOICE)
	
	-- self:BecomeRagdoll(dmginfo) //too laggy, and they can't be deleted.
	
	self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	timer.Simple(.2, function()
		if self:IsValid() then
			self:Remove()
		end
	end)
	
	net.Start("Civs_Ragdoll")
		net.WriteEntity(self)
		net.WriteVector(dmginfo:GetDamageForce())
	net.Broadcast()
	
	-- timer.Simple(Civs.BodyDisappear, function()
		-- if self:IsValid() then
			-- self:Remove()
		-- end
	-- end)
end

function ENT:OnOtherKilled(victim, dmginfo)
	
	if victim == self then return end
	if not dmginfo then return end
	if victim == dmginfo:GetAttacker() then return end
	
	if victim:GetPos():Distance(self:GetPos()) < Civs.AlertDist then
		
		self:FreakOut(dmginfo:GetAttacker():GetPos(), dmginfo:GetAttacker(), "murder")
		if math.random() == 1 then
			self:EmitSound(table.RandomSeq(Civs.OtherDieSounds[self:GetGender()]),75, 100, 1, CHAN_VOICE)
		end
		
	elseif self.FreakingOut and self.Attacker == dmginfo:GetAttacker() then
		self:FreakOut(dmginfo:GetAttacker():GetPos(), dmginfo:GetAttacker(), "murder")
		
		if math.random() == 1 then
			self:EmitSound(table.RandomSeq(Civs.OtherDieSounds[self:GetGender()]),75, 100, 1, CHAN_VOICE)
		end
	end
	
end

-- function ENT:OnIgnite()
	-- self:FreakOut()
-- end

function ENT:OnContact(other)

	if IsValid(other) and other:IsPlayer() then -- or other:GetClass():find("npc_") then
		if self.NextExcuseMe < CurTime() then 
			local playsound
			if self.FreakingOut then
				local index = math.floor(util.SharedRandom("Civ"..self:EntIndex(), 1, #Civs.AfraidSounds[self:GetGender()], CurTime()))
				playsound = Civs.AfraidSounds[self:GetGender()][index]
			else
				local index = math.floor(util.SharedRandom("Civ"..self:EntIndex(), 1, #Civs.ExcuseMeSounds[self:GetGender()], CurTime()))
				playsound = Civs.ExcuseMeSounds[self:GetGender()][index]
			end
			
			local dur = math.max(SoundDuration(playsound) or 0, 2)
			self.NextExcuseMe = CurTime() + dur + 2
			timer.Simple(math.Rand(0,.4), function()
				if self:IsValid() then
					self:EmitSound(playsound, 68, 100, 1, CHAN_VOICE)
				end
			end)
		end
		
	elseif IsValid(other) and other:IsVehicle() then
		self:OnVehicleContact(other)
	end
end

function ENT:OnVehicleContact(other)
	local speed = other:GetVelocity():Length()
	if speed > Civs.VehKillSpeed then
		local attk = other:GetDriver()
		local dmg = DamageInfo()
		dmg:SetDamageType(DMG_VEHICLE)
		dmg:SetDamage(Civs.Health)
		dmg:SetAttacker(attk:IsValid() and attk or other)
		dmg:SetInflictor(other)
		dmg:SetDamageForce(other:GetVelocity()*20)
		dmg:SetDamagePosition(self:GetPos())
		self:TakeDamageInfo(dmg)
	elseif speed > Civs.VehKillSpeed/4 then
		local attk = other:GetDriver()
		local dmg = DamageInfo()
		dmg:SetDamageType(DMG_VEHICLE)
		dmg:SetDamage(Civs.Health*(speed/Civs.VehKillSpeed))
		dmg:SetAttacker(attk:IsValid() and attk or other)
		dmg:SetInflictor(other)
		dmg:SetDamageForce(other:GetVelocity()*20)
		dmg:SetDamagePosition(self:GetPos())
		self:TakeDamageInfo(dmg)
	elseif speed > 20 and self:Health() > 0 then
		self:FreakOut()
	end
end

function ENT:ThrowMoney(attacker)
	if !IsValid(attacker) then return end
	if !attacker:IsPlayer() then return end
	if DarkRP and DarkRP.createMoneyBag and self.Money > 0 then
		
		if !Civs.CopsCanRob and Civs.IsCop(attacker) then return end
		
		if attacker.LastCivMug and CurTime() - attacker.LastCivMug < (Civs.TimeBetweenMugs or 0) then return end
		
		local a = hook.Run("Civ_DroppedMoney", self, attacker, self.Money)
		
		if a==false then return end
		
		local amount = isnumber(a) and a or self.Money
		
		local bag = DarkRP.createMoneyBag(self:GetPos()+Vector(0,0,25), amount)
		bag:SetOwner(self)
		bag:GetPhysicsObject():ApplyForceCenter(self.loco:GetGroundMotionVector()*2)
		
		attacker.LastCivMug = CurTime()
		
		-- local dir = (attacker:GetPos() - self:GetPos()):GetNormalized()
		-- bag:GetPhysicsObject():ApplyForceCenter(dir*1000)
		
		
		self.Money = 0
	end
end

function ENT:FreakOut(source, attacker, reason)
	
	-- local should = hook.Run("Civs_ShouldFreakOut",self,source,attacker,reason)
	
	-- if should == false then return end
	
	if isvector(source) then
		if Civs.RequireLineOfSight then
			local trace = self:IsLineOfSightClear(source)
			if !trace then
				return
			end
		end
	end
	
	if not self.FreakingOut then
		
		if hook.Run("Civ_StartFreakingOut", self, source, attacker, reason) == false then return end
		
		if isvector(source) then
			self.FearPoint = source
		end
		if IsValid(attacker) then
			self.Attacker = attacker
		end
		
		self.BreakPath = true
		self.FreakingOut = true
	end
	
	if IsValid(attacker) then
		if isstring(reason) and reason != "" then
			
			local r = Civs.Wanted[reason]
			if r then
				if attacker.CivWantedReason then
					if r.severity < attacker.CivWantedReason.severity then
						attacker.CivWantedReason = r
					end
				else
					attacker.CivWantedReason = r
				end
				
				-- if self.CivWantedReason then
					
				-- else
					-- self.CivWantedReason = r
				-- end
			end
			
		end
	end
	
end
function ENT:RunAndHide(from)
	local attacker = self.Attacker

	-- find the furthest away hiding spot
	
	-- local spots = self:FindSpots( { type = "hiding", radius = 0 } )
	local spots = self:FindSpots( { type = "hiding", radius = 2200 } )
	local pos
	
	if from then
		//calculate furthest spot from the attacker and us.
		pos = self:GetPos()
		-- local distBetweenUs = self:GetPos():DistToSqr(from)
		local furthest = 0
		for k,spot in pairs(spots)do
			local distFromMe = spot.distance*spot.distance
			local distFromThem = from:DistToSqr(spot.vector)
			
			if distFromThem > furthest then
				if (distFromThem > distFromMe) then
					pos = spot.vector
					furthest = distFromThem
				end
			end
			
		end
	else
		pos = spots[1].vector
	end
	
	local should = hook.Run("Civs_ShouldCallPolice",self,attacker,from)
	

	-- if the position is valid
	if ( pos ) then
		self:StartActivity( ACT_RUN )
		self:ResetSequence(self:LookupSequence(self.Anims.run))
		
		self:EmitSound(table.RandomSeq(Civs.AfraidSounds[self:GetGender()]),80, 100, 1, CHAN_VOICE)
		
		self.loco:SetDesiredSpeed( Civs.RunSpeed )  
		local result = self:WalkTo( {pos=pos} ) 
		
		self:ResetSequence(self:LookupSequence(self.Anims.hide))
		
		if (should != false) and Civs.CallPolice and isvector(from) and IsValid(self.Attacker) and self.Attacker:IsPlayer() and self.Attacker:Alive() and (not Civs.IsCop(self.Attacker)) then
			if self:IsValid() then
				if util.SharedRandom("Civ"..self:EntIndex(), 0, 1, CurTime()) <= Civs.CallChance then
					if !self.Attacker.isArrested or !self.Attacker:isArrested() then
						self:CallPolice(from)
					end
				end
			end
		else
			self.Attacker = NULL
		end
		if self:IsValid() then
			coroutine.wait(math.max(Civs.ScaredTime, Civs.CallTime))
		end
		if self:IsValid() then
			self:StartActivity( ACT_IDLE )
			self.FreakingOut = false
		end
		
	else
		
	
		self:ResetSequence(self:LookupSequence(self.Anims.hide))
		
		if (should != false) and Civs.CallPolice and isvector(from) and IsValid(self.Attacker) and self.Attacker:IsPlayer()and self.Attacker:Alive() and (not Civs.IsCop(self.Attacker)) then
			if self:IsValid() then
				if util.SharedRandom("Civ"..self:EntIndex(), 0, 1, CurTime()) <= Civs.CallChance then
					if !self.Attacker.isArrested or !self.Attacker:isArrested() then
						self:CallPolice(from)
					end
				end
			end
		else
			self.Attacker = NULL
		end
		if self:IsValid() then
			coroutine.wait(math.max(Civs.ScaredTime, Civs.CallTime)+3)
		end
		if self:IsValid() then
			self:StartActivity( ACT_IDLE )
			self.FreakingOut = false
		end
	end
	
end
function ENT:CallPolice(fearpos)
	
	if CLIENT then
		local pos = self:GetPos()
		local toscreen = (pos+Vector(0,0,44)):ToScreen()
		local x,y = toscreen.x, toscreen.y
		local progbar = vgui.Create("DProgress")
			-- progbar:ParentToHUD()
			progbar:SetPos(x-35,y-35)
			progbar:SetSize(70,70)
			progbar:SetFraction(0)
			progbar.Amt = 0
			progbar.pos = pos
			progbar.Color = Civs.ProgBarColor
			progbar.Interrupted = false
			function progbar.Think(s)
				if not s.Interrupted and not self:IsValid() then
					s:Remove()
					return
				end
				
				cam.Start3D() //Reset 3D viewport.
					toscreen = (s.pos+Vector(0,0,44)):ToScreen()
				cam.End3D()
				
				-- local visible = util.TraceLine({start=LocalPlayer():GetShootPos(), endpos=s.pos+Vector(0,0,44), filter={self,LocalPlayer(),LocalPlayer():GetVehicle()}})
				-- if visible.Hit and !Civs.ProgRequireLOS then 
				local visible = LocalPlayer():IsLineOfSightClear(s.pos)
				if !visible and Civs.ProgRequireLOS then 
					s:SetPos(-200, -200)
					s.Label:SetPos(-300, -300)
				else
					s:SetPos(math.Clamp(toscreen.x-35, 100, ScrW()-100-s.Label:GetWide()), math.Clamp(toscreen.y-35, 100, ScrH()-100-s:GetTall()))
					s.Label:SetPos(math.Clamp(toscreen.x-s.Label:GetWide()/2,100,ScrW()-100-s.Label:GetWide()), math.Clamp(toscreen.y-15-s:GetTall()/2,90,ScrH()-110-s:GetTall()))
				end
				
				s.Amt = s.Amt + FrameTime()
				if not s.Interrupted then
					s:SetFraction( math.Clamp(s.Amt / Civs.CallTime, 0, 1) )
				end
				
				if s:GetFraction() >= 1 then
					s.Color = Civs.ProgSuccessColor
					s.Label:SetText("Success!")
					s.Label:SizeToContents()
				end
				
				if Civs.CallTime - s.Amt < -Civs.ProgPersistTime then //delete after x seconds of being finished.
					if s:IsValid() then s:Remove() end
				end
			end
			function progbar.Paint(s,w,h)
				local x,y = s:GetPos()
				if x > -w and y > -h then
					draw.NoTexture()
					draw.Arc(w/2, h/2, w/2, 12, -s:GetFraction()*360+90, 90, 3, s.Color)
				end
			end
			function progbar:OnRemove()
				self.Label:Remove()
			end
			self.CallProg = progbar
			table.insert(Civs.Progbars, progbar)
			
		local proglab = vgui.Create("DLabel")
			proglab:SetFont("TargetID")
			proglab:SetText(Civs.CallingLabel)
			proglab:SetTextColor(Color(255,255,255))
			proglab:SizeToContents()
			self.CallProg.Label = proglab
			
			
			
	elseif IsValid(self.Attacker) then
		local pos = fearpos or self:GetPos()
		for k,v in pairs(player.GetAll()) do
			if Civs.ShouldSeeCall(self.Attacker, v) then
				v:SendLua([[local ent = Entity(]]..self:EntIndex()..[[) if ent:IsValid() then ent:CallPolice(Vector(]].. pos.x .. "," .. pos.y .. "," .. pos.z .. [[)) end]])
			end
		end
		
		local wait = 0
		while wait < Civs.CallTime do
			local snd = table.RandomSeq(Civs.AfraidSounds[self:GetGender()])
			timer.Simple(wait, function()
				if self:IsValid() and self.CallingPolice then
					self:EmitSound(snd,60, 100, 1, CHAN_VOICE)
				end
			end)
			wait = wait + math.max(SoundDuration(snd) or 0, 1.5) + .2
		end
		
		self.CallingPolice = true
		local name = self:GetName()
		local dfunc = function(ply)
			if ply == self.Attacker then
				ply.DiedRecently = true
				self:InterruptPoliceCall()
			end
		end
		hook.Add("DoPlayerDeath",name.."CivsCops",dfunc)
		hook.Add("playerArrested",name.."CivsCops",dfunc)
		
		timer.Simple(Civs.CallTime, function()
			hook.Remove("DoPlayerDeath",name.."CivsCops")
			hook.Remove("playerArrested",name.."CivsCops")
			if self:IsValid() then
				if self.CallingPolice then
					if self.Attacker:IsValid() and self.Attacker:IsPlayer() and self.Attacker:Alive() and !self.Attacker.DiedRecently then
						local reason = self.Attacker.CivWantedReason
						if reason then
							local shouldWanted = true
							if DarkRP and self.Attacker:isWanted() then
								local curReason = self.Attacker:getDarkRPVar("wantedReason","")
								local curCivReason
								for k,v in pairs(Civs.Wanted) do
									if v.desc == curReason then
										curCivReason = v
										break
									end
								end
								
								if curCivReason then
									if curCivReason.severity < reason.severity then
										shouldWanted = false
									end
								end
								
							end
							
							self.Attacker.LastCivCrimeCommitted = self.Attacker.CivWantedReason.desc
							
							if Civs.MakeWanted and DarkRP then //darkrp only.
								if shouldWanted then
									if self.Attacker:Alive() then
										self.Attacker:wanted(self, reason.desc, reason.time)
										self.Attacker.CivWantedReason = nil
									end
								end
							end
							
						end
						
						self:PoliceBeacon(pos)
						
						
					end
					
				end
				self.Attacker.DiedRecently = false
				self.Attacker = NULL
				self.CallingPolice = false
			end
		end)
	end
	
end

//Player functions because sometimes that happens I guess.
function ENT:Nick()
	return "A Civilian"
end
ENT.Name = ENT.Nick
ENT.SteamName = ENT.Nick
function ENT:SteamID()
	return "STEAM_0:0:0"
end
function ENT:SteamID32()
	return "90071996842377216"
end
function ENT:Ping()
	return 0
end
function ENT:IsUserGroup()
	return false
end
function ENT:CheckGroup()
	return false
end

function ENT:InterruptPoliceCall()
	hook.Run("Civ_PoliceCallInterrupted", self)
	
	if CLIENT then
		if self.CallProg and self.CallProg:IsValid() and self.CallProg:GetFraction() < 1 then
			self.CallProg.Color = Civs.ProgInterruptColor
			self.CallProg.Label:SetText("Interrupted!")
			self.CallProg.Label:SizeToContents()
			self.CallProg.Amt = Civs.CallTime
			self.CallProg.Interrupted = true
		end
	else
		BroadcastLua([[local ent=Entity(]]..self:EntIndex()..[[)if ent:IsValid()and ent:GetClass():find("npc_civ") then ent:InterruptPoliceCall()end]])
		self.CallingPolice = false
		
	end
end
function ENT:PoliceBeacon(pos, attacker, reason) //extra args are clientside only.
	
	hook.Run("Civ_PoliceBeaconCreated", self, pos, attacker, reason)
	
	if SERVER then
		-- if DarkRP then
			local attacker = self.Attacker
			local cops = {}
			for k,v in pairs(player.GetAll())do
				if Civs.IsCop(v) then
					table.insert(cops,v)
				end
			end
			net.Start("Civs_PoliceBeacon")
				net.WriteEntity(self)
				net.WriteEntity(attacker)
				net.WriteVector(pos)
				net.WriteString(attacker.LastCivCrimeCommitted or "")
				-- net.WriteString(attacker:getDarkRPVar("wantedReason"))
			-- net.Broadcast()
			net.Send(cops)
			-- BroadcastLua([[local ent = Entity(]]..self:EntIndex()..[[) if ent:IsValid() then ent:PoliceBeacon(Vector(]].. pos.x .. "," .. pos.y .. "," .. pos.z .. [[),"]]....[[") end]])
		-- end
	else
		
		local toscreen = (pos+Vector(0,0,32)):ToScreen()
		local x,y = toscreen.x, toscreen.y
		
		local beacon = vgui.Create("DImage")
			-- beacon:ParentToHUD()
			beacon:SetPos(x-16,y-16)
			beacon:SetSize(32,32)
			beacon:SetMaterial(Civs.BeaconMaterial)
			beacon.Amt = 0
			beacon.pos = pos
			function beacon.Think(s)
				cam.Start3D()
					toscreen = (s.pos+Vector(0,0,32)):ToScreen()
				cam.End3D()
				
				s:SetPos(math.Clamp(toscreen.x-16, 100+s.Label:GetWide()/2-16, ScrW()-100-s.Label:GetWide()/2-16), math.Clamp(toscreen.y-16, 100, ScrH()-100-s:GetTall()))
				s.Label:SetPos(math.Clamp(toscreen.x-s.Label:GetWide()/2,100,ScrW()-100-s.Label:GetWide()), math.Clamp(toscreen.y-24-s:GetTall()/2,90,ScrH()-110-s:GetTall()))
				
				s.Amt = s.Amt + FrameTime()
				
				if s.Amt > Civs.PoliceBeaconTime then
					if s:IsValid() then s:Remove() end
				end
			end
			function beacon:OnRemove()
				self.Label:Remove()
			end
			
		local beaclab = vgui.Create("DLabel")
			beaclab:SetFont("TargetID")
			beaclab:SetText(reason)
			beaclab:SetTextColor(Color(255,255,255))
			beaclab:SizeToContents()
			beacon.Label = beaclab
			
		table.insert(Civs.Beacons, beacon) //insert it to be removed on map cleanup.
		
	end
	
end


//Snake through connected areas and find a good one, then return a random position in that area.
function ENT:FindNewDestination()
	local time = SysTime()
	local area = navmesh.GetNearestNavArea(self:GetPos(), false, 1000)
	if not area then return self:GetPos() end
	
	local previous = {}
	
	local i = 0
	while i < Civs.WanderDist or (area:HasAttributes(NAV_MESH_AVOID) and i < 100) do
	
		if math.random(0,1) != 1 then
			local new = table.RandomSeq(area:GetAdjacentAreas() or {})
			
			if not new then //nowhere to go
				-- print("Nowhere to go: ", i) 
				break
			end
			
			if not previous[new] then //we've not been here already.
				previous[new] = true
				area = new
			end
			
		-- elseif (not area:HasAttributes(NAV_MESH_AVOID)) then
			-- -- print("Random cutout: ", i)
			-- break
		end
		
		i=i+1
		-- if i==Civs.WanderDist then
			-- print("Full path: ", i) 
		-- end
	end
	
	if SysTime() - time > 1 then
		print("Took "..SysTime() - time.." to find new destination")
	end
	
	return area:GetRandomPoint()
end

function ENT:WalkTo( options )

	local options = options or {}

	local path = Path( "Follow" )
	
	path:SetMinLookAheadDistance( options.lookahead or 80 )
	path:SetGoalTolerance( options.tolerance or 30 )
	
	self:ComputePath(path, options.pos or self:GetPos()) --compute path with no doors.
	
	if ( !path:IsValid() ) then 
		self.StuckCount = 0
		self.LastPos = {self:GetPos()}
		return "failed" 
	end
	
	-- local last = self:GetPos()
	-- for k,v in ipairs(path:GetAllSegments())do
		-- local trace = { start = last, endpos = v.pos+Vector(0,0,12), filter = self, mask=MASK_NPCSOLID}
		-- local res = util.TraceLine(trace)
		-- last = v.pos+Vector(0,0,1)
		-- if res.Hit then
			-- return "blocked"
		-- end
	-- end

	while ( path:IsValid() ) and (not self.BreakPath) do
		if not self:IsValid() then
			return "removed"
		end
		
		path:Update( self )								-- This function moves the bot along the path
		
		if not self.TriedToOpen then
			table.insert(self.LastPos, 1, self:GetPos())
		end
		
		local count = #self.LastPos
		local minCheck = 23
		if count > minCheck then
			self.LastPos[minCheck+1] = nil
			local sum = 0
			for i=1, minCheck do
				sum = sum + (self:GetPos() - self.LastPos[i]):Length2DSqr()
			end
			if (sum/minCheck) < Civs.WalkSpeed then
				self.StuckCount = self.StuckCount + 1
				
				if self.StuckCount > 30 then
					self.LastPos = {self:GetPos()}
					self.StuckCount = 0
					self:HandleStuck()
				
					return "stuck"
				end
				
			end
		end
		
		//Open doors.
		if SERVER then
			if Civs.CanOpenDoors then
				local doors = ents.FindInSphere(self:GetPos(), 12)
				for k,v in pairs(doors) do	
					if not IsValid(v) then continue end
					if v:GetClass() == "prop_door_rotating" then
						if self.TriedToOpen then
							
							self.StuckCount = 0
							self.LastPos = {self:GetPos()}
							self:HandleStuck()
							
							return "stuck"
							
						else
						
							v:Fire("OpenAwayFrom",self:GetName())
							-- self:PlaySequenceAndWait("Open_door_away")
							coroutine.wait(1)
							self:StartActivity(ACT_WALK)
							self.TriedToOpen = true
							
							self:WalkTo(options)
							
						end
					end
				end
				
				if #doors == 0 then
					self.TriedToOpen = false
				end
				
			end
			
			if Civs.CanOpenBrushes then
				-- local doors = ents.FindInCone(self:GetPos()+Vector(0,0,20), self:GetForward(), 50, 30)
				local doors = ents.FindInSphere(self:GetPos(), 32)
				for k,v in pairs(doors) do	
					if not IsValid(v) then continue end
					if v:GetClass():find("func_door") then
						local flags = v:GetFlags()
						if bit.band(flags, 512) != 512 then
							v:Fire("open")
						end
					end
					
				end
			end
			
		end
		
		if ( GetConVarNumber("nav_edit")==1 and not game.IsDedicated() ) then path:Draw() end
		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			
			self.LastPos = {self:GetPos()}
			self.StuckCount = 0
			self:HandleStuck()
			
			return "stuck"
			
		end
		
		coroutine.yield()
		
	end
	
	local wasbroke = self.BreakPath
	
	self.BreakPath = false
	self.StuckCount = 0
	self.LastPos = {self:GetPos()}
	
	if wasbroke then
		return "interrupted"
	end
	
	return "ok"

end

function ENT:ComputePath(path, pos)
	local time = SysTime()
	path:Compute( self, pos, function(area, fromArea, ladder, elevator, length )
		if ( !IsValid( fromArea ) ) then

			// first area in path, no cost
			return 0

		else
			if ( !fromArea:IsConnected(area) ) then
				return -1
			end

			if ( !self.loco:IsAreaTraversable( area ) ) then
				// our locomotor says we can't move here
				return -1
			end
			
			// compute distance traveled along path so far
			local dist = 0

			if ( IsValid( ladder ) ) then
				dist = ladder:GetLength()
			elseif ( length > 0 ) then
				// optimization to avoid recomputing length
				dist = length
			else
				dist = ( area:GetCenter() - fromArea:GetCenter() ):Length()
				-- dist = ( area:GetCenter() - fromArea:GetCenter() ):GetLength()
			end

			local cost = dist + fromArea:GetCostSoFar()
			
			local doors = ents.FindInBox(area:GetCorner(0), area:GetCorner(2) + Vector(0,0,100))
			for k,v in pairs(doors) do
				if v:GetClass():find("door") or v:GetClass():find("breakable") then
					-- cost = cost + 5
					return -1
				end
			end
			
			local avoidPenalty = 1.2
			if area:HasAttributes(NAV_MESH_AVOID) then
				if self.FreakingOut then //if we're in a hurry, allow movement through avoid areas.
					cost = cost + avoidPenalty * dist
				else
					return -1
				end
			end


			// check height change
			local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange( area )
			if ( deltaZ >= self.loco:GetStepHeight() ) then
				if ( deltaZ >= self.loco:GetMaxJumpHeight() ) then
					// too high to reach
					return -1
				end

				// jumping is slower than flat ground
				local jumpPenalty = 5
				cost = cost + jumpPenalty * dist
			elseif ( deltaZ < -self.loco:GetDeathDropHeight() ) then
				// too far to drop
				return -1
			end

			return cost
		end
	end)
	
	local dtime = SysTime() - time
	if dtime > 1.1 then
		print(self, " took "..dtime.." seconds to find a new destination! Removing...")
		self:Remove()
	end
	
end

function ENT:Use(ply)
	if Civs.AllowMug then
		local last = ply.LastCivMug or 0
		if CurTime() - last < (Civs.TimeBetweenMugs or 0) then return end
		if table.HasValue(Civs.MugWeapons, ply:GetActiveWeapon():GetClass()) then
			self:ThrowMoney(ply)
			self:FreakOut(ply:GetPos(),ply, "hurt")
			ply.LastCivMug = CurTime()
		end
	end
end

function ENT:OnRemove()
	if SERVER then
		if IsValid(self.Attacker)then
			self.Attacker.DiedRecently = false
		end
		hook.Remove("DoPlayerDeath",self:GetName().."CivsCops")
		hook.Remove("playerArrested",self:GetName().."CivsCops")
	end
end

if Civs and Civs.AllowArrest then
	function ENT:onArrestStickUsed(user)
		self:SetPos(DarkRP.retrieveJailPos())
	end
end

if CLIENT then
	language.Add( "npc_civ", "Civ" )
end
list.Set( "NPC", "npc_civ", {
	Name = "Civilian",
	Class = "npc_civ",
	Category = "Civs"
} )


//For wanted purposes.
-- table.Inherit(ENT,FindMetaTable("Player"))
-- for k,v in pairs(FindMetaTable("Player")) do
	-- if k:match("__") then continue end
	-- if not ENT[k] then ENT[k] = v end
-- end