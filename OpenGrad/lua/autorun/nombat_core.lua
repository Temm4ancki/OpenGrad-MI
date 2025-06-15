NOMBAT = NOMBAT or {}
NOMBAT.InCombat = false
NOMBAT.InCombatResetDelay = 7

if SERVER then
	SetGlobalBool("nombat.ambient.enabled", tobool(cookie.GetString("nombat.ambient.enabled", "true") or false))
	SetGlobalBool("nombat.combat.enabled", tobool(cookie.GetString("nombat.combat.enabled", "true") or false))
	SetGlobalBool("nombat.require.los", tobool(cookie.GetString("nombat.require.los", "true") or false))
	SetGlobalBool("nombat.disable.when.dead", tobool(cookie.GetString("nombat.disable.when.dead", "false") or false))
	SetGlobalInt("nombat.forced.volume", tonumber(cookie.GetString("nombat.forced.volume", "0") or false))
	local function nombatHasAccess(p)
		local b = (IsValid(p) and p:IsSuperAdmin()) or (not IsValid(p) and true)
		if not b then if IsValid(p) then p:ChatPrint("[NOMBAT] invalid privileges") end end
		return b
	end

	concommand.Add("nombat.ambient.enabled.toggle", function(p, _, t)
		if not nombatHasAccess(p) then return end
		local i = t[1] and tonumber(t[1])
		if not i then return end
		local b = tobool(i)
		SetGlobalBool("nombat.ambient.enabled", b)
		cookie.Set("nombat.ambient.enabled", b)
	end)

	concommand.Add("nombat.combat.enabled.toggle", function(p, _, t)
		if not nombatHasAccess(p) then return end
		local i = t[1] and tonumber(t[1])
		if not i then return end
		local b = tobool(i or 1)
		SetGlobalBool("nombat.combat.enabled", b)
		cookie.Set("nombat.combat.enabled", b)
	end)

	concommand.Add("nombat.require.los.toggle", function(p, _, t)
		if not nombatHasAccess(p) then return end
		local i = t[1] and tonumber(t[1])
		if not i then return end
		local b = tobool(i or 1)
		SetGlobalBool("nombat.require.los", b)
		cookie.Set("nombat.require.los", b)
	end)

	concommand.Add("nombat.disable.when.dead.toggle", function(p, _, t)
		if not nombatHasAccess(p) then return end
		local i = t[1] and tonumber(t[1])
		if not i then return end
		local b = tobool(i or 1)
		SetGlobalBool("nombat.disable.when.dead", b)
		cookie.Set("nombat.disable.when.dead", b)
	end)

	concommand.Add("nombat.forced.volume.set", function(p, _, t)
		if not nombatHasAccess(p) then return end
		local i = t[1] and tonumber(t[1])
		if not i then return end
		SetGlobalInt("nombat.forced.volume", i)
		cookie.Set("nombat.forced.volume", i)
	end)
end

----------------------------------------------------
-- VOLUME ENFORCER --
if SERVER then
	hook.Add("Think", "nombat.volume.enforcer.Think", function()
		if timer.Exists("nombat.volume.enforcer.Timer") then return end
		timer.Create("nombat.volume.enforcer.Timer", 1, 1, function() end)
		Nombat_Sv_VolumeEnforcer()
	end)

	function Nombat_Sv_VolumeEnforcer()
		for _, p in pairs(player.GetAll()) do
			-- p:ConCommand(
		end
	end
end

----------------------------------------------------
-- HAS HOSTILE SERVER CHECKS --
if SERVER then
	hook.Add("Think", "nombat.find.hostiles.Think", function()
		if timer.Exists("nombat.find.hostiles.Timer") then return end
		timer.Create("nombat.find.hostiles.Timer", 1, 1, function() end)
		Nombat_Sv_FindHostile()
		CheckForOpposingPlayers()
		WickOpposingPlayers()
		CheckForDangerousWeapons()
		CheckForHiddenIdentity()
	end)

	local MAX_VISIBILITY_DISTANCE_SQR = 2000

	local function IsInVisibilityRange(ply, other)
		return ply:GetPos():DistToSqr(other:GetPos()) <= MAX_VISIBILITY_DISTANCE_SQR
	end

	function Nombat_Sv_FindHostile()
		local RequireLOS = GetGlobalBool("nombat.require.los", false)
		local players = {}
		for _, npc in pairs(ents.FindByClass("*npc*")) do
			local e = npc.GetEnemy and npc:GetEnemy()
			if TypeID(e) == TYPE_ENTITY then if IsValid(e) then if e.IsPlayer and e:IsPlayer() then if (e.Health and e:Health() > 0) or (e.Alive and e:Alive()) then if RequireLOS and npc:IsLineOfSightClear(e) or true then players[e] = true end end end end end
		end

		for p, _ in pairs(players) do
			if p.ConCommand then p:ConCommand("nombat.client.has.hostiles") end
		end
	end

	function CheckForOpposingPlayers()
		for _, ply in ipairs(player.GetAll()) do
			if not ply:Alive() or ply:Team() == 3 then continue end
			for _, other in ipairs(player.GetAll()) do
				if ply == other or not other:Alive() or other:Team() == 3 then continue end
				if ply:Team() ~= other:Team() and ply:Visible(other) and IsInVisibilityRange(ply, other) then
					ply:ConCommand("nombat.client.has.hostiles")
					break
				end
			end
		end
	end

	function WickOpposingPlayers()
		local round = TableRound and TableRound()
		if not round or (round.Name ~= "wick" and round.Name ~= "John Wick") then return end

		for _, ply in ipairs(player.GetAll()) do
			if not ply:Alive() then continue end
			local plyIsT = ply.roleT == true
			local plyHasNoRole = ply.roleT ~= true and ply.roleCT ~= true
			if not plyIsT and not plyHasNoRole then continue end

			for _, other in ipairs(player.GetAll()) do
				if ply == other or not other:Alive() then continue end
				local otherIsT = other.roleT == true
				local otherHasNoRole = other.roleT ~= true and other.roleCT ~= true
				if ((plyIsT and otherHasNoRole) or (plyHasNoRole and otherIsT)) and ply:Visible(other) and IsInVisibilityRange(ply, other) then
					ply:ConCommand("nombat.client.has.hostiles")
					break
				end
			end
		end
	end

	function CheckForDangerousWeapons()
		local dangerousWeapons = {
			["weapon_s_hk_usps"] = true,
			["weapon_m_kabar"] = true
		}

		for _, ply in ipairs(player.GetAll()) do
			if not ply:Alive() or ply:Team() == 3 then continue end

			for _, other in ipairs(player.GetAll()) do
				if ply == other or not other:Alive() or other:Team() == 3 then continue end

				if ply:Visible(other) and IsInVisibilityRange(ply, other) then
					local activeWeapon = other:GetActiveWeapon()
					if IsValid(activeWeapon) and dangerousWeapons[activeWeapon:GetClass()] then
						ply:ConCommand("nombat.client.has.hostiles")
						print("nombat.client.has.hostiles1")
						break
					end
				end
			end
		end
	end

	function CheckForHiddenIdentity()
		for _, ply in ipairs(player.GetAll()) do
			if not ply:Alive() or ply:Team() == 3 then continue end

			for _, other in ipairs(player.GetAll()) do
				if ply == other or not other:Alive() or other:Team() == 3 then continue end

				if ply:Visible(other) and IsInVisibilityRange(ply, other) and other.IdentityHidden then
					ply:ConCommand("nombat.client.has.hostiles")
					print("nombat.client.has.hostiles2")
					break
				end
			end
		end
	end
end

hook.Add("PlayerDeath", "Nombat_PlayerDeath_Seen", function(victim, inflictor, attacker)
	if not IsValid(victim) or not victim:IsPlayer() then return end
	if victim:Team() == 3 then return end

	for _, ply in ipairs(player.GetAll()) do
		if not IsValid(ply) or not ply:Alive() then continue end
		if ply == victim or ply:Team() == 3 then continue end

		-- Если игрок из противоположной команды
		if ply:Team() ~= victim:Team() then
			-- Проверка видимости
			if ply:Visible(victim) then
				local tr = util.TraceLine({start = ply:EyePos(), endpos = victim:EyePos(), filter = ply})
				if not tr.Hit then
					ply:ConCommand("nombat.client.has.hostiles")
				end
			end
		end
	end
end)

-----------------------------------------------
-- NOMBAT CORE CLIENTSIDE --
if CLIENT then
	CreateConVar("nombat.volume", "50", {FCVAR_ARCHIVE}, "The volume of the music played via nombat")
	CreateConVar("nombat.debug", "0", {FCVAR_ARCHIVE}, "Toggle debug messages to be printed into console")
	CreateConVar("nombat.seamless.transitions", "1", {FCVAR_ARCHIVE}, "Toggle seamless transitions between ambient and combat music (both with be played but one really quietly (game engine limitation) )")
	hook.Add("Think", "cl.nombat.Think", function()
		local delta = 1
		if timer.Exists("cl.nombat.think.Timer") then return end
		timer.Create("cl.nombat.think.Timer", delta, 1, function() end)
		local p = LocalPlayer()
		NOMBAT:LoadDisabledPacks()
		NOMBAT:SwitchSong()
		NOMBAT:UpdateVolume(delta)
	end)

	function NOMBAT:SaveDisabledPacks()
		if not NOMBAT.DisabledPacks then return end
		local t = NOMBAT.DisabledPacks or {}
		local s = util.TableToJSON(t or {}) or ""
		-- util.SetPData( "NOMBAT.DISABLED.PACKS", (s or "") )
		file.Write("nombat-disabled-packs.txt", s or "")
	end

	function NOMBAT:LoadDisabledPacks()
		if timer.Exists("nombat.recently.loaded.disabled.packs.Timer") then return end
		timer.Create("nombat.recently.loaded.disabled.packs.Timer", 5, 1, function() end)
		-- local s = util.GetPData( "NOMBAT.DISABLED.PACKS", "" ) or ""
		local s = file.Read("nombat-disabled-packs.txt", "DATA") or ""
		local t = util.JSONToTable(s or "") or {}
		NOMBAT.DisabledPacks = t or {}
		
		-- Ensure DisabledPacks is always a table
		if not NOMBAT.DisabledPacks then
			NOMBAT.DisabledPacks = {}
		end
	end

	function NOMBAT:SwitchSong()
		local v = (GetConVar("nombat.volume") and GetConVar("nombat.volume"):GetInt() or 0) / 100
		v = GetGlobalInt("nombat.forced.volume", 0) > 0 and GetGlobalInt("nombat.forced.volume", 0) / 100 or v
		if v <= 0 then return end
		
		-- Ensure DisabledPacks is initialized
		if not NOMBAT.DisabledPacks then
			NOMBAT.DisabledPacks = {}
		end
		
		-- Get the current game mode's music pack
		local currentGameMode = TableRound and TableRound() or nil
		local preferredPack = currentGameMode and currentGameMode.MusicPack or nil
		
		-- If no music pack is specified for this mode, disable music
		if not preferredPack then
			if GetConVar("nombat.debug"):GetBool() then
				print("[NOMBAT] No music pack specified for mode '" .. (currentGameMode and currentGameMode.Name or "Unknown") .. "', disabling music")
			end
			
			-- Stop any currently playing music
			local a = NOMBAT:GetAmbientEmitter()
			local c = NOMBAT:GetCombatEmitter()
			if a and a.IsPlaying and a:IsPlaying() then a:Stop() end
			if c and c.IsPlaying and c:IsPlaying() then c:Stop() end
			
			-- Clear emitters
			NOMBAT.AmbientEmitter = nil
			NOMBAT.CombatEmitter = nil
			
			-- Reset timeouts to prevent music from starting
			NOMBAT.GetAmbientTimeout = math.huge
			NOMBAT.GetCombatTimeout = math.huge
			
			return
		end
		
		-- Check if we need to force switch due to game mode change
		if NOMBAT.LastUsedPack and NOMBAT.LastUsedPack ~= preferredPack then
			-- Force immediate switch by resetting timeouts
			NOMBAT.GetAmbientTimeout = 0
			NOMBAT.GetCombatTimeout = 0
			if GetConVar("nombat.debug"):GetBool() then
				print("[NOMBAT] Game mode changed, forcing music switch from '" .. NOMBAT.LastUsedPack .. "' to '" .. preferredPack .. "'")
			end
		end
		
		if GetConVar("nombat.debug"):GetBool() then
			print("[NOMBAT] Current game mode: " .. (currentGameMode and currentGameMode.Name or "Unknown"))
			print("[NOMBAT] Preferred music pack: " .. preferredPack)
			print("[NOMBAT] Disabled packs:")
			for packName, disabled in pairs(NOMBAT.DisabledPacks or {}) do
				print("  '" .. packName .. "' = " .. tostring(disabled))
			end
		end
		
		local t, _
		local packName
		
		-- First try to find the preferred pack
		local allPacks = NOMBAT:GetAllPacks()
		
		if GetConVar("nombat.debug"):GetBool() then
			print("[NOMBAT] Available packs:")
			for i, pack in pairs(allPacks) do
				print("  Pack " .. i .. ": '" .. tostring(pack[1]) .. "'")
			end
		end
		
		for _, pack in pairs(allPacks) do
			-- pack[1] already contains the trailing slash, so we need to remove it for comparison
			local packNameWithoutSlash = string.gsub(pack[1], "/$", "")
			
			if GetConVar("nombat.debug"):GetBool() then
				print("[NOMBAT] Comparing '" .. packNameWithoutSlash .. "' with '" .. preferredPack .. "'")
			end
			
			if packNameWithoutSlash == preferredPack then
				if not NOMBAT.DisabledPacks[pack[1]] then
					t = pack
					packName = pack[1]
					NOMBAT.LastUsedPack = preferredPack  -- Remember the pack we're using
					if GetConVar("nombat.debug"):GetBool() then
						print("[NOMBAT] Using preferred pack: " .. packName)
					end
					break
				else
					if GetConVar("nombat.debug"):GetBool() then
						print("[NOMBAT] Preferred pack found but disabled: " .. pack[1])
					end
				end
			end
		end
		
		-- If preferred pack not found or disabled, disable music for this mode
		if not t then
			if GetConVar("nombat.debug"):GetBool() then
				print("[NOMBAT] Preferred pack '" .. preferredPack .. "' not found or disabled, disabling music for this mode")
			end
			
			-- Stop any currently playing music
			local a = NOMBAT:GetAmbientEmitter()
			local c = NOMBAT:GetCombatEmitter()
			if a and a.IsPlaying and a:IsPlaying() then a:Stop() end
			if c and c.IsPlaying and c:IsPlaying() then c:Stop() end
			
			-- Clear emitters
			NOMBAT.AmbientEmitter = nil
			NOMBAT.CombatEmitter = nil
			
			-- Reset timeouts to prevent music from starting
			NOMBAT.GetAmbientTimeout = math.huge
			NOMBAT.GetCombatTimeout = math.huge
			
			return
		end

		local ambientSongs = NOMBAT:GetAmbientSongs(t)
		local ambientLength, ambientFile = table.Random(ambientSongs or {})
		local combatSongs = NOMBAT:GetCombatSongs(t)
		local combatLength, combatFile = table.Random(combatSongs or {})
		-- AMBIENT
		if CurTime() >= (NOMBAT.GetAmbientTimeout or 0) then NOMBAT:SetAmbientSong(ambientFile, ambientLength) end
		-- COMBAT
		if CurTime() >= (NOMBAT.GetCombatTimeout or 0) then NOMBAT:SetCombatSong(combatFile, combatLength) end
	end

	function NOMBAT:UpdateVolume(delta)
		local a = NOMBAT:GetAmbientEmitter()
		local c = NOMBAT:GetCombatEmitter()
		local v = (GetConVar("nombat.volume") and GetConVar("nombat.volume"):GetInt() or 0) / 100
		v = GetGlobalInt("nombat.forced.volume", 0) > 0 and GetGlobalInt("nombat.forced.volume", 0) / 100 or v
		local b = NOMBAT.InCombat
		local ad = not GetGlobalBool("nombat.ambient.enabled", false)
		local cd = not GetGlobalBool("nombat.combat.enabled", false)
		local mv = GetConVar("nombat.seamless.transitions"):GetBool() and 0.01 or 0
		local dwd = GetGlobalBool("nombat.disable.when.dead", false) and not LocalPlayer():Alive()
		-- force play
		if a and not a:IsPlaying() then a:PlayEx(0.01, 100) end
		if c and not c:IsPlaying() then c:PlayEx(0.01, 100) end
		-- change volume
		if a then a:ChangeVolume((b and not cd) and mv or v, delta) end
		if c then c:ChangeVolume(b and v or mv, delta) end
		-- disabled or (disable when dead + is dead) state
		if a and (ad or dwd) then a:ChangeVolume(mv, delta) end
		if c and (cd or dwd) then c:ChangeVolume(mv, delta) end
		-- disabled state reset songs
		if v <= 0 or ad then NOMBAT.GetAmbientTimeout = 0 end
		if v <= 0 or cd then NOMBAT.GetCombatTimeout = 0 end
	end

	function NOMBAT:SetAmbientSong(s, l)
		if not s then return end
		local e = NOMBAT:GetAmbientEmitter()
		if e and e.IsPlaying and e:IsPlaying() then e:Stop() end
		e = CreateSound(LocalPlayer(), s)
		e:SetSoundLevel(0)
		e:PlayEx(0, 100)
		NOMBAT.AmbientEmitter = e
		NOMBAT.GetAmbientTimeout = CurTime() + (l or SoundDuration(s) or 1)
		-- ambient song info
		local r = string.Explode("/", s or "")
		NOMBAT.CurrentAmbientSong = r[2] .. " " .. r[3]
		NOMBAT.CurrentAmbientPack = r[2]
	end

	function NOMBAT:SetCombatSong(s, l)
		if not s then return end
		local e = NOMBAT:GetCombatEmitter()
		if e and e.IsPlaying and e:IsPlaying() then e:Stop() end
		e = CreateSound(LocalPlayer(), s)
		e:SetSoundLevel(0)
		e:PlayEx(0, 100)
		NOMBAT.CombatEmitter = e
		NOMBAT.GetCombatTimeout = CurTime() + (l or SoundDuration(s) or 1)
		-- current song info
		local r = string.Explode("/", s or "")
		NOMBAT.CurrentCombatSong = r[2] .. " " .. r[3]
		NOMBAT.CurrentCombatPack = r[2]
	end

	function NOMBAT:GetAmbientEmitter()
		return NOMBAT.AmbientEmitter
	end

	function NOMBAT:GetCombatEmitter()
		return NOMBAT.CombatEmitter
	end

	function NOMBAT:GetAmbientSongs( pack )	
		if !pack or TypeID(pack) != TYPE_TABLE then return {} end
		local t = {}
		local dir = ("nombat/" .. (pack[1]) .. "a")
		local songs = pack[2]
		for file, length in pairs( songs ) do t[ dir .. file .. ".ogg" ] = length end
		return t --tableOf { filePath, songLength }
	end
	function NOMBAT:GetCombatSongs( pack )	
		if !pack or TypeID(pack) != TYPE_TABLE then return {} end
		local t = {}
		local dir = ("nombat/" .. (pack[1]) .. "c")
		local songs = pack[3]
		for file, length in pairs( songs ) do t[ dir .. file .. ".ogg" ] = length end
		return t --tableOf { filePath, songLength }
	end

	-- function NOMBAT:GetAllSongs( pack )	
	-- return arrayOf { number, folderPath }
	-- end
	function NOMBAT:GetAllPacks()
		return LocalPlayer().NOMBAT_PackTable or {}
	end

	------------------------------------------------------------------
	-- NOMBAT HAS HOSTILE CLIENT TRIGGER --
	concommand.Add("nombat.client.has.hostiles", function(p)
		if not GetGlobalBool("nombat.combat.eabled", true) then return end
		timer.Create("cl.NombatInCombatReset.Timer", NOMBAT.InCombatResetDelay, 1, function() NOMBAT.InCombat = false end)
		NOMBAT.InCombat = true
		if GetConVar("nombat.debug"):GetBool() then print("[NOMBAT] (CLIENT) Has Hostile") end
	end)

	concommand.Add("nombat.next.ambient", function()
		NOMBAT.GetAmbientTimeout = 0
		if GetConVar("nombat.debug"):GetBool() then print("[NOMBAT] (CLIENT) Next Ambient") end
	end)

	concommand.Add("nombat.next.combat", function()
		NOMBAT.GetCombatTimeout = 0
		if GetConVar("nombat.debug"):GetBool() then print("[NOMBAT] (CLIENT) Next Combat") end
	end)

	concommand.Add("nombat.next.ambient.and.combat", function()
		RunConsoleCommand("nombat.next.ambient")
		RunConsoleCommand("nombat.next.combat")
	end)
end

----------------------------------------------
-- Q MENU (UTILITY) OPTIONS --
if CLIENT then
	hook.Add("AddToolMenuCategories", "CreateNombatCatagory", function() spawnmenu.AddToolCategory("Utilities", "Slaugh7ers Configs", "Slaugh7ers Configs") end)
	hook.Add("PopulateToolMenu", "PopulateNombatMenu", function()
		spawnmenu.AddToolMenuOption("Utilities", "Slaugh7ers Configs", "Nombat.Settings", "Nombat", "", "", function(DForm)
			-- SERVER
			DForm:Button("", "").Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 150, 255))
				draw.SimpleText("SERVER", "Trebuchet24", w / 2, h / 2, Color(255, 255, 255), 1, 1)
			end

			-- local e = DForm:CheckBox( "Ambient music enabled (superadmin)", "" )
			local e = vgui.Create("DCheckBoxLabel", DForm)
			DForm:AddItem(e)
			e:Dock(TOP)
			e:SetText("Ambient music enabled (superadmin)")
			e:SetTextColor(Color(0, 0, 0))
			e.OnChange = function(s, b) RunConsoleCommand("nombat.ambient.enabled.toggle", b and 1 or 0) end
			e:SetChecked(GetGlobalBool("nombat.ambient.enabled", true))
			e.Think = function(s) s:SetChecked(GetGlobalBool("nombat.ambient.enabled", true)) end
			-- local e = DForm:CheckBox( "Combat music enabled (superadmin)", "" )
			local e = vgui.Create("DCheckBoxLabel", DForm)
			DForm:AddItem(e)
			e:Dock(TOP)
			e:SetText("Combat music enabled (superadmin)")
			e:SetTextColor(Color(0, 0, 0))
			e.OnChange = function(s, b) RunConsoleCommand("nombat.combat.enabled.toggle", b and 1 or 0) end
			e:SetChecked(GetGlobalBool("nombat.combat.enabled", true))
			e.Think = function(s) s:SetChecked(GetGlobalBool("nombat.combat.enabled", true)) end
			-- local e = DForm:CheckBox( "Require line of sight (superadmin)", "" )
			local e = vgui.Create("DCheckBoxLabel", DForm)
			DForm:AddItem(e)
			e:Dock(TOP)
			e:SetText("Require line of sight (superadmin)")
			e:SetTextColor(Color(0, 0, 0))
			e.OnChange = function(s, b) RunConsoleCommand("nombat.require.los.toggle", b and 1 or 0) end
			e:SetChecked(GetGlobalBool("nombat.require.los", true))
			e.Think = function(s) s:SetChecked(GetGlobalBool("nombat.require.los", true)) end
			-- local e = DForm:CheckBox( "Disable when dead (superadmin)", "" )
			local e = vgui.Create("DCheckBoxLabel", DForm)
			DForm:AddItem(e)
			e:Dock(TOP)
			e:SetText("Disable when dead (superadmin)")
			e:SetTextColor(Color(0, 0, 0))
			e.OnChange = function(s, b) RunConsoleCommand("nombat.disable.when.dead.toggle", b and 1 or 0) end
			e:SetChecked(GetGlobalBool("nombat.disable.when.dead", true))
			e.Think = function(s) s:SetChecked(GetGlobalBool("nombat.disable.when.dead", false)) end
			local e = vgui.Create("DNumSlider", DForm)
			DForm:AddItem(e)
			e:Dock(TOP)
			e:SetDark(true)
			e:SetMinMax(0, 100)
			e:SetDecimals(0)
			e:SetText("Volume (ENFORCED)")
			e.Think = function(s) s:SetValue(GetGlobalInt("nombat.forced.volume", 0)) end
			e.ValueChanged = function(s, v)
				if s.next and s.next > CurTime() then return end
				s.next = CurTime() + .1
				RunConsoleCommand("nombat.forced.volume.set", math.Round(v))
			end

			e.TextArea.Think = function(s) if not s:IsEditing() then s:SetText(GetGlobalInt("nombat.forced.volume", false)) end end
			DForm:ControlHelp("force all players to play at the same volume \n(0 disable allow clients own volume)")
			DForm:Button("Admin Song Forcer", "nombat.forced.song.vgui")
			DForm:ControlHelp("force all players to play the same ambient or combat music (useful for events)")
			--CLIENT
			DForm:Button("", "").Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(255, 150, 0))
				draw.SimpleText("CLIENT", "Trebuchet24", w / 2, h / 2, Color(255, 255, 255), 1, 1)
			end

			DForm:CheckBox("Debugging", "nombat.debug")
			DForm:NumSlider("Volume", "nombat.volume", 0, 100, 0)
			DForm:CheckBox("Seamless transitions", "nombat.seamless.transitions")
			DForm:ControlHelp("both ambient and combat will be playing but the one not currently in use really quietly (game engine limitation)")
			DForm:Button("", "").Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(64, 64, 64))
				draw.SimpleText("AUDIO CONTROL", "Trebuchet24", w / 2, h / 2, Color(255, 255, 255), 1, 1)
			end

			DForm:Button("Next Ambient", "nombat.next.ambient")
			DForm:Button("Next Combat", "nombat.next.combat")
			DForm:Button("Next Ambient/ Combat", "nombat.next.ambient.and.combat")
			local function NombatSplitString(s)
				s = tostring(s)
				local pack, song = "", ""
				-- CSoundPatch [nombat/gmod/c16.mp3]
				s = string.Replace(s, "CSoundPatch [", "")
				-- nombat/gmod/c16.mp3]
				s = string.Replace(s, "]", "")
				-- nombat/gmod/c16.mp3
				return s
			end

			DForm:Button("", "").Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(64, 64, 64))
				draw.SimpleText("AUDIO VIEWER", "Trebuchet24", w / 2, h / 2, Color(255, 255, 255), 1, 1)
			end

			local e = DForm:Button("Ambient Song", "")
			e:SetText("")
			e.DoClick = function(s)
				s.LastClicked = CurTime() + 2
				SetClipboardText(NombatSplitString(NOMBAT:GetAmbientEmitter()))
			end

			e.Think = function(s)
				if s.LastClicked and s.LastClicked > CurTime() then
					s.Text = "Copied to clipboard"
				elseif s:IsHovered() then
					s.Text = "Copy current song path?"
				else
					s.Text = NOMBAT.CurrentAmbientSong
				end
			end

			e.PaintOver = function(s, w, h)
				local k = "[AMBIENT SONG] <" .. (s.Text or "") .. ">"
				draw.SimpleText(k, "DermaDefault", w / 2, h / 2, Color(0, 0, 0), 1, 1, 2, Color(0, 0, 0, 100))
			end

			local e = DForm:Button("Combat Song", "")
			e:SetText("")
			e.DoClick = function(s)
				s.LastClicked = CurTime() + 2
				SetClipboardText(NombatSplitString(NOMBAT:GetCombatEmitter()))
			end

			e.Think = function(s)
				if s.LastClicked and s.LastClicked > CurTime() then
					s.Text = "Copied to clipboard"
				elseif s:IsHovered() then
					s.Text = "Copy current song path?"
				else
					-- s.Text = ( NombatSplitString( NOMBAT:GetCombatEmitter() ) ) 
					s.Text = NOMBAT.CurrentCombatSong
				end
			end

			e.PaintOver = function(s, w, h)
				local k = "[COMBAT SONG] <" .. (s.Text or "") .. ">"
				draw.SimpleText(k, "DermaDefault", w / 2, h / 2, Color(0, 0, 0), 1, 1, 2, Color(0, 0, 0, 100))
			end

			DForm:Button("", "").Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(64, 64, 64))
				draw.SimpleText("PACK TOGGLER", "Trebuchet24", w / 2, h / 2, Color(255, 255, 255), 1, 1)
			end

			DForm:Button("Open Interface", "nombat.open.pack.toggler")
		end)
	end)

	function NOMBAT:DisabledPacksVGUI()
		local t = NOMBAT.DisabledPacks
		local DFrame = vgui.Create("DFrame")
		DFrame:SetSize(ScrW() * .2, ScrH() * .4)
		DFrame:Center()
		DFrame:SetTitle("NOMBAT Disabled Pack")
		DFrame:MakePopup()
		DFrame.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 225)) end
		local DScrollPanel = vgui.Create("DScrollPanel", DFrame)
		DScrollPanel:Dock(FILL)
		DScrollPanel.Think = function() t = NOMBAT.DisabledPacks end
		for _, r in pairs(NOMBAT:GetAllPacks()) do
			local k = r[1]
			local K = string.upper(string.Replace(k or "", "/", ""))
			local DButton = vgui.Create("DButton", DScrollPanel)
			DButton:Dock(TOP)
			DButton:SetText("")
			DButton:SetFont("DermaLarge")
			DButton:SetTall(ScrH() * 0.075)
			DButton.DoClick = function(s)
				NOMBAT.DisabledPacks[k] = not NOMBAT.DisabledPacks[k]
				NOMBAT:SaveDisabledPacks()
			end

			DButton.Paint = function(s, w, h)
				h = h - 10
				local col = t[k] and Color(255, 100, 100) or Color(100, 255, 100)
				draw.RoundedBox(0, 0, 0, w, h, col)
				if s:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 10)) end
			end

			DButton.PaintOver = function(s, w, h)
				h = h - 10
				local b = t[k] and "<DISABLED>" or "<ENABLED>"
				draw.SimpleTextOutlined(K, "DermaLarge", w / 2, h * .3, Color(255, 255, 255), 1, 1, 2, Color(0, 0, 0, 100))
				draw.SimpleTextOutlined(b, "DermaLarge", w / 2, h * .7, Color(255, 255, 255), 1, 1, 2, Color(0, 0, 0, 100))
			end

			DScrollPanel:AddItem(DButton)
		end
	end

	concommand.Add("nombat.open.pack.toggler", function() NOMBAT:DisabledPacksVGUI() end)
end

-- ADMIN NOMBAT FORCED SONG
if SERVER then util.AddNetworkString("NOMBAT.FORCED.SONG") end
if SERVER then
	concommand.Add("_nombat.force.song", function(p, _, t)
		if IsValid(p) and not p:IsSuperAdmin() then return end
		net.Start("NOMBAT.FORCED.SONG")
		net.WriteString(t[1] or "")
		net.WriteString(t[2] or "")
		net.WriteString(t[3] or "")
		net.Broadcast()
	end)
end

if CLIENT then
	net.Receive("NOMBAT.FORCED.SONG", function()
		local pack = tonumber(net.ReadString() or 0)
		local ambientOrCombat = tonumber(net.ReadString() or 0)
		local song = tonumber(net.ReadString() or 0)
		local t = NOMBAT:GetAllPacks()
		local AorC = ambientOrCombat and ambientOrCombat == 2 and "a" or "c"
		-- print( pack, ambientOrCombat, song )
		-- print( t[pack] )
		if not t[pack] then return end
		-- print( t[pack][ambientOrCombat] )
		if not t[pack][ambientOrCombat] then return end
		-- print( t[pack][ambientOrCombat][song] )
		if not t[pack][ambientOrCombat][song] then return end
		local length = t[pack][ambientOrCombat][song]
		local filepath = "nombat/" .. t[pack][1] .. AorC .. song .. ".ogg"
		-- print( filepath )
		-- print( length )
		NOMBAT:SetAmbientSong(filepath, length)
	end)

	concommand.Add("nombat.forced.song.vgui", function()
		local DFrame = vgui.Create("DFrame")
		DFrame:SetSize(ScrW() * .2, ScrH() * .4)
		DFrame:Center()
		DFrame:SetTitle("NOMBAT Song Forcer")
		DFrame:MakePopup()
		DFrame.Think = function(s) if input.IsKeyDown(KEY_TAB) then s:Close() end end
		DFrame.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 225)) end
		local DScrollPanel = vgui.Create("DScrollPanel", DFrame)
		DScrollPanel:Dock(FILL)
		for packkey, t in pairs(NOMBAT:GetAllPacks()) do
			local header = t[1]
			local ambient = t[2]
			local combat = t[3]
			--clean header
			header = string.Replace(header, "/", "")
			--create header 
			local DButton = vgui.Create("DButton", DScrollPanel)
			DButton:Dock(TOP)
			DButton:SetText("")
			DButton:SetTall(ScrH() * 0.075)
			DButton.DoClick = function(s)
				local x, y, w, h = DFrame:GetBounds()
				local X, Y, _, H = DButton:GetBounds()
				local DMenu = DermaMenu()
				DMenu:SetPos(x + s:GetWide(), y + Y + (H / 2))
				DMenu:MoveToFront()
				do
					-- ambient sub menu
					local DSubMenu = DMenu:AddSubMenu("AMBIENT SONGS")
					for songkey, songlength in pairs(ambient or {}) do
						local niceLength = string.FormattedTime(songlength or 0, "%02i:%02i:%02i")
						DSubMenu:AddOption("A" .. songkey .. " (" .. niceLength .. ")").DoClick = function(s)
							RunConsoleCommand("_nombat.force.song", packkey, 2, songkey) -- packkey, ambientOrCombat(2-3), songkey
						end
					end
				end

				do
					-- combat sub menu
					local DSubMenu = DMenu:AddSubMenu("COMBAT SONGS")
					for songkey, songlength in pairs(combat or {}) do
						local niceLength = string.FormattedTime(songlength or 0, "%02i:%02i:%02i")
						DSubMenu:AddOption("C" .. songkey .. " (" .. niceLength .. ")").DoClick = function(s)
							RunConsoleCommand("_nombat.force.song", packkey, 3, songkey) -- packkey, ambientOrCombat(2-3), songkey
						end
					end
				end
			end

			DButton.Paint = function(s, w, h)
				draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
				if s:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 50)) end
				draw.SimpleTextOutlined(header, "DermaLarge", w * .5, h * .5, Color(255, 255, 255), 1, 1, 2, Color(0, 0, 0, 100))
			end

			DScrollPanel:AddItem(DButton)
		end
	end)
end