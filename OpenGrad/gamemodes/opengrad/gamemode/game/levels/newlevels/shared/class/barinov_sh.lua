local CLASS = player.RegClass("barinov")

CLASS.main_weapons = {
    "weapon_spas12","weapon_mp7"
}

local models_barinov = {
	"models/kuhnya/barinov.mdl",
    "models/kuhnya/barinov.mdl"
}

function CLASS.Off(self)
    if CLIENT then return end

    self.isBarinov = nil
end

function CLASS.On(self)
    if CLIENT then return end

    self:SetModel(models_barinov[math.random(#models_barinov)])
    self:SetWalkSpeed(250)
    self:SetRunSpeed(350)

    self:SetHealth(150)
    self:SetMaxHealth(150)

    tdm.GiveSwep(self,CLASS.main_weapons,8)

    self:Give("weapon_hands")
    self:Give("weapon_hg_hl2")

    self.isBarinov = true

    self:EmitSound("radio/go.wav")
end

local function getList(self)
    local list = {}

    for i,ply in RandomPairs(player.GetAll()) do
        if ply == self or not ply.isBarinov then continue end
        
        local pos = ply:EyePos()
        local deathPos = self:GetPos()

        if pos:Distance(deathPos) > 1000 then continue end

        local trace = {start = pos}
        trace.endpos = deathPos
        trace.filter = ply
        
        if util.TraceLine(trace).HitPos:Distance(deathPos) <= 512 then
            list[#list + 1] = ply
        end
    end

    return list
end

function CLASS.PlayerDeath(self)
    sound.Play(Sound("kuhnya/death" .. math.random(1,5) .. ".wav"),self:GetPos())
    self:SetPlayerClass()
end

function CLASS.Think(self)end   

function CLASS.HomigradDamage(self,hitGroup,dmgInfo,rag)
    if (self.delaysoundpain or 0) > CurTime() then
        self.delaysoundpain = CurTime() + math.Rand(0.25,0.5)

        self:PlaySound("kuhnya/barinov-hurt" .. math.random(1,4) .. ".wav")
    end
end

function CLASS.GuiltLogic(self,ply)
    return false
end