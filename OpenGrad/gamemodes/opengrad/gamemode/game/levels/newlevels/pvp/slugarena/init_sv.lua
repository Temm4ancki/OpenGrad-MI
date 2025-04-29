function slugarena.StartRoundSV()
    tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 60 * (1 + math.min(#player.GetAll() / 16,2))

    local players = PlayersInGame()
    for i,ply in pairs(players) do ply:SetTeam(1) end

    local aviable = ReadDataMap("slugarena")
    aviable = #aviable ~= 0 and aviable or homicide.Spawns()
    tdm.SpawnCommand(team.GetPlayers(1),aviable,function(ply)
        ply:Freeze(true)
    end)

    freezing = true

    RTV_CountRound = RTV_CountRound - 1

    roundTimeRespawn = CurTime() + 15

    return {roundTimeStart,roundTime}
end

function slugarena.RoundEndCheck()
    local Alive = 0

    for i,ply in pairs(team.GetPlayers(1)) do
        if ply:Alive() then Alive = Alive + 1 end
    end

    if freezing and roundTimeStart + slugarena.LoadScreenTime < CurTime() then
        freezing = nil

        for i,ply in pairs(team.GetPlayers(1)) do
            ply:Freeze(false)
        end
    end

    /*if roundTimeRespawn < CurTime() then
        roundTimeRespawn = CurTime() + 15

        local aviable = ReadDataMap("slugarena")
        aviable = #aviable ~= 0 and aviable or homicide.Spawns()
        tdm.SpawnCommand(team.GetPlayers(1),aviable,nil,function(ply) if ply:Alive() then return false end end)
    end*/

    if Alive <= 1 then EndRound() return end

end

local models_slug = {
    "models/crusader/rainworld/scug.mdl",
    "models/crusader/rainworld/scugARTI.mdl",
    "models/crusader/rainworld/scugGORM.mdl",
    "models/crusader/rainworld/scugRiv.mdl",
    "models/crusader/rainworld/scugSaint.mdl"
}

function slugarena.EndRound(winner)
	print("End round, win '" .. tostring(winner) .. "'")

    PrintMessage(3,"Победил " .. ("последний..."))
end

function slugarena.PlayerSpawn(ply,teamID)
	ply:SetModel(models_slug[math.random(#models_slug)] or "models/crusader/rainworld/scug.mdl")
    ply:SetPlayerColor(Vector(math.random(55,255)/255,math.random(55,255)/255,math.random(55,255)/255))


    ply:Give("weapon_hands")
    ply:Give("weapon_hg_sperm")
    ply:SetLadderClimbSpeed(100)
end

function slugarena.PlayerInitialSpawn(ply)
    ply:SetTeam(1)
end

function slugarena.PlayerCanJoinTeam(ply,teamID)
	if teamID == 2 or teamID == 3 then ply:ChatPrint("не чето не хочу") return false end

    return true
end

function slugarena.GuiltLogic() return false end

util.AddNetworkString("slugarena die")
function slugarena.PlayerDeath()
    net.Start("slugarena die")
    net.Broadcast()
end