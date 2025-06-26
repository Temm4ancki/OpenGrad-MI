HomicideAbilities = HomicideAbilities or {}

HomicideAbilities["ability_classic_traitor"] = {
    name = "Следопыт",
    description = "Видит следы других игроков на земле",
    icon = "vgui/icon/tracker.png",
    price = 4,
    onPurchase = function(ply)
        if SERVER then
            ply.CanSeeFootsteps = true
            ply:ChatPrint("Вы получили способность Следопыт - теперь видите следы других игроков")
            
            timer.Simple(0.1, function()
                if IsValid(ply) then
                    net.Start("homicide_footstep_sync")
                    net.WriteBool(ply.CanSeeFootsteps or false)
                    net.WriteBool(ply.TestFootsteps or false)
                    net.Send(ply)
                end
            end)
        end
    end
}

if SERVER then
    util.AddNetworkString("homicide_footstep_add")
    util.AddNetworkString("homicide_footstep_clear")
    util.AddNetworkString("homicide_footstep_sync")
    
    hook.Add("PlayerFootstep", "HomicideFootsteps", function(ply, pos, foot, sound, volume, filter)
        if not IsValid(ply) or not ply:Alive() then return end
        
        local traitors = {}
        for _, p in pairs(player.GetAll()) do
            if IsValid(p) and (p.CanSeeFootsteps or p.TestFootsteps) and p:Alive() then
                table.insert(traitors, p)
            end
        end
        
        if #traitors > 0 then
            net.Start("homicide_footstep_add")
            net.WriteEntity(ply)
            net.WriteVector(pos)
            net.WriteAngle(ply:GetAimVector():Angle())
            net.Send(traitors)
        end
    end)
    
    hook.Add("PlayerSpawn", "HomicideFootstepsReset", function(ply)
        ply.CanSeeFootsteps = nil
        ply.TestFootsteps = nil
    end)
    
    function homicide.ClearAllFootsteps()
        net.Start("homicide_footstep_clear")
        net.Broadcast()
    end
    
    local function syncFootstepFlags(ply)
        net.Start("homicide_footstep_sync")
        net.WriteBool(ply.CanSeeFootsteps or false)
        net.WriteBool(ply.TestFootsteps or false)
        net.Send(ply)
    end
    
    concommand.Add("homicide_test_footsteps", function(ply, cmd, args)
        if not ply:IsAdmin() then
            ply:ChatPrint("Только администраторы могут использовать эту команду")
            return
        end
        
        ply.TestFootsteps = not ply.TestFootsteps
        if ply.TestFootsteps then
            ply:ChatPrint("Тест следов включен - теперь видите все следы включая свои")
        else
            ply:ChatPrint("Тест следов выключен")
        end
        
        syncFootstepFlags(ply)
    end)
    
    concommand.Add("homicide_footsteps_debug", function(ply, cmd, args)
        if not ply:IsAdmin() then return end
        
        print("[HOMICIDE DEBUG] Игрок: " .. ply:Nick())
        print("  - roleT: " .. tostring(ply.roleT))
        print("  - CanSeeFootsteps: " .. tostring(ply.CanSeeFootsteps))
        print("  - TestFootsteps: " .. tostring(ply.TestFootsteps))
        print("  - Alive: " .. tostring(ply:Alive()))
        
        ply:ChatPrint("Отладочная информация выведена в консоль сервера")
    end)
else
    local FootSteps = {}
    local footMat = Material("thieves/footprint")
    local maxDistance = 500 ^ 2
    local lifeTime = 30
    
    local function renderFootsteps()
        local lply = LocalPlayer()
        if not lply.CanSeeFootsteps and not lply.TestFootsteps then return end
        
        cam.Start3D(EyePos(), EyeAngles())
        render.SetMaterial(footMat)
        
        for k, footstep in pairs(FootSteps) do
            if footstep.curtime + lifeTime > CurTime() then
                if (footstep.pos - EyePos()):LengthSqr() < maxDistance then
                    local FSCol, Ambient = footstep.col, render.GetLightColor(footstep.pos)
                    FSCol = Color(FSCol.r * Ambient.x, FSCol.g * Ambient.y, FSCol.b * Ambient.z, 200)
                    render.DrawQuadEasy(footstep.pos + footstep.normal * 0.01, footstep.normal, 10, 20, FSCol, footstep.angle)
                end
            else
                FootSteps[k] = nil
            end
        end
        
        cam.End3D()
    end
    
    hook.Add("PostDrawOpaqueRenderables", "HomicideDrawFootsteps", function()
        local errored, retval = pcall(renderFootsteps)
        if not errored then
            ErrorNoHalt(retval)
        end
    end)
    
    local function addFootstep(ply, pos, ang)
        local lply = LocalPlayer()
        if ply == lply and not lply.TestFootsteps then return end
        
        ang.p = 0
        ang.r = 0
        local fpos = pos
        
        if ply.LastFoot then
            fpos = fpos + ang:Right() * 5
        else
            fpos = fpos + ang:Right() * -5
        end
        ply.LastFoot = not ply.LastFoot
        
        local trace = {
            start = fpos,
            endpos = fpos + Vector(0, 0, -10),
            filter = ply
        }
        local tr = util.TraceLine(trace)
        
        if tr.Hit then
            local col = ply:GetPlayerColor()
            if ply == lply then
                col = Vector(1, 1, 0)
            end
            
            local tbl = {
                pos = tr.HitPos,
                plypos = fpos,
                curtime = CurTime(),
                angle = ang.y,
                normal = tr.HitNormal,
                col = Color(col.x * 255, col.y * 255, col.z * 255)
            }
            table.insert(FootSteps, tbl)
        end
    end
    
    net.Receive("homicide_footstep_add", function()
        local ply = net.ReadEntity()
        local pos = net.ReadVector()
        local ang = net.ReadAngle()
        
        if not IsValid(ply) then return end
        
        local lply = LocalPlayer()

        if not lply.CanSeeFootsteps and not lply.TestFootsteps then 
            return 
        end
        
        addFootstep(ply, pos, ang)
    end)
    
    net.Receive("homicide_footstep_clear", function()
        table.Empty(FootSteps)
    end)
    
    net.Receive("homicide_footstep_sync", function()
        local lply = LocalPlayer()
        lply.CanSeeFootsteps = net.ReadBool()
        lply.TestFootsteps = net.ReadBool()
        
    end)
    
    concommand.Add("homicide_client_debug", function()
        local lply = LocalPlayer()
        print("[HOMICIDE CLIENT DEBUG]")
        print("  - CanSeeFootsteps: " .. tostring(lply.CanSeeFootsteps))
        print("  - TestFootsteps: " .. tostring(lply.TestFootsteps))
        print("  - roleT: " .. tostring(lply.roleT))
        print("  - Всего следов: " .. #FootSteps)
        print("  - Материал следа: " .. tostring(footMat))
        
        chat.AddText(Color(0, 255, 0), "Отладочная информация выведена в консоль")
    end)
end