AddCSLuaFile()

SWEP.PrintName = "Фотоаппарат"
SWEP.Author = "koishi"
SWEP.Instructions = "Для сьёмок тупых видео. Случайно дезинтегрирует призраков попавших во вспышку"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Category = "md3"
SWEP.UseHands = true
SWEP.ViewModel = "models/maxofs2d/camera.mdl"
SWEP.WorldModel = "models/maxofs2d/camera.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary = true

SWEP.Cooldown = 10
SWEP.NextShootTime = 0

local FLASH_SOUND = Sound("npc/scanner/scanner_photo1.wav")
-- local FLASH_SOUND = Sound("hg_homicide/sfx/hmcd_fart.ogg")

if CLIENT then
    net.Receive("CameraFlashEffect", function()
        local dlight = DynamicLight(LocalPlayer():EntIndex())
        if dlight then
            dlight.pos = LocalPlayer():GetShootPos()
            dlight.r = 255
            dlight.g = 255
            dlight.b = 255
            dlight.brightness = 6
            dlight.Decay = 1000
            dlight.Size = 500
            dlight.DieTime = CurTime() + 0.1
        end
    end)
else
    util.AddNetworkString("CameraFlashEffect")
end


function SWEP:PrimaryAttack()
    if CurTime() < self.NextShootTime then return end

    self:SetNextPrimaryFire(CurTime() + 0.5)
    self.NextShootTime = CurTime() + self.Cooldown

    local owner = self:GetOwner()
    if not IsValid(owner) or not owner:IsPlayer() then return end

    self:EmitSound(FLASH_SOUND)

    if SERVER then
        net.Start("CameraFlashEffect")
        net.SendPVS(owner:GetPos())
    end

    if CLIENT then return end

    local coneAngle = 30
    local maxDistance = 1000

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or not ply:Alive() or ply == owner then continue end

        local toTarget = (ply:GetPos() + Vector(0, 0, 40)) - owner:GetShootPos()
        if toTarget:Length() > maxDistance then continue end

        local angle = math.deg(math.acos(owner:GetAimVector():Dot(toTarget:GetNormalized())))
        if angle > coneAngle then continue end

        local effect = EffectData()
        effect:SetOrigin(ply:GetPos() + Vector(0, 0, 40))
        util.Effect("effect_disintegrate_flash", effect)

        ply:EmitSound("ambient/creatures/town_child_scream1.wav")
        

        local rag = ply:CreateRagdoll()
        ply:KillSilent()

        SafeRemoveEntityDelayed(rag, 0.1)
    end
end
