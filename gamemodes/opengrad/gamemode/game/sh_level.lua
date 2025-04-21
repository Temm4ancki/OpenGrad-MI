timer.Simple(0,function()
    if roundActiveName == nil then
        roundActiveName = "homicide"
        roundActiveNameNext = "homicide"
        StartRound()
    end
end)