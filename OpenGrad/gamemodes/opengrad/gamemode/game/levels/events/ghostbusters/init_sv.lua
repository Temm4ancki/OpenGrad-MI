function ghostbusters.StartRoundSV()
	tdm.RemoveItems()
	roundTimeStart = CurTime()
	roundTime = 60 * (2 + math.min(#player.GetAll() / 8, 2))

	tdm.DirectOtherTeam(3, 1, 2)
	OpposingAllTeam()
	AutoBalanceTwoTeam()

	local spawnsT, spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1), spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2), spawnsCT)

	tdm.CenterInit()
end

function ghostbusters.RoundEndCheck()
	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive = tdm.GetCountLive(team.GetPlayers(2))

	if TAlive == 0 and CTAlive == 0 then
		EndRound()
		return
	end

	if TAlive == 0 then EndRound(2) end
	if CTAlive == 0 then EndRound(1) end
	tdm.Center()
end

function ghostbusters.EndRound(winner)
	tdm.EndRoundMessage(winner)
end

function ghostbusters.PlayerInitialSpawn(ply)
	ply:SetTeam(math.random(1, 2))
end

function ghostbusters.PlayerSpawn(ply, teamID)
	local teamTbl = ghostbusters[ghostbusters.teamEncoder[teamID]]
	local color = teamTbl[2]

	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)] or "models/player/group01/male_03.mdl")
	ply:SetPlayerColor(color:ToVector())

	for i, weapon in pairs(teamTbl.weapons) do
		ply:Give(weapon)
	end

	tdm.GiveSwep(ply, teamTbl.main_weapon, 3)
	tdm.GiveSwep(ply, teamTbl.secondary_weapon, 3)
	local r = math.random(1,30)
	print(r)
	if r==1 then ply:Give("weapon_s_rpgg") end
	if math.random(1,100)==1 then ply:Give("weapon_s_rpggatomic") end
	JMod.EZ_Equip_Armor(ply, (math.random(1, 2) == 1 and "Medium-Light-Vest") or (math.random(1, 2) and "Light-Vest"))

	if roundStarter then
		ply.allowFlashlights = false
	end
end

function ghostbusters.PlayerCanJoinTeam(ply, teamID)
	if teamID == 3 then
		ply:ChatPrint("yummers")
		return false
	end
end

function ghostbusters.ShouldSpawnLoot()
	return false
end

function ghostbusters.PlayerDeath(ply, inf, att)
	return false
end