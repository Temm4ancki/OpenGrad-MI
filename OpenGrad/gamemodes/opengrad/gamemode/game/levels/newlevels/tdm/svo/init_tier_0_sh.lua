table.insert(LevelList, "svo")

svo = {}
svo.Name = "SVO"

local models_separ = {
	"models/tdm_svo/citizens/p_female_01.mdl",
	"models/tdm_svo/citizens/p_female_02.mdl",
	"models/tdm_svo/citizens/p_female_04.mdl",
	"models/tdm_svo/citizens/pm_male_01.mdl",
	"models/tdm_svo/citizens/pm_male_01s1.mdl",
	"models/tdm_svo/citizens/pm_male_01s2.mdl",
	"models/tdm_svo/citizens/pm_male_02.mdl",
	"models/tdm_svo/citizens/pm_male_03.mdl",
	"models/tdm_svo/citizens/pm_male_04s1.mdl",
	"models/tdm_svo/citizens/pm_male_05s2.mdl",
	"models/tdm_svo/citizens/pm_male_06s1.mdl",
	"models/tdm_svo/citizens/pm_male_07.mdl",
	"models/tdm_svo/citizens/pm_male_07s1.mdl",
	"models/tdm_svo/citizens/pm_male_07s2.mdl",
	"models/tdm_svo/citizens/pm_male_08.mdl"
}

local models_homig = {
	"models/player/sibresp/rebel/male_02.mdl",
	"models/player/sibresp/rebel/male_04.mdl",
	"models/player/sibresp/rebel/male_05.mdl",
	"models/player/sibresp/rebel/male_06.mdl",
	"models/player/sibresp/rebel/male_07.mdl",
	"models/player/sibresp/rebel/male_08.mdl",
	"models/player/sibresp/rebel/male_09.mdl",
	"models/player/sibresp/rebel/female_01.mdl",
	"models/player/sibresp/rebel/female_02.mdl",
	"models/player/sibresp/rebel/female_04.mdl",
	"models/player/sibresp/rebel/female_06.mdl"
}

svo.red = {
	"Сепаратисты",
	Color(54, 155, 67),
	weapons = {"weapon_binokle", "weapon_radio", "weapon_m_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
	main_weapon = {"weapon_s_ak74u", "weapon_s_akm", "weapon_s_remington870", "weapon_s_galil", "weapon_s_rpk", "weapon_s_asval", "weapon_s_p90"},
	secondary_weapon = {"weapon_s_cz75", "weapon_s_deagle", "weapon_s_glock"},
	models = models_separ
}

svo.blue = {
	"Хомиградеры",
	Color(109, 109, 109),
	weapons = {"weapon_binokle", "weapon_radio", "weapon_hands", "weapon_m_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_handcuffs", "weapon_taser"},
	main_weapon = {"weapon_s_hk416", "weapon_s_m4a1", "weapon_s_m4super", "weapon_s_mp7", "weapon_s_m4super", "weapon_s_l85a1", "weapon_s_asval", "weapon_s_m249", "weapon_s_p90"},
	secondary_weapon = {"weapon_s_beretta", "weapon_s_p99", "weapon_s_hk_usp"},
	models = models_homig
}

svo.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function svo.StartRound()
	game.CleanUpMap(false)
	team.SetColor(1, svo.red[2])
	team.SetColor(2, svo.blue[2])

	if CLIENT then
		svo.StartRoundCL()
		return
	end

	svo.StartRoundSV()
end

svo.SupportCenter = true
svo.NoSelectRandom = false