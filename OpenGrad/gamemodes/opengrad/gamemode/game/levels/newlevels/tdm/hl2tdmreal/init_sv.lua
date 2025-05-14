function hl2dmreal.StartRoundSV()
	tdm.RemoveItems()

	roundTimeStart = CurTime()
	roundTime = 60 * (2 + math.min(#player.GetAll() / 8,2))

	tdm.DirectOtherTeam(3,1,2)

	OpposingAllTeam()
	AutoBalanceTwoTeam()

	local spawnsT,spawnsCT = tdm.SpawnsTwoCommand()
	tdm.SpawnCommand(team.GetPlayers(1),spawnsT)
	tdm.SpawnCommand(team.GetPlayers(2),spawnsCT)

	tdm.CenterInit()
end

function hl2dmreal.RoundEndCheck()

	local TAlive = tdm.GetCountLive(team.GetPlayers(1))
	local CTAlive = tdm.GetCountLive(team.GetPlayers(2))

	if TAlive == 0 and CTAlive == 0 then EndRound() return end

	if TAlive == 0 then EndRound(2) end
	if CTAlive == 0 then EndRound(1) end

	tdm.Center()
end

function hl2dmreal.EndRound(winner) tdm.EndRoundMessage(winner) end

function hl2dmreal.PlayerInitialSpawn(ply) ply:SetTeam(math.random(1,2)) end

function hl2dmreal.PlayerSpawn(ply,teamID)
	local teamTbl = hl2dmreal[hl2dmreal.teamEncoder[teamID]]
	local color = teamTbl[2]
	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)] or "models/player/group01/male_03.mdl")

    ply:SetPlayerColor(color:ToVector())

	for i,weapon in pairs(teamTbl.weapons) do ply:Give(weapon) end

	tdm.GiveSwep(ply,teamTbl.main_weapon,2)
	tdm.GiveSwep(ply,teamTbl.secondary_weapon,2)
	
	if teamID == 2 then
		ply:SetPlayerClass("combinereal")
		if math.random(1,2) == 2 then ply:Give("weapon_hg_hl2") end
		ply:Give("weapon_hg_stunstick")
		--JMod.EZ_Equip_Armor(ply,"Medium-Helmet",Color(0,0,0,0))
		JMod.EZ_Equip_Armor(ply,"Light-Vest",Color(0,0,0,0))
	end

	if teamID == 1 then
		local rnd = math.random(1,4)
		if rnd == 4 then ply:Give("adrenaline") end
		if rnd == 4 then ply:Give("morphine") end
		if math.random(1,3) == 3 then ply:Give("weapon_hg_hl2") end

		JMod.EZ_Equip_Armor(ply,"Medium-Helmet",color)
		local r = math.random(1,2)
		if r == 2 then ply:Give("weapon_hg_crowbar") else ply:Give("weapon_pipe") end
		JMod.EZ_Equip_Armor(ply,"Light-Vest",Color(0,0,0,0))
	end

end

function hl2dmreal.PlayerCanJoinTeam(ply,teamID)
    if teamID == 3 then ply:ChatPrint("Не чето нехочу пока") return false end
end

function hl2dmreal.ShouldSpawnLoot() return false end
function hl2dmreal.PlayerDeath(ply,inf,att) return false end