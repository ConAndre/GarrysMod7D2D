function GM:CanPlayerSuicide( ply )
    ply:ChatPrint("You killed yourself!")
    return true
end

function GM:AllowPlayerPickup(client, entity)
	return true
end

function GM:PlayerLoadout(client)
	if (client.ixSkipLoadout) then
		client.ixSkipLoadout = nil

		return
	end

	client:SetWeaponColor(Vector(client:GetInfo("cl_weaponcolor")))
	client:StripWeapons()
	client:StripAmmo()
	client:SetLocalVar("blur", nil)

	local character = client:GetCharacter()

	-- Check if they have loaded a character.
	if (character) then
		client:SetupHands()
		-- Set their player model to the character's model.
		client:SetModel(character:GetModel())
		--client:Give("ix_hands_")
		client:Give("weapon_physgun")
		--client:Give("weapon_crossbow")
		client:SetWalkSpeed(ix.config.Get("walkSpeed"))
		client:SetRunSpeed(ix.config.Get("runSpeed"))
		client:SetHealth(character:GetData("health", client:GetMaxHealth()))

		local faction = ix.faction.indices[client:Team()]

		if (faction) then
			-- If their faction wants to do something when the player spawns, let it.
			if (faction.OnSpawn) then
				faction:OnSpawn(client)
			end

			-- @todo add docs for player:Give() failing if player already has weapon - which means if a player is given a weapon
			-- here due to the faction weapons table, the weapon's :Give call in the weapon base will fail since the player
			-- will already have it by then. This will cause issues for weapons that have pac data since the parts are applied
			-- only if the weapon returned by :Give() is valid

			-- If the faction has default weapons, give them to the player.
			if (faction.weapons) then
				for _, v in ipairs(faction.weapons) do
					client:Give(v)
				end
			end
		end

		-- Ditto, but for classes.
		local class = ix.class.list[client:GetCharacter():GetClass()]

		if (class) then
			if (class.OnSpawn) then
				class:OnSpawn(client)
			end

			if (class.weapons) then
				for _, v in ipairs(class.weapons) do
					client:Give(v)
				end
			end
		end

		-- Apply any flags as needed.
		ix.flag.OnSpawn(client)
		ix.attributes.Setup(client)

		hook.Run("PostPlayerLoadout", client)

		client:SelectWeapon("weapon_physgun")
	else
		client:SetNoDraw(true)
		client:Lock()
		client:SetNotSolid(true)
	end
end


hook.Add("PlayerDeath", "dropinvondeathh", function(client)
	local items = client:GetCharacter():GetInventory():GetItems()
	if (table.IsEmpty(items)) then
		return
	end

	local entity = ents.Create("ix_deathshipment")
	entity:SetOwner(client)
	entity:Spawn()
	entity:SetPos(client:GetItemDropPos(entity))

	local items = client:GetCharacter():GetInventory():GetItems()
    for k, item in pairs( items ) do
        item:Remove()
    end

end)

-- for k, v in pairs(ents.FindByClass("ix_container")) do v:Remove() end