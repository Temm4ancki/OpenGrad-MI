-- Клиентская часть таймера оглушения
if engine.ActiveGamemode() != "opengrad" then return end

local unconsciousReason = ""

-- Получаем данные о состоянии оглушения от сервера
net.Receive("unconscious_timer_info", function()
    -- Можем использовать для синхронизации, если нужно
end)

-- Создаем шрифт для таймера
surface.CreateFont("UnconsciousTimerFont", {
    font = "Roboto",
    size = 32,
    weight = 800,
    outline = true,
    shadow = true
})

surface.CreateFont("UnconsciousReasonFont", {
    font = "Roboto", 
    size = 24,
    weight = 600,
    outline = true,
    shadow = true
})

-- Функция для расчета времени до выхода из оглушения в реальном времени
local function CalculateRecoveryTime()
    local ply = LocalPlayer()
    if not IsValid(ply) then return 0, "" end

    -- Получаем текущие значения
    local currentPain = pain or 0
    local currentPainlosing = painlosing or 0
    local currentBlood = ply:GetNWInt("Blood", 5000)
    local currentHeartstop = ply:GetNWBool("heartstop", false)
    local currentAdrenaline = ply:GetNWFloat("adrenaline", 0)
    local currentStamina = ply:GetNWInt("stamina", 30)

    -- Пороговые значения (из pain_sv.lua)
    local painlosingThreshold = 20
    local painThreshold = 250 + ply:GetNWInt("SharpenAMT", 0) * 5
    local bloodThreshold = 1500

    -- Учитываем сопротивление оглушению
    if ply:GetNWBool("ResistOtrub", false) then
        painlosingThreshold = painlosingThreshold + 25
        painThreshold = painThreshold + 110
        bloodThreshold = bloodThreshold - 350
    end

    local maxRecoveryTime = 0
    local reasons = {}
    local detailedReasons = {}

    -- Расчет времени восстановления от боли
    if currentPain > painThreshold then
        -- Скорость уменьшения боли: painlosing * 1 за тик (0.1 сек)
        -- Но также учитываем adrenalineNeed * k, где k = 1 - adrenaline/2 при adrenaline <= 2
        local k = 0
        if currentAdrenaline <= 2 then
            k = 1 - currentAdrenaline / 2
        end

        -- Эффективная скорость уменьшения боли за секунду
        local painDecreaseRate = (currentPainlosing * 1 - ply:GetNWFloat("adrenalineNeed", 0) * k) * 10 -- умножаем на 10, т.к. тик = 0.1 сек

        if painDecreaseRate > 0 then
            local painToRecover = currentPain - painThreshold
            local painTime = painToRecover / painDecreaseRate
            maxRecoveryTime = math.max(maxRecoveryTime, painTime)
            table.insert(reasons, "боль")
            table.insert(detailedReasons, string.format("Боль: %.0f/%.0f (-%0.1f/сек)", currentPain, painThreshold, painDecreaseRate))
        else
            -- Боль не уменьшается или даже растет
            maxRecoveryTime = math.max(maxRecoveryTime, 999)
            table.insert(reasons, "боль (не уменьшается)")
            table.insert(detailedReasons, string.format("Боль: %.0f/%.0f (растёт)", currentPain, painThreshold))
        end
    end

    -- Расчет времени восстановления от painlosing
    if currentPainlosing > painlosingThreshold then
        -- Скорость уменьшения: 0.01 за тик (0.1 сек) = 0.1 в секунду
        local painlosingDecreaseRate = 0.1
        local painlosingToRecover = currentPainlosing - painlosingThreshold
        local painlosingTime = painlosingToRecover / painlosingDecreaseRate

        maxRecoveryTime = math.max(maxRecoveryTime, painlosingTime)
        table.insert(reasons, "передозировка")
        table.insert(detailedReasons, string.format("Painlosing: %.1f/%.0f (-0.1/сек)", currentPainlosing, painlosingThreshold))
    end

    -- Расчет времени восстановления крови
    if currentBlood < bloodThreshold then
        -- Скорость восстановления крови за тик: stamina * 10 + adrenaline * 20
        local bloodRecoveryRate = (math.max(math.ceil(currentStamina), 1) * 10 + currentAdrenaline * 20) * 10 / 0.1 -- конвертируем в единицы в секунду

        if bloodRecoveryRate > 0 then
            local bloodToRecover = bloodThreshold - currentBlood
            local bloodTime = bloodToRecover / bloodRecoveryRate
            maxRecoveryTime = math.max(maxRecoveryTime, bloodTime)
            table.insert(reasons, "кровопотеря")
            table.insert(detailedReasons, string.format("Кровь: %d/%d (+%.0f/сек)", currentBlood, bloodThreshold, bloodRecoveryRate))
        else
            maxRecoveryTime = math.max(maxRecoveryTime, 999)
            table.insert(reasons, "кровопотеря (критическая)")
            table.insert(detailedReasons, string.format("Кровь: %d/%d (не восстанавливается)", currentBlood, bloodThreshold))
        end
    end

    -- Остановка сердца
    if currentHeartstop then
        maxRecoveryTime = math.max(maxRecoveryTime, 999) -- Практически бесконечно без дефибриллятора
        table.insert(reasons, "остановка сердца")
        table.insert(detailedReasons, "Жди спасения лол")
    end

    -- Проверка на критические состояния
    if currentPainlosing > 5 then
        -- При painlosing > 5 боль увеличивается на 8 за тик
        maxRecoveryTime = math.max(maxRecoveryTime, 999)
        table.insert(reasons, "критическая передозировка")
    end

    if currentAdrenaline > 2 then
        -- При адреналине > 2 боль увеличивается на 5 за тик
        maxRecoveryTime = math.max(maxRecoveryTime, 999)
        table.insert(reasons, "передозировка адреналина")
    end

    unconsciousReason = table.concat(reasons, ", ")

    return maxRecoveryTime, table.concat(detailedReasons, "\n")
end

-- Отрисовка таймера
hook.Add("HUDPaintBackground", "DrawUnconsciousTimer", function()
    local ply = LocalPlayer()
    if not IsValid(ply) or not ply:Alive() then return end

    -- Проверяем, находится ли игрок в оглушении
    if not ply:GetNWBool("Otrub", false) then return end

    -- Рассчитываем время восстановления
    local recoveryTime, detailedInfo = CalculateRecoveryTime()

    -- Позиция отрисовки
    local x = ScrW() / 2
    local y = ScrH() / 2 + 100

    -- Фон
    local bgWidth, bgHeight = 450, 100
    draw.RoundedBox(8, x - bgWidth/2, y - bgHeight/2, bgWidth, bgHeight, Color(0, 0, 0, 200))

    -- Основной текст
    if recoveryTime >= 999 then
        draw.SimpleText("Выход из оглушения: требуется медпомощь", "UnconsciousTimerFont", x, y - 20, Color(255, 50, 50, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText(string.format("Выход из оглушения: %.1f сек", recoveryTime), "UnconsciousTimerFont", x, y - 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    if unconsciousReason != "" then
        draw.SimpleText("Причина: " .. unconsciousReason, "UnconsciousReasonFont", x, y + 10, Color(200, 200, 200, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    -- Отладка
    if GetConVar("developer"):GetInt() > 0 and detailedInfo != "" then
        local lines = string.Explode("\n", detailedInfo)
        for i, line in ipairs(lines) do
            draw.SimpleText(line, "Default", x, y + 40 + (i-1)*15, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
end)