table.insert(LevelList,"css")
css = {}
css.Name = "Контер Стрике Сурс: Гомд едитион"

css.red = {"КОНТЕРЫ",Color(53,53,179),
	weapons = {"weapon_binokle","weapon_radio","weapon_hands","weapon_kabar","med_band_big","med_band_small","medkit","painkiller","weapon_handcuffs","weapon_taser"},
	main_weapon = {"weapon_mk18","weapon_m4a1","weapon_m3super","weapon_mp7","weapon_xm1014","weapon_fal","weapon_galilsar","weapon_m249","weapon_mp40"},
	secondary_weapon = {"weapon_beretta","weapon_fiveseven","weapon_hk_usp"},
	models = {"models/player/riot.mdl","models/player/swat.mdl","models/player/urban.mdl","models/player/gasmask.mdl"}
}


css.blue = {"ТЕРЫ",Color(161,121,61),
	weapons = {"weapon_binokle","weapon_radio","weapon_gurkha","weapon_hands","med_band_big","med_band_small","medkit","painkiller"},
	main_weapon = {"weapon_ak74u","weapon_akm","weapon_remington870","weapon_galil","weapon_rpk","weapon_galilsar","weapon_mp40"},
	secondary_weapon = {"weapon_p220","weapon_deagle","weapon_glock"},
	models = {"models/player/charple.mdl","models/player/leet.mdl","models/player/phoenix.mdl","models/player/guerilla.mdl","models/player/arctic.mdl"}
}

css.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function css.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,css.red[2])
	team.SetColor(2,css.blue[2])

	if CLIENT then

		css.StartRoundCL()
		return
	end

	css.StartRoundSV()
end

css.SupportCenter = true

css.NoSelectRandom = false