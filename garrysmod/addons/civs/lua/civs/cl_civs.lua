
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

Civs.CivClasses = {"npc_civ"}

-- startang and endang are in degrees, 
-- radius is the total radius of the outside edge to the center.
local cos, sin, abs, max, rad1 = math.cos, math.sin, math.abs, math.max, math.rad
local surface = surface
function draw.Arc(cx,cy,radius,thickness,startang,endang,roughness,color)
	surface.SetDrawColor(color)
	surface.DrawArc(surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness))
end

-- surface.DrawArc() draw a premade arc.
-- Use surface.PrecacheArc() to generate one. 
-- This is the most efficient way to draw a STATIC arc which doesn't change every frame.
function surface.DrawArc(arc) 
	for k,v in ipairs(arc) do
		surface.DrawPoly(v)
	end
end

-- surface.PrecacheArc() creates an arc table.
-- Feed this into surface.DrawArc() to draw it.
function surface.PrecacheArc(cx,cy,radius,thickness,startang,endang,roughness)
	local quadarc = {}
	-- local deg2rad = math.pi / 180
	
	-- Define step
	local roughness = max(roughness or 1, 1)
	local step = roughness
	
	-- Correct start/end ang
	local startang,endang = startang or 0, endang or 0
	
	if startang > endang then
		step = abs(step) * -1
	end
	
	-- Create the inner circle's points.
	local inner = {}
	local outer = {}
	local ct = 1
	local r = radius - thickness
	for deg=startang, endang, step do
		local rad = rad1(deg)
		-- local rad = deg2rad * deg
		local cosrad, sinrad = cos(rad), sin(rad) --calculate sin,cos
		
		local ox, oy = cx+(cosrad*r), cy+(-sinrad*r) --apply to inner distance
		inner[ct] = {
			x=ox,
			y=oy,
			u=(ox-cx)/radius + .5,
			v=(oy-cy)/radius + .5,
		}
		
		local ox2, oy2 = cx+(cosrad*radius), cy+(-sinrad*radius) --apply to outer distance
		outer[ct] = {
			x=ox2,
			y=oy2,
			u=(ox2-cx)/radius + .5,
			v=(oy2-cy)/radius + .5,
		}
		
		ct = ct + 1
	end
	
	-- QUAD the points.
	for tri=1,ct do
		local p1,p2,p3,p4
		local t = tri+1
		p1=outer[tri]
		p2=outer[t]
		p3=inner[t]
		p4=inner[tri]
		
		quadarc[tri] = {p1,p2,p3,p4}
	end
	
	-- Return a table of triangles to draw.
	return quadarc
	
end

function table.RandomSeq(tbl)
	local rand = math.random( 1, #tbl )
	return tbl[rand], rand
end

Civs.Progbars = {}
Civs.Beacons = {}
hook.Add("PreCleanupMap","Civ_RemoveProgs",function()
	for k,v in pairs(Civs.Progbars)do
		if v:IsValid() then
			v:Remove()
		end
		Civs.Progbars[k] = nil
	end
	for k,v in pairs(Civs.Beacons)do
		if v:IsValid() then
			v:Remove()
		end
		Civs.Beacons[k] = nil
	end
end)

//Quiet footsteps
hook.Add( "EntityEmitSound", "TimeWarpSounds", function( t )
    if t.Entity:IsValid() and t.Entity:GetClass():find("civ") and t.SoundName:find("foot") then
        t.Volume = .4
        return true
    end
end)

net.Receive("Civs_Ragdoll", function()
	local civ = net.ReadEntity()
	local force = net.ReadVector()
	
	if not IsValid(civ) then
		print("Could not create Civ ragdoll: ", civ, force)
		return
	end
	
	local rag = civ:BecomeRagdollOnClient()
	
	if not IsValid(rag) then
		print("Civ ragdoll was not created: ", civ, rag)
		return
	end
	
	for i=1, rag:GetPhysicsObjectCount() do
		if IsValid(rag:GetPhysicsObjectNum(i)) then
			rag:GetPhysicsObjectNum(i):ApplyForceCenter(force/2 or Vector(0,0,0))
		end
	end
	
	timer.Simple(Civs.BodyDisappear, function()
		if rag:IsValid() then
			rag:Remove()
		end
	end)
end)
net.Receive("Civs_PoliceBeacon", function()
	local civ = net.ReadEntity()
	local attacker = net.ReadEntity()
	local pos = net.ReadVector()
	local reason = net.ReadString()
	
	if not (IsValid(civ) and isvector(pos) and IsValid(attacker) and isstring(reason)) then 
		print("Can't create police beacon: ", civ, pos, attacker, reason)
		return 
	end
	
	civ:PoliceBeacon(pos,attacker,reason)
	
end)

concommand.Add("civs_animlist", function(p,c,a)
	
	local ent = LocalPlayer():GetEyeTrace().Entity
	if ent:IsValid() and ent:IsRagdoll() then
		local anims = ent:GetSequenceList()
		
		local frame = vgui.Create("DFrame")
			frame:ParentToHUD()
			frame:SetTitle("Civs Anim Viewer")
			frame:SetSize(800,500)
			frame:Center()
			frame:MakePopup()
		
		local list
		local search = vgui.Create("DTextEntry",frame)
			search:Dock(TOP)
			search:SetText("Search...")
			function search:OnGetFocus()
				self:SelectAll()
			end
			function search:OnEnter()
				list:Update( string.lower(self:GetValue()) )
			end
			
		local dmodel = vgui.Create("DModelPanel",frame)
			dmodel:SetModel(ent:GetModel())
			dmodel:Dock(RIGHT)
			dmodel:SetWide(400)
			dmodel:SetAnimated(true)
			local PrevMins, PrevMaxs = dmodel.Entity:GetRenderBounds()
			dmodel:SetLookAt((PrevMaxs + PrevMins) / 2)
			dmodel:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.5, 0.5, 0.5) - (dmodel:GetLookAt()-dmodel:GetCamPos()):GetNormal()*10)
			dmodel.Angles = Angle( 0, 0, 0 )
		
		list = vgui.Create("DListView",frame)
			list:Dock(LEFT)
			list:SetWide(400)
			list:AddColumn("Index:"):SetFixedWidth(60)
			list:AddColumn("Anim Name:")
			list:AddColumn("Info:")
			list:SetMultiSelect(false)
			
			function list:Update( searchtext )
				self:Clear()
				for k,v in SortedPairs(anims) do
					if isstring(searchtext) and searchtext != "" then
						if v:match(searchtext) then
							self:AddLine(k,v, dmodel.Entity:GetSequenceActivityName( dmodel.Entity:LookupSequence( v ) )) 
						end
					else
						self:AddLine(k,v, dmodel.Entity:GetSequenceActivityName( dmodel.Entity:LookupSequence( v ) )) 
					end
				end
			end
			list:Update()
			
			function list:OnRowSelected(index, row)
				local val = row:GetValue(2)
				dmodel:SetModel(dmodel:GetModel())
				dmodel.Entity:ResetSequenceInfo()
				dmodel.Entity:ResetSequence(val)
			end
			
			function dmodel:OnMouseWheeled(delta)
				dmodel:SetCamPos(dmodel:GetCamPos() + (dmodel:GetLookAt()-dmodel:GetCamPos()):GetNormal()*delta*2)
			end
			
			function dmodel:DragMousePress()
				self.PressX, self.PressY = gui.MousePos()
				self.Pressed = true
			end

			function dmodel:DragMouseRelease() self.Pressed = false end

			function dmodel:LayoutEntity( Entity )
				if ( self.bAnimated ) then self:RunAnimation() end

				if ( self.Pressed ) then
					local mx, my = gui.MousePos()
					self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )
					
					self.PressX, self.PressY = gui.MousePos()
				end

				Entity:SetAngles( self.Angles )
			end
		
		
	end
	
end)
