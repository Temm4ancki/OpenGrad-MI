table.insert(LevelList, "ghostbusters")

ghostbusters = {}
ghostbusters.Name = "Ghostbusters"

ghostbusters.red = {
	"Искатели",
	Color(200, 255, 117),
	weapons = {"weapon_radio", "weapon_hands"},
	main_weapon = {"weapon_photoapparat"},
	secondary_weapon = {},
	models = {"models/player/riot.mdl"}
}

ghostbusters.blue = {
	"Призраки",
	Color(214, 255, 252),
	weapons = {"weapon_radio", "weapon_hands"},
	main_weapon = {},
	secondary_weapon = {},
	models = {"models/player/riot.mdl"}
}

ghostbusters.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function ghostbusters.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1, ghostbusters.red[2])
	team.SetColor(2, ghostbusters.blue[2])

	if CLIENT then
		ghostbusters.StartRoundCL()
		return
	end

	ghostbusters.StartRoundSV()
end

ghostbusters.SupportCenter = true
ghostbusters.NoSelectRandom = false