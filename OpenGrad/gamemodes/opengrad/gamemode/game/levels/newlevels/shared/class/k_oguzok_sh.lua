local CLASS = player.RegClass("oguzok")

CLASS.main_weapons = {
    "weapon_spas12","weapon_mp7"
}

local models_oguzok = {
    "models/tdm_kuhnya/fedya/fedya.mdl",
    "models/tdm_kuhnya/senya/senya.mdl",
    "models/tdm_kuhnya/oguzok/oguzok.mdl"
}

function CLASS.Off(self)
    if CLIENT then return end

    self.isOguzok = nil
end

function CLASS.On(self)
    if CLIENT then return end

    self:SetModel(models_oguzok[math.random(#models_oguzok)])
    self:SetWalkSpeed(250)
    self:SetRunSpeed(350)

    self:SetHealth(150)
    self:SetMaxHealth(150)

    tdm.GiveSwep(self,CLASS.main_weapons,8)

    self.isOguzok = true

end

local function getList(self)
    local list = {}

    for i,ply in RandomPairs(player.GetAll()) do
        if ply == self or not ply.isOguzok then continue end

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
    sound.Play(Sound("tdm_kuhnya/death" .. math.random(1,5) .. ".ogg"),self:GetPos())
    self:SetPlayerClass()
end

function CLASS.Think(self) end

function CLASS.HomigradDamage(self,hitGroup,dmgInfo,rag)
    if (self.delaysoundpain or 0) > CurTime() then
        self.delaysoundpain = CurTime() + math.Rand(0.25,0.5)

        self:PlaySound("tdm_kuhnya/oguzok-hurt" .. math.random(1,5) .. ".ogg")
    end
end

function CLASS.GuiltLogic(self,ply)
    return false
end