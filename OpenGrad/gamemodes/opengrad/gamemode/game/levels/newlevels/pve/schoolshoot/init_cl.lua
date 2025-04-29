tdm = tdm or {}
schoolshoot.GetTeamName = tdm.GetTeamName

local colorSpec = ScoreboardSpec
function schoolshoot.Scoreboard_Status(ply)
	local lply = LocalPlayer()
	if not lply:Alive() or lply:Team() == 1002 then return true end

	return "Неизвестно",colorSpec
end

local green = Color(0,125,0)
local white = Color(255,255,255)

local roundSound = ""

local playsound = false
function schoolshoot.StartRoundCL()
    playsound = true
end

function schoolshoot.HUDPaint_RoundLeft(white2,time)
	local time = math.Round(roundTimeStart + roundTime - CurTime())
	local acurcetime = string.FormattedTime(time,"%02i:%02i")
	local lply = LocalPlayer()
	local name,color = schoolshoot.GetTeamName(lply)

	local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound("round/start/school.ogg")
        end
		
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),0.5,0.5)

		drawRoundMode("Player vs Everyone",schoolshoot.Name,startRound,Color(155,155,155))

		if lply:Team() == 1 then
        	drawRoundStart(name,"Убей их всех.",startRound,Color(color.r,color.g,color.b))
		else
        	drawRoundStart(name,"В здании стрелок, сбеги по приезду спецназа.",startRound,Color(color.r,color.g,color.b))
		end

        return
    end

	if time > 0 then
		draw.SimpleText("До прибытия полиции : ","HomigradFont",ScrW() / 2 - 200,ScrH()-25,white,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		draw.SimpleText(acurcetime,"HomigradFont",ScrW() / 2 + 200,ScrH()-25,white,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	end
	green.a = white2.a


	if lply:Team() == 3 or lply:Team() == 2 or not lply:Alive() and schoolshoot.police then
		local list = SpawnPointsList.spawnpoints_ss_exit
		--local list = ReadDataMap("spawnpoints_ss_exit")
		if list then
			for i,point in pairs(list[3]) do
				point = ReadPoint(point)
				local pos = point[1]:ToScreen()
				draw.SimpleText("EXIT","ChatFont",pos.x,pos.y,green,TEXT_ALIGN_CENTER)
			end

			draw.SimpleText("Нажми TAB чтобы снова увидеть это.","HomigradFont",ScrW() / 2,ScrH() - 100,white2,TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Попроси админа поставить эвакуационные точки для школьников...","HomigradFont",ScrW() / 2,ScrH() - 100,white2,TEXT_ALIGN_CENTER)
		end
	end
end

function schoolshoot.PlayerClientSpawn()
	if LocalPlayer():Team() ~= 3 then return end

	showRoundInfo = CurTime() + 10
end