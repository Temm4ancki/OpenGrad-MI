table.insert(LevelList,"homicide")
homicide = homicide or {}
homicide.Name = "Homicide"

homicide.red = {"Невиновный",Color(125,125,125),
    models = tdm.models
}

homicide.teamEncoder = {
    [1] = "red"
}
-- ВАЖНО ПРИ ДОБАВЛЕНИИ НОВЫХ РЕДИМОВ
-- ДОБАВЛЯТЬ ИХ НУЖНО ПО ПОРЯДКЕ НАЧИНАЯ С ПОСЛЕДНЕГО, ПОТОМУ ЧТО РАЗРАБОТЧИКИ (не буду показывать пальцем) ДОЛБАЕБЫ И НЕ СМОГЛИ СДЕЛАТЬ НОРМАЛЬНЫЙ СПОСОБ ПОЛУЧЕНИЯ ИНДЕКСА ПО ИМЕНИ
-- А ЕЩЁ НУЖНО ОБЯЗАТЕЛЬНО ДОБАВЛЯТЬ В ТАБЛИЦУ roundSound ЗВУК ИНАЧЕ БУДЕТ ОШИБКА
local roundTypes = {
[1] = "Чрезвычайное Положение",
[2] = "Стандартный",
[3] = "Безоружная территория",
[4] = "Дикий Запад"
/**[5] = "Спидран",
[6] = "HL2: RP",
[7] = "Аристократы",
[8] = "Военный Лагерь"**/
}
-- по большей части режимы один и те же просто ЭРПЭ ебать на них разное ;3
local roundSound = {
"snd_jack_hmcd_disaster.mp3",
"snd_jack_hmcd_shining.mp3",
"snd_jack_hmcd_panic.mp3",
"snd_jack_hmcd_wildwest.mp3",
"snd_jack_hmcd_shining.mp3",
"snd_jack_hmcd_shining.mp3",
"snd_jack_hmcd_shining.mp3",
"snd_jack_hmcd_shining.mp3"
}
homicide.RoundRandomDefalut = 6
local playsound = false
if SERVER then
    util.AddNetworkString("roundType")
else
    net.Receive("roundType",function(len)
        homicide.roundType = net.ReadInt(4)
        playsound = true
    end)
end

local homicide_setmode = CreateConVar("homicide_setmode","",FCVAR_LUA_SERVER,"")

function homicide.IsMapBig()
    local mins,maxs = game.GetWorld():GetModelBounds()
    local skybox = 0
    for i,ent in pairs(ents.FindByClass("sky_camera")) do
        --local skyboxang = ent:GetPos():GetNormalized():Dot(maxs:GetNormalized())
        
        skybox = 0--skyboxang > 0 and ent:GetPos():Distance(-mins) or ent:GetPos():Distance(-maxs)
        --maxs:Sub(skybox)
    end
    
    --PrintMessage(3,tostring(mins:Distance(maxs) - skybox))
    return (mins:Distance(maxs) - skybox) > 5000
    --Vector(-10000, -2000, -2500) Vector(5000, 10000, 800)
end

function homicide.StartRound(data)
    team.SetColor(1,homicide.red[2])

    game.CleanUpMap(false)

    if SERVER then
        local roundType = homicide_setmode:GetInt() == 1 and 1 or false

        homicide.roundType = roundType or math.random(2,4)
        net.Start("roundType")
        net.WriteInt(homicide.roundType,4)
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
    --local name,color = homicide.GetTeamName(spec)
    --draw.SimpleText(name,"HomigradFontBig",ScrW() / 2,ScrH() - 150,color,TEXT_ALIGN_CENTER)
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

        draw.DrawText( "Вы " .. name, "HomigradFontBig", ScrW() / 2, ScrH() / 2, Color( color.r,color.g,color.b,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Homicide", "HomigradFontBig", ScrW() / 2, ScrH() / 8, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( roundTypes[roundType], "HomigradFontBig", ScrW() / 2, ScrH() / 6, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )

        if lply.roleT then
            draw.DrawText( "Ваша задача убить всех", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 155,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        elseif lply.roleCT then
            if homicide.roundType == 1 then 
                draw.DrawText( "У вас есть крупногабаритное оружие", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            elseif homicide.roundType == 2 then
                draw.DrawText( "У вас есть скрытое огнестрельное оружие", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            elseif homicide.roundType == 3 then
                draw.DrawText( "У вас есть средства усмирения", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            elseif homicide.roundType == 4 then
                draw.DrawText( "У вас РЕВОЛЬВЕР ЕБАТЬ", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,55,155,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
            end
        else
            draw.DrawText( "Найдите предателя", "HomigradFontBig", ScrW() / 2, ScrH() / 1.2, Color( 55,55,55,math.Clamp(startRound - 0.5,0,1) * 255 ), TEXT_ALIGN_CENTER )
        end
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
