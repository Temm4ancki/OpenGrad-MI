function wick.StartRoundSV(data)
    tdm.RemoveItems()
    tdm.DirectOtherTeam(1, 1)

    roundTimeStart = CurTime()
    roundTime = math.max(math.ceil(#player.GetAll() / 2.5), 1) * 60
    roundTimeLoot = 5

    for _, ply in ipairs(player.GetAll()) do
        ply:SetTeam(1)
        ply.roleT = false
        ply.nopain = false
    end
    wick.t = {}

    local aviableNaem = wick.SpawnsCT()
    local aviableWick = wick.SpawnsT()

    local players = player.GetAll()

    local count = 1
    local selectedPlayers = {}

    for i, ply in ipairs(players) do
        if ply.forceT then
            ply.forceT = nil
            table.insert(selectedPlayers, ply)
            count = count - 1
            if count <= 0 then
                break
            end
        end
    end

    if count > 0 then
        local availablePlayers = {}
        for i, ply in ipairs(players) do
            if not table.HasValue(selectedPlayers, ply) and not ply.forceCT then
                table.insert(availablePlayers, ply)
            end
        end

        while count > 0 and #availablePlayers > 0 do
            local randIndex = math.random(#availablePlayers)
            table.insert(selectedPlayers, availablePlayers[randIndex])
            table.remove(availablePlayers, randIndex)
            count = count - 1
        end
    end

    for i, ply in ipairs(selectedPlayers) do
        wick.makeT(ply)
    end

    wick.SyncRole()

    local naemniki = {}
    for i, ply in ipairs(player.GetAll()) do
        if not ply.roleT then
            table.insert(naemniki, ply)
        end
    end

    tdm.SpawnCommand(naemniki, aviableNaem, function(ply)
        ply:Give("weapon_gurkha")
        local wep = ply:Give("weapon_hk_usp")
        if IsValid(wep) then
            wep:SetClip1(wep:GetMaxClip1())
            ply:GiveAmmo(2 * wep:GetMaxClip1(), wep:GetPrimaryAmmoType())
        end
    end)

    tdm.SpawnCommand(wick.t, aviableWick)

    tdm.CenterInit()
    return {roundTimeLoot = roundTimeLoot}
end

function GetTeamPlayersSafe(teamID)
    local players = team.GetPlayers(teamID)
    return istable(players) and players or {}
end

function wick.makeT(ply)
    ply.roleT = true
    table.insert(wick.t, ply)

    ply:Give("weapon_kabar")
    local wep = ply:Give("weapon_hk_usp")
    wep:SetClip1(wep:GetMaxClip1())
    ply:GiveAmmo(6 * wep:GetMaxClip1(), wep:GetPrimaryAmmoType())

    ply:Give("weapon_hg_rgd5")
    ply:Give("weapon_hg_flashbang")

    ply:Give("food_monster")
    ply:Give("med_band_big")
    ply:Give("medkit")
    ply:Give("med_band_small")
    ply:Give("adrenaline")

    local wep = ply:Give("weapon_mk18")
    wep:SetClip1(wep:GetMaxClip1())
    ply:GiveAmmo(2 * wep:GetMaxClip1(), wep:GetPrimaryAmmoType())

    ply.nopain = true

    local playerCount = #player.GetAll()
    local healthMultiplier = math.Clamp(playerCount * 100, 300, 2000) * 0.75
    healthMultiplier = math.Round(healthMultiplier)
    timer.Simple(0.1, function()
        if IsValid(ply) then
            ply:SetMaxHealth(healthMultiplier)
            ply:SetHealth(healthMultiplier)
            ply:ChatPrint("Ваше здоровье: " .. healthMultiplier)
        end
    end)

    ply:ChatPrint("Вы Джон Уик.")
end

-- хук для обработки болевого урона
-- hook.Add("SetPlayerAnimation", "WickNoPainAnimation", function(ply, animation)
--     if ply.nopain and (animation == PLAYER_RELOAD or animation == PLAYER_SUPERJUMP or animation == PLAYER_ATTACK1) then
--         return true
--     end
-- end)

-- хук для предотвращения падения от боли
--hook.Add("OnPlayerHitGround", "WickNoPainFalling", function(ply, inWater, onFloater, speed)
    --if ply.nopain then
        --return true
    --end
--end)

hook.Add("PlayerHurt", "WickNoPainHurt", function(victim, attacker, healthRemaining, damageTaken)
    if victim.nopain then
        victim:StopSound("physics/body/body_medium_impact_hard1.wav")
        victim:StopSound("physics/body/body_medium_impact_hard2.wav")
        victim:StopSound("physics/body/body_medium_impact_hard3.wav")
        victim:StopSound("physics/body/body_medium_impact_hard4.wav")
        victim:StopSound("physics/body/body_medium_impact_hard5.wav")
        victim:StopSound("physics/body/body_medium_impact_hard6.wav")

        timer.Simple(0, function()
            if IsValid(victim) and victim:Alive() then
                victim:SetLocalVelocity(Vector(0, 0, 0))
            end
        end)
    end
end)

COMMANDS.nopain = {function(ply, args)
    if ply:IsAdmin() then
        local target = ply
        if args[2] then
            target = FindPlayerByName(args[2])
            if not IsValid(target) then return end
        end
        target.nopain = tobool(args[1])
        ply:ChatPrint(target:Nick() .. (target.nopain and " теперь не чувствует боли" or " снова чувствует боль"))
    end
end}

function wick.SpawnsCT()
    local aviable = {}

    for i, point in pairs(ReadDataMap("spawnpointsnaem")) do
        table.insert(aviable, point)
    end

     if #aviable == 0 then
        for i, point in pairs(ReadDataMap("spawnpointst")) do
            table.insert(aviable, point)
        end
    end

    return aviable
end

function wick.SpawnsT()
    local aviable = {}

    for i, point in pairs(ReadDataMap("spawnpointswick")) do
        table.insert(aviable, point)
    end

    if #aviable == 0 then
        for i, point in pairs(ReadDataMap("spawnpointsct")) do
            table.insert(aviable, point)
        end
    end

    return aviable
end

function wick.RoundEndCheck()
    tdm.Center()

    local TAlive = tdm.GetCountLive(type(wick.t) == "table" and wick.t or {})

    local naemniki = {}
    for i, ply in ipairs(player.GetAll()) do
        if not ply.roleT and ply:Team() == 1 then
            table.insert(naemniki, ply)
        end
    end
    local CTAlive = tdm.GetCountLive(naemniki)

    if roundTimeStart + roundTime < CurTime() then
        EndRound(1)
        return
    end

    if TAlive == 0 and CTAlive == 0 then
        EndRound()
        return
    end

    if TAlive == 0 then
        EndRound(2)
        return
    end

    if CTAlive == 0 then
        EndRound(1)
        return
    end
end

function wick.EndRound(winner)
    local winText = winner == 1 and "Победа Джона Уика." or winner == 2 and "Победа наемников." or "Ничья"
    PrintMessage(3, winText)
end

function wick.PlayerSpawn(ply, teamID)
    local teamTbl = wick[wick.teamEncoder[teamID]]
    local color = teamID == 1 and Color(math.random(55, 165), math.random(55, 165), math.random(55, 165)) or teamTbl[2]

    ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
    ply:SetPlayerColor(color:ToVector())

    if ply.roleT then
        local color = Color(75, 75, 75, 0)

        JMod.EZ_Equip_Armor(ply, "Medium-Helmet", color)
        JMod.EZ_Equip_Armor(ply, "Medium-Vest", color)

        JMod.EZ_Equip_Armor(ply, "Light-Right-Shoulder", color)
        JMod.EZ_Equip_Armor(ply, "Light-Left-Shoulder", color)
        JMod.EZ_Equip_Armor(ply, "BallisticMask", color)

        local color = teamTbl[2]
        ply:SetModel(teamTbl.models[math.random(#teamTbl.models)])
        ply:SetPlayerColor(color:ToVector())

        ply.nopain = true

        timer.Simple(0.1, function()
            if IsValid(ply) then
                local playerCount = #player.GetAll()
                local healthMultiplier = math.Clamp(playerCount * 100, 300, 2000) * 0.75
                healthMultiplier = math.Round(healthMultiplier)
                ply:SetMaxHealth(healthMultiplier)
                ply:SetHealth(healthMultiplier)
            end
        end)
    end

    ply:Give("weapon_hands")
    timer.Simple(0, function()
        if IsValid(ply) then
            ply.allowFlashlights = false
        end
    end)
end

function wick.PlayerInitialSpawn(ply)
    ply:SetTeam(1)
end

function wick.PlayerCanJoinTeam(ply, teamID)
    if teamID == 2 or teamID == 3 then
        return false
    end
    -- откуда ты вообще скопировал весь тот код который адмемам позволяет спавниться, при условии что я вырезал эту функцию
    -- С ланограда @Temm4ancki
    return true
end

util.AddNetworkString("homicide_roleget2")

function wick.SyncRole()
    local role = {{}, {}}

    for _, ply in ipairs(player.GetAll()) do
        if ply.roleT then
            table.insert(role[1], ply)
        end
    end

    net.Start("homicide_roleget2")
    net.WriteTable(role)
    net.Broadcast()
end

function wick.PlayerDeath(ply, inf, att)
    return false
end

function wick.ShouldSpawnLoot()
    return false
end

function wick.GuiltLogic(ply, att, dmgInfo)
    if not IsValid(ply) or not IsValid(att) then return 0 end

    if (ply.roleT and att.roleT) or (not ply.roleT and not att.roleT) then
        return dmgInfo:GetDamage() * 3
    end

    return 0
end

function wick.NoSelectRandom()
    local wickPoints = #ReadDataMap("spawnpointswick")
    local standardCTPoints = #ReadDataMap("spawnpointsct")

    return wickPoints < 1 and standardCTPoints < 1
end
