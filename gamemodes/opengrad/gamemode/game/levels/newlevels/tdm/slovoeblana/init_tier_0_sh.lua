table.insert(LevelList,"slovopacana")
slovopacana = {}
slovopacana.Name = "Пизделово Городских"

slovopacana.red = {"Питерский",Color(55,150,98),
	weapons = {"weapon_hands","med_band_small"},
	main_weapon = {"weapon_molotok","med_band_big","med_band_small","weapon_hg_molotov","weapon_per4ik","weapon_molotok","med_band_big","med_band_small","weapon_per4ik"},
	secondary_weapon = {"weapon_hg_metalbat", "weapon_bat","weapon_pipe"},
	models = {"models/player/Group01/male_04.mdl","models/player/Group01/male_01.mdl","models/player/Group01/male_02.mdl","models/player/Group01/male_08.mdl"}
}


slovopacana.blue = {"Москвичевский",Color(45,75,75),
	weapons = {"weapon_hands","med_band_small"},
	main_weapon = {"weapon_molotok","med_band_big","med_band_small","weapon_hg_molotov","weapon_per4ik","weapon_molotok","med_band_big","med_band_small","weapon_per4ik"},
	secondary_weapon = {"weapon_hg_metalbat", "weapon_bat","weapon_pipe"},
	models = {"models/player/Group01/male_04.mdl","models/player/Group01/male_01.mdl","models/player/Group01/male_02.mdl","models/player/Group01/male_08.mdl"}
}

slovopacana.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function slovopacana.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,slovopacana.red[2])
	team.SetColor(2,slovopacana.blue[2])

	if CLIENT then

		slovopacana.StartRoundCL()
		return
	end

	slovopacana.StartRoundSV()
end

slovopacana.SupportCenter = true

slovopacana.NoSelectRandom = false