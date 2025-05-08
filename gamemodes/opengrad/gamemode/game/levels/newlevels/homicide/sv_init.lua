changeClass = {
	["prop_vehicle_jeep"]="vehicle_van",
	["prop_vehcle_jeep_old"]="vehicle_van",
	["prop_vehicle_airboat"]="vehicle_van",
	["weapon_crowbar"]="weapon_bat",
	["weapon_stunstick"]="weapon_knife",
	["weapon_pistol"]="weapon_glock",
	["weapon_357"]="weapon_deagle",
	["weapon_shotgun"]="weapon_m3super",
	--["weapon_crossbow"]="weapon_kar98k",
	["weapon_ar2"]="weapon_ar15",
	["weapon_smg1"]="weapon_ar15",
	["weapon_frag"]="weapon_hg_f1",
	["weapon_slam"]="weapon_hg_molotov",

	["weapon_rpg"]="ent_ammo_46×30mm",
	["item_ammo_ar2_altfire"]="ent_ammo_762x39mm",
	["item_ammo_357"]="ent_ammo_.44magnum",
	["item_ammo_357_large"]="ent_ammo_.44magnum",
	["item_ammo_pistol"]="ent_ammo_9х19mm",
	["item_ammo_pistol_large"]="ent_ammo_9х19mm",
	["item_ammo_ar2"]="ent_ammo_556x45mm",
	["item_ammo_ar2_large"]="ent_ammo_556x45mm",
	["item_ammo_ar2_smg1"]="ent_ammo_545×39mm",
	["item_ammo_ar2_large"]="ent_ammo_556x45mm",
	["item_ammo_smg1"]="ent_ammo_545×39mm",
	["item_ammo_smg1_large"]="ent_ammo_762x39mm",
	["item_box_buckshot"]="ent_ammo_12/70gauge",
	["item_box_buckshot_large"]="ent_ammo_12/70gauge",
	["item_rpg_round"]="ent_ammo_57×28mm",
	["item_ammo_crate"]="ent_ammo_9x39mm",

	["item_healthvial"]="med_band_small",
	["item_healthkit"]="med_band_big",
	["item_healthcharger"]="medkit",
	["item_suitcharger"]="painkiller",
	["item_battery"]="blood_bag",
	["weapon_alyxgun"]={"food_fishcan","food_lays","food_monster","food_spongebob_home"}
}

local function GetFriends(play)
    
    local huy = ""

    for i, ply in pairs(homicide.t) do
        if play == ply then continue end
        huy = huy .. ply:Name() .. ", "
    end

    return huy
end

local function makeT(ply)
    if !IsValid(ply) then return end
	ply.roleT = true
    table.insert(homicide.t, ply)
    if homicide.roundType == 1 then
        SpawnBadGuy(ply,{
            "weapon_kabar",
            "weapon_hk_usps", 
            "weapon_hidebomb", 
            "weapon_hg_m26",
            "weapon_jahidka"
        })
    elseif homicide.roundType == 2 then
        SpawnBadGuy(ply,{
            "weapon_kabar", 
            "weapon_hg_t_syringepoison", 
            "weapon_hg_t_vxpoison",
            "weapon_hidebomb",
            "weapon_hg_m26",
            "weapon_jahidka"
        })
    elseif homicide.roundType == 3 then
        SpawnBadGuy(ply,{
            "weapon_kabar",
            "weapon_hg_t_syringepoison",
            "weapon_hg_t_vxpoison",
        })
    elseif homicide.roundType == 4 then
        SpawnBadGuy(ply,{
            "weapon_kabar",
            "weapon_hidebomb",
            "weapon_hg_m26",
            "weapon_jahidka"
        })
        ply:GiveAmmo(12,5)
    elseif homicide.roundType == 5 then
        SpawnBadGuy(ply,{
            "weapon_kabar",
            "weapon_hidebomb",
            "weapon_hg_usps"
        })
    end

    timer.Simple(5,function() ply.allowFlashlights = true end)

    if #GetFriends(ply) >= 1 then
        timer.Simple(1,function() AddNotificate( ply,"Ваши товарищи " .. GetFriends(ply)) end)
    end
end

local function makeCT(ply)
    if !IsValid(ply) then return end

    ply.roleCT = true
    table.insert(homicide.ct,ply)
    if     homicide.roundType == 1 then 
        SpawnBadGuy(ply,{
            "weapon_m3super"
        })
    elseif homicide.roundType == 2 then 
        SpawnBadGuy(ply,{
            "weapon_beretta"
        })
    elseif homicide.roundType == 3 then 
        SpawnBadGuy(ply,{
            "weapon_police_bat",
            "weapon_taser"
        })
    elseif homicide.roundType == 4 then 
        SpawnBadGuy(ply,{
            "weapon_m3super"
        })
    elseif homicide.roundType == 5 then
        SpawnBadGuy(ply,{
            "weapon_beretta"
        }) 
    end
end

function homicide.Spawns()
    local available = {}

    for i,ent in pairs(ents.FindByClass("info_player*")) do
        table.insert(available,ent:GetPos())
    end

    for i,ent in pairs(ents.FindByClass("info_node*")) do
        table.insert(available,ent:GetPos())
    end

    for i,point in pairs(ReadDataMap("spawnpointst")) do
        table.insert(available,point)
    end

    for i,point in pairs(ReadDataMap("spawnpointsct")) do
        table.insert(available,point)
    end

    return available
end

sound.Add({
	name = "police_arrive",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = 100,
	sound = "snd_jack_hmcd_policesiren.wav"
})

function homicide.StartRoundSV()
    tdm.ChangeTeams(2,1,1)

    homicide.police = false
	roundTimeStart = CurTime()
	roundTime = math.max(math.ceil(#player.GetAll() / 2), 1) * 75

    if homicide.roundType == 3 then
        roundTime = roundTime / 2
    end

    roundTimeLoot = 5

    for i,ply in pairs(team.GetPlayers(2)) do ply:SetTeam(1) end

    homicide.ct = {}
    homicide.t = {}

    local countT = 0
    local countCT = 0

    local available = homicide.Spawns()
    tdm.SpawnCommand(PlayersInGame(),available,function(ply)
        ply.roleT = false
        ply.roleCT = false

        if homicide.roundType == 4 then
            timer.Simple(0,function()
                ply:Give("weapon_deagle")
            end)
        end

        if ply.forceT then
            ply.forceT = nil
            countT = countT + 1

            makeT(ply)
        end

        if ply.forceCT then
            ply.forceCT = nil
            countCT = countCT + 1

            makeCT(ply)
        end
    end)

    local players = PlayersInGame()
    local count = math.max(math.random(1,math.ceil(#players / 16)),1) - countT
    for i = 1,count do
        local ply = table.Random(players)
        table.RemoveByValue(players,ply)

        makeT(ply)
    end

    local count = math.max(math.random(1,math.ceil(#players / 16)),1) - countCT

    for i = 1,count do
        local ply = table.Random(players)
        table.RemoveByValue(players,ply)

        makeCT(ply)
    end

    timer.Simple(0,function()
        for i,ply in pairs(homicide.t) do
            if not IsValid(ply) then table.remove(homicide.t,i) continue end

            homicide.SyncRole(ply,1)
        end

        for i,ply in pairs(homicide.ct) do
            if not IsValid(ply) then table.remove(homicide.ct,i) continue end

            homicide.SyncRole(ply,2)
        end
    end)

    return {roundTimeLoot = roundTimeLoot}
end

local available = ReadDataMap("spawnpointsct")

function homicide.RoundEndCheck()

	local TAlive = tdm.GetCountLive(homicide.t)
	local Alive = tdm.GetCountLive(team.GetPlayers(1),function(ply) if ply.roleT or ply.isContr then return false end end)

    if roundTimeStart + roundTime < CurTime() and not homicide.police then
        homicide.police = true
        if homicide.roundType == 1 then
            PrintMessage(3,"Приехал спецназ.")
        else
            PrintMessage(3,"Приехала полиция.")
        end

        local available = ReadDataMap("spawnpointsct")
        local ctPlayers = tdm.GetListMul(player.GetAll(),1,function(ply) return not ply:Alive() and not ply.roleT and ply:Team() ~= 1002 end)
        
        local playsound = true
        tdm.SpawnCommand(ctPlayers,available,function(ply)
            timer.Simple(0,function()
                if homicide.roundType == 1 then
                    ply:SetPlayerClass("contr")
                else
                    ply:SetPlayerClass("police")
                end
                if playsound then
                    ply:EmitSound("police_arrive")
                    playsound = false
                end
                ply:ConCommand("hg_bodycam 0")
            end)
        end)
	end

	if TAlive == 0 and Alive == 0 then EndRound(1) return end

	if TAlive == 0 then EndRound(2) end
	if Alive == 0 then EndRound(1) end
end

function homicide.EndRound(winner)
    if #PlayersInGame() < 2 then 
        PrintMessage(3, "Недостаточно игроков. Раунд завершен.")
        return
    end
    PrintMessage(3,(winner == 1 and "Победа предателей." or winner == 2 and "Победа невиновых." or "Ничья"))
    if homicide.t and #homicide.t > 0 then
        PrintMessage(3,#homicide.t > 1 and ("Трейторами были: " .. homicide.t[1]:Name() .. ", " .. GetFriends(homicide.t[1])) or ("Трейтором был: " .. homicide.t[1]:Name()))
    end
end

local empty = {}

function homicide.PlayerSpawn(ply,teamID)
    local teamTbl = homicide[homicide.teamEncoder[teamID]]
    local color = teamID == 1 and Color(math.random(55,165),math.random(55,165),math.random(55,165)) or teamTbl[2]
    if homicide.roundType ~= 1 then
	    ply:SetModel(teamTbl.models[math.random(#teamTbl.models)] or "models/player/group01/male_03.mdl")
    else
        ply:SetModel(models_rebels[math.random(#models_rebels)] or "models/player/group03/male_01.mdl")
    end
    ply:SetPlayerColor(color:ToVector())

	ply:Give("weapon_hands")
	ply:ConCommand("hg_bodycam 0")
    timer.Simple(0,function() ply.allowFlashlights = false end)
end

function homicide.PlayerInitialSpawn(ply)
    ply:SetTeam(1)
end

function homicide.PlayerCanJoinTeam(ply,teamID)
-- uncomment maybe
--     if ply:IsAdmin() then
--         if teamID == 2 then ply.forceCT = nil ply.forceT = true ply:ChatPrint("Ты будешь за шерифа некст раунд") return false end
--         if teamID == 3 then ply.forceT = nil ply.forceCT = true ply:ChatPrint("Ты будешь за предателя некст раунд") return false end
--     else
--         if teamID == 2 or teamID == 3 then ply:ChatPrint("Рип бозо") return false end
--     end

     return true
end

util.AddNetworkString("homicide_roleget")

function homicide.SyncRole(ply,teamID)
    local role = {{},{}}

    for i,ply in pairs(team.GetPlayers(1)) do
        if teamID ~= 2 and ply.roleT then table.insert(role[1],ply) end
        if teamID ~= 1 and ply.roleCT then table.insert(role[2],ply) end
    end

    net.Start("homicide_roleget")
    net.WriteTable(role)
    net.Send(ply)
end

function homicide.PlayerDeath(ply,inf,att) return false end

local common = {"food_lays","weapon_pipe","weapon_bat","med_band_big","med_band_small","medkit","food_monster","food_fishcan","food_spongebob_home"}
local uncommon = {"medkit","weapon_molotok","painkiller"}
local rare = {"weapon_glock18","weapon_gurkha","weapon_t","weapon_per4ik","*ammo*"}

function homicide.ShouldSpawnLoot()
    --[[
    Структура лут таблиц
    local lootingTable = {
        ["mdl name"] = {
            ["unique category name"] = {
                ["chance"] = number,
                ["loot"] = {
                    ["weapon name"] = number, -- chance
                    ["weapon name"] = number,
                    ["weapon name"] = number,
                }
            },
        },
    }
    ]]
    local lootingTable = {
        ["models/props_junk/trashdumpster01a.mdl"] = {
            ["weapons"] = {
                ["chance"] = 100,
                ["loot"] = {
                    ["weapon_m3super"] = 100,
                }
            },
        },
    }

    if false then return false end

    return true, lootingTable
end

function homicide.GuiltLogic(ply,att,dmgInfo)
    return ply.roleT == att.roleT
end

function tdm.GetCountLive(list,func)
	local count = 0
	local result

	for i,ply in pairs(list) do
		if not IsValid(ply) then continue end

		result = func and func(ply)
		if result == true then count = count + 1 continue elseif result == false then continue end
		if ply:Alive() then count = count + 1 end
        -- uncomment
		-- if not PlayerIsCuffs(ply) and ply:Alive() then count = count + 1 end
	end

	return count
end

function tdm.GetListMul(list,mul,func,max)
	local newList = {}
	mul = math.Round(#list * mul)
	if max then mul = math.max(mul,max) end

	for i = 1,mul do
		local ply,key = table.Random(list)
		list[key] = nil

		if func and func(ply) ~= true then continue end

		newList[#newList + 1] = ply
	end

	return newList
end