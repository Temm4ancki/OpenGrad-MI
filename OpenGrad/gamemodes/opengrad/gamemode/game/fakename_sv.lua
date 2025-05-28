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
        "Мария",
        "Анна",
        "Екатерина",
        "Ольга",
        "Ирина",
        "Наталья",
        "Светлана",
        "Татьяна",
        "Елена",
        "Алиса",
    },
}

local EntityMeta = FindMetaTable("Entity")

function EntityMeta:SetFakeName()
    local model = self:GetModel()

    local gender = "male"
    if isstring(model) and string.find(string.lower(model), "female") then
        gender = "female"
    end

    self.FakeGender = gender
    self.FakeName = self:GenerateFakeName(gender)

    if roundActiveName == "homicide" then
        self:SetNWString("FakeName", self.FakeName)
    else
        self:SetNWString("FakeName", self:Nick())
    end
end

function EntityMeta:GetFakeName()
    return self:GetNWString("FakeName", self.FakeName)
end

function EntityMeta:GenerateFakeName(gender)
    local names = FakeNames[gender or "male"]
    return names[math.random(1, #names)]
end