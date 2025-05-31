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
	weapons = {"weapon_binokle", "weapon_radio", "weapon_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
	main_weapon = {"weapon_aks74u", "weapon_akm", "weapon_remington870", "weapon_galil", "weapon_rpk", "weapon_asval", "weapon_p90-2"},
	secondary_weapon = {"weapon_cz75", "weapon_deagle", "weapon_glock"},
	models = models
}

tdm.blue = {
	"Rebels",
	Color(245, 255, 99),
	weapons = {"weapon_binokle", "weapon_radio", "weapon_hands", "weapon_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_handcuffs", "weapon_taser"},
	main_weapon = {"weapon_hk416-2", "weapon_m4a1", "weapon_m4super-2", "weapon_mp7", "weapon_xm1014", "weapon_l85a1", "weapon_asval", "weapon_m249", "weapon_p90-2"},
	secondary_weapon = {"weapon_beretta", "weapon_p99", "weapon_hk_usp"},
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