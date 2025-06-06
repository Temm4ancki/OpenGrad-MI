table.insert(LevelList, "css")

css = {}
css.Name = "Couynter-Strike: Source"

css.red = {
	"КОНТЕРЫ",
	Color(53, 53, 179),
	weapons = {"weapon_binokle", "weapon_radio", "weapon_hands", "weapon_m_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_handcuffs", "weapon_taser"},
	main_weapon = {"weapon_s_hk416", "weapon_s_m4a1", "weapon_s_m4super", "weapon_s_mp7", "weapon_s_m4super", "weapon_s_l85a1", "weapon_s_asval", "weapon_s_m249", "weapon_s_p90"},
	secondary_weapon = {"weapon_s_beretta", "weapon_s_p99", "weapon_s_hk_usp"},
	models = {"models/player/riot.mdl", "models/player/swat.mdl", "models/player/urban.mdl", "models/player/gasmask.mdl"}
}

css.blue = {
	"ТЕРЫ",
	Color(161, 121, 61),
	weapons = {"weapon_binokle", "weapon_radio", "weapon_m_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
	main_weapon = {"weapon_s_ak74u", "weapon_s_akm", "weapon_s_remington870", "weapon_s_galil", "weapon_s_rpk", "weapon_s_asval", "weapon_s_p90"},
	secondary_weapon = {"weapon_s_cz75", "weapon_s_deagle", "weapon_s_glock"},
	models = {"models/player/leet.mdl", "models/player/phoenix.mdl", "models/player/guerilla.mdl", "models/player/arctic.mdl"}
}

css.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function css.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1, css.red[2])
	team.SetColor(2, css.blue[2])

	if CLIENT then
		css.StartRoundCL()
		return
	end

	css.StartRoundSV()
	css.GetBombSites()
end

css.SupportCenter = true
css.NoSelectRandom = false