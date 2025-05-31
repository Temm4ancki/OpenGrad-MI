table.insert(LevelList, "wick")
wick = wick or {}
wick.Name = "John Wick"

local models = {}
for i = 1, 9 do table.insert(models, "models/player/group01/male_0" .. i .. ".mdl") end
for i = 1, 6 do table.insert(models, "models/player/group01/female_0" .. i .. ".mdl") end

wick.red = {"John Wick", Color(255, 98, 98),
    weapons = {"weapon_radio", "weapon_gurkha", "weapon_hands", "med_band_big", "med_band_small", "medkit", "painkiller"},
    main_weapon = {"weapon_hk416-2", "weapon_m4a1"},
    secondary_weapon = {"weapon_hk_usp", "weapon_cz75"},
    models = models
}

wick.green = {"Наемник", Color(125, 125, 125),
    weapons = {"weapon_radio", "weapon_hands", "weapon_gurkha"},
    main_weapon = {"weapon_mp5a3", "weapon_mp7", "weapon_p90-2"},
    secondary_weapon = {"weapon_hk_usp", "weapon_beretta"},
    models = models
}

wick.teamEncoder = {
    [1] = "green"
}

local playsound = false
if SERVER then
    util.AddNetworkString("roundType2")
else
    net.Receive("roundType2",function(len)
        playsound = true
    end)
end

function wick.StartRound(data)
    team.SetColor(1, wick.green[2])

    game.CleanUpMap(false)

    if SERVER then
        net.Start("roundType2")
        net.Broadcast()
    end

    if CLIENT then
        if data and data.roundTimeLoot then
            roundTimeLoot = data.roundTimeLoot
        end
        wick.StartRoundCL()
        return
    end

    return wick.StartRoundSV()
end

if SERVER then return end

local red = Color(200, 0, 10)
local blue = Color(75, 75, 255)
local gray = Color(122, 122, 122, 255)
local black = Color(0, 0, 0, 255)

function wick.GetTeamName(ply)
    if ply.roleT then
        return "John Wick", red
    end

    local teamID = ply:Team()
    if teamID == 1 then
        return "Наемник", ScoreboardSpec
    end

    return "Неизвестно", ScoreboardSpec or Color(255, 255, 255)
end

net.Receive("homicide_roleget2", function()
    for i, ply in ipairs(player.GetAll()) do
        ply.roleT = nil
    end

    local role = net.ReadTable()

    for i, ply in pairs(role[1]) do
        ply.roleT = true
    end
end)


