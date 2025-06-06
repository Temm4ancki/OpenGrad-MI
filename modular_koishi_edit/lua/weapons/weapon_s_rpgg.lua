SWEP.Base = 'koishi_sweps' -- base

SWEP.PrintName 				= "РПГ"
SWEP.Author 				= "Homigrad"
SWEP.Instructions			= "Ручной противотанковый гранатомёт"
SWEP.Category 				= "md3" -- Теперь работает!!
SWEP.WepSelectIcon			= "pwb/sprites/m134"

SWEP.Spawnable 				= true
SWEP.AdminOnly 				= false

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Ammo = "RPG_Round"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.TwoHands = true
SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.HoldType = "rpg"

SWEP.Slot					= 2
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/w_rocket_launcher.mdl"
SWEP.WorldModel				= "models/weapons/w_rocket_launcher.mdl"
SWEP.ReloadSound			= "weapons/tfa_hl2r/rpg/rpg_reload1.wav"

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	if not IsValid(ply) then return end
    if self:Clip1() <= 0 then return end

	ply:SetAnimation(PLAYER_ATTACK1)
	ply:EmitSound("weapons/tfa_hl2r/rpg/rocketfire1.wav")
    local shotpos = ply:GetPos()+Vector(0,0,50) + ply:EyeAngles():Forward()*60 + ply:EyeAngles():Right()*5
    if SERVER then 
        local rocket = ents.Create( "gb_rocket_rp3" )
        rocket:SetPos(shotpos)
		rocket:SetAngles( ply:EyeAngles()+Angle(-5,0,0) )
        rocket:Spawn()
        rocket:Launch()
		rocket:SetModel("models/weapons/w_missile_closed.mdl")
    end
    self:TakePrimaryAmmo(1)
end

--models/weapons/w_rocket_launcher.mdl
--models/weapons/insurgency/w_rpg7_projectile.mdl

SWEP.vbwPos = Vector(5,-4,-4)