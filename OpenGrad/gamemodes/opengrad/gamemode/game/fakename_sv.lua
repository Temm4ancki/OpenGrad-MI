local FakeNames = {
    russian = {
        male = {
            "Максим","Михаил","Александр","Дмитрий","Денис","Илья","Андрей","Даниил","Артём","Иван","Алексей","Никита","Павел","Евгений","Антон","Лев","Эльдар","Григорий","Владимир","Руслан","Василий","Виталий","Вячеслав","Игнат","Николай","Олег","Роман","Сергей","Тимур","Пётр"
        },
        female = {
            "Ольга"
        },
    },
    german = {
        male = {
            "Конрад"
        },
        female = {

        }
    },
    italian = {
        male = {

        },
        female = {

        },
    }
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
    local maleNames,femaleNames = FakeNames.russian.male,FakeNames.russian.female
    if gender == "male" then return maleNames[math.random(1,#maleNames)]
    else return femaleNames[math.random(1,#femaleNames)] end
end

concommand.Add("penis",function()
    for langset,name in pairs(FakeNames) do
        print(name.male)
    end
end)