table.insert(LevelList, "riot")

riot = {}
riot.Name = "RIOT"

local poli = {}

for i=1,9 do
	table.insert(poli,"models/tdm_riot/londoncop/londoncop_0" ..i.. ".mdl") 
end


riot.red = {
	"Полиция",
	Color(55, 55, 150),
	weapons = {"weapon_hands", "weapon_m_police_bat", "med_band_big", "med_band_small", "weapon_taser", "weapon_handcuffs", "weapon_radio"},
	main_weapon = {"weapon_per4ik", "medkit", "painkiller", "weapon_hg_flashbang", "weapon_per4ik", "medkit", "painkiller", "weapon_s_remington870police"},
	secondary_weapon = {""},
	models = poli
}

local bunt = {
	"models/player/Group01/male_04.mdl",
	"models/player/Group01/male_01.mdl",
	"models/player/Group01/male_02.mdl",
	"models/player/Group01/male_08.mdl",
	"models/player/group02/male_02.mdl",
	"models/player/group02/male_04.mdl",
	"models/player/group02/male_06.mdl",
	"models/player/group02/male_08.mdl"
}

riot.blue = {
	"Бунтующие",
	Color(75, 45, 45),
	weapons = {"weapon_hands", "med_band_small"},
	main_weapon = {"weapon_s_p99", "weapon_molotok", "med_band_big", "med_band_small", "weapon_hg_molotov", "weapon_per4ik", "weapon_molotok", "med_band_big", "med_band_small", "weapon_per4ik"},
	secondary_weapon = {"weapon_m_metalbat", "weapon_m_bat", "weapon_m_pipe"},
	models = homicide.models
}

riot.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function riot.StartRound()
	game.CleanUpMap(false)
	team.SetColor(1, riot.red[2])
	team.SetColor(2, riot.blue[2])

	if CLIENT then
		riot.StartRoundCL()
		return
	end

	riot.StartRoundSV()
end

riot.SupportCenter = true
riot.NoSelectRandom = false