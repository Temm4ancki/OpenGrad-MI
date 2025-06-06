table.insert(LevelList, "tdm")

tdm = {}
tdm.Name = "Rebels vs Повстанцы"

local models = {}
for i = 1, 9 do
	table.insert(models, "models/player/group01/male_0" .. i .. ".mdl")
end

for i = 1, 6 do
	table.insert(models, "models/player/group01/female_0" .. i .. ".mdl")
end

tdm.models = models
tdm.red = {
	"Повстанцы",
	Color(255, 165, 31),
	weapons = {"weapon_binokle", "weapon_radio", "weapon_m_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
	main_weapon = {"weapon_s_ak74u", "weapon_s_akm", "weapon_s_remington870", "weapon_s_galil", "weapon_s_rpk", "weapon_s_asval", "weapon_s_p90"},
	secondary_weapon = {"weapon_s_cz75", "weapon_s_deagle", "weapon_s_glock"},
	models = models
}

tdm.blue = {
	"Rebels",
	Color(245, 255, 99),
	weapons = {"weapon_binokle", "weapon_radio", "weapon_hands", "weapon_m_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_handcuffs", "weapon_taser"},
	main_weapon = {"weapon_s_hk416", "weapon_s_m4a1", "weapon_s_m4super", "weapon_s_mp7", "weapon_s_m4super", "weapon_s_l85a1", "weapon_s_asval", "weapon_s_m249", "weapon_s_p90"},
	secondary_weapon = {"weapon_s_beretta", "weapon_s_p99", "weapon_s_hk_usp"},
	models = models
}

tdm.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function tdm.StartRound()
	game.CleanUpMap(false)
	team.SetColor(1, red)
	team.SetColor(2, blue)

	if CLIENT then return end
	tdm.StartRoundSV()
end

if SERVER then return end
function tdm.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]
		return team[1], team[2], team[3]
	end
end

function tdm.ChangeValue(oldName, value)
	local oldValue = tdm[oldName]

	if oldValue ~= value then
		oldValue = value
		return true
	end
end

function tdm.AccurceTime(time)
	return string.FormattedTime(time, "%02i:%02i")
end