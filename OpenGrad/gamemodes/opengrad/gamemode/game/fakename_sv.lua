local FakeNames = {
    male = {
        "Максим",
        "Михаил",
        "Александр",
        "Дмитрий",
        "Денис",
        "Илья",
        "Андрей",
        "Даниил",
        "Артём",
        "Иван",
        "Алексей",
        "Никита",
        "Павел",
        "Евгений"
    },
    female = {
        "Mary",
        "Linda",
        "Patricia",
        "Jennifer",
        "Elizabeth",
        "Barbara",
        "Susan",
        "Jessica",
        "Sarah",
        "Karen",
    },
}

local EntityMeta = FindMetaTable("Entity")

function EntityMeta:SetFakeName()
    self.FakeName = self:GenerateFakeName("male")
    if roundActiveName == "homicide" then
        self:SetNWString("FakeName",self.FakeName)
    else
        self:SetNWString("FakeName",self:Nick())
    end
end

function EntityMeta:GetFakeName()
    return self:GetNWString("FakeName",self.FakeName)
end

function EntityMeta:GenerateFakeName(gender)
    local maleNames,femaleNames = FakeNames.male,FakeNames.female
    if gender == "male" then return maleNames[math.random(1,#maleNames)]
    else return femaleNames[math.random(1,#femaleNames)] end
end