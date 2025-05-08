local ROOT = "homigradlogic"
local shInitFiles, svInitFiles, clInitFiles = {}, {}, {}
local shOtherFiles, svOtherFiles, clOtherFiles = {}, {}, {}
local function getDepth(path) return #string.Explode("/", path) - 2 end
local function comparePaths(a, b) local da, db = getDepth(a), getDepth(b) return da < db or (da == db and a < b) end
local function logAction(prefix, file) print(string.format("%-20s %s", prefix, file)) end
local function scanDir(dir)
    for _, f in ipairs(file.Find(dir .. "/*.lua", "LUA")) do
        local path = dir .. "/" .. f
        if f == "sh_init.lua" then table.insert(shInitFiles, path)
        elseif f == "sv_init.lua" then table.insert(svInitFiles, path)
        elseif f == "cl_init.lua" then table.insert(clInitFiles, path)
        elseif f:find("^sh_") then table.insert(shOtherFiles, path)
        elseif f:find("^sv_") then table.insert(svOtherFiles, path)
        elseif f:find("^cl_") then table.insert(clOtherFiles, path)
        end
    end
    for _, sub in ipairs(select(2, file.Find(dir .. "/*", "LUA"))) do scanDir(dir .. "/" .. sub) end
end
for _, folder in ipairs(select(2, file.Find(ROOT .. "/*", "LUA"))) do scanDir(ROOT .. "/" .. folder) end
table.sort(shInitFiles, comparePaths) table.sort(svInitFiles, comparePaths) table.sort(clInitFiles, comparePaths)
table.sort(shOtherFiles, comparePaths) table.sort(svOtherFiles, comparePaths) table.sort(clOtherFiles, comparePaths)
if SERVER then
    for _, f in ipairs(shInitFiles) do
        logAction("[SERVER]sent", f) AddCSLuaFile(f)
        logAction("[SERVER] included", f) include(f)
    end
    for _, f in ipairs(svInitFiles) do
        logAction("[SERVER] included", f) include(f)
    end
    for _, f in ipairs(clInitFiles) do
        logAction("[SERVER]sent", f) AddCSLuaFile(f)
    end
    for _, f in ipairs(shOtherFiles) do
        logAction("[SERVER]sent", f) AddCSLuaFile(f)
        logAction("[SERVER] included", f) include(f)
    end
    for _, f in ipairs(svOtherFiles) do
        logAction("[SERVER] included", f) include(f)
    end
    for _, f in ipairs(clOtherFiles) do
        logAction("[SERVER]sent", f) AddCSLuaFile(f)
    end
else
    for _, f in ipairs(shInitFiles) do
        logAction("[CLIENT] included", f) include(f)
    end
    for _, f in ipairs(clInitFiles) do
        logAction("[CLIENT] included", f) include(f)
    end
    for _, f in ipairs(shOtherFiles) do
        logAction("[CLIENT] included", f) include(f)
    end
    for _, f in ipairs(clOtherFiles) do
        logAction("[CLIENT] included", f) include(f)
    end
end