file.CreateDir("homigrad")
file.CreateDir("homigrad/maps")

SpawnPointsPage = SpawnPointsPage or 1

SpawnPointsList = {
	--Команды
	spawnpointst = {"red",Color(255,0,0)},
	spawnpointsct = {"blue",Color(0,0,255)},

	--Силовики после количества времени
	spawnpoints_ss_police = {"police",Color(0,0,125)},

	--Режим CSS
	bomb_site = {"bomb_site",Color(161,121,61)},

	--Режим SchoolShooter
	spawnpoints_ss_exit = {"exit",Color(0,125,0),true},
	--spawnpoints_ss_school = {"school",Color(0,255,0)}, 
	--Для чего нужен???

 	--Режим TDM (центер не используется, но нужен)
	center = {"center",color_white},

	--Режим JohnWick. Если их нет, используем стандарные T и CT точки
	spawnpointswick = {"wick",color_white},
	spawnpointsnaem = {"naem",color_white},

	--Режим NextBot (отключен)
	--points_nextbox = {"nextbot",Color(0,255,255)},

	--Режим CP (отключен)
	--swo_carsct = ???
	--swo_carst = ???
	--gred_emp_dshk = {"gred_emp_dshk",Color(25,25,25)},
	--gred_ammobox = {"gred_ammobox",Color(25,25,25)},
	--controlpoint = {"control_point",Color(25,25,25)},
	
	--Режим Сonstruct (отключен)
	--level_construct = {"level_construct",Color(0,0,0)},

	--Режим BaseDefence (отключен)
	--basedefencebots = {"basedefencebots",Color(155,155,155)},
	--basedefencegred = {"basedefencegred",Color(255,255,255)},
	--basedefencegred_ammo = {"basedefencegred_ammo",Color(25,25,25)},
	--gred_simfphys_brdm2 = {"gred_simfphys_brdm2",Color(25,25,25)},
	--basedefenceplayerspawns = {"basedefenceplayerspawns",Color(255,255,0)},
	--boxspawn = {"boxspawn",Color(25,25,25)},


	-- НЕ ИСПОЛЬЗУЕТСЯ (ДУМАЙТЕ)
	-- spawnpointswick = {"spawnpointswick",Color(255,0,0)},
	-- spawnpointsnaem = {"spawnpointsnaem",Color(0,0,255)},

	--gred_emp_2a65 = {"gred_emp_2a65",Color(25,25,25)},
	--gred_emp_pak40 = {"gred_emp_pak40",Color(25,25,25)},
	--gred_emp_breda35 = {"gred_emp_breda35",Color(25,25,25)},

	--wac_hc_ah1z_viper = {"wac_hc_ah1z_viper",Color(25,25,25)},
	--wac_hc_littlebird_ah6 = {"wac_hc_littlebird_ah6",Color(25,25,25)},
	--wac_hc_mi28_havoc = {"wac_hc_mi28_havoc",Color(25,25,25)},
	--wac_hc_blackhawk_uh60 = {"wac_hc_blackhawk_uh60",Color(25,25,25)},

	--car_red = {"car_red",Color(125,125,125)},
	--car_blue = {"car_blue",Color(125,125,125)},

	--car_red_btr = {"car_red_btr",Color(125,125,125)},
	--car_blue_btr = {"car_blue_btr",Color(125,125,125)},

	--car_red_tank = {"car_red_tank",Color(125,125,125)},
	--car_blue_tank = {"car_blue_tank",Color(125,125,125)},

	--jailbreak = {"jailbreak",Color(0,125,0)},
	--jailbreak_doors = {"jailbreak_doors",Color(255,0,0)},

	-- darkrp_jail = {"darkrp_jail",Color(255,255,255)},

	-- scp173 = {"scp173",Color(255,0,0)},
	-- scp096 = {"scp096",Color(255,0,0)},

	-- scpWhite = {"scpWhite",color_white},

	-- bhop = {"bhop",Color(255,0,0)},

	--sim_fphys_tank3 = {"sim_fphys_tank3",Color(165,165,165)},
	--sim_fphys_tank4 = {"sim_fphys_tank4",Color(165,165,165)},
	--sim_fphys_conscriptapc_armed = {"sim_fphys_conscriptapc_armed",Color(165,165,165)},
}

function GetDataMapName(name) return "homigrad/maps/" .. name .. "/" .. game.GetMap() .. (SpawnPointsPage == 1 and "" or SpawnPointsPage) ..".txt" end

function GetMaxDataPages(name)
	local i = 0

	while true do
		i = i + 1

		if not file.Exists("homigrad/maps/" .. name .. "/" .. game.GetMap() .. (i == 1 and "" or i) ..".txt","DATA") then return i - 1 end
	end
end

function ReadDataMap(name)
	return util.JSONToTable(file.Read(GetDataMapName(name),"DATA") or "") or {}
end

function WriteDataMap(name,data)
	file.CreateDir("homigrad/maps/" .. name)
	file.Write(GetDataMapName(name),util.TableToJSON(data or {}) or "")
end

function SetupSpawnPointsList()--чтение и запись
	for name,info in pairs(SpawnPointsList) do
		info[3] = ReadDataMap(name)
	end
end

SetupSpawnPointsList()

util.AddNetworkString("points")

function SendSpawnPoint(ply)
	net.Start("points")
	net.WriteTable(SpawnPointsList)
	if ply then net.Send(ply) else net.Broadcast() end
end

COMMANDS.point = {function(ply,args)
	local name

	for _name,info in pairs(SpawnPointsList) do
		if info[1] == args[1] then name = _name break end
	end

	if not name then ply:ChatPrint("Ты еблан") return end

	local tbl = ReadDataMap(name)
	local point = {ply:GetPos() + Vector(0,0,5),Angle(0,ply:EyeAngles()[2],0),tonumber(args[2])}
	table.insert(tbl,point)
	WriteDataMap(name,tbl)

	PrintMessage(3,"Точка " .. args[1])
	SetupSpawnPointsList()
	SendSpawnPoint()
end}

COMMANDS.pointreset = {function(ply,args)
	if args[1] ~= "" then
		for name,info in pairs(SpawnPointsList) do
			if info[1] ~= args[1] then continue end

			WriteDataMap(name)

			break
		end

		PrintMessage(3,"Точки с именем " .. args[1] .. " очищены.")
	else
		for name,info in pairs(SpawnPointsList) do
			WriteDataMap(name)
		end

		PrintMessage(3,"Все точки очищены.")
	end

	SetupSpawnPointsList()
	SendSpawnPoint()
end}

COMMANDS.pointsync = {function(ply,args)
	SendSpawnPoint()
end}

COMMANDS.pointpage = {function(ply,args)
	SpawnPointsPage = tonumber(args[1])
	SetupSpawnPointsList()
	SendSpawnPoint()
	PrintMessage(3,"Вариация точек номер: " .. SpawnPointsPage)
end}

COMMANDS.pointpages = {function(ply,args)
	PrintMessage(3,GetMaxDataPages("spawnpointst"))
end}

COMMANDS.points = {function(ply,args)
	for i,point in pairs(SpawnPointsList) do ply:ChatPrint("	" .. point[1]) end
end}

concommand.Add("hg_points",function(ply)
	for i,point in pairs(SpawnPointsList) do ply:ChatPrint("	" .. point[1]) end
end)

concommand.Add("hg_point",function(ply,cmd,args)
	local name

	for _name,info in pairs(SpawnPointsList) do
		if info[1] == args[1] then name = _name break end
	end

	if not name then ply:ChatPrint("Ты еблан") return end

	local tbl = ReadDataMap(name)
	local point = {ply:GetPos() + Vector(0,0,5),Angle(0,ply:EyeAngles()[2],0),tonumber(args[2])}
	table.insert(tbl,point)
	WriteDataMap(name,tbl)

	PrintMessage(3,"Точка " .. args[1])
	SetupSpawnPointsList()
	SendSpawnPoint()
end)