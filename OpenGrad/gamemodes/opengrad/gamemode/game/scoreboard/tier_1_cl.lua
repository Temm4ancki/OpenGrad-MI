-- Цвета и материалы
local red, green, white = Color(255, 80, 80), Color(80, 255, 80), Color(240, 240, 240)
local specColor = Color(155, 155, 155)
local whiteAdd = Color(255, 255, 255, 15)
local unmutedicon = Material("icon32/unmuted.png", "noclamp smooth")
local mutedicon = Material("icon32/muted.png", "noclamp smooth")
local hostname = GetHostName()

-- Материал для размытия фона
local blurMat = Material("pp/blurscreen")
local blurStrength = 0

-- Функции для работы с мутом
local function ReadMuteStatusPlayers()
	return util.JSONToTable(file.Read("homigrad_mute.txt", "DATA") or "") or {}
end

MutePlayers = ReadMuteStatusPlayers()

local function SaveMuteStatusPlayer(ply, value)
	if value == false then value = nil end
	MutePlayers[ply:SteamID()] = value
	file.Write("homigrad_mute.txt", util.TableToJSON(MutePlayers))
end

-- Функция размытия фона
local function BlurBackground(panel)
	if not (IsValid(panel) and panel:IsVisible()) then return end

	local x, y = panel:LocalToScreen(0, 0)
	local w, h = ScrW(), ScrH()

	surface.SetDrawColor(255, 255, 255, 120)
	surface.SetMaterial(blurMat)

	for i = 1, 5 do
		blurMat:SetFloat("$blur", (i / 1) * 1 * blurStrength)
		blurMat:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, w, h)
	end

	surface.SetDrawColor(0, 0, 0, 100 * blurStrength)
	surface.DrawRect(0, 0, panel:GetWide(), panel:GetTall())

	blurStrength = math.Clamp(blurStrength + FrameTime() * 6, 0, 1)
end

-- Создание стилизованной кнопки
local function StyledButton(parent, text, color, font, onclick)
	local btn = vgui.Create("DButton", parent)
	btn:SetText(text)
	btn:SetFont(font or "HomigradFont")
	btn:SetTextColor(color or color_white)
	btn:SetTall(35)

	btn.Paint = function(self, w, h)
		local hover = self:IsHovered()
		local bg = hover and Color(50, 50, 50, 200) or Color(30, 30, 30, 180)
		draw.RoundedBox(0, 0, 0, w, h, bg)

		-- Обводка кнопки
		surface.SetDrawColor(44, 110, 73, hover and 255 or 180)
		for i = 0, 1 do
			surface.DrawOutlinedRect(i, i, w - i*2, h - i*2)
		end
	end

	btn.DoClick = onclick
	return btn
end

-- Создание шрифтов
surface.CreateFont("ScoreboardTitle", {
	font = "Roboto",
	size = 28,
	weight = 1000,
	outline = false,
	shadow = false
})

surface.CreateFont("ScoreboardHeader", {
	font = "Roboto",
	size = 20,
	weight = 800,
	outline = false,
	shadow = false
})

surface.CreateFont("ScoreboardText", {
	font = "Roboto",
	size = 18,
	weight = 600,
	outline = false,
	shadow = false
})

-- Градиенты для анимации
local grtodown = Material("vgui/gradient-u")
local grtoup = Material("vgui/gradient-d")

muteallspectate = muteallspectate
mutealllives = mutealllives

local colorSpec = Color(155, 155, 155)
local colorRed = Color(255, 80, 80)
local colorGreen = Color(80, 255, 80)

ScoreboardRed = colorRed
ScoreboardSpec = colorSpec
ScoreboardGreen = colorGreen
ScoreboardBlack = Color(0, 0, 0, 200)

ScoreboardList = ScoreboardList or {}

local function timeSort(a, b)
	local time1 = math.floor(CurTime() - (a.TimeStart or 0) + (a.Time or 0))
	local time2 = math.floor(CurTime() - (b.TimeStart or 0) + (b.Time or 0))
	return time1 > time2
end

local function ToggleScoreboard(toggle)
	if toggle then
		if IsValid(HomigradScoreboard) then
			return
		end

		-- Сброс силы размытия при открытии
		blurStrength = 0
		showRoundInfo = CurTime() + 2.5

		local scrw, scrh = ScrW(), ScrH()

		HomigradScoreboard = vgui.Create("DFrame")
		HomigradScoreboard:SetTitle("")
		HomigradScoreboard:SetSize(scrw * .8, scrh * .9)
		HomigradScoreboard:Center()
		HomigradScoreboard:ShowCloseButton(false)
		HomigradScoreboard:SetDraggable(false)
		HomigradScoreboard:MakePopup()
		HomigradScoreboard:SetKeyboardInputEnabled(false)
		ScoreboardList[HomigradScoreboard] = true

		local wheelY = 0
		local animWheelUp, animWheelDown = 0, 0

		function HomigradScoreboard:Sort()
			local teams = {}
			local lives, deads = {}, {}

			for ply in pairs(self.players) do
				ply.last = nil
				local teamID = ply:Team()

				teams[teamID] = teams[teamID] or {{}, {}}
				teamID = teams[teamID]

				if ply:Alive() then
					teamID[1][#teamID[1] + 1] = ply
				else
					teamID[2][#teamID[2] + 1] = ply
				end
			end

			for teamID, list in pairs(teams) do
				table.sort(list[1], timeSort)
				table.sort(list[2], timeSort)
			end

			local sort = {}

			local func = TableRound().ScoreboardSort
			if func then
				func(sort)
			else
				for teamID, team in pairs(teams) do
					for i, ply in pairs(team[1]) do
						sort[#sort + 1] = ply
					end

					for i, ply in pairs(team[2]) do
						sort[#sort + 1] = ply
					end

					local last = team[1][#team[1]]
					if last then
						local func = TableRound().Scoreboard_DrawLast
						if func and func(last) ~= nil then continue end

						last.last = #team[1]
					end

					last = team[2][#team[2]]
					if last then
						local func = TableRound().Scoreboard_DrawLast
						if func and func(last) ~= nil then continue end

						last.last = #team[2]
					end
				end
			end

			self.sort = sort
		end

		HomigradScoreboard.players = {}
		HomigradScoreboard.delaySort = 0
		HomigradScoreboard.Paint = function(self, w, h)
			-- Размытие фона
			BlurBackground(self)

			-- Основной фон без скруглений
			draw.RoundedBox(0, 0, 0, w, h, Color(10, 10, 10, 180))
			
			-- Обводка основного окна
			surface.SetDrawColor(44, 110, 73, 255)
			for i = 0, 2 do
				surface.DrawOutlinedRect(i, i, w - i*2, h - i*2)
			end

			-- Заголовок
			draw.SimpleText(hostname, "ScoreboardTitle", w / 2, 25, Color(255, 255, 255, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Пан��ль заголовков
			draw.RoundedBox(0, 20, 70, w - 40, 40, Color(20, 20, 20, 150))
			surface.SetDrawColor(44, 110, 73, 200)
			surface.DrawOutlinedRect(20, 70, w - 40, 40)

			-- Заголовки колонок
			draw.SimpleText("Статус", "ScoreboardHeader", 120, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Имя игрока", "ScoreboardHeader", w / 2, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Время игры", "ScoreboardHeader", w - 320, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Пинг", "ScoreboardHeader", w - 220, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Команда", "ScoreboardHeader", w - 120, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Информационная панель внизу
			draw.RoundedBox(0, 20, h - 60, w - 40, 40, Color(20, 20, 20, 150))
			surface.SetDrawColor(44, 110, 73, 200)
			surface.DrawOutlinedRect(20, h - 60, w - 40, 40)
			
			draw.SimpleText("Игроков: " .. table.Count(player.GetAll()), "ScoreboardText", 40, h - 40, green, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			local tick = math.Round(1 / engine.ServerFrameTime())
			local tickColor = tick <= 35 and red or green
			draw.SimpleText("TPS Сервера: " .. tick, "ScoreboardText", w - 40, h - 40, tickColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			local players = self.players
			for i, ply in pairs(player.GetAll()) do
				if not players[ply] then
					self:AddPlayer(ply)
					self:Sort()
				end
			end

			for ply, panel in pairs(players) do
				if IsValid(ply) then continue end
				players[ply] = nil
				panel:Remove()
				self:Sort()
			end

			if self.delaySort < CurTime() then
				self.delaySort = CurTime() + 1 / 10
				self:Sort()
			end

			-- Анимация прокрутки
			surface.SetMaterial(grtodown)
			surface.SetDrawColor(125, 125, 155, math.min(animWheelUp * 255, 10))
			surface.DrawTexturedRect(0, 0, w, animWheelUp)

			surface.SetMaterial(grtoup)
			surface.SetDrawColor(125, 125, 155, math.min(animWheelDown * 255, 10))
			surface.DrawTexturedRect(0, h - animWheelDown, w, animWheelDown)

			local lerp = math.max(FrameTime() / (1 / 60) * 0.1, 0)
			animWheelUp = Lerp(lerp, animWheelUp, 0)
			animWheelDown = Lerp(lerp, animWheelDown, 0)

			local yPos = -wheelY
			local sort = self.sort
			for i, ply in pairs(sort) do
				ply:SetMuted(MutePlayers[ply:SteamID()])

				if muteall then ply:SetMuted(true) end

				if muteAlldead and not ply:Alive() and (not LocalPlayer():Alive() or ply:Team() == 1002) then ply:SetMuted(true) end

				local panel = players[ply]
				panel:SetPos(0, yPos)
				yPos = yPos + panel:GetTall() + 1
			end
		end

		local panelPlayers = vgui.Create("Panel", HomigradScoreboard)
		panelPlayers:SetPos(0, 120)
		panelPlayers:SetSize(HomigradScoreboard:GetWide(), HomigradScoreboard:GetTall() - 190)
		function panelPlayers:Paint(w, h) end

		function HomigradScoreboard:OnMouseWheeled(wheel)
			local count = table.Count(self.players)
			local limit = count * 55 + count - panelPlayers:GetTall()

			if limit > 0 then
				wheelY = wheelY - math.Clamp(wheel, -1, 1) * 55
				if wheelY < 0 then
					animWheelUp = animWheelUp + 132
					wheelY = 0
				elseif wheelY > limit then
					wheelY = limit
					animWheelDown = animWheelDown + 32
				end
			end
		end

		function HomigradScoreboard:AddPlayer(ply)
			local playerPanel = vgui.Create("DButton", panelPlayers)
			self.players[ply] = playerPanel
			playerPanel:SetText("")
			playerPanel:SetPos(0, 0)
			playerPanel:SetSize(HomigradScoreboard:GetWide(), 52)
			playerPanel.DoClick = function()
				local playerMenu = vgui.Create("DMenu")
				playerMenu:SetPos(input.GetCursorPos())

				-- Стилизация меню
				playerMenu.Paint = function(self, w, h)
					draw.RoundedBox(0, 0, 0, w, h, Color(20, 20, 20, 240))
					surface.SetDrawColor(44, 110, 73, 255)
					for i = 0, 1 do
						surface.DrawOutlinedRect(i, i, w - i*2, h - i*2)
					end
				end

				local option1 = playerMenu:AddOption("Скопировать SteamID", function()
					SetClipboardText(ply:SteamID())
					LocalPlayer():ChatPrint("SteamID " .. ply:Name() .. " скопирован! (" .. ply:SteamID() .. ")")
				end)
				option1:SetFont("ScoreboardText")
				option1:SetColor(Color(180, 180, 180))

				local option2 = playerMenu:AddOption("Открыть профиль", function()
					ply:ShowProfile()
				end)
				option2:SetFont("ScoreboardText")
				option2:SetColor(Color(180, 180, 180))

				playerMenu:MakePopup()
				ScoreboardList[playerMenu] = true
			end

			local name1 = ply:Name()
			local team = ply:Team()
			local alive
			local alivecol
			local colorAdd

			local func = TableRound().Scoreboard_Status
			if func then alive, alivecol, colorAdd = func(ply) end
			if not func or (func and alive == true) then
				if LocalPlayer():Team() == 1002 or not LocalPlayer():Alive() then
					if ply:Alive() then
						alive = "Живой"
						alivecol = colorGreen
					elseif ply:Team() == 1002 then
						alive = "Наблюдает"
						alivecol = colorSpec
					else
						alive = "Мёртв"
						alivecol = colorRed
						colorAdd = colorRed
					end
				elseif ply:Team() == 1002 then
					alive = "Наблюдает"
					alivecol = colorSpec
				else
					alive = "Неизвестно"
					alivecol = colorSpec
					colorAdd = colorSpec
				end
			end

			playerPanel.Paint = function(self, w, h)
				-- Основной фон панели игрока
				local isHovered = playerPanel:IsHovered()
				local isLocalPlayer = ply == LocalPlayer()

				if isLocalPlayer then
					draw.RoundedBox(0, 25, 2, w - 50, h - 4, Color(60, 60, 60, 120))
					surface.SetDrawColor(44, 110, 73, 200)
					surface.DrawOutlinedRect(25, 2, w - 50, h - 4)
				elseif isHovered then
					draw.RoundedBox(0, 25, 2, w - 50, h - 4, Color(40, 40, 40, 100))
					surface.SetDrawColor(44, 110, 73, 150)
					surface.DrawOutlinedRect(25, 2, w - 50, h - 4)
				end

				-- Цветовая полоска статуса
				if colorAdd then
					draw.RoundedBox(0, 30, h/2 - 15, 4, 30, colorAdd)
				end

				-- Номер в списке
				if alive ~= "Неизвестно" and ply.last then
					draw.SimpleText(ply.last, "ScoreboardText", 50, h / 2, Color(180, 180, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				-- Статус
				draw.SimpleText(alive, "ScoreboardText", 120, h / 2, alivecol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				-- Имя игрока
				draw.SimpleText(name1, "ScoreboardText", w / 2, h / 2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				-- Время игры
				if not ply.TimeStart then
					draw.SimpleText("Ожидание...", "ScoreboardText", w - 320, h / 2, Color(150, 150, 150), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					local time = math.floor(CurTime() - ply.TimeStart + (ply.Time or 0))
					local dTime = math.floor(time / 60 / 60 / 24)
					local hTime = string.format("%02d", math.floor(time / 60 / 60) % 24)
					local mTime = string.format("%02d", math.floor(time / 60) % 60)

					local timeText = dTime > 0 and (dTime .. "д " .. hTime .. ":" .. mTime) or (hTime .. ":" .. mTime)
					draw.SimpleText(timeText, "ScoreboardText", w - 320, h / 2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				-- Пинг
				local ping = ply:Ping()
				local pingColor = ping > 100 and red or (ping > 50 and Color(255, 255, 0) or green)
				draw.SimpleText(ping .. " мс", "ScoreboardText", w - 220, h / 2, pingColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				-- Команда
				local teamName, teamColor = ply:PlayerClassEvent("TeamName")
				if not teamName then
					teamName, teamColor = TableRound().GetTeamName(ply)
					teamName = teamName or "Наблюдатель"
					teamColor = teamColor or ScoreboardSpec
				end
				draw.SimpleText(teamName, "ScoreboardText", w - 120, h / 2, teamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			-- Кнопка мута
			if ply ~= LocalPlayer() then
				local button = vgui.Create("DButton", playerPanel)
				button:SetSize(28, 28)
				button:SetText("")
				button:SetPos(playerPanel:GetWide() - 60, playerPanel:GetTall() / 2 - 14)

				function button:Paint(w, h)
					local isHovered = self:IsHovered()
					if isHovered then
						draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 100))
						surface.SetDrawColor(44, 110, 73, 200)
						surface.DrawOutlinedRect(0, 0, w, h)
					end

					surface.SetMaterial(ply:IsMuted() and mutedicon or unmutedicon)
					surface.SetDrawColor(255, 255, 255, isHovered and 255 or 200)
					surface.DrawTexturedRect(2, 2, w-4, h-4)
				end

				function button:DoClick()
					ply:SetMuted(not ply:IsMuted())
					SaveMuteStatusPlayer(ply, ply:IsMuted())
				end
			end
		end

		-- Панель управления внизу
		local controlPanel = vgui.Create("Panel", HomigradScoreboard)
		controlPanel:SetPos(30, HomigradScoreboard:GetTall() - 120)
		controlPanel:SetSize(HomigradScoreboard:GetWide() - 60, 50)

		-- Кнопка меню
		local menuButton = StyledButton(controlPanel, "Меню", Color(120, 120, 255), "ScoreboardText", function()
			if OpenHomigradMenu then
				OpenHomigradMenu()
			end
			HomigradScoreboard:Remove()
		end)
		menuButton:SetPos(controlPanel:GetWide() / 2 - 50, 0)
		menuButton:SetSize(100, 35)

		-- Кнопка "Замутить всех"
		local muteAll = StyledButton(controlPanel, "Замутить всех", nil, "ScoreboardText", function()
			muteall = not muteall
		end)
		muteAll:SetPos(20, 0)
		muteAll:SetSize(150, 35)

		local oldMuteAllPaint = muteAll.Paint
		muteAll.Paint = function(self, w, h)
			self:SetTextColor(not muteall and green or red)
			oldMuteAllPaint(self, w, h)
		end

		-- Кнопка "Замутить мертвых"
		local muteAllDead = StyledButton(controlPanel, "Замутить мертвых", nil, "ScoreboardText", function()
			muteAlldead = not muteAlldead
		end)
		muteAllDead:SetPos(controlPanel:GetWide() - 170, 0)
		muteAllDead:SetSize(150, 35)

		local oldMuteDeadPaint = muteAllDead.Paint
		muteAllDead.Paint = function(self, w, h)
			self:SetTextColor(not muteAlldead and green or red)
			oldMuteDeadPaint(self, w, h)
		end

		local func = TableRound().ScoreboardBuild
		if func then func(HomigradScoreboard, ScoreboardList) end
	else
		ToggleScoreboard_Override = nil
		blurStrength = 0 -- Сброс размытия при закрытии

		if IsValid(HomigradScoreboard) then HomigradScoreboard:Close() end

		for panel in pairs(ScoreboardList) do
			if not IsValid(panel) then continue end

			if panel.Close then panel:Close() else panel:Remove() end
		end

		-- Очистка списка
		ScoreboardList = {}
	end
end

hook.Add("ScoreboardShow", "HomigradOpenScoreboard", function()
	ToggleScoreboard(true)

	return false
end)

hook.Add("ScoreboardHide", "HomigradHideScoreboard", function()
	if ToggleScoreboard_Override then return end

	ToggleScoreboard(false)
end)

net.Receive("close_tab", function(len) ToggleScoreboard(false) end)

ToggleScoreboard(false)