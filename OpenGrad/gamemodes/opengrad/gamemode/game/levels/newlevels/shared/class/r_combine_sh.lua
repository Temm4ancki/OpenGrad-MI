local CLASS = player.RegClass("combinereal")

local function MewMath(first, second)
    temp1 = math.random(first, second)
    temp2 = math.random(first, second)
    if temp1 ~= temp2 then
        return temp1
    else
        return temp2
    end
end

CLASS.main_weapons = {
    "weapon_sar2", "weapon_spas12", "weapon_mp7"
}

CLASS.secondary_weapons = {
    "weapon_hk_usp"
}

local models_combine = {
    "models/player/combine_soldier.mdl",
    "models/player/combine_super_soldier.mdl",
    "models/player/combine_soldier_prisonguard.mdl",
    "models/tdm_hl2dmreal/eng/combine_engineer_male.mdl",
}

function CLASS.Off(self)
    if CLIENT then return end

    self.isCombinereal = nil
    self.cantUsePer4ik = nil
    self.ResistOtrub = nil
end

function CLASS.On(self)
    if CLIENT then return end

    self:SetModel(models_combine[math.random(#models_combine)])
    self:SetWalkSpeed(250)
    self:SetRunSpeed(350)

    self:SetHealth(150)
    self:SetMaxHealth(150)

    tdm.GiveSwep(self, CLASS.main_weapons, 8)
    tdm.GiveSwep(self, CLASS.secondary_weapons, 8)

    self:Give("weapon_hands")
    self:Give("weapon_hg_hl2")

    self.isCombinereal = true
    self.cantUsePer4ik = true
    self.ResistOtrub = true

    self:EmitSound("radio/go.wav")
end

function CLASS.PlayerFootstep(self, pos, foot, name, volume, filter)
    if SERVER then return true end
    --sound.Play(Sound("npc/combine_soldier/gear" .. math.random(1,6) .. ".wav"), pos, 65, 100, 1)
    sound.Play(Sound("tdm_hl2dmreal/gear_" .. math.random(1,6) .. ".ogg"), pos, 65, 100, 23)
    sound.Play(name, pos, 65, 100, volume)

    return true
end

local function getList(self)
    local list = {}

    for i, ply in RandomPairs(player.GetAll()) do
        if ply == self or not ply.isCombinereal then continue end

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
    local playerList = getList(self)
    local rag = self:GetNWEntity("ragdoll")
    sound.Play(Sound("tdm_hl2dmreal/die_" .. MewMath(1,6) .. ".ogg"), rag:GetPos())

    timer.Simple(1, function()
        if #playerList == 1 then
            local ply = playerList[1]
            ply:EmitSound(Sound("tdm_hl2dmreal/squadmemberlost_lastman_" .. MewMath(1, 4) .. ".ogg"))
        elseif #playerList == 0 then
            sound.Play(Sound("tdm_hl2dmreal/failuretotreatoutbreak.ogg"), rag:GetPos())
        else
            for i, ply in RandomPairs(playerList) do
                ply:EmitSound(Sound("tdm_hl2dmreal/squadmemberlost_" .. MewMath(1, 7) .. ".ogg"))
                break
            end
        end
    end)

    self:SetPlayerClass()
end

function CLASS.Think(self) end

function CLASS.PlayerStartVoice(self)
    for i,ply in pairs(player.GetAll()) do
        if not ply.isCombinereal then continue end

        ply:EmitSound("npc/combine_soldier/vo/on" .. math.random(1,2) .. ".wav")
    end
end

function CLASS.PlayerEndVoice(self)
    for i,ply in pairs(player.GetAll()) do
        if not ply.isCombinereal then continue end

        ply:EmitSound("npc/combine_soldier/vo/off" .. math.random(1,3) .. ".wav")
    end
end

function CLASS.CanLisenOutput(output,input,isChat)
    if input.isCombinereal then return true end
end

function CLASS.CanLisenInput(input,output,isChat)
    if not output:Alive() then return false end
end

-- Я ЕБАЛ ЭТОТ КОД. КТО-ТО ПЕРЕДЕЛАЙТЕ ПЛИЗ
-- что ты хочешь чтобы здесь переделали :thinking:
function CLASS.HomigradDamage(self, hitGroup, dmgInfo, rag)
    if (self.delaysoundpain or 0) > CurTime() then return end

    local otrub = self.Otrub
    local health = self:Health() - 1.5
    local notcritical = 60
    local critical = 30

    local delay = math.Rand(1, 2)
    if health <= notcritical then
        delay = math.Rand(4, 5)
    end

    self.delaysoundpain = CurTime() + delay

    --print("IsValid")
    --print("rag Pos:",rag)
    --print("self Pos:",self)
    if IsValid(rag) then
        pos = rag
    else
        pos = self
    end
    --print("Pos:",pos)

    --print(pos:Alive())
    --print(IsValid(pos))

    if not otrub then
        if not IsValid(pos) then
            --print("StopSound")
            pos:StopSound("tdm_hl2dmreal/critical_1.ogg")
            pos:StopSound("tdm_hl2dmreal/critical_2.ogg")
            pos:StopSound("tdm_hl2dmreal/critical_3.ogg")
            pos:StopSound("tdm_hl2dmreal/notcritical_1.ogg")
            pos:StopSound("tdm_hl2dmreal/notcritical_2.ogg")
            pos:StopSound("tdm_hl2dmreal/notcritical_3.ogg")
            for i = 1, 10 do
                pos:StopSound("tdm_hl2dmreal/pain_" .. i .. ".ogg")
            end
            return
        end
        --print("PlaySound")
        if health <= critical then
            pos:EmitSound("tdm_hl2dmreal/critical_" .. math.random(1, 3) .. ".ogg")
        elseif health <= notcritical then
            pos:EmitSound("tdm_hl2dmreal/notcritical_" .. math.random(1, 3) .. ".ogg")
        else
            pos:EmitSound("tdm_hl2dmreal/pain_" .. math.random(1, 10) .. ".ogg")
        end
    end
end

function CLASS.GuiltLogic(self,ply) return false end