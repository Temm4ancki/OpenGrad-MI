-- хуйня для удобства ввода на клиенте, а то я заебался нахуй @temm4ancki

concommand.Add("hg_level_end", function(ply, cmd, args)
    net.Start("HGLEVEL_END_COMMAND")
    net.SendToServer()
end)

net.Receive("SendLevelNextList", function()
    LevelList = net.ReadTable()
end)

local function AutoCompleteHGLevelNext(cmd, arg)
    if not LevelList then return {} end

    local suggestions = {}
    for _, level in ipairs(LevelList) do
        table.insert(suggestions, cmd .. " " .. level)
    end
    return suggestions
end

concommand.Add("hg_level_next", function(ply, cmd, args)
    net.Start("HGLEVEL_NEXT_COMMAND")
    net.WriteString(args[1] or "")
    net.SendToServer()
end, AutoCompleteHGLevelNext)