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
    
    homicide.SpawnTraitor(ply)

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

function homicide.SpawnMan()
    local available = {}
    for i, ent in pairs(ents.FindByClass("info_player*")) do
        table.insert(available, ent:GetPos())
    end
    return available
end

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

-- Система типов спавна
homicide.SpawnType = homicide.SpawnType or "standard"
homicide.SpawnSettings = homicide.SpawnSettings or {}

SetGlobalString("homicide_spawn_type", homicide.SpawnType)

local SPAWN_TYPES = {
    ["random"] = "Случайный",
    ["standard"] = "Стандартный спавн Хомисайда", 
    ["random_preset"] = "Случайный пресет",
    ["preset_selection"] = "Выбор пресетов",
    ["shop_spawn"] = "Спавн с магазином"
}

function homicide.SetSpawnType(spawnType)
    if SPAWN_TYPES[spawnType] then
        homicide.SpawnType = spawnType
        
        if spawnType == "random" then
            local types = {"standard", "random_preset", "shop_spawn"}
            homicide.SpawnType = table.Random(types)
        end

        SetGlobalString("homicide_spawn_type", homicide.SpawnType)
        
        return true
    end
    return false
end

function homicide.GetSpawnType()
    return homicide.SpawnType
end

function homicide.SpawnTraitor(ply)
    if not IsValid(ply) then return end
    
    local spawnType = homicide.GetSpawnType()
    
    if spawnType == "random_preset" then
        homicide.SpawnTraitorWithRandomPreset(ply)
    elseif spawnType == "preset_selection" then
        homicide.SpawnTraitorWithSelectedPreset(ply)
    elseif spawnType == "shop_spawn" then
        homicide.SpawnTraitorWithShop(ply)
    else
        homicide.SpawnTraitorStandard(ply)
    end
end

function homicide.SpawnTraitorStandard(ply)
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
            "weapon_hg_t_cyanid_capsule",
        })
    elseif homicide.roundType == 2 then
        SpawnEblan(ply, {
            "weapon_m_kabar",
            "weapon_s_hk_usps",
            "weapon_hg_t_syringepoison",
            "weapon_hg_t_vxpoison",
            "weapon_hidebomb",
            "weapon_hg_rgd5",
            "weapon_jahidka",
            "weapon_trap",
            "weapon_jam",
            "weapon_mask",
            "weapon_hg_t_cyanid_capsule",
        })
    elseif homicide.roundType == 3 then
        SpawnEblan(ply, {
            "weapon_m_kabar",
            "weapon_hg_t_syringepoison",
            "weapon_hg_t_vxpoison",
            "weapon_trap",
            "weapon_jam",
            "weapon_mask",
            "weapon_hg_t_cyanid_capsule",
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
            "weapon_hg_t_cyanid_capsule",
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
            "weapon_hg_t_cyanid_capsule",
        })
    end
    
    if HomicideAbilities and HomicideAbilities["ability_classic_traitor"] and HomicideAbilities["ability_classic_traitor"].onPurchase then
        HomicideAbilities["ability_classic_traitor"].onPurchase(ply)
    end
end

function homicide.SpawnTraitorWithRandomPreset(ply)
    if not HomicidePresets then return homicide.SpawnTraitorStandard(ply) end
    
    local presetIds = {}
    for id, _ in pairs(HomicidePresets) do
        table.insert(presetIds, id)
    end
    
    if #presetIds > 0 then
        local randomPreset = table.Random(presetIds)
        homicide.ApplyPresetToPlayer(ply, randomPreset)
    else
        homicide.SpawnTraitorStandard(ply)
    end
end

function homicide.SpawnTraitorWithSelectedPreset(ply)
    homicide.OpenPresetSelectionForTraitor(ply)
end

function homicide.SpawnTraitorWithShop(ply)
    SpawnEblan(ply, {"weapon_hands"})
    ply.TraitorCredits = TRAITOR_SHOP_CONFIG.DEFAULT_CREDITS
    
    net.Start("traitor_shop_credits")
    net.WriteInt(ply.TraitorCredits, 8)
    net.Send(ply)
end

local function GiveWeaponsWithoutEquip(ply, weapons)
    for _, weapon in ipairs(weapons) do
        ply:Give(weapon)
    end
    timer.Simple(0, function()
        if IsValid(ply) then
            ply:SelectWeapon("weapon_hands")
        end
    end)
end

function homicide.ApplyPresetToPlayer(ply, presetId)
    if not HomicidePresets or not HomicidePresets[presetId] then
        return homicide.SpawnTraitorStandard(ply)
    end
    
    local preset = HomicidePresets[presetId]
    
    if preset.weapons then
        GiveWeaponsWithoutEquip(ply, preset.weapons)
    end
    
    if preset.abilities then
        for _, ability in ipairs(preset.abilities) do
            if HomicideAbilities and HomicideAbilities[ability] and HomicideAbilities[ability].onPurchase then
                HomicideAbilities[ability].onPurchase(ply)
            end
        end
    end
    
    ply.SelectedPreset = presetId
end

util.AddNetworkString("homicide_spawn_type")
util.AddNetworkString("homicide_traitor_preset_menu")
util.AddNetworkString("homicide_traitor_preset_select")

net.Receive("homicide_spawn_type", function(len, ply)
    if not IsValid(ply) or not ply:IsAdmin() then return end
    
    local spawnType = net.ReadString()
    homicide.SetSpawnType(spawnType)
    
    local spawnTypeNames = {
        ["random"] = "Случайный",
        ["standard"] = "Стандартный спавн", 
        ["random_preset"] = "Случайный пресет",
        ["preset_selection"] = "Выбор пресетов трейтором",
        ["shop_spawn"] = "Спавн с магазином"
    }
    
    ply:ChatPrint("Тип спавна Homicide установлен: " .. (spawnTypeNames[spawnType] or spawnType))
end)

function homicide.OpenPresetSelectionForTraitor(ply)
    if not IsValid(ply) or not ply.roleT then return end
    if not HomicidePresets then 
        homicide.SpawnTraitorStandard(ply)
        return 
    end
    
    SpawnEblan(ply, {"weapon_hands"})

    timer.Simple(5, function()
        if not IsValid(ply) or not ply.roleT then return end
        
        net.Start("homicide_traitor_preset_menu")
        local presetList = {}
        for id, preset in pairs(HomicidePresets) do
            table.insert(presetList, {
                id = id, 
                name = preset.name,
                description = preset.description,
                model = preset.model,
                weapons = preset.weapons or {},
                abilities = preset.abilities or {}
            })
        end
        net.WriteTable(presetList)
        net.Send(ply)
    end)
end

net.Receive("homicide_traitor_preset_select", function(len, ply)
    if not IsValid(ply) or not ply.roleT then return end
    
    local presetId = net.ReadString()
    
    if HomicidePresets and HomicidePresets[presetId] then
        homicide.ApplyPresetToPlayer(ply, presetId)
        ply:ChatPrint("Выбран пресет: " .. HomicidePresets[presetId].name)
        if HomicidePresets[presetId].name=="Szaleniec" then // мне похуй на костыли
            homicide.maniac = true
        end    
    else
        homicide.SpawnTraitorStandard(ply)
        ply:ChatPrint("Ошибка выбора пресета, применен стандартный набор")
    end
end)

function homicide.StartRoundSV()
    hook.Run("homicide.StartRound")
    
    tdm.RemoveItems()
    tdm.DirectOtherTeam(2, 1, 1)
    
    homicide.maniac = false
    homicide.police = false
    roundTimeStart = CurTime()
    roundTime = math.max(math.ceil(#player.GetAll() / 2), 1) * 70

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
    homicide.SpawnRagdoll()

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

concommand.Add("maniac",function ()
    for _,ply in player.Iterator() do
       ply:EmitSound("hg_homicide/traitor/killer.ogg",45,100,1,CHAN_STATIC)
    end
end)

function homicide.RoundEndCheck()
    tdm.Center()
    local TAlive = tdm.GetCountLive(homicide.t)
    local Alive = tdm.GetCountLive(team.GetPlayers(1), function(ply) if ply.roleT or ply.isContr then return false end end)
    if roundTimeStart + roundTime < CurTime() and not homicide.police then
        homicide.police = true
        if homicide.roundType == 1 or homicide.maniacTemp then
            PrintMessage(3, "Приехал спецназ.")
        else
            PrintMessage(3, "Приехала полиция.")
        end

        local aviable = ReadDataMap("spawnpointsct")
        local ctPlayers = tdm.GetListMul(player.GetAll(), 1, function(ply) return not ply:Alive() and not ply.roleT and ply:Team() ~= 1002 end)

        local playsound = true
        tdm.SpawnCommand(ctPlayers, aviable, function(ply)
            timer.Simple(0, function()
                if homicide.roundType == 1 or homicide.maniacTemp then
                    ply:SetPlayerClass("contr")
                    homicide.maniacTemp = false
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

    if homicide.maniac then
        for _,ply in player.Iterator() do
            if ply.roleT then
                ply:ChatPrint("У меня немного времени до приезда полиции.")
                ply:EmitSound("hg_homicide/traitor/killer.ogg",45,100,1,CHAN_STATIC)
                ply:StripWeapon("weapon_s_deagle") // ковбоифембои
                ply:ScreenFade(SCREENFADE.IN,Color(0,0,0),15,4)
                ply:SetPos(homicide.SpawnMan()[math.random(#homicide.SpawnMan())])
            else 
                ply:ChatPrint("Маньяк потные яички вышел на охоту. \nПродержитесь до приезда полиции.")
                ply:EmitSound("hg_homicide/traitor/survivors.ogg",45,100,1,CHAN_STATIC)
                ply:StripWeapons()
            end
            
        end
        homicide.maniac = false
        homicide.maniacTemp = true
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
        PrintMessage(3, #homicide.t > 1 and ("Трейторами были: " .. homicide.t[1]:Name() .. homicide.t[1]:GetNWString("FakeName") .. ", " .. GetFriends(homicide.t[1])) or ("Трейтором был: " .. homicide.t[1]:GetNWString("FakeName").."("..homicide.t[1]:Name()..")"))
    end
end

function homicide.PlayerSpawn(ply, teamID)
    local color = teamID == 1 and Color(math.random(55, 165), math.random(55, 165), math.random(55, 165)) or teamTbl[2]
    local teamTbl = homicide[homicide.teamEncoder[teamID]]
    if homicide.roundType ~= 1 then
        ply:SetModel(teamTbl.models[math.random(#teamTbl.models)] or "models/player/group01/male_03.mdl")
    else
        ply:SetModel(homicide_rebels_models[math.random(#models_rebels)] or "models/player/group03/male_01.mdl")
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

function homicide.SpawnRagdoll()
    local ent = ents.Create("prop_ragdoll")
    if not IsValid(ent) then return end
    pos = spawns[math.random(#spawns)] + Vector(0,0,0)
    ent:SetModel(homicide_models[math.random(#homicide_models)])
    ent:SetPos(pos) -- spawn position
    ent:Spawn()
    ent:Activate()
    ent.FakeRagdoll = true
end

function homicide.PlayerDeath(ply, inf, att)
    if ply.unfakeable then ply.unfakeable = false end
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