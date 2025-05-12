util.AddNetworkString("OpenLootingUI")


hook.Add("PlayerUse","lootUse", function(ply,ent)
    -- if not IsValid(ent) then return end
    -- mdl = (ent:GetModel() or "")

    -- if lootable_extra_small[mdl] then print("у меня пенис")
    -- elseif lootable_small[mdl] then 
    --     if SERVER then
    --         net.Start("OpenLootingUI")
    --         net.Send(ply)
    --     end
    -- elseif lootable_medium[mdl] then print("lootable_medium")
    -- elseif lootable_big[mdl] then print("lootable_big") 

    -- else print("подо мной пенис") end
end)