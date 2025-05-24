if engine.ActiveGamemode() != "opengrad" then return end

-- Я ОБОЖАЮ ККХТА
-- НИЖНИЙ ТЕКСТ
hook.Add("CalcView","md3View", function (ply,pos,ang,fov,zn,zf)
    local glaza = ply:GetAttachment(ply:LookupAttachment("eyes"))
    local glazaAng = glaza.Ang + Angle(0,0,-5) -- центрируемся
    local glazaPos = glaza.Pos

    local crosshair = ply:EyePos()

    -- убираем башку
	ply:ManipulateBoneScale(ply:LookupBone("ValveBiped.Bip01_Head1"),Vector(0,0,0) or Vector(1,1,1))
    
    local view = {
		origin = glazaPos,
		angles = LerpAngle(.9,glazaAng,ang) ,
		fov = fov,
		drawviewer = true
	}

	return view
end)