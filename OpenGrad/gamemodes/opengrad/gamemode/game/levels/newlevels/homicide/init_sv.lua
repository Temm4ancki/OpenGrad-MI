local function GetFriends(play)
    local huy = ""
    for i, ply in pairs(homicide.t) do
        if play == ply then continue end
        huy = huy .. ply:GetNWString("FakeName", "Неизвестный") .. ", "
    end

    return huy
end

COMMANDS.homicide_get = {
    function(ply, args)
        if not ply:IsAdmin() then return end

        local role = {{}, {}}
        for i, ply in pairs(team.GetPlayers(1)) do
            if ply.roleT then table.insert(role[1], ply) end
            if ply.roleCT then table.insert(role[2], ply) end
        end

        net.Start("homicide_roleget")
        net.WriteTable(role)
        net.Send(ply)
    end
}

local function makeT(ply)
    if not IsValid(ply) then return end
    ply.roleT = true
    table.insert(homicide.t, ply)
    if homicide.roundType == 1 then
        SpawnEblan(ply, {
            "weapon_m_kabar",
            "weapon_s_hk_usps",
            "weapon_hidebomb",
            "weapon_hg_rgd5",
            "weapon_jahidka",
            "weapon_trap",
            "weapon_jam",
            "weapon_mask",
        })
    elseif homicide.roundType == 2 then
        SpawnEblan(ply, {
            "weapon_m_kabar",
            "weapon_hg_t_syringepoison",
            "weapon_hg_t_vxpoison",
            "weapon_hidebomb",
            "weapon_hg_rgd5",
            "weapon_jahidka",
            "weapon_trap",
            "weapon_jam",
            "weapon_mask",
        })
    elseif homicide.roundType == 3 then
        SpawnEblan(ply, {
            "weapon_m_kabar",
            "weapon_hg_t_syringepoison",
            "weapon_hg_t_vxpoison",
            "weapon_trap",
            "weapon_jam",
            "weapon_mask",
        })
    elseif homicide.roundType == 4 then
        SpawnEblan(ply, {
            "weapon_m_kabar",
            "weapon_hidebomb",
            "weapon_hg_rgd5",
            "weapon_jahidka",
            "weapon_trap",
            "weapon_jam",
            "weapon_mask",
        })
        ply:GiveAmmo(12, 5)
    elseif homicide.roundType == 5 then
        SpawnEblan(ply, {
            "weapon_m_kabar",
            "weapon_hidebomb",
            "weapon_s_hk_usps",
            "weapon_trap",
            "weapon_jam",
            "weapon_mask",
        })
    end

    timer.Simple(5, function() ply.allowFlashlights = true end)
    if #GetFriends(ply) >= 1 then timer.Simple(1, function() AddNotificate(ply, "Ваши товарищи " .. GetFriends(ply)) end) end
end

local function makeCT(ply)
    if not IsValid(ply) then return end
    ply.roleCT = true
    table.insert(homicide.ct, ply)
    if homicide.roundType == 1 then
        SpawnEblan(ply, {
            "weapon_s_remington870"
        })
    elseif homicide.roundType == 2 then
        SpawnEblan(ply, {
            "weapon_s_beretta"
        })
    elseif homicide.roundType == 3 then
        SpawnEblan(ply, {
            "weapon_m_police_bat",
            "weapon_taser"
        })
    elseif homicide.roundType == 4 then
        SpawnEblan(ply, {
            "weapon_s_remington870"
        })
    elseif homicide.roundType == 5 then
        SpawnEblan(ply, {
            "weapon_s_beretta"
        })
    end
end

COMMANDS.russian_roulette = {
    function(ply, args)
        if not ply:IsAdmin() then return end

        for i, plya in pairs(player.GetListByName(args[1]) or {ply}) do
            local wep = plya:Give("weapon_s_deagle", true)
            wep:SetClip1(1)
            wep:RollDrum()
        end
    end
}

function homicide.Spawns()
    local aviable = {}
    for i, ent in pairs(ents.FindByClass("info_player*")) do
        table.insert(aviable, ent:GetPos())
    end

    for i, ent in pairs(ents.FindByClass("info_node*")) do
        table.insert(aviable, ent:GetPos())
    end

    for i, point in pairs(ReadDataMap("spawnpointst")) do
        table.insert(aviable, point)
    end

    for i, point in pairs(ReadDataMap("spawnpointsct")) do
        table.insert(aviable, point)
    end
    return aviable
end

sound.Add({
    name = "police_arrive",
    channel = CHAN_STATIC,
    volume = 1.0,
    level = 80,
    pitch = 100,
    sound = "hg_homicide/police/snd_jack_hmcd_policesiren.ogg"
})

function homicide.StartRoundSV()
    tdm.RemoveItems()
    tdm.DirectOtherTeam(2, 1, 1)

    homicide.police = false
    roundTimeStart = CurTime()
    roundTime = math.max(math.ceil(#player.GetAll() / 2), 1) * 75

    if homicide.roundType == 3 then roundTime = roundTime / 2 end
    roundTimeLoot = 5

    for i, ply in pairs(team.GetPlayers(2)) do
        ply:SetTeam(1)
    end

    homicide.ct = {}
    homicide.t = {}

    local countT = 0
    local countCT = 0

    local aviable = homicide.Spawns()
    tdm.SpawnCommand(PlayersInGame(), aviable, function(ply)
        ply.roleT = false
        ply.roleCT = false
        if homicide.roundType == 4 then
            timer.Simple(0, function()
                ply:Give("weapon_s_deagle")
            end)
        end

        if ply.forceT then
            ply.forceT = nil
            countT = countT + 1
            makeT(ply)
        end

        if ply.forceCT then
            ply.forceCT = nil
            countCT = countCT + 1
            makeCT(ply)
        end
    end)

    local players = PlayersInGame()
    local count = math.max(math.random(1, math.ceil(#players / 16)), 1) - countT
    for i = 1, count do
        local ply = table.Random(players)
        table.RemoveByValue(players, ply)
        makeT(ply)
    end

    local count = math.max(math.random(1, math.ceil(#players / 16)), 1) - countCT
    for i = 1, count do
        local ply = table.Random(players)
        table.RemoveByValue(players, ply)
        makeCT(ply)
    end

    timer.Simple(0, function()
        for i, ply in pairs(homicide.t) do
            if not IsValid(ply) then
                table.remove(homicide.t, i)
                continue
            end

            homicide.SyncRole(ply, 1)
        end

        for i, ply in pairs(homicide.ct) do
            if not IsValid(ply) then
                table.remove(homicide.ct, i)
                continue
            end

            homicide.SyncRole(ply, 2)
        end
    end)

    tdm.CenterInit()
    return {
        roundTimeLoot = roundTimeLoot
    }
end

local aviable = ReadDataMap("spawnpointsct")
COMMANDS.forcepolice = {
    function(ply)
        if not ply:IsAdmin() then return end
        homicide.police = false
        roundTime = 0
    end
}

function homicide.RoundEndCheck()
    tdm.Center()
    local TAlive = tdm.GetCountLive(homicide.t)
    local Alive = tdm.GetCountLive(team.GetPlayers(1), function(ply) if ply.roleT or ply.isContr then return false end end)
    if roundTimeStart + roundTime < CurTime() and not homicide.police then
        homicide.police = true
        if homicide.roundType == 1 then
            PrintMessage(3, "Приехал спецназ.")
        else
            PrintMessage(3, "Приехала полиция.")
        end

        local aviable = ReadDataMap("spawnpointsct")
        local ctPlayers = tdm.GetListMul(player.GetAll(), 1, function(ply) return not ply:Alive() and not ply.roleT and ply:Team() ~= 1002 end)

        local playsound = true
        tdm.SpawnCommand(ctPlayers, aviable, function(ply)
            timer.Simple(0, function()
                if homicide.roundType == 1 then
                    ply:SetPlayerClass("contr")
                else
                    ply:SetPlayerClass("police")
                end

                if playsound then
                    ply:EmitSound("police_arrive")
                    playsound = false
                end
            end)
        end)
    end

    if TAlive == 0 and Alive == 0 then
        EndRound(1)
        return
    end

    if TAlive == 0 then EndRound(2) end
    if Alive == 0 then EndRound(1) end
end

function homicide.EndRound(winner)
    PrintMessage(3, winner == 1 and "Победа предателей." or winner == 2 and "Победа невиновых." or "Ничья")
    if homicide.t and #homicide.t > 0 then
        PrintMessage(3, #homicide.t > 1 and ("Трейторами были: " .. homicide.t[1]:Name() .. homicide.t[1]:GetNWString("FakeName") .. ", " .. GetFriends(homicide.t[1])) or ("Трейтором был: " .. homicide.t[1]:Name()))
    end
end

local empty = {}
function homicide.PlayerSpawn(ply, teamID)
    local teamTbl = homicide[homicide.teamEncoder[teamID]]
    local color = teamID == 1 and Color(math.random(55, 165), math.random(55, 165), math.random(55, 165)) or teamTbl[2]
    if homicide.roundType ~= 1 then
        ply:SetModel(teamTbl.models[math.random(#teamTbl.models)] or "models/player/group01/male_03.mdl")
    else
        ply:SetModel(models_rebels[math.random(#models_rebels)] or "models/player/group03/male_01.mdl")
    end

    local bodygroups = ply:GetBodyGroups()
    for _, group in ipairs(bodygroups) do
        local randomValue = math.random(0, group.num)
        ply:SetBodygroup(group.id, randomValue)
    end

    ply:SetPlayerColor(color:ToVector())
    ply:Give("weapon_hands")
    timer.Simple(0, function() ply.allowFlashlights = true end)
end

function homicide.PlayerInitialSpawn(ply)
    ply:SetTeam(1)
end

function homicide.PlayerCanJoinTeam(ply, teamID)
    --     if ply:IsAdmin() then
    --         if teamID == 2 then ply.forceCT = nil ply.forceT = true ply:ChatPrint("Ты будешь за шерифа некст раунд") return false end
    --         if teamID == 3 then ply.forceT = nil ply.forceCT = true ply:ChatPrint("Ты будешь за предателя некст раунд") return false end
    --     else
    --         if teamID == 2 or teamID == 3 then ply:ChatPrint("Рип бозо") return false end
    --     end
    return true
end

-- yummers
util.AddNetworkString("homicide_roleget")

function homicide.SyncRole(ply, teamID)
    local role = {{}, {}}
    for i, ply in pairs(team.GetPlayers(1)) do
        if teamID ~= 2 and ply.roleT then table.insert(role[1], ply) end
        if teamID ~= 1 and ply.roleCT then table.insert(role[2], ply) end
    end

    net.Start("homicide_roleget")
    net.WriteTable(role)
    net.Send(ply)
end

function homicide.PlayerDeath(ply, inf, att)
    return false
end

local common = {
    "weapon_m_pipe",
    "weapon_m_bat",
    "weapon_m_knife",

    "med_band_big",
    "med_band_small",
    "medkit",
    "blood_bag",
    "med_splint",

    "food_monster",
    "food_lays",
    "food_bleach",
    "food_shaverma",
}

local uncommon = {
    "medkit",
    "painkiller",
    "adrenaline",
    "morphine",

    "weapon_m_crowbar",
    "weapon_m_bat",
    "weapon_m_metalbat",
    "weapon_m_hatchet",

    "weapon_molotok",
}

local rare = {
    "weapon_s_beretta",
    "weapon_s_remington870police",
    "weapon_s_glock",
    "weapon_s_p99",
    "weapon_s_hk_usp",
    "weapon_s_cz75",
    "weapon_s_deserteagle",

    "weapon_m_gurkha",
    "weapon_m_tomahawk",
    "weapon_m_sleagehammer",
    "weapon_m_fireaxe",
    "weapon_m_fubar",

    "weapon_per4ik",

    "*ammo*",
}

function homicide.ShouldSpawnLoot()
    if roundTimeStart + roundTimeLoot - CurTime() > 0 then return false end
    if homicide.roundType ~= 1 then
        local chance = math.random(100)
        if chance < 3 then
            return true, rare[math.random(#rare)], "rare"
        elseif chance < 20 then
            return true, uncommon[math.random(#uncommon)], "uncommon"
        elseif chance < 70 then
            return true, common[math.random(#common)], "common"
        else
            return false
        end
    else
        return true
    end
end

function homicide.GuiltLogic(ply, att, dmgInfo)
    return ply.roleT == att.roleT
end