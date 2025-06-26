HomicidePresets = HomicidePresets or {}

HomicidePresets["jason"] = {
    name = "Jason",
    description = "Медленный, но неостановимый охотник с мощными ударами и высоким уроном. Подходит игрокам, любящим давить страхом и не оставлять шансов на спасение",
    model = "models/hg_homicide/traitor/MKX_Jajon.mdl",
    weapons = {
        "weapon_m_machete",
        "weapon_jam",
        "weapon_trap",
        "weapon_mask"
    },
    abilities = {
        "ability_unstoppable_force"
    }
}

HomicidePresets["maniac"] = {
    name = "Szaleniec",
    description = "Мне дали бензопилу и топор я пошел убивать :) \nСразу становится видимым как убийца, маскировки нет.",
    model = "models/hg_homicide/traitor/salvador.mdl",
    weapons = {
        "weapon_m_chainsawsal",
        "weapon_m_axe",
    },
    abilities = {
        "dbd"
    }
}

HomicidePresets["jacket"] = {
    name = "Jacket",
    description = "Быстрый и беспощадный убийца, мастер ближнего боя. Идеален для тех, кто предпочитает стремительные атаки и хаос",
    model = "models/hg_homicide/traitor/jacket.mdl",
    weapons = {
        "weapon_m_bat",
        "weapon_s_hk_usps",
        "weapon_jam",
        "weapon_trap",
        "weapon_mask"
    },
    abilities = {
        "ability_ultra_brutality"
    }
}

HomicidePresets["classic"] = {
    name = "Classic",
    description = "Стандартный трейтор со способностью видеть следы других игроков",
    model = "models/player/corpse1.mdl",
    weapons = {
        "weapon_m_kabar",
        "weapon_s_hk_usps",
        "weapon_hidebomb",
        "weapon_hg_rgd5",
        "weapon_jahidka",
        "weapon_trap",
        "weapon_jam",
        "weapon_mask",
        "weapon_hg_t_cyanid_capsule"
    },
    abilities = {
        "ability_classic_traitor"
    }
}