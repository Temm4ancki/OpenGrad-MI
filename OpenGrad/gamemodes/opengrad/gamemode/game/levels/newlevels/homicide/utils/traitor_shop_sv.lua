if CLIENT then return end

util.AddNetworkString("traitor_shop_request")
util.AddNetworkString("traitor_shop_credits")
util.AddNetworkString("traitor_shop_presets")
util.AddNetworkString("traitor_shop_buy")
util.AddNetworkString("traitor_shop_buy_preset")

local function GiveTraitorCredits(ply, amount)
    ply.TraitorCredits = (ply.TraitorCredits or 0) + amount
    
    net.Start("traitor_shop_credits")
    net.WriteInt(ply.TraitorCredits, 8)
    net.Send(ply)
end

local function GetTraitorCredits(ply)
    return ply.TraitorCredits or 0
end

local function SpendTraitorCredits(ply, amount)
    if GetTraitorCredits(ply) >= amount then
        ply.TraitorCredits = ply.TraitorCredits - amount
        
        net.Start("traitor_shop_credits")
        net.WriteInt(ply.TraitorCredits, 8)
        net.Send(ply)
        
        return true
    end
    return false
end

local function GetAvailablePresets()
    local presets = {}
    
    if HomicidePresets then
        for id, preset in pairs(HomicidePresets) do
            local price = preset.price
            if not price and CalculatePresetPrice then
                price = CalculatePresetPrice(preset)
                preset.price = price
            end
            
            table.insert(presets, {
                id = id,
                name = preset.name,
                description = preset.description,
                price = price or 0,
                model = preset.model,
                weapons = preset.weapons,
                abilities = preset.abilities
            })
        end
    end
    
    return presets
end

local function GiveAbility(ply, abilityClass)
    if not HomicideAbilities or not HomicideAbilities[abilityClass] then return false end
    
    local ability = HomicideAbilities[abilityClass]
    if ability.onPurchase then
        ability.onPurchase(ply)
    end
    
    ply.PurchasedAbilities = ply.PurchasedAbilities or {}
    ply.PurchasedAbilities[abilityClass] = true
    
    return true
end

hook.Add("homicide.StartRound", "GiveTraitorCredits", function()
    for _, ply in ipairs(homicide.t or {}) do
        if IsValid(ply) then
            ply.TraitorCredits = TRAITOR_SHOP_CONFIG.DEFAULT_CREDITS
            ply.PurchasedAbilities = {}
            
            net.Start("traitor_shop_credits")
            net.WriteInt(ply.TraitorCredits, 8)
            net.Send(ply)
        end
    end
end)

net.Receive("traitor_shop_request", function(len, ply)
    if not IsValid(ply) or not ply.roleT then return end
    
    net.Start("traitor_shop_credits")
    net.WriteInt(GetTraitorCredits(ply), 8)
    net.Send(ply)
    
    net.Start("traitor_shop_presets")
    net.WriteTable(GetAvailablePresets())
    net.Send(ply)
end)

net.Receive("traitor_shop_buy", function(len, ply)
    if not IsValid(ply) or not ply.roleT then return end
    
    local itemClass = net.ReadString()
    local price = GetHomicideItemPrice(itemClass)
    
    if price == 0 and not string.StartWith(itemClass, "ability_") then
        ply:ChatPrint("Неизвестный предмет!")
        return
    end
    
    if not SpendTraitorCredits(ply, price) then
        ply:ChatPrint("Недостаточно кредитов!")
        return
    end
    
    if string.StartWith(itemClass, "ability_") then
        if GiveAbility(ply, itemClass) then
            ply:ChatPrint("Способность " .. itemClass .. " приобретена!")
        else
            GiveTraitorCredits(ply, price)
            ply:ChatPrint("Ошибка при покупке способности!")
        end
    else
        if ply:HasWeapon(itemClass) then
            ply:ChatPrint("У вас уже есть этот предмет!")
            GiveTraitorCredits(ply, price)
            return
        end
        
        ply:Give(itemClass)
        ply:ChatPrint("Предмет " .. itemClass .. " приобретен!")
    end
end)

net.Receive("traitor_shop_buy_preset", function(len, ply)
    if not IsValid(ply) or not ply.roleT then return end
    
    local presetId = net.ReadString()
    
    if not HomicidePresets or not HomicidePresets[presetId] then
        ply:ChatPrint("Неизвестный пресет!")
        return
    end
    
    local preset = HomicidePresets[presetId]
    local price = preset.price or 0
    
    if not SpendTraitorCredits(ply, price) then
        ply:ChatPrint("Недостаточно кредитов!")
        return
    end
    
    ply:StripWeapons()
    ply:Give("weapon_hands")
    
    if preset.weapons then
        for _, weapon in ipairs(preset.weapons) do
            ply:Give(weapon)
        end
    end
    
    if preset.abilities then
        for _, ability in ipairs(preset.abilities) do
            GiveAbility(ply, ability)
        end
    end

    ply.SelectedPreset = presetId
    ply:ChatPrint("Пресет " .. preset.name .. " применен!")
end)

hook.Add("PlayerDeath", "ResetTraitorShop", function(victim)
    if IsValid(victim) then
        victim.TraitorCredits = nil
        victim.PurchasedAbilities = nil
        victim.SelectedPreset = nil
    end
end)