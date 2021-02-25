

AddCSLuaFile()

SWEP.PrintName				= "Navmesh Editing SWEP"
SWEP.Author					= "Bobblehead"
SWEP.Purpose				= "Edit Navmeshes the easy way."
SWEP.Instructions			= "Right click to select a tool. Left click to use the tool. REQUIRES SV_CHEATS 1."

SWEP.Slot					= 2
SWEP.SlotPos				= 1

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= Model( "models/weapons/v_toolgun.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_toolgun.mdl" )
SWEP.ViewModelFOV			= 54
SWEP.UseHands				= false

SWEP.DrawCrosshair			= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.DrawAmmo				= false
SWEP.AdminOnly				= true

if SERVER then
	util.AddNetworkString("nav_editor_mode")
	net.Receive("nav_editor_mode", function(len,ply)
		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and wep:GetClass() == "weapon_nav_editor" then
			local str = net.ReadString()
			if str == "generate" then
				RunConsoleCommand("nav_generate")
			else
				wep:SetMode(str)
				wep.Stage = 1
			end
		end
	end)
end


function SWEP:SetupDataTables()
	self:NetworkVar( "String", 0, "Mode" )
	self:NetworkVar( "Int", 0, "NavEdit" )
end

function SWEP:Initialize()
	
	
	self:SetHoldType( "pistol" )
	self:SetMode("")
	self.Changed = false
	self.Stage = 1
	self:SetNavEdit(GetConVarNumber("nav_edit"))
	self.LastReload = CurTime()
	
end

function SWEP:Deploy()
	self:SetNavEdit(GetConVarNumber("nav_edit"))
	RunConsoleCommand("nav_edit", 1)
	return true
end
function SWEP:Holster()
	RunConsoleCommand("nav_edit", self:GetNavEdit())
	return true
end

function SWEP:PrimaryAttack()
	if game.SinglePlayer() then
		self:CallOnClient("PrimaryAttack")
	end
	self:SetNextPrimaryFire( CurTime() + 0.1 )

	self:EmitSound( Sound("buttons/button16.wav") )
	-- self:EmitSound( Sound("ambient/water/drip"..math.random(1,4)..".wav") )
	self:ShootEffects( self )
	
	if SERVER then
		
		if not (GetConVarNumber("nav_edit") > 0) then self.Owner:PrintMessage(HUD_PRINTTALK,"This SWEP requires 'nav_edit 1'. Run 'nav_edit 1' in the server console to continue.") return end
		if not (GetConVarNumber("sv_cheats") > 0) then self.Owner:PrintMessage(HUD_PRINTTALK,"This SWEP requires 'sv_cheats 1'. Run 'sv_cheats 1' in the server console to continue.") return end
		
		local cmd = self:GetMode()
		
		if cmd == "delete" then
			RunConsoleCommand("nav_delete")
		elseif cmd == "create" then
			if self.Stage == 1 then
				RunConsoleCommand("nav_begin_area")
				self.Stage = 2
			else
				RunConsoleCommand("nav_end_area")
				self.Stage = 1
			end
		elseif cmd == "connect" then
			if self.Stage == 1 then
				RunConsoleCommand("nav_mark")
				self.Stage = 2
			else
				RunConsoleCommand("nav_connect")
				self.Stage = 1
			end
		elseif cmd == "disconnect" then
			if self.Stage == 1 then
				RunConsoleCommand("nav_mark")
				self.Stage = 2
			else
				RunConsoleCommand("nav_disconnect")
				self.Stage = 1
			end
		elseif cmd == "merge" then
			if self.Stage == 1 then
				RunConsoleCommand("nav_mark")
				self.Stage = 2
			else
				RunConsoleCommand("nav_merge")
				self.Stage = 1
			end
		elseif cmd == "splice" then
			if self.Stage == 1 then
				RunConsoleCommand("nav_mark")
				self.Stage = 2
			else
				RunConsoleCommand("nav_splice")
				self.Stage = 1
			end
		elseif cmd == "split" then
			RunConsoleCommand("nav_split")
		elseif cmd == "avoid" then
			RunConsoleCommand("nav_avoid")
		elseif cmd == "subdivide" then
			RunConsoleCommand("nav_subdivide")
		end
		
		
		self.Changed = true
		
	end
end

function SWEP:SecondaryAttack()
	if game.SinglePlayer() then
		self:CallOnClient("SecondaryAttack")
	end
	self:SetNextPrimaryFire( CurTime() + 0.1 )
	
	if CLIENT then
	
		local menu = vgui.Create("DFrame")
			-- menu:ParentToHUD()
			menu:SetSize(305,200)
			menu:Center()
			menu:SetTitle("Select Mode")
			menu:MakePopup()
			function menu.OnClose()
				if game.IsDedicated() then self.Owner:PrintMessage(HUD_PRINTTALK,"You should probably do your navmesh editing in singleplayer to avoid issues. :)") end
				self:EmitSound( Sound("ambient/water/drip"..math.random(1,4)..".wav") )
			end
		
		local List	= vgui.Create( "DIconLayout", menu )
			List:Dock(FILL)
			List:SetSpaceY( 5 ) //Sets the space in between the panels on the X Axis by 5
			List:SetSpaceX( 5 ) //Sets the space in between the panels on the Y Axis by 5

		local delete = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			delete:SetSize( 95, 40 ) //Set the size of it
			delete:SetText("Delete Areas")
			function delete.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("delete")
				net.SendToServer()
				menu:Close()
			end
		
		local create = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			create:SetSize( 95, 40 ) //Set the size of it
			create:SetText("Create Areas")
			function create.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("create")
				net.SendToServer()
				menu:Close()
			end
		
		local connect = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			connect:SetSize( 95, 40 ) //Set the size of it
			connect:SetText("Connect Areas")
			function connect.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("connect")
				net.SendToServer()
				menu:Close()
			end
		
		local disconnect = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			disconnect:SetSize( 95, 40 ) //Set the size of it
			disconnect:SetText("Disconnect Areas")
			function disconnect.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("disconnect")
				net.SendToServer()
				menu:Close()
			end
		
		local merge = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			merge:SetSize( 95, 40 ) //Set the size of it
			merge:SetText("Merge Areas")
			function merge.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("merge")
				net.SendToServer()
				menu:Close()
			end
		
		local splice = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			splice:SetSize( 95, 40 ) //Set the size of it
			splice:SetText("Splice Areas")
			function splice.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("splice")
				net.SendToServer()
				menu:Close()
			end
		
		local split = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			split:SetSize( 95, 40 ) //Set the size of it
			split:SetText("Split Areas")
			function split.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("split")
				net.SendToServer()
				menu:Close()
			end
		
		local subdivide = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			subdivide:SetSize( 95, 40 ) //Set the size of it
			subdivide:SetText("Subdivide Area")
			function subdivide.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("subdivide")
				net.SendToServer()
				menu:Close()
			end
		
		local avoid = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			avoid:SetSize( 95, 40 ) //Set the size of it
			avoid:SetText("Mark as Avoid")
			function avoid.DoClick(s)
				net.Start("nav_editor_mode")
					net.WriteString("avoid")
				net.SendToServer()
				menu:Close()
			end
		
		local help = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			help:SetSize( 145, 30 ) //Set the size of it
			help:SetText("Instructions")
			function help.DoClick(s)
				menu:Close()
				self:ShowHelp()
			end
			
		local generate = List:Add( "DButton" ) //Add DPanel to the DIconLayout
			generate:SetSize( 145, 30 ) //Set the size of it
			generate:SetText("Generate Navmesh")
			function generate.DoClick(s)
				Derma_Query("This will take a long time and reload the map. Are you sure?","Generate Navmesh","Generate",function()
					RunConsoleCommand("showconsole")
					net.Start("nav_editor_mode")
						net.WriteString("generate")
					net.SendToServer()
					menu:Close()
				end,
				"Cancel",
				function()
				end
				)
			end
		
		
	end
	
	
end

function SWEP:DrawHUD()
	draw.WordBox( 8, ScrW()/2 - 101, ScrH()-160, "Left click to run a command.", "ChatFont", Color(0,0,0,150), Color(255,255,255) )
	draw.WordBox( 8, ScrW()/2-115, ScrH()-129, "Right click to change commands.", "ChatFont", Color(0,0,0,150), Color(255,255,255) )
	draw.WordBox( 8, ScrW()/2-58, ScrH()-98, "Reload to save.", "ChatFont", Color(0,0,0,150), Color(255,255,255) )
	draw.WordBox( 8, ScrW()/2-85, ScrH()-67, "Requires 'sv_cheats 1'.", "ChatFont", Color(0,0,0,150), Color(255,255,255) )
end

function SWEP:ShowHelp()
	
	local menu = vgui.Create("DFrame")
		-- menu:ParentToHUD()
		menu:SetSize(600,400)
		menu:Center()
		menu:SetTitle("Navmesh Help")
		menu:MakePopup()
		function menu.OnClose()
			self:SecondaryAttack()
		end
	
	local lbl = vgui.Create("DLabel", menu)
		lbl:SetText("Loading...")
		lbl:SizeToContents()
		lbl:Center()
	
	local utube = vgui.Create("DHTML", menu)
		utube:Dock(FILL)
		utube:SetHTML([[<iframe width="573" height="350" src="https://www.youtube.com/embed/OB7gRmB-nGw" frameborder="0" allowfullscreen></iframe>]])
	
	
end

function SWEP:Reload()
	if IsFirstTimePredicted() then
		if self.LastReload < CurTime() - 2 then
			if CLIENT then
				RunConsoleCommand("showconsole")
			end
			if self.Changed then
				RunConsoleCommand("nav_analyze")
			else
				RunConsoleCommand("nav_save")
			end
			self.LastReload = CurTime()
		end
	end
end

if SERVER then
	hook.Add("InitPostEntity","nav_editing_0", function()
		RunConsoleCommand("nav_edit", 0)
	end)
end
