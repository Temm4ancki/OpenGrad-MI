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
    weapons = {"weapon_radio", "weapon_m_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
    main_weapon = {"weapon_s_m4super", "weapon_s_remington870"},
    secondary_weapon = {"weapon_s_cz75", "weapon_s_deagle", "weapon_s_glock"},
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
    weapons = {"weapon_radio", "weapon_hands", "weapon_m_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_hg_f1", "weapon_handcuffs", "weapon_taser", "weapon_hg_flashbang"},
    main_weapon = {"weapon_s_hk416", "weapon_s_m4a1", "weapon_s_m4super", "weapon_s_mp7", "weapon_s_m4super", "weapon_s_l85a1", "weapon_s_asval", "weapon_s_m249", "weapon_s_mp5a3", "weapon_s_p90"},
    secondary_weapon = {"weapon_s_beretta", "weapon_s_p99", "weapon_s_hk_usp"},
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