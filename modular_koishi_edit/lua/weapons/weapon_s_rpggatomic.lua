SWEP.Base = "koishi_sweps" -- base

SWEP.PrintName 				= "РЯГ"
SWEP.Author 				= "Homigrad"
SWEP.Purpose			= "Ручной ядерный гранатомёт"
SWEP.Category 				= "md3" -- Теперь работает!! -- ytn yt hf,jnftn
SWEP.WepSelectIcon = "vgui/select/w/rpgg"
SWEP.IconOverride = "vgui/icon/w/rpggatomic.png"

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
SWEP.ReloadSound			= "weapons/salat/w_rpgg/rpg_reload1.ogg"

function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    if not IsValid(ply) then return end
    if self:Clip1() <= 0 then return end

    ply:SetAnimation(PLAYER_ATTACK1)
    ply:EmitSound("weapons/salat/w_rpgg/rocketfire1.ogg")
    local shotpos = ply:GetPos() + Vector(0, 0, 50) + ply:EyeAngles():Forward() * 100 + ply:EyeAngles():Right() * 30 + ply:EyeAngles():Up() * 50
    if SERVER then
        local rocket = ents.Create("ent_jack_gmod_eznukerocket")
        local penis = ply:EyeAngles():Forward():Angle() -- ну правильно зачем пушкам стрелять ровно куда смотришь нам надо указывать куда им стрелять
        rocket:SetPos(shotpos)
        penis:RotateAroundAxis(penis:Up(),-90)
        rocket:SetAngles(penis)
        rocket:Spawn()
        rocket:TriggerInput("Launch",1)
    end

    self:TakePrimaryAmmo(1)
end

--models/weapons/w_rocket_launcher.mdl
--models/weapons/insurgency/w_rpg7_projectile.mdl

SWEP.vbwPos = Vector(5,-4,-4)