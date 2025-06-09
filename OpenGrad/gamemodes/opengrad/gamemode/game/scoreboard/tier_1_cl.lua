-- Цвета и материалы
local red, green, white = Color(255, 80, 80), Color(80, 255, 80), Color(240, 240, 240)
local specColor = Color(155, 155, 155)
local whiteAdd = Color(255, 255, 255, 15)
local unmutedicon = Material("icon32/unmuted.png", "noclamp smooth")
local mutedicon = Material("icon32/muted.png", "noclamp smooth")
local hostname = GetHostName()

-- Используем общую библиотеку UI
include("homigrad_scr/game/tier_1/ui_library_cl.lua")


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
		HG_UI.ResetBlur()
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
			HG_UI.BlurBackground(self)

			-- Основной фон
			HG_UI.DrawFrame(0, 0, w, h)

			-- Заголовок
			draw.SimpleText(hostname, HG_UI.FONTS.HEADER, w / 2, 25, HG_UI.COLORS.TEXT_PRIMARY, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Панель заголовков
			HG_UI.DrawPanel(20, 70, w - 40, 40)

			-- Заголовки колонок
			draw.SimpleText("Статус", HG_UI.FONTS.NORMAL, 120, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Имя игрока", HG_UI.FONTS.NORMAL, w / 2, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Пинг", HG_UI.FONTS.NORMAL, w - 220, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Команда", HG_UI.FONTS.NORMAL, w - 120, 90, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			-- Информационная панель внизу
			HG_UI.DrawPanel(20, h - 60, w - 40, 40)
			
			draw.SimpleText("Игроков: " .. table.Count(player.GetAll()), HG_UI.FONTS.NORMAL, 40, h - 40, green, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			local tick = math.Round(1 / engine.ServerFrameTime())
			local tickColor = tick <= 35 and red or green
			draw.SimpleText("TPS Сервера: " .. tick, HG_UI.FONTS.NORMAL, w - 40, h - 40, tickColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

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
					HG_UI.DrawFrame(0, 0, w, h, Color(20, 20, 20, 240), nil, 1)
				end

				local option1 = HG_UI.AddMenuOption(playerMenu, "Скопировать SteamID", function()
					SetClipboardText(ply:SteamID())
					LocalPlayer():ChatPrint("SteamID " .. ply:Name() .. " скопирован! (" .. ply:SteamID() .. ")")
				end)

				local option2 = HG_UI.AddMenuOption(playerMenu, "Открыть профиль", function()
					ply:ShowProfile()
				end)

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
					local roleColors = HG_UI.GetRoleColors()
					draw.RoundedBox(0, 25, 2, w - 50, h - 4, Color(60, 60, 60, 120))
					surface.SetDrawColor(roleColors.PRIMARY.r, roleColors.PRIMARY.g, roleColors.PRIMARY.b, 200)
					surface.DrawOutlinedRect(25, 2, w - 50, h - 4)
				elseif isHovered then
					local roleColors = HG_UI.GetRoleColors()
					draw.RoundedBox(0, 25, 2, w - 50, h - 4, Color(40, 40, 40, 100))
					surface.SetDrawColor(roleColors.PRIMARY.r, roleColors.PRIMARY.g, roleColors.PRIMARY.b, 150)
					surface.DrawOutlinedRect(25, 2, w - 50, h - 4)
				end

				-- Цветовая полоска статуса
				if colorAdd then
					draw.RoundedBox(0, 30, h/2 - 15, 4, 30, colorAdd)
				end

				-- Номер в списке
				if alive ~= "Неизвестно" and ply.last then
					draw.SimpleText(ply.last, HG_UI.FONTS.NORMAL, 50, h / 2, Color(180, 180, 180), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				-- Статус
				draw.SimpleText(alive, HG_UI.FONTS.NORMAL, 120, h / 2, alivecol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				-- Имя игрока
				draw.SimpleText(name1, HG_UI.FONTS.NORMAL, w / 2, h / 2, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				-- Пинг
				local ping = ply:Ping()
				local pingColor = ping > 100 and red or (ping > 50 and Color(255, 255, 0) or green)
				draw.SimpleText(ping .. " мс", HG_UI.FONTS.NORMAL, w - 220, h / 2, pingColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

				-- Команда
				local teamName, teamColor = ply:PlayerClassEvent("TeamName")
				if not teamName then
					teamName, teamColor = TableRound().GetTeamName(ply)
					teamName = teamName or "Наблюдатель"
					teamColor = teamColor or ScoreboardSpec
				end
				draw.SimpleText(teamName, HG_UI.FONTS.NORMAL, w - 120, h / 2, teamColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
						local roleColors = HG_UI.GetRoleColors()
						draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50, 100))
						surface.SetDrawColor(roleColors.PRIMARY.r, roleColors.PRIMARY.g, roleColors.PRIMARY.b, 200)
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
		local menuButton = HG_UI.CreateStyledButton(controlPanel, "Меню", {
			textColor = Color(120, 120, 255),
			font = HG_UI.FONTS.NORMAL,
			onClick = function()
				if OpenHomigradMenu then
					OpenHomigradMenu()
				end
				HomigradScoreboard:Remove()
			end
		})
		menuButton:SetPos(controlPanel:GetWide() / 2 - 50, 0)
		menuButton:SetSize(100, 35)

		-- Кнопка "Замутить всех"
		local muteAll = HG_UI.CreateStyledButton(controlPanel, "Замутить всех", {
			font = HG_UI.FONTS.NORMAL,
			onClick = function()
				muteall = not muteall
			end
		})
		muteAll:SetPos(20, 0)
		muteAll:SetSize(150, 35)

		local oldMuteAllPaint = muteAll.Paint
		muteAll.Paint = function(self, w, h)
			self:SetTextColor(not muteall and green or red)
			oldMuteAllPaint(self, w, h)
		end

		-- Кнопка "Замутить мертвых"
		local muteAllDead = HG_UI.CreateStyledButton(controlPanel, "Замутить мертвых", {
			font = HG_UI.FONTS.NORMAL,
			onClick = function()
				muteAlldead = not muteAlldead
			end
		})
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
		HG_UI.ResetBlur() -- Сброс размытия при закрытии

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