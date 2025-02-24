table.insert(LevelList,"homicide")
homicide = homicide or {}
homicide.Name = "Homicide"

models = {}
for i = 1,9 do table.insert(models,"models/player/group01/male_0" .. i .. ".mdl") end

models_rebels = {}
for i = 1,9 do table.insert(models_rebels,"models/player/Group03/male_0"..i..".mdl") end

--table.insert(models,"models/player/group01/male_07.mdl")
homicide.models = models
homicide.red = {"Невиновный",Color(125,125,125),
    models = models
}

homicide.teamEncoder = {
    [1] = "red"
}
-- ВАЖНО ПРИ ДОБАВЛЕНИИ НОВЫХ РЕДИМОВ
-- ДОБАВЛЯТЬ ИХ НУЖНО ПО ПОРЯДКЕ НАЧИНАЯ С ПОСЛЕДНЕГО, ПОТОМУ ЧТО РАЗРАБОТЧИКИ (не буду показывать пальцем) ДОЛБАЕБЫ И НЕ СМОГЛИ СДЕЛАТЬ НОРМАЛЬНЫЙ СПОСОБ ПОЛУЧЕНИЯ ИНДЕКСА ПО ИМЕНИ
-- А ЕЩЁ НУЖНО ОБЯЗАТЕЛЬНО ДОБАВЛЯТЬ В ТАБЛИЦУ roundSound ЗВУК ИНАЧЕ БУДЕТ ОШИБКА
local roundTypes = {
"Чрезвычайное Положение", -- 1
"Стандартный",
"Безоружная территория",
"Запад Запад"
-- "Спидран",
-- "HL2: RP",
-- "Мафия",
-- "Военная Оккупация",
-- "ANEURISM IV"
}
local roundSound = {
"snd_jack_hmcd_disaster.mp3",
"snd_jack_hmcd_shining.mp3",
"snd_jack_hmcd_panic.mp3",
"snd_jack_hmcd_wildwest.mp3"
-- "snd_jack_hmcd_shining.mp3",
-- "snd_jack_hmcd_shining.mp3",
-- "snd_jack_hmcd_shining.mp3",
-- "snd_jack_hmcd_shining.mp3",
-- "snd_jack_hmcd_shining.mp3"
}
homicide.RoundRandomDefalut = 9
local playsound = false
if SERVER then
    util.AddNetworkString("roundType")
else
    net.Receive("roundType",function(len)
        homicide.roundType = net.ReadInt(5)
        playsound = true
    end)
end

local homicide_setmode = CreateConVar("homicide_setmode","",FCVAR_LUA_SERVER,"")

-- function homicide.IsMapBig()
--     local mins,maxs = game.GetWorld():GetModelBounds()
--     local skybox = 0
--     for i,ent in pairs(ents.FindByClass("sky_camera")) do
--         --local skyboxang = ent:GetPos():GetNormalized():Dot(maxs:GetNormalized())
        
--         skybox = 0--skyboxang > 0 and ent:GetPos():Distance(-mins) or ent:GetPos():Distance(-maxs)
--         --maxs:Sub(skybox)
--     end
    
--     --PrintMessage(3,tostring(mins:Distance(maxs) - skybox))
--     return (mins:Distance(maxs) - skybox) > 5000
--     --Vector(-10000, -2000, -2500) Vector(5000, 10000, 800)
-- end

function homicide.StartRound(data)
    team.SetColor(1,homicide.red[2])

    game.CleanUpMap(false)

    if SERVER then
        local roundType = homicide_setmode:GetInt() == 1 and 1 or false

        homicide.roundType = roundType or math.random(2,4)
        net.Start("roundType")
        net.WriteInt(homicide.roundType,5)
        net.Broadcast()
    end

    if CLIENT then
        for i,ply in pairs(player.GetAll()) do
            ply.roleT = false
            ply.roleCT = false
            ply.countKick = 0
        end

        roundTimeLoot = data.roundTimeLoot

        return
    end

    return homicide.StartRoundSV()
end

if SERVER then return end

local red,blue = Color(200,0,10),Color(75,75,255)
local gray = Color(122,122,122,255)
function homicide.GetTeamName(ply)
    if ply.roleT then return "Предатель",red end
    if ply.roleCT then return "Невиновный",blue end

    local teamID = ply:Team()
    if teamID == 1 then
        return "Невиновный",ScoreboardSpec
    end
    if teamID == 3 then
        return "Спецназ",blue
    end
end

local black = Color(0,0,0,255)

net.Receive("homicide_roleget",function()
    local role = net.ReadTable()

    for i,ply in pairs(role[1]) do ply.roleT = true end
    for i,ply in pairs(role[2]) do ply.roleCT = true end
end)

function homicide.HUDPaint_Spectate(spec)
    local name,color = homicide.GetTeamName(spec)
    draw.SimpleText(name,"HomigradFontBig",ScrW() / 2,ScrH() - 150,color,TEXT_ALIGN_CENTER)
end

function homicide.Scoreboard_Status(ply)
    local lply = LocalPlayer()
    if not lply:Alive() or lply:Team() == 1002 then return true end

    return "Неизвестно",ScoreboardSpec
end

local red,blue = Color(200,0,10),Color(75,75,255)

function homicide.HUDPaint_RoundLeft(white2)
    local roundType = homicide.roundType or 2
    local lply = LocalPlayer()
    local name,color = homicide.GetTeamName(lply)

    local startRound = roundTimeStart + 7 - CurTime()
    if startRound > 0 and lply:Alive() then
        if playsound then
            playsound = false
            surface.PlaySound(roundSound[homicide.roundType])
        end
        lply:ScreenFade(SCREENFADE.IN,Color(0,0,0,255),3,0.5)
        if lply.roleT then
            draw.DrawText( "Homicide", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color( 155,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            draw.DrawText( roundTypes[roundType], "HomigradFontBig", ScrW() / 2, ScrH() / 6, Color( 155,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        else
            draw.DrawText( "Homicide", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            draw.DrawText( roundTypes[roundType], "HomigradFontBig", ScrW() / 2, ScrH() / 6, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        end

        if homicide.roundType == 1 then
            if lply.roleT then 
                drawRoundStart("Убийца", "Ваша задача подебить всех", startRound, 2)
            elseif lply.roleCT then 
                drawRoundStart("Выживший искатель", "У вас есть дробовик", startRound, 1)
            else 
                drawRoundStart("Выживший", "Найдите убийцу", startRound, 3)
        end end
        if homicide.roundType == 2 then
            if lply.roleT then 
                drawRoundStart("Убийца", "Ваша задача подебить всех", startRound, 2)
            elseif lply.roleCT then 
                drawRoundStart("Мирный с оружием", "У вас есть скрытый пистолет", startRound, 1)
            else 
                drawRoundStart("Мирный", "Найдите убийцу", startRound, 3)
        end end        
        if homicide.roundType == 3 then
            if lply.roleT then 
                drawRoundStart("Убийца", "Ваша задача подебить всех", startRound, 2)
            elseif lply.roleCT then 
                drawRoundStart("Мирный", "У вас есть средства усмирения", startRound, 1)
            else 
                drawRoundStart("Мирный", "Найдите убийцу", startRound, 3)
        end end
        if homicide.roundType == 4 then
            if lply.roleT then 
                drawRoundStart("Убийца", "Ваша задача подебить всех", startRound, 2)
            elseif lply.roleCT then 
                drawRoundStart("Шериф", "У вас есть револьвер и дробовик", startRound, 1)
            else 
                drawRoundStart("Ковбой", "Найдите убийцу", startRound, 3)
        end end
        -- if homicide.roundType == 5 then
        --     if lply.roleT then 
        --         drawRoundStart("Убийца-спидраннер", "Ваша задача подебить всех за 60 секунд", startRound, 2)
        --     elseif lply.roleCT then 
        --         drawRoundStart("Мирный", "У вас есть а потом че-нибудь придумаю", startRound, 1)
        --     else 
        --         drawRoundStart("Мирный", "Найдите убийцу", startRound, 3)
        -- end end
        -- if homicide.roundType == 6 then
        --     if lply.roleT then 
        --         drawRoundStart("Анти-коллаборационист", "Ваша задача подебить всех", startRound, 2)
        --     elseif lply.roleCT then 
        --         drawRoundStart("ГО-шник", "У вас есть пистолет и дубинка", startRound, 1)
        --     else 
        --         drawRoundStart("Коллаборационист", "Найдите предателя Альянса", startRound, 3)
        -- end end
        -- if homicide.roundType == 7 then
        --     if lply.roleT then 
        --         drawRoundStart("Мафия", "Ваша задача подебить всех", startRound, 2)
        --     elseif lply.roleCT then 
        --         drawRoundStart("Мирный", "У вас есть самопал", startRound, 1)
        --     else 
        --         drawRoundStart("Мирный", "Найдите убийцу", startRound, 3)
        -- end end
        -- if homicide.roundType == 8 then
        --     if lply.roleT then 
        --         drawRoundStart("Агент", "Ваша задача подебить всех", startRound, 2)
        --     elseif lply.roleCT then 
        --         drawRoundStart("Офицер", "У вас есть фуражка и револьвер", startRound, 1)
        --     else 
        --         drawRoundStart("Солдат", "Найдите агента под прикрытием", startRound, 3)
        -- end end
        -- if homicide.roundType == 9 then
        --     if lply.roleT then 
        --         drawRoundStart("Отброс", "Ваша задача подебить всех", startRound, 2)
        --     elseif lply.roleCT then 
        --         drawRoundStart("Ликвидатор", "У вас есть оружие", startRound, 1)
        --     else 
        --         drawRoundStart("Рабочий", "Найдите отброса общества", startRound, 3)
        -- end end
        return
    end

    local time = math.Round(roundTimeStart + roundTimeLoot - CurTime())
    if time > 0 then
        local acurcetime = string.FormattedTime(time,"%02i:%02i")
        acurcetime = "До спавна лута : " .. acurcetime

        draw.SimpleText(acurcetime,"HomigradFont",ScrW()/2,ScrH()-25,white,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end

    local lply_pos = lply:GetPos()

    for i,ply in pairs(player.GetAll()) do
        local color = ply.roleT and red or ply.roleCT and blue
        if not color or ply == lply or not ply:Alive() then continue end

        local pos = ply:GetPos() + ply:OBBCenter()
        local dis = lply_pos:Distance(pos)
        if dis > 350 then continue end

        local pos = pos:ToScreen()
        if not pos.visible then continue end

        color.a = 255 * (1 - dis / 350)

        draw.SimpleText(ply:Nick(),"HomigradFont",pos.x,pos.y,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end

function homicide.VBWHide(ply,list)
    if ply:Team() == 1002 then return end

    local blad = {}

    for i = 1,#list do
        local wep = list[i]
        if not wep.TwoHands then continue end

        blad[#blad + 1] = wep
    end--ufff

    return blad
end

function homicide.Scoreboard_DrawLast(ply)
    if LocalPlayer():Team() ~= 1002 and LocalPlayer():Alive() then return false end
end

homicide.SupportCenter = true
