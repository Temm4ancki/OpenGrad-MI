LevelList = {}
function TableRound(name) return _G[name or roundActiveName] end

timer.Simple(0,function() -- Timer Failed! [Simple][@addons/opengrad/gamemodes/opengrad/gamemode/game/sh_level.lua (line 4)]
    if roundActiveName == nil then
        roundActiveName = "homicide"
        roundActiveNameNext = "homicide"
        StartRound()
    end
end)