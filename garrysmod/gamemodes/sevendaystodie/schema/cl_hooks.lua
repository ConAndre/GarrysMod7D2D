
-- Here is where all of your clientside hooks should go.

-- Disables the crosshair permanently.
function Schema:CharacterLoaded(character)
	self:ExampleFunction("@serverWelcome", character:GetName())
end

local tab = {
    ["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = -.055,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = .3,
	["$pp_colour_mulr"] = .3,
	["$pp_colour_mulg"] = .55,
	["$pp_colour_mulb"] = 0.25
}

hook.Add("RenderScreenspaceEffects", "NationalGuard_ScreenEffects", function()
	DrawColorModify( tab )
end)
