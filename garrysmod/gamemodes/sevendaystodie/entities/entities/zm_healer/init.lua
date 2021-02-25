AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SpawnFunction( ply, tr )
	
	if !tr.Hit then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 1

	local ent = ents.Create( "zm_healer" )
    ent:SetPos( SpawnPos + Vector(0,0, 30) )
    ent:SetHealth(self.Health)
    
    ent:Spawn()
    ent:Activate()
    
	return ent
end

function ENT:Initialize()

	self.Entity:SetModel("models/props_c17/gravestone_statue001a.mdl")
    self.Entity:SetModelScale(.75, 0)


	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE)
	self.Entity:SetSolid( SOLID_VPHYSICS )

	
    self.Index = self.Entity:EntIndex()
    self.NextHandleTarget = CurTime()
    self.NextHandleHeal = CurTime()

    self.Healthbar = self:GetOwner():GetMaxHealth()*.35
    

    self:GetOwner():CallOnRemove(self:EntIndex().." Target Died", function() 
        self.Disabled = true
    end)
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Think()
    if self.NextHandleTarget < CurTime() then
        self:HandleTarget()
    end

    if self.NextHandleHeal < CurTime() then 
        self:HandleHeal()
    end
end

function ENT:OnTakeDamage( dmginfo )
    if dmginfo:IsBulletDamage() || dmginfo:IsExplosionDamage() then return dmginfo:GetAttacker():ChatNotify("You must melee the beacon!")
    end

    self.Healthbar = self.Healthbar - dmginfo:GetDamage()
    self:EmitSound("Breakable.MatConcrete", 75,100, 1, CHAN_AUTO) 
    if self.Healthbar <= 0 then
        self:EmitSound("ceiling_tile.Break", 75,100, 1, CHAN_AUTO) 
	    self:EmitSound("Metal_Box.Break", 75,100, 1, CHAN_AUTO) 
	    self:EmitSound("GlassBottle.Break", 75,100, 1, CHAN_AUTO) 
	    self:EmitSound("Pottery.Break", 75,100, 1, CHAN_AUTO) 
	    dmginfo:GetAttacker():ChatNotify("You broke the healing beacon!")
        self:Remove()
    end
end


function ENT:HandleTarget()
    self.NextHandleTarget = CurTime() + .25
    if !self.Disabled && self:GetOwner() then
        local Ang =  self:GetOwner():GetPos() - self:GetPos()
        local ang1 = Ang:GetNormalized():Angle()
        self:SetAngles(Angle(0,ang1.y,0))
    end
end

function ENT:HandleHeal()
    self.NextHandleHeal = CurTime() + 4
    if !self.Disabled && self:GetOwner() then 
        self:GetOwner():SetHealth(math.min( self:GetOwner():Health() + self:GetOwner():GetMaxHealth() * .05, self:GetOwner():GetMaxHealth() ) ) 
    end
end