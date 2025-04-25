if engine.ActiveGamemode() != "opengrad" then return end

hook.Add( "Initialize", "AutoTTTMapVote", function()
      if GAMEMODE_NAME == "terrortown" then
        function CheckForMapSwitch()
           -- Check for mapswitch
           local rounds_left = math.max(0, GetGlobalInt("ttt_rounds_left", 6) - 1)
           SetGlobalInt("ttt_rounds_left", rounds_left)
 
           local time_left = math.max(0, (GetConVar("ttt_time_limit_minutes"):GetInt() * 60) - CurTime())
           local switchmap = false
           local nextmap = string.upper(game.GetMapNext())
 
            if rounds_left <= 0 then
			timer.Stop("end2prep")
              LANG.Msg("limit_round", {mapname = nextmap})
              SolidMapVote.start()
            elseif time_left <= 0 then
			timer.Stop("end2prep")
              LANG.Msg("limit_time", {mapname = nextmap})
              SolidMapVote.start()
            end
        end
      end
end )