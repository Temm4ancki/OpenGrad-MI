AddCSLuaFile()
local viewmodeldraw = {
	["weapon_physgun"] = true,
	["gmod_tool"] = true,
	["gmod_camera"] = true,
	["sf_tool"] = true,
    ["weapon_drr_remote"] = true
}
local finalpos, finalang, dot
local gunPos, gunAng = Vector(0,0,0), Angle(0,0,0)
local InSights = 0
local gunInfo, gunSight
LerpEyeRagdoll = Angle(0,0,0)
SIB_suppress = SIB_suppress or {}

local sightOR = true
sib_wep = sib_wep or {}

local function InSight(ply)
	if !ply:IsSprinting() and !timer.Exists("reload"..ply:GetActiveWeapon():EntIndex()) and ply:GetActiveWeapon():GetNWBool("Sighted") then
		return true
	end
	return false
end


hook.Add('StartCommand', 'wep-scope.Wheel', function(ply, cmd)
    if (cmd:GetMouseWheel() != 0 and InSight(ply)) then 
        if (cmd:GetMouseWheel() < 1) then
            sightOR = true 
        elseif (cmd:GetMouseWheel() > -1) then 
            sightOR = false 
        end
    end
end )

local vecZero = Vector(0,0,0)
local tryaska = vecZero
local shootfov = 0
lastShootSib = 0

local adddis = 0

local fogMode = render.FogMode
local fogStart = render.FogStart
local fogEnd = render.FogEnd
local fogMaxDensity = render.FogMaxDensity
local fogColor = render.FogColor
local r,g,b = 255 * 0.6,255 * 0.7,255 * 0.8

local dataFogMap = {
    [1] = Vector(95,95,110),
    ["rp_asheville"] = 3000
}


local ang = Angle(0,0,0)

local mat = Material("color")

local surface_SetMaterial = surface.SetMaterial
local surface_SetDrawColor = surface.SetDrawColor
local render_SetColorMaterial = render.SetColorMaterial
local render_DrawQuadEasy = render.DrawQuadEasy


hook.Add( "HUDPaint", "CrosshairPhysgun", function()
	local lply = LocalPlayer() 
	if lply:Alive() and IsValid(lply:GetActiveWeapon()) and viewmodeldraw[ lply:GetActiveWeapon():GetClass() ] and lply:GetActiveWeapon():GetClass()!="weapon_drr_remote" then
		local hairpos = lply:GetEyeTrace().HitPos:ToScreen() 
		local wepcolor = lply:GetWeaponColor()*255
		surface.SetDrawColor(wepcolor.x,wepcolor.y,wepcolor.z)
		surface.DrawLine( hairpos.x, hairpos.y-10, hairpos.x, hairpos.y-2 )
		surface.DrawLine( hairpos.x, hairpos.y+10, hairpos.x, hairpos.y+2 )
		surface.DrawLine( hairpos.x+10, hairpos.y, hairpos.x+2, hairpos.y )
		surface.DrawLine( hairpos.x-10, hairpos.y, hairpos.x-2, hairpos.y )
	end
end )

local filename = "homigrad_scr/game/tier_1/cl_view.lua" 

local contents = file.Read(filename, "LUA")
if not contents then
	print("[Reload] Failed to read file:", filename)
	return
end

RunString(contents, filename)
print("[Reload] Reloaded:", filename)