
-- You can define factions in the factions/ folder. You need to have at least one faction that is the default faction - i.e the
-- faction that will always be available without any whitelists and etc.

FACTION.name = "Citizen"
FACTION.description = "An oppressed group of people forced to wear ridiculous blue jumpsuits."
FACTION.isDefault = true
FACTION.weapons = {"gmod_tool", "weapon_crowbar"} -- Weapons that every member of the faction should start with.

FACTION.isGloballyRecognized = true -- Makes it so that everyone knows the name of the characters in this faction.
FACTION.color = Color(100, 60, 60)

-- You should define a global variable for this faction's index for easy access wherever you need. FACTION.index is
-- automatically set, so you can simply assign the value.

-- Note that the player's team will also have the same value as their current character's faction index. This means you can use
-- client:Team() == FACTION_CITIZEN to compare the faction of the player's current character.
FACTION_CITIZEN = FACTION.index


function FACTION:OnCharacterCreated(client, character)
    character:GiveFlags("ept")
end