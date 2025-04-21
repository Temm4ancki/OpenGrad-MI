DeriveGamemode("sandbox")

GM.Name = "ClearGrad"
GM.Author = "Roffold, AnimeAss"
GM.Email = "N/A"
GM.Website = "N/A"
GM.TeamBased = true

local start = SysTime()
print("Start OpenGrad gamemode.")

LevelList = {}
function TableRound(name) return _G[name or roundActiveName] end

print("End opengrad gamemode for " .. math.Round(SysTime() - start,4) .. "s")

function GM:CreateTeams()
	team.SetUp(1,"Terrorists",Color(255,0,0))
	team.SetUp(2,"Counter Terrorists",Color(0,0,255))
	team.SetUp(3,"Other",Color(0,255,0))

	team.MaxTeams = 3
end

function OpposingTeam(team)
	if team == 1 then return 2 elseif team == 2 then return 1 end
end

function ReadPoint(point)
	if TypeID(point) == TYPE_VECTOR then
		return {point,Angle(0,0,0)}
	elseif type(point) == "table" then
		if type(point[2]) == "number" then
			point[3] = point[2]
			point[2] = Angle(0,0,0)
		end

		return point
	end
end

local team_GetPlayers = team.GetPlayers

function PlayersInGame()
    local newTbl = {}

    for i,ply in pairs(team_GetPlayers(1)) do newTbl[i] = ply end
    for i,ply in pairs(team_GetPlayers(2)) do newTbl[#newTbl + 1] = ply end
    for i,ply in pairs(team_GetPlayers(3)) do newTbl[#newTbl + 1] = ply end

    return newTbl
end

player.classList = player.classList or {}
classList = player.classList

local PlayerMeta = FindMetaTable("Player")

local empty = {}
function PlayerMeta:GetPlayerClass()
    return classList[self.PlayerClassName or ""]
end

local meta
function PlayerMeta:PlayerClassEvent(name,...)--haha
    meta = self:GetPlayerClass()
    meta = meta and meta[name]

    if meta then return meta(self,...) end
end

function player.RegClass(name)
    local class = classList[name] or {}

    classList[name] = class

    return class
end


--------------------------
--		LOADING SHIT	--
--------------------------
local ROOT = "opengrad/gamemode"
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