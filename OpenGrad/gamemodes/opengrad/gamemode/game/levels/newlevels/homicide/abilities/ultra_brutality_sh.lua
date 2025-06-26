HomicideAbilities = HomicideAbilities or {}

HomicideAbilities["ability_ultra_brutality"] = {
    name = "Ультра Жестокость",
    description = "Повышает скорость атаки и резист к отрубу за каждое убийство",
    icon = "vgui/icon/brutality.png",
    price = 5,
    onPurchase = function(ply)
        if SERVER then
            ply.UltraBrutality = true
            ply.BrutalityKills = 0
            ply:ChatPrint("Способность 'Ультра Жестокость' активирована!")
        end
    end,
    onKill = function(ply, victim)
        if SERVER and ply.UltraBrutality then
            ply.BrutalityKills = (ply.BrutalityKills or 0) + 1
            
            local baseSpeed = 200
            local speedBoost = baseSpeed * (1 + (ply.BrutalityKills * 0.15))
            
            ply:SetRunSpeed(speedBoost)
            ply:SetWalkSpeed(speedBoost * 0.5)
            
            if ply.BrutalityKills >= 3 then
                ply.ResistOtrub = true
            end
            
            ply:ChatPrint("Жестокость растет! Убийств: " .. ply.BrutalityKills)
        end
    end
}