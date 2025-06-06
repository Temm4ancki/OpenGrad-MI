--CP от слова чайлд порн, очевидно. 
--TODO А ты почини сначала его блять @temm4ancki

--table.insert(LevelList,"cp") 
cp = {}
cp.Name = "Захват точек"
cp.points = {}

cp.WinPoints = cp.WinPoints or {}
cp.WinPoints[1] = cp.WinPoints[1] or 0
cp.WinPoints[2] = cp.WinPoints[2] or 0

local models = {}

for i = 1, 9 do
    table.insert(models, "models/player/group01/male_0" .. i .. ".mdl")
end

for i = 1, 6 do
    table.insert(models, "models/player/group01/female_0" .. i .. ".mdl")
end

local red, blue, gray = Color(255, 75, 75), Color(75, 75, 255), Color(200, 200, 200)
cp.red = {
    "Красные",
    Color(255, 75, 75),
    weapons = {"weapon_binokle", "weapon_hg_flashbang", "weapon_radio", "weapon_m_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
    main_weapon = {"weapon_s_ak74u", "weapon_s_akm", "weapon_s_remington870", "weapon_s_galil", "weapon_s_rpk", "weapon_s_asval", "weapon_s_p90"},
    secondary_weapon = {"weapon_s_cz75", "weapon_s_deagle", "weapon_s_glock"},
    models = models
}

cp.blue = {
    "Синие",
    Color(75, 75, 255),
    weapons = {"weapon_binokle", "weapon_hg_flashbang", "weapon_radio", "weapon_hands", "weapon_m_kabar", "med_band_big", "med_band_small", "medkit", "painkiller", "weapon_handcuffs", "weapon_taser"},
    main_weapon = {"weapon_s_hk416", "weapon_s_m4a1", "weapon_s_m4super", "weapon_s_mp7", "weapon_s_m4super", "weapon_s_l85a1", "weapon_s_asval", "weapon_s_m249", "weapon_s_p90"},
    secondary_weapon = {"weapon_s_beretta", "weapon_s_p99", "weapon_s_hk_usp"},
    models = models
}

cp.teamEncoder = {
    [1] = "red",
    [2] = "blue"
}

cp.RoundRandomDefalut = 1
function cp.StartRound()
    game.CleanUpMap(false)

    cp.points = {}
    cp.LastWave = CurTime()

    cp.WinPoints = {}
    cp.WinPoints[1] = 0
    cp.WinPoints[2] = 0

    team.SetColor(1, red)
    team.SetColor(2, blue)

    for i, point in pairs(SpawnPointsList.controlpoint[3]) do
        SetGlobalInt(i .. "PointProgress", 0)
        SetGlobalInt(i .. "PointCapture", 0)
        cp.points[i] = {}
    end

    SetGlobalInt("CP_respawntime", CurTime())

    if CLIENT then return end
    timer.Create("CP_ThinkAboutPoints", 1, 0, function()
        --подумай о точках... засунул в таймер для оптимизации, ибо там каждый тик игроки в сфере подглядываются, ну и в целом для удобства
        cp.PointsThink()
    end)

    cp.StartRoundSV()
end

--тот кто это кодил нужно убить нахуй
cp.SupportCenter = true