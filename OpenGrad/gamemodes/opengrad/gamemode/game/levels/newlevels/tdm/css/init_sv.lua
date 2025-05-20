function css.StartRoundSV()
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

function css.RoundEndCheck()
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

function css.EndRound(winner)
	tdm.EndRoundMessage(winner)
end

function css.PlayerInitialSpawn(ply)
	ply:SetTeam(math.random(1, 2))
end

function css.PlayerSpawn(ply, teamID)
	local teamTbl = css[css.teamEncoder[teamID]]
	local color = teamTbl[2]

	ply:SetModel(teamTbl.models[math.random(#teamTbl.models)] or "models/player/group01/male_03.mdl")
	ply:SetPlayerColor(color:ToVector())

	for i, weapon in pairs(teamTbl.weapons) do
		ply:Give(weapon)
	end

	tdm.GiveSwep(ply, teamTbl.main_weapon, 3)
	tdm.GiveSwep(ply, teamTbl.secondary_weapon, 3)
	JMod.EZ_Equip_Armor(ply, (math.random(1, 2) == 1 and "Medium-Light-Vest") or (math.random(1, 2) and "Light-Vest"))

	if roundStarter then
		ply.allowFlashlights = false
	end
end

function css.GetBombSites()
	local avaible = ReadDataMap("bomb_site")
	local sites = {}

	for i, _ in ipairs(avaible) do
		debugoverlay.Sphere(avaible[i][1], 70)
		table.insert(sites, avaible[i])
	end

	return sites
end

function css.PlayerCanJoinTeam(ply, teamID)
	if teamID == 3 then
		ply:ChatPrint("yummers")
		return false
	end
end

local common = {"food_lays", "weapon_pipe", "weapon_bat", "medkit", "food_monster", "food_fishcan", "food_spongebob_home"}
local uncommon = {"weapon_molotok", "painkiller"}

function css.ShouldSpawnLoot()
	local chance = math.random(100)
	if chance < 30 then
		return true, uncommon[math.random(#uncommon)]
	elseif chance < 70 then
		return true, common[math.random(#common)]
	else
		return false
	end
end

function css.PlayerDeath(ply, inf, att)
	return false
end