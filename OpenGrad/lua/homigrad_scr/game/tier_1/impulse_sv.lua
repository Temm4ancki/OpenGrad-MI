
--[[hook.Add("EntityTakeDamage","GainImpulse",function(ply,dmginfo)
	local ply = RagdollOwner(ply) or ply
	local dmg=dmginfo:GetDamage()
	ply.dmgimpulse=ply.dmgimpulse or 0
	ply.dmgimpulse=ply.dmgimpulse+dmg
end)--]]

local vests = {
	["Heavy-Vest"] = true,
	["Light-Vest"] = true,
	["Medium-Vest"] = true,
	["Medium-Heavy-Vest"] = true,
	["Medium-Light-Vest"] = true
}

local helmets = {
	["BallisticMask"] = true,
	["Metal Bucket"] = true,
	["Metal Pot"] = true,
	["Ceramic Pot"] = true,
	["Traffic Cone"] = true,
	["Heavy-Helmet"] = true,
	["Heavy-Riot-Helmet"] = true,
	["Light-Helmet"] = true,
	["Medium-Helmet"] = true,
	["Riot-Helmet"] = true
}

local PlayerMeta = FindMetaTable("Entity")

function PlayerMeta:GetPlayerArmor()
	for i,v in pairs(self.EZarmor.items) do
		if vests[v.name] then return "vest" end
		if helmets[v.name] then return "helmet" end
	end
end

hook.Add("HomigradDamage","ImpulseShock",function(ply,hitGroup,dmginfo)
	local dmg = dmginfo:GetDamage()

	if dmginfo:IsDamageType(DMG_BLAST) then
		dmg = dmg * 4
	elseif dmginfo:IsDamageType(DMG_VEHICLE + DMG_CRUSH) and dmg > 5 then
		dmg = dmg * 0.05
	elseif dmginfo:IsDamageType(DMG_BURN + DMG_SHOCK + DMG_BUCKSHOT) then
		if ply:GetPlayerArmor()=="vest" or ply:GetPlayerArmor()=="helmet" then
			dmg = dmg
		else
			dmg = dmg * 6
		end
	elseif dmginfo:IsDamageType(DMG_BLAST + DMG_CLUB + DMG_GENERIC + DMG_SLASH) then
		if ply:GetPlayerArmor()=="vest" or ply:GetPlayerArmor()=="helmet" then
			dmg = dmg / 2
		else
			dmg = dmg * 1
		end
	elseif dmginfo:IsDamageType(DMG_NERVEGAS + DMG_DROWN) then
		dmg = 0
	else
		dmg = dmg
	end

	dmg = ply.nopain and 0.01 or dmg

	ply.dmgimpulse = ply.dmgimpulse or 0
	ply.dmgimpulse = ply.dmgimpulse + dmg

	net.Start("info_impulse")
	net.WriteFloat(ply.dmgimpulse)
	net.Send(ply)
	print(ply.dmgimpulse)
	if hitGroup == HITGROUP_RIGHTLEG or hitGroup == HITGROUP_LEFTLEG then
		if ply.dmgimpulse > 500 then 
			timer.Simple(0,function() 
				if not ply.fake then 
					Faking(ply) 
				end 
			end) 
		end
	end

	if hitGroup == HITGROUP_CHEST then
		if ply.dmgimpulse > 200 or (ply:GetPlayerArmor()=="vest" and ply.dmgimpulse > 1000) then 
			timer.Simple(0,function() 
				if not ply.fake then 
					Faking(ply) 
				end 
			end) 
		end
	end

	if hitGroup == HITGROUP_STOMACH then
		if ply.dmgimpulse > 200  or (ply:GetPlayerArmor()=="vest" and ply.dmgimpulse > 1000)  then 
			timer.Simple(0,function() 
				if not ply.fake then 
					Faking(ply) 
				end 
			end) 
		end
	end
end)

util.AddNetworkString("info_impulse")

hook.Add("Player Think","StoppingImpulse",function(ply,time)
	if ply:HasGodMode() or (ply.impulseNext or time) > time then return end
	ply.impulseNext = time + 0.05

	net.Start("info_impulse")
	net.WriteFloat(ply.dmgimpulse)
	net.Send(ply)

	ply.dmgimpulse  = math.max(ply.dmgimpulse - 3,0)
end)

hook.Add("PlayerSpawn","homgirad-impulse",function(ply)
	if PLYSPAWN_OVERRIDE then return end
	ply.dmgimpulse = 0
	ply.impulseNext = 0

	net.Start("info_impulse")
	net.WriteFloat(0)
	net.Send(ply)
end)
