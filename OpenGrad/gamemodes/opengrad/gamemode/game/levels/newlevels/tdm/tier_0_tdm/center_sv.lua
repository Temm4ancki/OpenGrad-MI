function tdm.CenterInit()
	for i, ply in pairs(player.GetAll()) do
		ply.delayKill = nil
	end
end

function tdm.Center()
	if not GetGlobalVar("Center") then return end

	local point = ReadDataMap("center")
	if #point == 0 then return end

	for i, ply in pairs(player.GetAll()) do
		if not ply:Alive() or ply:Team() == 1002 or ply:HasGodMode() then continue end
		if tdm.KCenter(ply:GetPos(), point) >= 5000 then
			if not ply.delayKill then
				ply.delayKill = CurTime() + 10
				ply:ChatPrint("Ты умрёшь, покинь запретную зону в течении 10 секунд.")
			elseif ply.delayKill < CurTime() then
				ply:Kill()
			end
		elseif ply.delayKill then
			ply.delayKill = nil
			ply:ChatPrint("Харош.")
		end
	end
end

if GetGlobalVar("Center") == nil then SetGlobalVar("Center", true) end

concommand.Add("center",function (ply,cmd,args)
	if not args[1] then print("ты еблан укажи 1 или 0") return end
	SetGlobalVar("Center", tonumber(args[1]) > 0)
	PrintMessage(3, tostring(GetGlobalVar("Center")))
end)