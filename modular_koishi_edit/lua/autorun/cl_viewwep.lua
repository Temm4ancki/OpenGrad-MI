-- if engine.ActiveGamemode() != "opengrad" then return end -- долбоеб а как я буду дебажить это? #todo удалить после релиза

local md3_weps = {}
local md3_melee = {}

for _, wep in ipairs(weapons.GetList()) do
    if wep.Category == "md3" then
        md3_weps[wep.ClassName] = true
	elseif wep.Category == "md3melee" then
        md3_melee[wep.ClassName] = true
    end
end

-- Я ОБОЖАЮ ККХТА
-- НИЖНИЙ ТЕКСТ
hook.Add("CalcView","md3View", function (ply,pos,ang,fov)
    local glaza = ply:GetAttachment(ply:LookupAttachment("eyes"))
    local glazaAng = glaza.Ang + Angle(0,0,-5) -- центрируемся
    local glazaPos = Vector(glaza.Pos.x,glaza.Pos.y,glaza.Pos.z+1.5)

    local crosshair = ply:EyePos()



    -- убираем башку
	ply:ManipulateBoneScale(ply:LookupBone("ValveBiped.Bip01_Head1"),Vector(0,0,0) or Vector(1,1,1))
    
	if 	ply:Alive() and 
	   	ply:GetMoveType() ~= MOVETYPE_NOCLIP and
		(md3_weps or md3_melee)[ply:GetActiveWeapon():GetClass()]
		then
		view = {
			origin = glazaPos,
			angles = LerpAngle(1,glazaAng,ang) ,
			fov = fov,
			drawviewer = true
		}
	else
		view = {
			origin = pos,
			angles = ang ,
			fov = fov,
			drawviewer = false
		}
	end
	
	
	return view
end)