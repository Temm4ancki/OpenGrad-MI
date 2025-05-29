table.insert(LevelList,"hl2dmreal")
hl2dmreal = {}
hl2dmreal.Name = "ABSOLUTE KINO Half-Life 2: Deathmatch"

local models = {}
for i = 1,9 do table.insert(models,"models/player/group03/male_0" .. i .. ".mdl") end

hl2dmreal.red = {"Повстанец",Color(125,95,60),
	weapons = {"weapon_hands","med_band_big","med_band_small","weapon_radio"},
	main_weapon = {"weapon_sar2","weapon_remington870","weapon_akm","weapon_mp7"},
	secondary_weapon = {"weapon_p228","weapon_cz75-2"},
	models = models
}


hl2dmreal.blue = {"Комбайн",Color(75,75,125),
	weapons = {"weapon_hands"},
	main_weapon = {"weapon_sar2","weapon_mp7"},
	secondary_weapon = {"weapon_hk_usp"},
	models = ""
}

hl2dmreal.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function hl2dmreal.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,hl2dmreal.red[2])
	team.SetColor(2,hl2dmreal.blue[2])

	if CLIENT then

		hl2dmreal.StartRoundCL()
		return
	end

	hl2dmreal.StartRoundSV()
end
hl2dmreal.RoundRandomDefalut = 2
hl2dmreal.SupportCenter = true
