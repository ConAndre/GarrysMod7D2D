local ITEMS = {}

ITEMS.m9k_colt1911 = {
    ["name"] = "Colt 1911",
    ["class"] = "m9k_colt1911",
	["model"] = "models/weapons/s_dmgf_co1911.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "sidearm"
}

ITEMS.m9k_remington1858 = {
    ["name"] = "Remington1858",
    ["class"] = "m9k_remington1858",
	["model"] = "models/weapons/w_remington_1858.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "sidearm"
}

ITEMS.m9k_sig_p229r = {
    ["name"] = "P229",
    ["class"] = "m9k_sig_p229r",
	["model"] = "models/weapons/w_sig_229r.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "sidearm"
}

ITEMS.m9k_m29satan = {
    ["name"] = "M29 Satan",
    ["class"] = "m9k_m29satan",
	["model"] = "models/weapons/w_m29_satan.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "sidearm"
}

ITEMS.m9k_mp5sd = {
    ["name"] = "MP5SD",
    ["class"] = "m9k_mp5sd",
	["model"] = "models/weapons/w_hk_mp5sd.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "smg"
}

ITEMS.m9k_honeybadger = {
    ["name"] = "AAC Honey Badger",
    ["class"] = "m9k_honeybadger",
	["model"] = "models/weapons/w_aac_honeybadger.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "smg"
}

ITEMS.m9k_mp40 = {
    ["name"] = "MP40",
    ["class"] = "m9k_mp40",
	["model"] = "models/weapons/w_mp40smg.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "smg"
}
ITEMS.m9k_thompson = {
    ["name"] = "Tommy Gun",
    ["class"] = "m9k_thompson",
	["model"] = "models/weapons/w_tommy_gun.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "smg"
}

ITEMS.m9k_kac_pdw = {
    ["name"] = "KAC PDW",
    ["class"] = "m9k_kac_pdw",
	["model"] = "models/weapons/w_kac_pdw.mdl",
    ["description"] = "A Weapon.",
    ["category"] = "Weapon",
	["width"] = 1,
	["height"] = 1,
    ["chance"] = 20,
    ["weaponCategory"] = "smg"
}

for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, "weaponbase", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
    ITEM.description = v.description
    ITEM.class = v.class or "weapon_357"
	ITEM.category = v.category or "unset"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
    ITEM.chance = v.chance or 0
    ITEM.isWeapon = true
    ITEM.isGrenade = false
    ITEM.weaponCategory = v.weaponCategory
end
