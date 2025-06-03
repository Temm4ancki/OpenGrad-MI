TOOL.Category = "OpenGrad"
TOOL.Name = "#tool.hg_spawnpoints.name"

TOOL.ClientConVar["point_type"] = "red"
TOOL.ClientConVar["point_id"] = "1"

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" }
}

-- Получаем список доступных типов точек из SpawnPointsList
local function GetSpawnPointTypes()
	local types = {}
	if SpawnPointsList then
		for name, info in pairs(SpawnPointsList) do
			table.insert(types, {name = name, display = info[1], color = info[2]})
		end
	else
		-- Если SpawnPointsList еще не загружен, используем базовые типы
		types = {
			{name = "spawnpointst", display = "red", color = Color(255, 0, 0)},
			{name = "spawnpointsct", display = "blue", color = Color(0, 0, 255)},
			{name = "spawnpoints_ss_police", display = "police", color = Color(0, 0, 125)},
			{name = "bomb_site", display = "bomb_site", color = Color(161, 121, 61)},
			{name = "spawnpoints_ss_exit", display = "exit", color = Color(0, 125, 0)},
		}
	end
	return types
end

function TOOL:LeftClick(trace)
	if not trace.Hit then return false end

	local ply = self:GetOwner()
	if not IsValid(ply) then return false end

	if SERVER and not ply:IsAdmin() then
		ply:ChatPrint("У вас нет прав для размещения точек спавна!")
		return false
	end

	local point_type = self:GetClientInfo("point_type")
	local point_id = self:GetClientNumber("point_id")

	if SERVER then
		-- Проверяем наличие необходимых функций
		if not ReadDataMap or not WriteDataMap or not SetupSpawnPointsList or not SendSpawnPoint then
			ply:ChatPrint("Ошибка: функции datamap не загружены!")
			return false
		end

		-- Проверяем, существует ли такой тип точки
		local found = false
		for name, info in pairs(SpawnPointsList or {}) do
			if info[1] == point_type then
				found = true

				local tbl = ReadDataMap(name)

				-- Добавляем новую точку
				local point = {
					trace.HitPos + Vector(0, 0, 5),
					Angle(0, ply:EyeAngles()[2], 0),
					point_id
				}
				table.insert(tbl, point)

				WriteDataMap(name, tbl)

				SetupSpawnPointsList()
				SendSpawnPoint()

				ply:ChatPrint("Точка " .. point_type .. " (ID: " .. point_id .. ") добавлена")
				break
			end
		end

		if not found then
			ply:ChatPrint("Неизвестный тип точки: " .. point_type)
		end
	end

	return true
end

function TOOL:RightClick(trace)
	if not trace.Hit then return false end

	local ply = self:GetOwner()
	if not IsValid(ply) then return false end

	if SERVER and not ply:IsAdmin() then
		ply:ChatPrint("У вас нет прав для удаления точек спавна!")
		return false
	end

	local point_type = self:GetClientInfo("point_type")
	local hit_pos = trace.HitPos

	if SERVER then
		if not ReadDataMap or not WriteDataMap or not SetupSpawnPointsList or not SendSpawnPoint then
			ply:ChatPrint("Ошибка: функции datamap не загружены!")
			return false
		end

		-- Ищем тип точки
		for name, info in pairs(SpawnPointsList or {}) do
			if info[1] == point_type then
				local tbl = ReadDataMap(name)
				local closest_index = nil
				local closest_distance = 100 -- Максимальное расстояние для удаления

				-- Ищем ближайшую точку
				for i, point in pairs(tbl) do
					local point_pos = point[1]
					local distance = hit_pos:Distance(point_pos)

					if distance < closest_distance then
						closest_distance = distance
						closest_index = i
					end
				end

				-- Удаляем найденную точку
				if closest_index then
					local removed_point = tbl[closest_index]
					table.remove(tbl, closest_index)

					WriteDataMap(name, tbl)

					SetupSpawnPointsList()
					SendSpawnPoint()

					ply:ChatPrint("Точка " .. point_type .. " (ID: " .. (removed_point[3] or "неизвестно") .. ") удалена")
				else
					ply:ChatPrint("Не найдено точек " .. point_type .. " рядом с указанным местом")
				end
				break
			end
		end
	end

	return true
end

function TOOL:Reload(trace)
	local ply = self:GetOwner()
	if not IsValid(ply) then return false end


	if SERVER and not ply:IsAdmin() then
		ply:ChatPrint("У вас нет прав для очистки точек спавна!")
		return false
	end

	local point_type = self:GetClientInfo("point_type")

	if SERVER then
		if not WriteDataMap or not SetupSpawnPointsList or not SendSpawnPoint then
			ply:ChatPrint("Ошибка: функции datamap не загружены!")
			return false
		end

		-- Ищем тип точки и очищаем
		for name, info in pairs(SpawnPointsList or {}) do
			if info[1] == point_type then
				WriteDataMap(name, {})

				SetupSpawnPointsList()
				SendSpawnPoint()

				ply:ChatPrint("Все точки " .. point_type .. " очищены")
				break
			end
		end
	end

	return true
end

-- Создание панели настроек
function TOOL.BuildCPanel(CPanel)
	local Header = vgui.Create("DLabel", CPanel)
	Header:SetText("#tool.hg_spawnpoints.desc")
	Header:SetWrap(true)
	Header:SetAutoStretchVertical(true)
	CPanel:AddItem(Header)

	-- Список типов точек
	local TypeList = vgui.Create("DListView", CPanel)
	TypeList:SetHeight(200)
	TypeList:SetMultiSelect(false)
	TypeList:AddColumn("#tool.hg_spawnpoints.type")
	TypeList:AddColumn("#tool.hg_spawnpoints.color")

	-- Заполняем список типов точек
	local spawn_types = GetSpawnPointTypes()
	for _, type_info in ipairs(spawn_types) do
		local line = TypeList:AddLine(type_info.display, "")
		line.Paint = function(self, w, h)
			if self:IsSelected() then
				draw.RoundedBox(0, 0, 0, w, h, Color(100, 100, 100, 100))
			end
			-- Рисуем цветной индикатор
			draw.RoundedBox(0, w - 20, 2, 16, h - 4, type_info.color)
		end
	end

	TypeList.OnRowSelected = function(lst, index, pnl)
		local selected_type = pnl:GetColumnText(1)
		GetConVar("hg_spawnpoints_point_type"):SetString(selected_type)
	end
	CPanel:AddItem(TypeList)

	-- Слайдер для ID точки
	local IDSlider = vgui.Create("DNumSlider", CPanel)
	IDSlider:SetText("#tool.hg_spawnpoints.point_id")
	IDSlider:SetMinMax(1, 100)
	IDSlider:SetDecimals(0)
	IDSlider:SetConVar("hg_spawnpoints_point_id")
	CPanel:AddItem(IDSlider)

	-- Кнопка для показа/скрытия точек
	local ShowHideButton = vgui.Create("DButton", CPanel)
	ShowHideButton:SetText("#tool.hg_spawnpoints.showhide")
	ShowHideButton:SetMouseInputEnabled(true)
	function ShowHideButton:DoClick()
		LocalPlayer():ConCommand("hg_drawspawn " .. (GetConVar("hg_drawspawn"):GetBool() and "0" or "1"))
	end
	CPanel:AddItem(ShowHideButton)

	-- Кнопка для синхронизации точек
	local SyncButton = vgui.Create("DButton", CPanel)
	SyncButton:SetText("#tool.hg_spawnpoints.sync")
	SyncButton:SetMouseInputEnabled(true)
	function SyncButton:DoClick()
		LocalPlayer():ConCommand("hg_pointsync")
	end
	CPanel:AddItem(SyncButton)

	-- Информация о страницах
	local PageInfo = vgui.Create("DLabel", CPanel)
	PageInfo:SetText("#tool.hg_spawnpoints.page_info")
	PageInfo:SetWrap(true)
	PageInfo:SetAutoStretchVertical(true)
	CPanel:AddItem(PageInfo)

	-- Слайдер для выбора страницы
	local PageSlider = vgui.Create("DNumSlider", CPanel)
	PageSlider:SetText("#tool.hg_spawnpoints.page")
	PageSlider:SetMinMax(1, 10)
	PageSlider:SetDecimals(0)
	PageSlider:SetValue(SpawnPointsPage or 1)
	PageSlider.OnValueChanged = function(self, value)
		LocalPlayer():ConCommand("hg_pointpage " .. math.floor(value))
	end
	CPanel:AddItem(PageSlider)
end

-- Визуализация для TOOL'а
function TOOL:DrawHUD()
	if CLIENT then
		local trace = LocalPlayer():GetEyeTrace()
		if trace.Hit then
			local point_type = self:GetClientInfo("point_type")
			local point_id = self:GetClientNumber("point_id")

			local pos = trace.HitPos:ToScreen()
			if pos.visible then
				draw.SimpleText("Точка: " .. point_type .. " (ID: " .. point_id .. ")", "DermaDefault", pos.x, pos.y - 20, color_white, TEXT_ALIGN_CENTER)
			end
		end
	end
end

function TOOL:DrawToolScreen(width, height)
	if CLIENT then
		surface.SetDrawColor(50, 50, 50, 255)
		surface.DrawRect(0, 0, width, height)

		local point_type = self:GetClientInfo("point_type")
		local point_id = self:GetClientNumber("point_id")

		draw.SimpleText("Spawn Points Tool", "DermaLarge", width / 2, 20, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText("Тип: " .. point_type, "DermaDefault", width / 2, 60, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText("ID: " .. point_id, "DermaDefault", width / 2, 80, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText("ЛКМ - добавить", "DermaDefault", width / 2, 110, Color(0, 255, 0), TEXT_ALIGN_CENTER)
		draw.SimpleText("ПКМ - удалить", "DermaDefault", width / 2, 130, Color(255, 0, 0), TEXT_ALIGN_CENTER)
		draw.SimpleText("R - очистить все", "DermaDefault", width / 2, 150, Color(255, 255, 0), TEXT_ALIGN_CENTER)
	end
end

-- Локализация
if CLIENT then
	language.Add("tool.hg_spawnpoints.name", "Spawn Points Tool")
	language.Add("tool.hg_spawnpoints.desc", "Инструмент для размещения и удаления точек спавна. ЛКМ - добавить точку, ПКМ - удалить ближайшую точку, R - очистить все точки выбранного типа.")
	language.Add("tool.hg_spawnpoints.left", "Добавить точку спавна")
	language.Add("tool.hg_spawnpoints.right", "Удалить ближайшую точку")
	language.Add("tool.hg_spawnpoints.reload", "Очистить все точки выбранного типа")
	language.Add("tool.hg_spawnpoints.type", "Тип точки")
	language.Add("tool.hg_spawnpoints.color", "Цвет")
	language.Add("tool.hg_spawnpoints.point_id", "ID точки")
	language.Add("tool.hg_spawnpoints.showhide", "Показать/Скрыть точки")
	language.Add("tool.hg_spawnpoints.sync", "Синхронизировать точки")
	language.Add("tool.hg_spawnpoints.page_info", "Текущая страница точек спавна. Используйте разные страницы для разных вариантов расстановки.")
	language.Add("tool.hg_spawnpoints.page", "Страница точек")
end