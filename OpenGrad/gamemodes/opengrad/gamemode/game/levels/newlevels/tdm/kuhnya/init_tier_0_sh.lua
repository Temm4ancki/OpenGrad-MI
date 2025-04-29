table.insert(LevelList,"kuhnya")
kuhnya = {}
kuhnya.Name = "КУХНЯ"

kuhnya.red = {"ОГУЗКИ",Color(255,255,255),
	weapons = {"weapon_hands","med_band_big","med_band_small","weapon_radio"},
	main_weapon = {"weapon_sar2","weapon_spas12","weapon_akm","weapon_mp7"},
	secondary_weapon = {"weapon_hk_usp","weapon_p220"},
	models = {"models/kuhnya/fedya/fedya.mdl","models/kuhnya/senya/senya.mdl","models/kuhnya/oguzok/oguzok.mdl"}
}


kuhnya.blue = {"ШЕФЫ",Color(255,0,0),
	weapons = {"weapon_hands"},
	main_weapon = {"weapon_sar2","weapon_mp7"},
	secondary_weapon = {"weapon_hk_usp"},
	models = {"models/kuhnya/barinov/barinov.mdl"}
}

kuhnya.teamEncoder = {
	[1] = "red",
	[2] = "blue"
}

function kuhnya.StartRound()
	game.CleanUpMap(false)

	team.SetColor(1,kuhnya.red[2])
	team.SetColor(2,kuhnya.blue[2])

	if CLIENT then

		kuhnya.StartRoundCL()
		return
	end

	kuhnya.StartRoundSV()
end
kuhnya.RoundRandomDefalut = 2
kuhnya.SupportCenter = true
