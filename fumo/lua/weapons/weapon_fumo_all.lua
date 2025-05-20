AddCSLuaFile()

SWEP.Base = "weapon_fumo_base"
SWEP.Category = "Fumos"
SWEP.Spawnable	= true

SWEP.InLoadoutFor = {ROLE_INNOCENT, ROLE_TRAITOR, ROLE_DETECTIVE}
SWEP.EquipMenuData = {
  type = "fumo!!!!!!!!!!!!",
  desc = "left click: dont press that\nright click: change fumo\nreload: squeeze fumo (dont)"
};

SWEP.Kind = 9
SWEP.PrintName		= "All Fumos"
SWEP.Purpose        = "fumo!!!!!!!!!!!!"
SWEP.Instructions   = "left click: dont press that\nright click: change fumo\nreload: squeeze fumo (dont)"
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.FumoIcon = "entities/weapon_fumo_all.png"

SWEP.OffsetVec = Vector(-5, -2, -5)
SWEP.OffsetAng = Angle(-50, 50, 80)

local fumo_options = {
	"weapon_fumo_cirno",
	"weapon_fumo_flandre",
	"weapon_fumo_junko",
	"weapon_fumo_keiki",
	"weapon_fumo_koishi",
	"weapon_fumo_marisa",
	"weapon_fumo_mokou",
	"weapon_fumo_momiji",
	"weapon_fumo_okuu",
	"weapon_fumo_reimu",
	"weapon_fumo_remi",
	"weapon_fumo_sakuya",
	"weapon_fumo_sanae",
	"weapon_fumo_shion",
	"weapon_fumo_suwako",
	"weapon_fumo_tsukasa",
	"weapon_fumo_youmu",
	"weapon_fumo_yuuka",
	"weapon_fumo_yuyuko",
}

-- todofumo: Save the selected fumo somehow. Could use ClientConVar,
-- but a whole bunch of error/exploit checking would need to be done
function SWEP:SetupDataTables()
	self:NetworkVar( "Int", 0, "SelectedFumo" )
	self:NetworkVarNotify( "SelectedFumo", self.FumoChanged )
	self:SetSelectedFumo(1)
end

function SWEP:SecondaryAttack()
	if self.SelectTimer == nil then self.SelectTimer = 0 end
	if self.SelectTimer > CurTime() then return end
	fumo = self:GetSelectedFumo() + 1
	if fumo > #fumo_options then
		fumo = 1
	end

	if CLIENT and IsFirstTimePredicted() then
		surface.PlaySound("carryable_fumos/fumosays.wav") 
	elseif game.SinglePlayer() then
		self.Owner:EmitSound("carryable_fumos/fumosays.wav")
	end

	self:SetSelectedFumo(fumo)
	self.Owner.LastSelectedFumo = fumo
	self.SelectTimer = CurTime() + 0.5
end


function SWEP:FumoChanged( name, old, new )
	-- Some weird fuckery with network values that default to nil.
	if new == 0 then return end

	selected_swep = weapons.Get(fumo_options[new])
	-- Why does this become nil and why
	-- does nothing bad happen if we ignore it?
	if selected_swep == nil then return end

	--Msg("FumoChanged   ", new, "\n")

	self.ViewModel = selected_swep.ViewModel
	self.WorldModel = selected_swep.WorldModel
	self.OffsetVec = selected_swep.OffsetVec
	self.OffsetAng = selected_swep.OffsetAng
end


function SWEP:PreDrawViewModel(vm, weapon, ply)
	vm:SetModel(self.ViewModel)
end

function SWEP:PrimaryAttack()
	local music = ""
	if GetConVarNumber("fumo_use_themes") == 1 then
		if self:GetSelectedFumo() == 1 then
			music = "carryable_fumos/cirno_theme.mp3"
		elseif self:GetSelectedFumo() == 2 then
			music = "carryable_fumos/flan_theme.mp3"
		elseif self:GetSelectedFumo() == 3 then
			music = "carryable_fumos/junko_theme.mp3"
		elseif self:GetSelectedFumo() == 4 then
			music = "carryable_fumos/keiki_theme.mp3"
		elseif self:GetSelectedFumo() == 5 then
			music = "carryable_fumos/koishi_theme.mp3"
		elseif self:GetSelectedFumo() == 6 then
			music = "carryable_fumos/marisa_theme.mp3"
		elseif self:GetSelectedFumo() == 7 then
			music = "carryable_fumos/mokou_theme.mp3"
		elseif self:GetSelectedFumo() == 8 then
			music = "carryable_fumos/momiji_theme.mp3"
		elseif self:GetSelectedFumo() == 9 then
			music = "carryable_fumos/okuu_theme.mp3"
		elseif self:GetSelectedFumo() == 10 then
			music = "carryable_fumos/reimu_theme.mp3"
		elseif self:GetSelectedFumo() == 11 then
			music = "carryable_fumos/remi_theme.mp3"
		elseif self:GetSelectedFumo() == 12 then
			music = "carryable_fumos/sakuya_theme.mp3"
		elseif self:GetSelectedFumo() == 13 then
			music = "carryable_fumos/sanae_theme.mp3"
		elseif self:GetSelectedFumo() == 14 then
			music = "carryable_fumos/shion_theme.mp3"
		elseif self:GetSelectedFumo() == 15 then
			music = "carryable_fumos/suwako_theme.mp3"
		elseif self:GetSelectedFumo() == 16 then
			music = "carryable_fumos/tsukasa_theme.mp3"
		elseif self:GetSelectedFumo() == 17 then
			music = "carryable_fumos/youmu_theme.mp3"
		elseif self:GetSelectedFumo() == 18 then
			music = "carryable_fumos/yuuka_theme.mp3"
		elseif self:GetSelectedFumo() == 19 then
			music = "carryable_fumos/yuyu_theme.mp3"
		end
	elseif GetConVarNumber("fumo_use_themes") == 0 then
		music = "carryable_fumos/fumofunkyy.wav"
	end
	print(music)
	print(self:GetSelectedFumo())
	self.TimerName = self.PrintName .. self.FumoCount .. "_spin"
    local ply = self:GetOwner()
    if not IsValid( ply ) then return end
    ply:SetAnimation( PLAYER_ATTACK1 )
    local vm = ply:GetViewModel()
    if not IsValid( vm ) then return end
    vm:SendViewModelMatchingSequence( vm:LookupSequence( "deploy" ) )
    if SERVER then
        local ply = self:GetOwner()
        self.Primary.Delay = CurTime() + cvarTripCooldown:GetInt() + 0.01
        local pos = ply:GetPos() + Vector(0,0,10)
        local ent = ents.Create("prop_physics")
        ent:SetModel(self.WorldModel)
        ent:SetPos(pos)
        ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
        ent:SetMoveType(MOVETYPE_NONE)
        ent:SetSolid(SOLID_NONE)
        ent:Spawn()
		ent:EmitSound("carryable_fumos/wtfac4.wav", 100, 130)
        ent:EmitSound(music, 70, 100)
		ent:CallOnRemove( "StopFumoSound", function() ent:StopSound( music ) end )
		self.FumoCount = self.FumoCount + 2
        timer.Simple(cvarDetonateTime:GetInt(), function()
            if IsValid(ent) then
				ent:Remove()
                local explosion = ents.Create("env_explosion")
                explosion:SetPos(ent:GetPos())
                explosion:SetOwner(ply)
                explosion:SetKeyValue("iMagnitude", "100")
                explosion:Spawn()
                explosion:Fire("Explode", "", 0)
                ent:Remove()
				ent:StopSound("carryable_fumos/fumofunkyy.wav")
				
				--some quick patch
				if ply:Alive() then
					self.FumoCount = self.FumoCount - 1
				end
            end
        end)
    local ang = Angle(0,0,-80)
        local phys = ent:GetPhysicsObject()
        if IsValid(phys) then
            phys:EnableMotion(false)
        end

        timer.Create(self.TimerName, 0.01, 0, function()
            if IsValid(ent) then
                ang.y = ang.y + 10
                ent:SetAngles(ang)
                ent:SetPos(pos + Vector(0,0,math.sin(CurTime()*5)*5))
            end
        end)
    end
	if SERVER then
    self:SetNextPrimaryFire(CurTime() + cvarTripCooldown:GetInt())
	end
end

function SWEP:Reload()
	if self.ReloadTimer == nil then self.ReloadTimer = 0 end
	if self.ReloadTimer > CurTime() then return end
	
	self.Owner:EmitSound("carryable_fumos/fumosquee.wav", 100, 100)
	if self:GetNextPrimaryFire() > CurTime() then return end
	self:SetNextSecondaryFire(CurTime() + 1)

	if SERVER and self.ClickCount >= cvarMinSqueezes:GetInt() and math.random() < cvarExpChance:GetFloat() then 
		local explosion = ents.Create("env_explosion") 
		explosion:SetPos(self.Owner:GetPos()) 
		explosion:SetOwner(self.Owner)
		explosion:Spawn()
		explosion:SetKeyValue("iMagnitude", "200")
		explosion:Fire("Explode", 0, 0)

		if cvarForceKill:GetBool() then
			self.Owner:Kill()
		end
	end
	
	self.ClickCount = self.ClickCount + 1
	self.ReloadTimer = CurTime() + 1
end