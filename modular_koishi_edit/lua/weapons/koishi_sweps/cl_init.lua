--
include( "sh_bullet.lua" )
include( "sh_util.lua" )
include( "shared.lua" )

viewShootPunch = Angle(0,0,0)

net.Receive("huysound",function(len)
	local pos = net.ReadVector()
	local sound = net.ReadString()
	local farsound = net.ReadString()
	local ent = net.ReadEntity()

	if ent == LocalPlayer() then return end

	local dist = LocalPlayer():EyePos():Distance(pos)
	if ent:IsValid() and dist < 4000 then
		ent:EmitSound(sound,100,math.random(90,110),1,CHAN_WEAPON,0,0)
	elseif ent:IsValid() then
        timer.Simple(dist/45000,function()
		    ent:EmitSound(farsound,120,math.random(90,110),1,CHAN_WEAPON,0,0)
        end)
	end
end)

function SWEP:ShootPunch(force)
    force = force/50
    viewShootPunch.x = math.Clamp(viewShootPunch.x - ((self.HoldType == "revolver" and force*5) or force),-force*5,0)
    viewShootPunch.y = math.Clamp(viewShootPunch.y+math.random(-force,force)*0.5,-force,force)
	viewShootPunch.z = math.Clamp(viewShootPunch.z+math.random(-force,force)*15,-force,force)
	self.setAng = self:GetOwner():EyeAngles()+viewShootPunch/3
	self.setAng.z = 0
	self.eyeSpray:Add(Angle(-force/1.5,viewShootPunch.y/5,0))
    return viewShootPunch
end

function draw.Circle( x, y, radius, seg )
    local cir = {}

    table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
    for i = 0, seg do
        local a = math.rad( ( i / seg ) * -360 )
        table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
    end

    local a = math.rad( 0 ) -- This is needed for non absolute segment counts
    table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

    surface.DrawPoly( cir )
end


local rtsize = 512


local vecZero = Vector(0,0,0)
local angZero = Angle(0,0,0)


function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )
	
	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s
	
	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
	
end

function SWEP:DrawHUD()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local wep = ply:GetActiveWeapon()
    if not IsValid(wep) or not wep:Clip1() or wep:Clip1() < 0 then return end

    local clip = wep:Clip1()
    local reserve = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
    draw.SimpleTextOutlined("" .. clip .. " / " .. reserve,
    "DermaLarge",
    ScrW() / 2, ScrH() / 1.1,
    Color(255, 255, 255, 255),
    TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,
    1,
    Color(0, 0, 0, 200)
    )
end

