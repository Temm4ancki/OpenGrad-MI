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
	weapons = {"weapon_binokle", "weapon_radio", "weapon_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
	main_weapon = {"weapon_aks74u", "weapon_akm", "weapon_remington870", "weapon_galil", "weapon_rpk", "weapon_asval", "weapon_p90-2"},
	secondary_weapon = {"weapon_cz75", "weapon_deagle", "weapon_glock"},
	models = models_separ
}

svo.blue = {
	"Хомиградеры",
	Color(109, 109, 109),
	weapons = {"weapon_binokle", "weapon_radio", "weapon_hands", "weapon_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_handcuffs", "weapon_taser"},
	main_weapon = {"weapon_hk416-2", "weapon_m4a1", "weapon_m4super-2", "weapon_mp7", "weapon_xm1014", "weapon_l85a1", "weapon_asval", "weapon_m249", "weapon_p90-2"},
	secondary_weapon = {"weapon_beretta", "weapon_p99", "weapon_hk_usp"},
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