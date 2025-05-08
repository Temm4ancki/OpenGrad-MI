local modelsbig = {
    ["models/props_c17/oildrum001_explosive.mdl"] = true,
    ["models/combine_helicopter/helicopter_bomb01.mdl"] = true,
    ["models/props_phx/amraam.mdl"] = true,
    ["models/props_phx/facepunch_barrel.mdl"] = true,
    ["models/props_phx/oildrum001.mdl"] = true,
    ["models/props_phx/mk-82.mdl"] = true,
    ["models/props_phx/torpedo.mdl"] = true,
    ["models/props_phx/rocket1.mdl"] = true,
}

local modelssmall = {
    ["models/props_junk/gascan001a.mdl"] = true,
	["models/props_junk/propane_tank001a.mdl"] = true,
	["models/props_junk/propanecanister001a.mdl"] = true,
    ["models/props_junk/metalgascan.mdl"] = true,
    ["models/props_c17/canister02a.mdl"] = true,
    ["models/props_c17/canister01a.mdl"] = true,
    ["models/props_phx/ww2bomb.mdl"] = true,
    ["models/props_phx/cannonball.mdl"] = true,
    ["models/props/griggs/sotbx8.mdl"] = true,
}

local function BoomBig(ent)
    local SelfPos = ent:LocalToWorld(ent:OBBCenter())
    local PowerMult = 4

    timer.Simple(math.Rand(0,.1),function()
        ParticleEffect("pcf_jack_groundsplode_medium",SelfPos,vector_up:Angle())
        util.ScreenShake(SelfPos,99999,99999,1,3000)
        sound.Play("BaseExplosionEffect.Sound", SelfPos,120,math.random(90,110))

        for i = 1,4 do
            sound.Play("explosions/doi_ty_01_close.wav",SelfPos,140,math.random(80,110))
        end

        timer.Simple(.1,function()
            for i = 1, 5 do
                local Tr = util.QuickTrace(SelfPos, VectorRand() * 20)

                if Tr.Hit then
                    util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
                end
            end
        end)

		for i = 1, 10 do
			local FireVec = ( VectorRand() * .3 + Vector(0, 0, .3)):GetNormalized()
			FireVec.z = FireVec.z / 2
			local Flame = ents.Create("ent_jack_gmod_eznapalm")
			Flame:SetPos(SelfPos + Vector(0, 0, 80))
			Flame:SetAngles(FireVec:Angle())
			Flame:SetOwner(game.GetWorld())
			Flame.SpeedMul = 0.2
			Flame.Creator = game.GetWorld()
			Flame.HighVisuals = true
			Flame:Spawn()
			Flame:Activate()
		end

        -- JMod.WreckBuildings(ent, SelfPos, PowerMult/2)
        JMod.BlastDoors(ent, SelfPos, PowerMult)

        timer.Simple(0,function()
            local ZaWarudo = game.GetWorld()
            local Infl, Att = (IsValid(ent) and ent) or ZaWarudo, (IsValid(ent) and IsValid(ent.Owner) and ent.Owner) or (IsValid(ent) and ent) or ZaWarudo
            -- util.BlastDamage(Infl,Att,SelfPos,120 * PowerMult,120 * PowerMult)
            -- util.BlastDamage(Infl,Att,SelfPos,20 * PowerMult,1000 * PowerMult)

            local explosionRadius = 120 * PowerMult
            local forceRadius = 120 * PowerMult
            local damageRadius = 120 * PowerMult
            local maxForce = 250 * PowerMult
            local baseUpForce = 0.3 -- вертикальная составляющая

            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() then
                    local dist = ply:GetPos():Distance(SelfPos)
                    
                    if dist <= explosionRadius then
                        -- Вычисляем направление от взрыва к игроку
                        local dir = (ply:GetPos() - SelfPos):GetNormalized()

                        local forceDir = Vector(dir.x, dir.y, math.max(dir.z + baseUpForce, 0.1)):GetNormalized()
                        
                        -- Применяем силу от взрыва
                        if dist <= forceRadius then
                            local force = maxForce * (1 - dist/forceRadius)

                            local function ApplyExplosionForce(ragdoll)
                                if IsValid(ragdoll) then
                                    -- Получаем все физические объекты регдолла
                                    for i = 0, ragdoll:GetPhysicsObjectCount()-1 do
                                        local phys = ragdoll:GetPhysicsObjectNum(i)
                                        if IsValid(phys) then
                                            -- Основной вектор скорости с небольшим рандомом
                                            local velocityVec = forceDir * force * math.Rand(0.9, 1.1)
                                            
                                            -- Применяем скорость ко всем частям тела
                                            phys:SetVelocity(velocityVec)
                                            
                                            -- Дополнительное воздействие
                                            phys:AddAngleVelocity(VectorRand() * force * 0.005)
                                        end
                                    end
                                    
                                    -- Дополнительный толчок для всего регдолла
                                    local mainPhys = ragdoll:GetPhysicsObject()
                                    if IsValid(mainPhys) then
                                        mainPhys:ApplyForceCenter(forceDir * force * 2)
                                    end
                                end
                            end
                            if not ply.fake then
                                Faking(ply) -- Превращаем игрока в регдолл
                                
                                -- Откладываем применение силы на 0.1 секунду для создания регдолла
                                timer.Simple(0.1, function()
                                    if IsValid(ply) then
                                        ApplyExplosionForce(ply:GetNWEntity("Ragdoll"))
                                    end
                                end)
                            else
                                -- Если уже в регдолле - применяем сразу
                                ApplyExplosionForce(ply:GetNWEntity("Ragdoll"))
                            end
                        end
                        -- Наносим урон в зависимости от расстояния
                        if dist <= damageRadius then
                            local damage = 5 * PowerMult * (1 - dist/damageRadius)
                            ply:TakeDamage(damage, Att, Infl)
                        end
                    end
                end
            end
        end)
    end)
end

local function BoomSmall(ent)
    local SelfPos = ent:LocalToWorld(ent:OBBCenter())
    local PowerMult = 2

    timer.Simple(math.Rand(0,.1),function()
        ParticleEffect("pcf_jack_groundsplode_small",SelfPos,vector_up:Angle())
        util.ScreenShake(SelfPos,99999,99999,1,3000)
        sound.Play("BaseExplosionEffect.Sound", SelfPos,120,math.random(130,160))

        for i = 1,4 do
            sound.Play("explosions/doi_ty_01_close.wav",SelfPos,140,math.random(140,160))
        end

        timer.Simple(.1,function()
            for i = 1, 5 do
                local Tr = util.QuickTrace(SelfPos, VectorRand() * 20)

                if Tr.Hit then
                    util.Decal("Scorch", Tr.HitPos + Tr.HitNormal, Tr.HitPos - Tr.HitNormal)
                end
            end
        end)

        JMod.WreckBuildings(ent, SelfPos, PowerMult/2)
        JMod.BlastDoors(ent, SelfPos, PowerMult)

		for i = 1, 3 do
			local FireVec = ( VectorRand() * .3 + Vector(0, 0, .3)):GetNormalized()
			FireVec.z = FireVec.z / 2
			local Flame = ents.Create("ent_jack_gmod_eznapalm")
			Flame:SetPos(SelfPos + Vector(0, 0, 50))
			Flame:SetAngles(FireVec:Angle())
			Flame:SetOwner(game.GetWorld())
			Flame.SpeedMul = 0.25
			Flame.Creator = game.GetWorld()
			Flame.HighVisuals = true
			Flame:Spawn()
			Flame:Activate()
		end

        timer.Simple(0,function()
            local ZaWarudo = game.GetWorld()
            local Infl, Att = (IsValid(ent) and ent) or ZaWarudo, (IsValid(ent) and IsValid(ent.Owner) and ent.Owner) or (IsValid(ent) and ent) or ZaWarudo
            -- util.BlastDamage(Infl,Att,SelfPos,120 * PowerMult,120 * PowerMult)
            -- util.BlastDamage(Infl,Att,SelfPos,20 * PowerMult,1000 * PowerMult)

            local explosionRadius = 120 * PowerMult
            local forceRadius = 120 * PowerMult
            local damageRadius = 120 * PowerMult
            local maxForce = 250 * PowerMult
            local baseUpForce = 0.3 -- вертикальная составляющая

            for _, ply in ipairs(player.GetAll()) do
                if ply:Alive() then
                    local dist = ply:GetPos():Distance(SelfPos)
                    
                    if dist <= explosionRadius then
                        -- Вычисляем направление от взрыва к игроку
                        local dir = (ply:GetPos() - SelfPos):GetNormalized()

                        local forceDir = Vector(dir.x, dir.y, math.max(dir.z + baseUpForce, 0.1)):GetNormalized()
                        
                        -- Применяем силу от взрыва
                        if dist <= forceRadius then
                            local force = maxForce * (1 - dist/forceRadius)

                            local function ApplyExplosionForce(ragdoll)
                                if IsValid(ragdoll) then
                                    -- Получаем все физические объекты регдолла
                                    for i = 0, ragdoll:GetPhysicsObjectCount()-1 do
                                        local phys = ragdoll:GetPhysicsObjectNum(i)
                                        if IsValid(phys) then
                                            -- Основной вектор скорости с небольшим рандомом
                                            local velocityVec = forceDir * force * math.Rand(0.9, 1.1)
                                            
                                            -- Применяем скорость ко всем частям тела
                                            phys:SetVelocity(velocityVec)
                                            
                                            -- Дополнительное воздействие
                                            phys:AddAngleVelocity(VectorRand() * force * 0.005)
                                        end
                                    end
                                    
                                    -- Дополнительный толчок для всего регдолла
                                    local mainPhys = ragdoll:GetPhysicsObject()
                                    if IsValid(mainPhys) then
                                        mainPhys:ApplyForceCenter(forceDir * force * 2)
                                    end
                                end
                            end
                            if not ply.fake then
                                Faking(ply) -- Превращаем игрока в регдолл
                                
                                -- Откладываем применение силы на 0.1 секунду для создания регдолла
                                timer.Simple(0.1, function()
                                    if IsValid(ply) then
                                        ApplyExplosionForce(ply:GetNWEntity("Ragdoll"))
                                    end
                                end)
                            else
                                -- Если уже в регдолле - применяем сразу
                                ApplyExplosionForce(ply:GetNWEntity("Ragdoll"))
                            end
                        end
                        -- Наносим урон в зависимости от расстояния
                        if dist <= damageRadius then
                            local damage = 5 * PowerMult * (1 - dist/damageRadius)
                            ply:TakeDamage(damage, Att, Infl)
                        end
                    end
                end
            end
        end)
    end)
end

hook.Add("PropBreak","PropVengeance",function(client,prop)
    local model = prop:GetModel()

	if modelsbig[model] then BoomBig(prop) end
	if modelssmall[model] then BoomSmall(prop) end
end)

hook.Add("EntityTakeDamage", "PropBreakSystem", function(ent, dmgInfo)
    if ent:IsRagdoll() then return end
    if modelsbig[ent:GetModel()] or modelssmall[ent:GetModel()] then
        if IsValid(ent) and ent:Health() == 0 then
            local newHealth = math.Round(ent:GetPhysicsObject():GetMass() / 10)
            ent:SetHealth(math.max(newHealth, 1))
            ent.initialHealthSet = true
        end
        if ent.initialHealthSet or ent:Health() > 0 then
            ent:SetHealth(ent:Health() - (dmgInfo:GetDamage() / 4))
            if ent:Health() <= 0 then
                ent:Fire("break")
            end
        end
    end
end)

-- local function send(ply)
-- 	if not ply then
-- 		for i,ply in player.Iterator() do
-- 			if not ply:Alive() then continue end

-- 			BoomBig(ply)
-- 		end
-- 	else
-- 		BoomBig(ply)
-- 	end
-- end