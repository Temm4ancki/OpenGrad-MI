
local ammotypes = {
    ["556x45mm"] = {
        name = "5.56x45 mm",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 200,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },

    ["127×99mm"] = {
        name = "12.7×99 mm",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 200,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },

    ["762x39mm"] = {
        name = "7.62x39 mm",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 400,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },

    ["545×39mm"] = {
        name = "5.45x39 mm",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 160,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },

    ["12/70gauge"] = {
        name = "12/70 gauge",
        dmgtype = DMG_BUCKSHOT, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 350,
        maxcarry = 46,
        minsplash = 10,
        maxsplash = 5
    },

    ["12/70beanbag"] = {
        name = "12/70 beanbag",
        dmgtype = DMG_BUCKSHOT, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 350,
        maxcarry = 46,
        minsplash = 10,
        maxsplash = 5
    },

    ["9х19mm"] = {
        name = "9х19 mm Parabellum",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 80,
        minsplash = 10,
        maxsplash = 5
    },

    [".45rubber"] = {
        name = ".45 Rubber",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 80,
        minsplash = 10,
        maxsplash = 5
    },

    ["46×30mm"] = {
        name = "4.6×30 mm",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 120,
        minsplash = 10,
        maxsplash = 5
    },
    
    ["57×28mm"] = {
        name = "5.7×28 mm",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },

    [".44magnum"] = {
        name = ".44 Remington Magnum",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },

    [".50ae"] = {
        name = ".50 AE Magnum",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },

    [".308winchester"] = {
        name = ".308 Winchester",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },

    [".45acp"] = {
        name = ".45 acp",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },

    ["9x39mm"] = {
        name = "9x39 mm",
        dmgtype = DMG_BULLET, 
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 100,
        maxcarry = 150,
        minsplash = 10,
        maxsplash = 5
    },
}

local ammoents = {
    ["556x45mm"] = {
    },
    
    ["127×99mm"] = {
        Color = Color(86,58,212)
    },

    ["762x39mm"] = {
        Color = Color(95,95,95)
    },

    ["545×39mm"] = {
        Color = Color(125,155,95)
    },

    ["12/70gauge"] = {
    },

    ["12/70beanbag"] = {
        Color = Color(255,155,55)
    },

    ["9х19mm"] = {
    },

    [".45rubber"] = {
    },

    ["46×30mm"] = {
    },

    [".44magnum"] = {
    },

    [".50ae"] = {
        Color = Color(212,189,58)
    },

    [".308winchester"] = {
        Color = Color(212,189,58)
    },

    [".45acp"] = {
        Color = Color(86,58,212)
    },

    ["9x39mm"] = {
        Color = Color(125,155,95)
    },
    
    ["57×28mm"] = {
        Color = Color(125,155,95)
    },
}

for k,v in pairs(ammotypes) do
    --PrintTable(v)
    game.AddAmmoType( v )
    if CLIENT then
        language.Add(v.name.."_ammo", v.name)
    end
    timer.Simple(1,function()
    local ammoent = {} 
    ammoent.Base = "ammo_base"
    ammoent.PrintName = v.name
    ammoent.Category = "[Homibox SWEPS] Ammo"
    ammoent.Spawnable = true
    ammoent.AmmoCount = 10
    ammoent.AmmoType = v.name
    ammoent.ModelMaterial = ammoents[k].Material
    ammoent.ModelScale = ammoents[k].Scale
    ammoent.Color = ammoents[k].Color or nil

    scripted_ents.Register( ammoent, "ent_ammo_"..k )
    end)
end

game.BuildAmmoTypes()
--PrintTable(game.GetAmmoTypes())

