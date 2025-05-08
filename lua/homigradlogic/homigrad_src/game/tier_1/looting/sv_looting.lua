local function LootingWorld(ply, ent)
    net.Start("inventory")
    net.WriteEntity(ent)

    net.WriteTable(ent.Info.Weapons)
    net.WriteTable(ent.Info.Ammo)
    net.Send(ply) 
end

local function SpawnLoot(ent)
    ent.Info = {}
    ent.Info.Weapons = {}
    ent.Info.Weapons2 = {}
    ent.Info.Ammo = {}

    local result, lootingTable = TableRound().ShouldSpawnLoot()

    if not result then return end

    -- lootingTable type validation
    --print("=====\nLootingTable validation start\n=====")
    if type(lootingTable) ~= "table" then return end
    for modelName, modelData in pairs(lootingTable) do
        --print("modelName:", type(modelName))
        --print("modelData:", type(modelData))
        if type(modelName) ~= "string" or type(modelData) ~= "table" then return end
        
        --print()

        for categoryName, categoryData in pairs(modelData) do
            --print("categoryName:", type(categoryName))
            --print("categoryData:", type(categoryData))
            if type(categoryName) ~= "string" or type(categoryData) ~= "table" then return end

            --print()

            --print("categoryData['chance']:", type(categoryData["chance"]))
            --print("categoryData['loot']:", type(categoryData["loot"]))
            if type(categoryData["chance"]) ~= "number" or type(categoryData["loot"]) ~= "table" then return end
            
            --print()

            for itemName, chance in pairs(categoryData["loot"]) do
                --print("itemName", type(itemName))
                --print("chance", type(chance))
                if type(itemName) ~= "string" or type(chance) ~= "number" then return end
            end
        end
    end
    --print("=====\nLootingTable validation end\n=====")

    for _, categoryData in pairs(lootingTable[ent:GetModel()]) do
        local categoryMathChance = math.random(0,100)

        if categoryMathChance > categoryData["chance"] then
            -- не выпало, пропускаем
        else    
            for itemName, chance in pairs(categoryData["loot"]) do
                local itemMathChance = math.random(0,100)
                
                if itemMathChance > chance then
                    -- не выпало, пропускаем
                else
                    local wep = weapons.Get(itemName)
                
                    ent.Info.Weapons[wep.ClassName] ={
                        Clip1=wep.Primary.DefaultClip,
                        Clip2=0,
                        AmmoType=wep.Primary.Ammo
                    }
                    ent.Info.Weapons2[0] = wep.ClassName
                end
            end
        end
    end
end

hook.Add("Player Think", "LootingWorld", function(ply)
    if not ply.fake and ply:Alive() and ply:KeyPressed(IN_USE) then 
        local trace = {}

        trace.start = ply:GetAttachment(ply:LookupAttachment("eyes")).Pos
        trace.endpos = trace.start + ply:EyeAngles():Forward() * 64
        trace.filter = ply

        local traceA = util.TraceLine(trace)
        local hitEnt = traceA.Entity

        if not IsValid(hitEnt) then return end
        if IsValid(RagdollOwner(hitEnt)) or hitEnt:GetClass() == "prop_ragdoll" then return end

        local func = TableRound().ShouldSpawnLoot
        if not func then return end
        
        if hitEnt.Info == nil then SpawnLoot(hitEnt) end

        hitEnt.UsersInventory = hitEnt.UsersInventory or {}
        hitEnt.UsersInventory[ply] = true
        LootingWorld(ply, hitEnt)
    end
end)