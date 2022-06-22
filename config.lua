Config = {
    Debug = false, -- Enable to add debug boxes and message.
    img = "lj-inventory/html/images/", -- Set this to your inventory
    RandomLocation = true, -- Set to true if you want random location. False = create for each location a blackmarket
    OpenWithItem = false, -- Is there an item needed to open the blackmarket ?
    ItemName = "blackpass", -- If you set the above function to yes, place here your itemname
	RemoveItem = true,
    ScratchPrice = 3500,
	UseScratchItem = false,
	ScratchItem = "sandpaper",
	RemoveScratchItem = true,
	UseBlackMoney = false,
	BlackMoneyName = "markedbills",
	BlackMoneyMultiplier = 1.2,
}

Config.Weapons = {
	["weapons"] = {
        [1] = { name = "weapon_pistol", price = 14000, amount = 1, scratchprice = 2500 },
		[2] = { name = "weapon_microsmg", price = 850, amount = 1, scratchprice = 2500 },
		[3] = { name = "weapon_appistol", price = 550, amount = 1, scratchprice = 2500 },
	},
}
Config.Locations = {
	["PopSmoke"] = {
		["label"] = "Pop Smoke",
        ["gun"] = "weapon_microsmg",
        ["car"] = `GBurrito2`,
		["model"] = {
			[1] = `s_m_o_busker_01`,
			[2] = `ig_claypain`,
			[3] = `s_m_y_dealer_01`,
			[4] = `ig_lamardavis`,
			[5] = `a_m_m_og_boss_01`,
			[6] = `s_m_y_prismuscl_01`,
			[7] = `ig_ramp_mex`,
		},
		["coords"] = {
			[1] = vector4(768.91, 4178.64, 40.71, 220.54),
			--[2] = vector4(2473.18, 3735.46, 42.37, 159.88),
			--[3] = vector4(-98.72, 6373.75, 31.48, 135.59),
			--[4] = vector4(756.9, -3195.2, 6.07, 84.6),
			},
		["products"] = Config.Weapons["weapons"],
		["hideblip"] = true,
	},
}
