-- Чтобы анимации работали или че там, хз не шарю
hook.Add("HandlePlayerLanding","animoverride",function()
	return true
end)

-- Пропуск различного кода при наличии у игрока god mode
hook.Add("Player Think","HasGodMode Rep",function(ply)
    ply:SetNWBool("HasGodMode",ply:HasGodMode())
end)

hook.Add("PlayerInitialSpawn","homigrad-addcallback",function(ply)
	ply:AddCallback("PhysicsCollide",function(phys,data)
		hook.Run("Player Collide",ply,data.HitEntity,data)
	end)
end)

hook.Add("PlayerDeath","PlayerClass",function(ply,inf,att)
    if IsValid(att) and att:IsPlayer() then att:PlayerClassEvent("PlayerKill",ply) end

    ply:PlayerClassEvent("PlayerDeath",att)
end)

hook.Add("Player Start Voice","PlayerClass",function(ply)
    ply:PlayerClassEvent("PlayerStartVoice")
end)

hook.Add("Player End Voice","PlayerClass",function(ply)
    ply:PlayerClassEvent("PlayerEndVoice")
end)

hook.Add("HomigradDamage","PlayerClass",function(ply,hitGroup,dmgInfo,rag)
    return ply:PlayerClassEvent("HomigradDamage",hitGroup,dmgInfo,rag)
end)

hook.Add("Player Can Lisen","PlayerClass",function(output,input,isChat)
    local result = output:PlayerClassEvent("CanLisenOutput",input,isChat)
    if result ~= nil then return result end

    local result = input:PlayerClassEvent("CanLisenInput",output,isChat)
    if result ~= nil then return result end
end)

hook.Add("Fake Up","PlayerClass",function(ply)
    return ply:PlayerClassEvent("ShouldFakeUp")
end)

hook.Add("Fake","PlayerClass",function(ply)
    return ply:PlayerClassEvent("ShouldFake")
end)

hook.Add("PlayerCanPickupWeapon","PlayerClass",function(ply,wep)
    return ply:PlayerClassEvent("ShouldUpWeapon",wep)
end)

hook.Add("PlayerCanPickupItem","PlayerClass",function(ply,item)
    return ply:PlayerClassEvent("ShouldUpItem",wep)
end)

hook.Add("Shuold JMod Armor Equip","PlayerClass",function(ply)
    return ply:PlayerClassEvent("JModArmorEquip")
end)

hook.Add("Think", "homigrad-player-thinker", function(ply)
	time = CurTime()
    
	for _, ply in player.Iterator() do
		hook.Run("Player Think", ply, time)
	end
end)