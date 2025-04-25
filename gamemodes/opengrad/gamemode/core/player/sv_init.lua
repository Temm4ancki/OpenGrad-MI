-- Функции с методами игрока
function GM:PlayerSpawn(ply)
    ply:SetNWEntity("HeSpectateOn",false)
	if PLYSPAWN_OVERRIDE then
        return
    end
    ply.allowFlashlights = false

    ply:RemoveFlags(FL_ONGROUND)
    ply:SetMaterial("")

	--jmod cum incoming
	net.Start("remove_jmod_effects")
	net.Broadcast()
	--jmod cum end

	--переменные для единичного отображения сообщения о сломанных ногах в чате
	ply.firstTimeNotifiedLeftLeg = true
	ply.firstTimeNotifiedRightLeg = true

	ply:SetCanZoom(false)
	ply.Blood = 5000
	ply.pain = 0

	if ply.NEEDKILLNOW then
		if ply.NEEDKILLNOW == 1 then ply:KillSilent() else ply:KillSilent() end

		ply.NEEDKILLNOW = nil

		return
	end

	if not ply:Alive() then return end

	ply:UnSpectate()
	ply:SetupHands()

    if ply:GetNWBool("DynamicFlashlight") then
        ply:Flashlight(false)
    end

	ply:SetHealth(150)
	ply:SetMaxHealth(150)
	ply:SetWalkSpeed(200)
	ply:SetRunSpeed(350)
	ply:SetSlowWalkSpeed(75)
	ply:SetLadderClimbSpeed(75)
	ply:SetJumpPower(200)

	local size = 9

	ply.slots = {}

	ply:SetNWVector("HullMin",Vector(-size,-size,0))
	ply:SetNWVector("Hull",Vector(size,size,DEFAULT_VIEW_OFFSET[3]))
	ply:SetNWVector("HullDuck",Vector(size,size,DEFAULT_VIEW_OFFSET_DUCKED[3]))

	ply:SetHull(ply:GetNWVector("HullMin"),ply:GetNWVector("Hull"))
	ply:SetHullDuck(ply:GetNWVector("HullMin"),ply:GetNWVector("HullDuck"))

	ply:SetViewOffset(DEFAULT_VIEW_OFFSET)
	ply:SetViewOffsetDucked(DEFAULT_VIEW_OFFSET_DUCKED)

	local phys = ply:GetPhysicsObject()
	if phys:IsValid() then phys:SetMass(DEFAULT_MASS) end

	ply:SetPlayerClass()

	if ply:Team() == 1002 then
		ply:SetModel("models/player/gman_high.mdl")
		ply:SetPlayerColor(Vector(0.25,0.25,0.25))

		ply:Give("weapon_hands")
		ply:Give("weapon_physgun")

		return
	end

	ply:PlayerClassEvent("On")
	TableRound().PlayerSpawn(ply,ply:Team())
end

function GM:PlayerDeath(ply,inf,att)
	if not roundActive then return end

	if att == ply then att = ply.Attacker2 end
	if not IsValid(att) or att == ply or not att:IsPlayer() then return end

	ply.allowGrab = false
	timer.Simple(3,function() ply.allowGrab = true end)
end

function GM:PlayerInitialSpawn(ply)
	local func = TableRound().PlayerInitialSpawn
	if func then func(ply) else ply:SetTeam(1002) end

	if #player.GetAll() < 2 then EndRound() end
	
	ply.NEEDKILLNOW = 2
	ply.allowGrab = true

	RoundTimeSync(ply)
	RoundStateSync(ply,RoundData)

	RoundActiveSync(ply)
	RoundActiveNextSync(ply)

	SendSpawnPoint(ply)
	if SERVER and IsValid(ply) then
		ply:KillSilent()
	end
end

function GM:PlayerDeathThink(ply)
	local tbl = {}

	for _, ply in ipairs(player.GetAll()) do
		if not ply:Alive() then continue end

		tbl[#tbl + 1] = ply
	end

	local key = ply:KeyDown(IN_RELOAD)
	if key ~= ply.oldKeyWalk and key then
		ply.EnableSpectate = not ply.EnableSpectate
		ply:ChatPrint(ply.EnableSpectate and "Наблюдение за игроками." or "Свободный полёт.")
	end

	ply.oldKeyWalk = key

	ply.SpectateGuy = ply.SpectateGuy or 0
	if ply.SpectateGuy > #tbl then
		ply.SpectateGuy = #tbl
	end

	if ply.EnableSpectate then
		ply:Spectate(OBS_MODE_CHASE)
		local key1 = ply:KeyDown(IN_ATTACK)
		local key2 = ply:KeyDown(IN_ATTACK2)

		if ply.oldKeyAttack1 ~= key1 and key1 then
			ply.SpectateGuy = ply.SpectateGuy + 1
			if ply.SpectateGuy > #tbl then ply.SpectateGuy = 1 end
		elseif ply.oldKeyAttack2 ~= key2 and key2 then
			ply.SpectateGuy = ply.SpectateGuy - 1
			if ply.SpectateGuy == 0 then ply.SpectateGuy = #tbl end
		end

		local spec = tbl[ply.SpectateGuy]
		if not IsValid(spec) then ply.SpectateGuy = 1 return end
		ply:SetPos(spec:GetPos() + Vector(0,0,40))
		local spec = spec
		ply:SetNWEntity("HeSpectateOn",spec)
		ply:SetMoveType(MOVETYPE_NONE)
		ply.oldKeyAttack1 = key1
		ply.oldKeyAttack2 = key2
	else
		ply:UnSpectate()
		ply:SetMoveType(MOVETYPE_NOCLIP)
		ply:SetNWEntity("HeSpectateOn",false)

		if ply:KeyDown(IN_ATTACK) then
			local tr = {}
			tr.start = ply:GetPos()
			tr.endpos = tr.start + ply:GetAimVector() * 128
			tr.filter = ply

			local traceResult = util.TraceLine(tr)
			local bot = traceResult.Entity

			if not bot:IsNPC() then return end

			hook.Run("Spectate NPC",ply,bot)
		end
	end

	local func = TableRound().PlayerDeathThink

	if func then
		return func(ply)
	else
		if roundActive then
			return false
		else
			return true
		end
	end
end

local function PlayerCanJoinTeam(ply,teamID)
	local addT,addCT = 0,0
	if teamID == 1 then addT = 1 end
	if teamID == 2 then addCT = 1 end

	local favorT,count = NeedAutoBalance(addT,addCT)

	if count and ((teamID == 1 and favorT) or (teamID == 2 and not favorT)) then
		ply:ChatPrint("Команда полная.")

		return false
	end

	return true
end

function GM:PlayerCanJoinTeam(ply,teamID)
	if teamID == 1002 then ply.NEEDKILLNOW = 1 end
	if ply:Team() == 1002 then ply.NEEDKILLNOW = 2 end
	if teamID == 1002 then return true end

	local result = TableRound().PlayerCanJoinTeam(ply,teamID)
	if result ~= nil then return result end

	result = PlayerCanJoinTeam(ply,teamID)
	if result ~= nil then return result end
end

function GM:PlayerDisconnected(ply) end

function GM:DoPlayerDeath(ply) end

function GM:PlayerDeathSound()
    return true
end

function GM:PlayerStartVoice(ply)
	if ply:Alive() then return true end
end

function GM:ShowSpare1(ply)
	net.Start("menuska")
	net.Send(ply)
end

local classList = player.classList

local Player = FindMetaTable("Player")

function Player:SetPlayerClass(value)
    value = value or "none"

    local old = self.PlayerClassName
    self.PlayerClassNameOld = old
    old = classList[old]
    if old and old.Off then old.Off(self) end

    self.PlayerClassName = value
    self:PlayerClassEvent("On")

    net.Start("setupclass")
    net.WriteEntity(self)
    net.WriteString(value)
    net.WriteString(self.PlayerClassNameOld or "")
    net.Broadcast()
end

util.AddNetworkString("remove_jmod_effects")

-- бесконечный цикл для лазера
util.AddNetworkString("lasertgg")
net.Receive("lasertgg",function(len,ply)
	local boolen = net.ReadBool()
	net.Start("lasertgg")
	net.WriteEntity(ply)
	net.WriteBool(boolen)
	net.Broadcast()
end)

-- работа "C"-menu?
util.AddNetworkString("menuska")

util.AddNetworkString("setupclass")
