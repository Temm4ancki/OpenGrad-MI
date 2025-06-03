AddCSLuaFile()

local filename = "homigrad_scr/game/tier_1/cl_view.lua" 

local contents = file.Read(filename, "LUA")
if not contents then
	print("[Reload wep] Failed to read file:", filename)
	return
end

RunString(contents, filename)
print("[Reload wep] Reloaded:", filename)