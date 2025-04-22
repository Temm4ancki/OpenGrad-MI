local ROOT = "homigradLogic"
local shInitFiles, svInitFiles, clInitFiles, otherFiles = {}, {}, {}, {}
local function scanDir(dir)
    local luaFiles = file.Find(dir .. "/*.lua", "LUA")
    for _, filename in ipairs(luaFiles) do
        local fullpath = dir .. "/" .. filename
        if filename == "sh_init.lua" then
            table.insert(shInitFiles, fullpath)
        elseif filename == "sv_init.lua" then
            table.insert(svInitFiles, fullpath)
        elseif filename == "cl_init.lua" then
            table.insert(clInitFiles, fullpath)
        elseif string.StartWith(filename, "sh_") or string.StartWith(filename, "sv_") or string.StartWith(filename, "cl_") then
            table.insert(otherFiles, fullpath)
        end
    end
    local _, subdirs = file.Find(dir .. "/*", "LUA")
    for _, sub in ipairs(subdirs) do scanDir(dir .. "/" .. sub) end
end
local _, topFolders = file.Find(ROOT .. "/*", "LUA")
for _, folder in ipairs(topFolders) do scanDir(ROOT .. "/" .. folder) end
table.sort(shInitFiles)
table.sort(svInitFiles)
table.sort(clInitFiles)
table.sort(otherFiles)
-- shared
for _, file in ipairs(shInitFiles) do
    if SERVER then
        AddCSLuaFile(file)
        print("[SERVER]sent: " .. file)
        include(file)
        print("[SERVER] included: " .. file)
    elseif CLIENT then
        include(file)
		print("[CLIENT] included: " .. file)
    end
end
-- server
for _, file in ipairs(svInitFiles) do
    if SERVER then
        include(file)
        print("[SERVER] included: " .. file)
    end
end
-- client
for _, file in ipairs(clInitFiles) do
    if SERVER then
        AddCSLuaFile(file)
        print("[SERVER]sent: " .. file)
    elseif CLIENT then
        include(file)
		print("[CLIENT] included: " .. file)
    end
end
-- other
for _, file in ipairs(otherFiles) do
    local name = file:match(".*/([^/]+)%.lua$")
    if string.StartWith(name, "sh_") then
        if SERVER then
            AddCSLuaFile(file)
            print("[SERVER]sent: " .. file)
            include(file)
            print("[SERVER] included: " .. file)
        elseif CLIENT then
            include(file)
			print("[CLIENT] included: " .. file)
        end
    elseif string.StartWith(name, "sv_") then
        if SERVER then
            include(file)
            print("[SERVER] included: " .. file)
        end
    elseif string.StartWith(name, "cl_") then
        if SERVER then
            AddCSLuaFile(file)
            print("[SERVER]sent: " .. file)
        elseif CLIENT then
            include(file)
			print("[CLIENT] included: " .. file)
        end
    end
end