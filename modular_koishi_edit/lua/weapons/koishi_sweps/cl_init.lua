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
    viewShootPunch.x = math.Clamp(viewShootPunch.x - ((self.HoldType == "revolver" and force*5) or force),-force*10,0)
    viewShootPunch.y = math.Clamp(viewShootPunch.y+math.random(-force,force)*0.5,-force*10,force)
	self.setAng = self:GetOwner():EyeAngles()+viewShootPunch/2
	self.setAng.z = 0
	self.eyeSpray:Add(Angle(-force/4,viewShootPunch.y/10,0))
    return viewShootPunch
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
        ScrW() /2, ScrH() /1.1, 
        Color(255, 255, 255, 255), 
        TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM,
        1, Color(0, 0, 0, 200)     
    )
end