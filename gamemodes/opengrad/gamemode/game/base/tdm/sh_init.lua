tdm = {}

function tdm.StartRound(_game)
	game.CleanUpMap(false)

	team.SetColor(1,_game.redTeam[2])
	team.SetColor(2,_game.blueTeam[2])

	if CLIENT then return end
	tdm.StartRoundSV()
end

if SERVER then return end

function tdm.GetTeamName(ply)
	local game = TableRound()
	local team = game.teamEncoder[ply:Team()]

	if team then
		team = game[team]

		return team[1],team[2]
	end
end

function tdm.ChangeValue(oldName,value)
	local oldValue = tdm[oldName]

	if oldValue ~= value then
		oldValue = value

		return true
	end
end

function tdm.AccurceTime(time)
	return string.FormattedTime(time,"%02i:%02i")
end