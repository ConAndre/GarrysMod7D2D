ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName		= ""
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Category		= "Zombies"
ENT.Spawnable       = true

if CLIENT then 
    local wave = Material( "trails/smoke")
    --"cable/hydra" --green

    
    function ENT:Draw()
        self:DrawModel()
    end

    function ENT:Initialize()
        local hookname = self:EntIndex().." Unique ID"
        local NextEntCheck = CurTime()
        local MaxAlpha = 100
        local CurAlpha = MaxAlpha

        hook.Add("PreDrawEffects", hookname, function() 
            if NextEntCheck < CurTime() then 
                NextEntCheck = CurTime() + 1
                if !IsValid(self) then hook.Remove("PreDrawEffects", hookname ) return end
            end
            self.NextBeam = self.NextBeam or CurTime()
            self.NextSound = self.NextSound or CurTime()
            if self.NextBeam && self.NextBeam < CurTime() then
                if !IsValid(self:GetOwner()) then 

                    self.NextBeam = CurTime() + 99999
                    self.NextSound = CurTime() + 99999 
                else 
                    CurAlpha = math.max(math.abs( math.cos( CurTime() ) ) * MaxAlpha - 50, 0)
                    if CurAlpha > 45 then 
                        if self.NextSound < CurTime() then
                            self.NextSound = CurTime() + 50
                            self:EmitSound("items/smallmedkit1.wav")
                        end
                    elseif CurAlpha <= 45 then
                        self.NextSound = CurTime()
                    end

                    render.SetMaterial(wave)
                    self.Center = self.Center or self:OBBCenter()
                    self.TargetHeight =  Vector(0,0,self:GetOwner():OBBCenter().z*1.5)
                    render.DrawBeam(self:GetPos() + Vector(0, 0, self.Center.z*5.8) , self:GetOwner():GetPos() + self.TargetHeight, 15, 0, 0, Color(0, 255, 0, CurAlpha))
                end
            end
        end) 
    end
end