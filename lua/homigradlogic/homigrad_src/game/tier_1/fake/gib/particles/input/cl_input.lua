local mats = {}
for i = 1,8 do mats[i] = Material("decals/blood" .. i) end
local countmats = #mats

local random = math.random
local Rand = math.Rand

local bloodparticels1 = bloodparticels1
local bloodparticels2 = bloodparticels2

local vecZero = Vector(0,0,0)

local function addBloodPart(pos,vel,mat,w,h)
	pos = pos + vecZero
	vel = vel + vecZero
	local pos2 = Vector()
	pos2:Set(pos)
	
	bloodparticels1[#bloodparticels1 + 1] = {pos,pos2,vel,mat,w,h}
end

net.Receive("blood particle",function()
	addBloodPart(net.ReadVector(),net.ReadVector(),mats[random(1,#mats)],random(10,15),random(10,15))
end)

local Rand = math.Rand

net.Receive("blood particle more",function()
	local pos,vel = net.ReadVector(),net.ReadVector()

	for i = 1,random(10,15) do
		addBloodPart(pos,vel + Vector(Rand(-15,15),Rand(-15,15)),mats[random(1,#mats)],random(10,15),random(10,15))
	end
end)

local function addBloodPart2(pos,vel,mat,w,h,time)
	pos = pos + vecZero
	vel = vel + vecZero
	local pos2 = Vector()
	pos2:Set(pos)
	
	bloodparticels2[#bloodparticels2 + 1] = {pos,pos2,vel,mat,w,h,CurTime() + time,time}
end


local function explode(pos)
	local xx,yy = 12,12
	local w,h = 360 / xx,360 / yy

	for x = 1,xx do
		for y = 1,yy do
			local dir = Vector(0,0,-1)
			dir:Rotate(Angle(h * y * Rand(0.9,1.1),w * x * Rand(0.9,1.1),0))
			dir[3] = dir[3] + Rand(0.5,1.5)
			dir:Mul(250)

			addBloodPart(pos,dir,mats[random(1,#mats)],random(7,19),random(7,10))
		end
	end
end

net.Receive("blood particle explode",function()
	explode(net.ReadVector())
end)

local vecR = Vector(10,10,10)

-- net.Receive("blood particle headshoot",function()
-- 	local pos,vel = net.ReadVector(),net.ReadVector()
-- 	local dir = Vector()
-- 	dir:Set(vel)
-- 	dir:Normalize()
-- 	dir:Mul(25)

-- 	local l1,l2 = pos - dir / 2,pos + dir / 2

-- 	local r = random(10,15)

-- 	for i = 1,r do
-- 		local vel = Vector(vel[1],vel[2],vel[3])
-- 		vel:Rotate(Angle(Rand(-15,15) * Rand(0.9,1.1),Rand(-15,15) * Rand(0.9,1.1)))

-- 		addBloodPart(Lerp(i / r * Rand(0.9,1.1),l1,l2),vel,mats[random(1,#mats)],random(10,15),random(10,15))
-- 	end

-- 	for i = 1,8 do
-- 		addBloodPart2(pos,vecZero,mats[random(1,#mats)],random(30,45),random(30,45),Rand(1,2))
-- 	end
-- end)

net.Receive("blood particle headshoot", function()
    local pos, vel = net.ReadVector(), net.ReadVector()
    
    -- Направление основного выброса (как в оригинальном headshoot)
    local mainDir = Vector(vel)
    mainDir:Normalize()
    mainDir:Mul(100) -- Уменьшенная сила по сравнению с explode (было 250)
    
    -- Добавляем небольшой разброс к основному направлению
    mainDir:Rotate(Angle(
        Rand(-20, 20), -- Разброс по pitch (вверх/вниз)
        Rand(-30, 30), -- Разброс по yaw (влево/вправо)
        0
    ))
    
    -- Основные летящие частицы (меньше, чем в explode)
    local particleCount = 50 -- Вместо 144 (как в explode)
    
    for i = 1, particleCount do
        -- Направление частицы (основано на mainDir, но с дополнительным рандомом)
        local dir = Vector(mainDir)
        dir:Rotate(Angle(
            Rand(-15, 15) * 0.5, -- Меньший разброс, чем в explode
            Rand(-15, 15) * 0.5,
            0
        ))
        
        -- Добавляем немного хаотичности в разлёт
        dir[1] = dir[1] + Rand(-40, 40)
        dir[2] = dir[2] + Rand(-40, 40)
        dir[3] = dir[3] + Rand(10, 50) -- Лёгкий подъём
        
        -- Создаём частицу
        addBloodPart(
            pos, 
            dir, 
            mats[random(1, #mats)], 
            random(7, 15), -- Размер
            random(5, 10)  -- Время жизни
        )
    end
    
    -- Статичные капли (как в оригинальном headshoot)
    for i = 1, 8 do
        addBloodPart2(
            pos, 
            Vector(0, 0, 0), -- Без скорости (капли падают на землю)
            mats[random(1, #mats)], 
            random(20, 40), -- Размер
            random(20, 30), -- Время жизни
            Rand(1, 2)      -- Доп. параметр (если требуется)
        )
    end
end)