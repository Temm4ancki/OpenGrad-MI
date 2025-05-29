table.insert(LevelList, "schoolshoot")
schoolshoot = {}
schoolshoot.Name = "School Shooter"

local models = {}
for i = 1, 9 do
    table.insert(models, "models/player/group01/male_0" .. i .. ".mdl")
end

for i = 1, 6 do
    table.insert(models, "models/player/group01/female_0" .. i .. ".mdl")
end

schoolshoot.red = {
    "Кибер-спортсмен",
    Color(255, 98, 98),
    weapons = {"weapon_radio", "weapon_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
    main_weapon = {"weapon_m4super-2", "weapon_remington870", "weapon_xm1014"},
    secondary_weapon = {"weapon_cz75-2", "weapon_deagle", "weapon_glock"},
    models = models
}

schoolshoot.green = {
    "Школьник",
    Color(55, 255, 55),
    weapons = {"weapon_hands"},
    models = models
}

schoolshoot.blue = {
    "Спецназ",
    Color(55, 55, 255),
    weapons = {"weapon_radio", "weapon_hands", "weapon_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_hg_f1", "weapon_handcuffs", "weapon_taser", "weapon_hg_flashbang"},
    main_weapon = {"weapon_hk416-2", "weapon_m4a1", "weapon_m4super-2", "weapon_mp7", "weapon_xm1014", "weapon_l85a1", "weapon_asval", "weapon_m249", "weapon_mp5a3", "weapon_p90-2"},
    secondary_weapon = {"weapon_beretta", "weapon_p99", "weapon_hk_usp"},
    models = models
}

schoolshoot.teamEncoder = {
    [1] = "red",
    [2] = "green",
    [3] = "blue"
}

function schoolshoot.StartRound(data)
    team.SetColor(1, schoolshoot.red[2])
    team.SetColor(2, schoolshoot.green[2])
    team.SetColor(3, schoolshoot.blue[2])
    game.CleanUpMap(false)
    if CLIENT then
        roundTimeLoot = data.roundTimeLoot
        schoolshoot.StartRoundCL()
        return
    end
    return schoolshoot.StartRoundSV()
end

schoolshoot.SupportCenter = true