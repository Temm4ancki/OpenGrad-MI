HomicideAbilities = HomicideAbilities or {}

HomicideAbilities["ability_unstoppable_force"] = {
    name = "Неостановимая Сила",
    description = "Больше ХП и резист к отрубу, но медленнее движение",
    icon = "vgui/icon/unstoppable.png",
    price = 5,
    onPurchase = function(ply)
        if SERVER then
            ply.UnstoppableForce = true
            ply.ResistOtrub = true

            ply:SetMaxHealth(250)
            ply:SetHealth(250)

            ply:SetRunSpeed(ply:GetRunSpeed() * 0.8)
            ply:SetWalkSpeed(ply:GetWalkSpeed() * 0.8)

            ply:ChatPrint("Способность 'Неостановимая Сила' активирована!")
        end
    end
}