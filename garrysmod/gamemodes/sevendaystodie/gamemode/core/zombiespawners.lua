local zombiespawnersV = {
	Vector(-4591, -2179, 72),	-- 4house town
	Vector(-5195, -2386, 72),	-- 4house town
	Vector(-5464, -3506, 200),	-- 4house town
	Vector(-4584, -3421, 200),	-- 4house town
	Vector(-3669, 2033, 64), 	-- factory
	Vector(-3667, 2302, 64),	-- factory
	Vector(-4028, 2131, 64),	-- factory
	Vector(-4378, 2067, 64),	-- factory
	Vector(-4568, 2061, 64),	-- factory
	Vector(-4966, 2238, 64),	-- factory
	Vector(-4655, 2539, 64),	-- factory
	Vector(-5074, 1650, 64),	-- factory
	Vector(-6239, 6367, 416),	-- tower near spawn
	Vector(2651, 10972, 58),	-- small shack
	Vector(2518, 10983, 58),	-- small shack
	Vector(3169, 8266, 65),		-- gated yard
	Vector(3154, 7959, 65),		-- gated yard
	Vector(5375, 5361, 232),	-- jail
	Vector(5152, 5286, 232),	-- jail
	Vector(4813, 5278, 232),	-- jail
	Vector(5226, 5028, 232),	-- jail
	Vector(4169, 4968, 72),		-- garage door near jail
	Vector(4246, 3986, 72),		-- bar across jail
	Vector(4616, 3779, 200),	-- bar across jail
	Vector(4253, 3810, 200),	-- bar across jail
}





hook.Add( "InitPostEntity", "addthosespawners!", function()

	local c1boss = ents.Create("sent_vj_zss_c1boss_spawner")
	c1boss:SetPos(Vector(5339, 10016, 55) + Vector(0,0,25))
	c1boss:SetAngles(Angle(0,-120,0))
	c1boss:Spawn()

	local c2boss = ents.Create("sent_vj_zss_c2boss_spawner")
	c2boss:SetPos(Vector(5023, -3932, -13) + Vector(0,0,25))
	c2boss:SetAngles(Angle(0,165,0))
	c2boss:Spawn()

	for k, v in pairs(zombiespawnersV) do
		local spawners = ents.Create("sent_vj_zss_zprand_spawner")

		spawners:SetPos(v + Vector(0,0,25))
		spawners:Spawn()
	end
end )