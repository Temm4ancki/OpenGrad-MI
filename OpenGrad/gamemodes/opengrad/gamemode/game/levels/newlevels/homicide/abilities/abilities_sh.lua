HomicideAbilities = HomicideAbilities or {}

if SERVER then
    hook.Add("PlayerDeath", "HomicideAbilities_OnKill", function(victim, inflictor, attacker)
        if IsValid(attacker) and attacker:IsPlayer() and attacker.roleT then
            for abilityId, ability in pairs(HomicideAbilities) do
                if attacker.PurchasedAbilities and attacker.PurchasedAbilities[abilityId] and ability.onKill then
                    ability.onKill(attacker, victim)
                end
            end
        end
    end)

    hook.Add("PlayerSpawn", "HomicideAbilities_Reset", function(ply)
        ply.UltraBrutality = nil
        ply.BrutalityKills = nil
        ply.UnstoppableForce = nil
        ply.ResistOtrub = nil
        ply.PurchasedAbilities = nil
    end)
end