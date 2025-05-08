concommand.Add(
    "cg_heal",
    function (ply, cmd, args)
        print("lol")
        for _, _ply in ipairs( player.GetAll()) do
            if args[1] != nil and _ply != nil and _ply:Nick():lower():find(args[1]) then
                print("Healed")
                _ply.stamina = 100
                _ply.pain = 0
                _ply.Blood = 5000
                _ply.Bloodlosing = 0
                _ply.dmgimpulse = 0
                _ply.Otrub = false
            end
        end
    end,
    function()
        return {
            "heal PlayerNickname"
        }
    end
)