-- Русская локализация для Spawn Points Tool
if CLIENT then
	-- Основные строки
	language.Add("tool.hg_spawnpoints.name", "Инструмент точек спавна")
	language.Add("tool.hg_spawnpoints.desc", "Инструмент для размещения и удаления точек спавна. ЛКМ - добавить точку, ПКМ - удалить ближайшую точку, R - очистить все точки выбранного типа.")

	-- Действия
	language.Add("tool.hg_spawnpoints.left", "Добавить точку спавна")
	language.Add("tool.hg_spawnpoints.right", "Удалить ближайшую точку")
	language.Add("tool.hg_spawnpoints.reload", "Очистить все точки выбранного типа")

	-- Интерфейс
	language.Add("tool.hg_spawnpoints.type", "Тип точки")
	language.Add("tool.hg_spawnpoints.color", "Цвет")
	language.Add("tool.hg_spawnpoints.point_id", "ID точки")
	language.Add("tool.hg_spawnpoints.showhide", "Показать/Скрыть точки")
	language.Add("tool.hg_spawnpoints.sync", "Синхронизировать точки")
	language.Add("tool.hg_spawnpoints.page_info", "Текущая страница точек спавна. Используйте разные страницы для разных вариантов расстановки.")
	language.Add("tool.hg_spawnpoints.page", "Страница точек")

	-- Типы точек (переводы для отображения)
	local point_translations = {
		["red"] = "Красные (Террористы)",
		["blue"] = "Синие (Спецназ)",
		["police"] = "Полиция",
		["bomb_site"] = "Место закладки бомбы",
		["exit"] = "Выход",
		["center"] = "Центр",
		["wick"] = "Джон Вик",
		["naem"] = "Наёмники"
	}

	-- Добавляем переводы для типов точек
	for eng, rus in pairs(point_translations) do
		language.Add("spawnpoint.type." .. eng, rus)
	end
end