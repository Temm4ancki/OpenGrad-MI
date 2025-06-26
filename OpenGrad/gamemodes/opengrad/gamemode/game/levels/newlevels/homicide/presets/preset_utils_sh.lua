function CalculatePresetPrice(preset)
    local totalPrice = 0
    
    if preset.weapons then
        for _, weapon in ipairs(preset.weapons) do
            totalPrice = totalPrice + GetHomicideItemPrice(weapon)
        end
    end
    
    if preset.abilities then
        for _, ability in ipairs(preset.abilities) do
            totalPrice = totalPrice + GetHomicideItemPrice(ability)
        end
    end
    
    return totalPrice
end

function UpdatePresetPrices()
    if not HomicidePresets or not GetHomicideItemPrice then return end
    
    for id, preset in pairs(HomicidePresets) do
        preset.price = CalculatePresetPrice(preset)
    end
end

hook.Add("Initialize", "UpdateHomicidePresetPrices", function()
    timer.Simple(1, function()
        UpdatePresetPrices()
        timer.Simple(5, UpdatePresetPrices)
    end)
end)