-- Серверная часть таймера оглушения
if engine.ActiveGamemode() != "opengrad" then return end

util.AddNetworkString("unconscious_timer_info")

-- Хук для отслеживания изменения состояния оглушения
hook.Add("Think", "UnconsciousTimerTracker", function()
    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or not ply:Alive() then continue end

        -- Проверяем текущее состояние оглушения
        local isUnconscious = IsUnconscious(ply)

        -- Если состояние изменилось
        if ply.wasUnconscious != isUnconscious then
            ply.wasUnconscious = isUnconscious

            if isUnconscious then
                -- Игрок вошел в оглушение
                ply.unconsciousStartTime = CurTime()

                -- Отправляем информацию клиенту
                net.Start("unconscious_timer_info")
                net.WriteBool(true)
                net.WriteFloat(CurTime())
                net.WriteString("")
                net.Send(ply)
            else
                -- Игрок вышел из оглушения
                net.Start("unconscious_timer_info")
                net.WriteBool(false)
                net.WriteFloat(0)
                net.WriteString("")
                net.Send(ply)
            end
        end

        -- Синхронизируем необходимые данные с клиентом
        ply:SetNWBool("Otrub", ply.Otrub or false)
        ply:SetNWInt("Blood", ply.Blood or 5000)
        ply:SetNWBool("heartstop", ply.heartstop or false)
        ply:SetNWFloat("adrenaline", ply.adrenaline or 0)
        ply:SetNWInt("stamina", ply.stamina or 100)
        ply:SetNWBool("ResistOtrub", ply.ResistOtrub or false)
        ply:SetNWInt("SharpenAMT", ply:GetNWInt("SharpenAMT") or 0)
    end
end)

-- При спавне игрока сбрасываем состояние
hook.Add("PlayerSpawn", "ResetUnconsciousTimer", function(ply)
    ply.wasUnconscious = false
    ply.unconsciousStartTime = nil

    -- Отправляем сброс клиенту
    net.Start("unconscious_timer_info")
    net.WriteBool(false)
    net.WriteFloat(0)
    net.WriteString("")
    net.Send(ply)
end)