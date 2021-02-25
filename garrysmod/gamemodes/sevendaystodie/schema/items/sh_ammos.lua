--To add a new item or remove an item, this is the file to do it.

local ITEMS = {}

ITEMS.pistol_ammo = {
	["name"] = "Pistol Ammo",
	["model"] = "models/items/boxsrounds.mdl",
	["description"] = "A box that contains %s of pistol ammo",
	["width"] = 1,
	["height"] = 1,
	["category"] = "Ammunition",
    ["ammo"] = "pistol", -- type of the ammo
    ["ammoAmount"] = 30, -- amount of the ammo
 	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}

ITEMS.smg1_ammo = {
	["name"] = "Smg Ammo",
	["model"] = "models/items/boxsrounds.mdl",
	["description"] = "A box that contains %s of SMG ammo",
	["width"] = 1,
	["height"] = 1,
	["category"] = "Ammunition",
    ["ammo"] = "smg1", -- type of the ammo
    ["ammoAmount"] = 45, -- amount of the ammo
 	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}
ITEMS.m9k_ammo_sniper_rounds = {
	["name"] = "Sniper Ammo",
	["model"] = "models/items/sniper_round_box.mdl",
	["description"] = "A box that contains %s of sniper ammo",
	["width"] = 1,
	["height"] = 1,
	["category"] = "Ammunition",
    ["ammo"] = "SniperPenetratedRound", -- type of the ammo
    ["ammoAmount"] = 10, -- amount of the ammo
 	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}
ITEMS.m9k_ammo_buckshot = {
	["name"] = "Shotgun Ammo",
	["model"] = "models/items/boxbuckshot.mdl",
	["description"] = "A box that contains %s of buckshot ammo",
	["width"] = 1,
	["height"] = 1,
	["category"] = "Ammunition",
    ["ammo"] = "buckshot", -- type of the ammo
    ["ammoAmount"] = 5, -- amount of the ammo
 	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
}





for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, nil, false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = v.category or "unset"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
    ITEM.chance = v.chance or 0
    ITEM.ammo = v.ammo or "pistol"
	ITEM.ammoAmount = v.ammoAmount or "30"
	ITEM.isAmmo = true


    -- ITEM.functions.use = { -- sorry, for name order.
    -- name = "Load",
    -- tip = "useTip",
    -- icon = "icon16/add.png",
    -- OnRun = function(item)
    --     item.player:GiveAmmo(ITEM.ammoAmount, ITEM.ammo)
    --     item.player:EmitSound("items/ammo_pickup.wav", 110)

    --     return true
    -- end,
	-- }

	ITEM.functions.take = {
		tip = "takeTip",
		icon = "icon16/box.png",
		OnRun = function(item)
			local client = item.player
			local bSuccess, error = item:Transfer(client:GetCharacter():GetInventory():GetID(), nil, nil, client)

			if (!bSuccess) then
				client:NotifyLocalized(error or "unknownError")
				return false
			else
				client:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
				item.player:GiveAmmo(ITEM.ammoAmount, ITEM.ammo)
				item.player:EmitSound("items/ammo_pickup.wav", 110)

				if (item.data) then -- I don't like it but, meh...
					for k, v in pairs(item.data) do
						item:SetData(k, v)
					end
				end
			end
			item:Remove()
			return true
		end,
		OnCanRun = function(item)
			return IsValid(item.entity)
		end
	}

    function ITEM:GetDescription()
        return Format(ITEM.description, ITEM.ammoAmount)
    end

end

