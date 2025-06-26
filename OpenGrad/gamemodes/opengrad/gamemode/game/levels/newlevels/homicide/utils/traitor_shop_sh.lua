SHOP_CATEGORIES = {
    ["Оружие"] = {
        "weapon_s_hk_usps",
        "weapon_s_beretta",

        "weapon_m_kabar",
        "weapon_m_hatchet",
        "weapon_m_machete",
        "weapon_m_chainsawsal",
    },
    ["Взрывчатка"] = {
        "weapon_hidebomb",
        "weapon_hg_rgd5",
        "weapon_jahidka",
    },
    ["Яды"] = {
        "weapon_hg_t_syringepoison",
        "weapon_hg_t_vxpoison",
        "weapon_hg_t_cyanid_capsule",
    },
    ["Инструменты"] = {
        "weapon_jam",
        "weapon_mask",
        "weapon_trap",
    },
    ["Способности"] = {
        "ability_classic_traitor",
        "ability_ultra_brutality",
        "ability_unstoppable_force",
    }
}

HOMICIDE_ITEM_PRICES = {
    ["weapon_s_hk_usps"] = 4,
    ["weapon_s_beretta"] = 4,

    ["weapon_m_kabar"] = 2,
    ["weapon_m_bat"] = 2,
    ["weapon_m_hatchet"] = 2,
    ["weapon_m_chainsawsal"] = 5,
    ["weapon_m_machete"] = 3,

    ["weapon_hidebomb"] = 4,
    ["weapon_hg_rgd5"] = 3,
    ["weapon_jahidka"] = 4,

    ["weapon_hg_t_syringepoison"] = 3,
    ["weapon_hg_t_vxpoison"] = 4,
    ["weapon_hg_t_cyanid_capsule"] = 3,

    ["weapon_trap"] = 3,
    ["weapon_jam"] = 3,
    ["weapon_mask"] = 1,
    ["weapon_hands"] = 0,
}

function GetHomicideItemPrice(itemClass)
    if string.StartWith(itemClass, "ability_") then
        if HomicideAbilities and HomicideAbilities[itemClass] then
            return HomicideAbilities[itemClass].price or 0
        end
        return 0
    end

    return HOMICIDE_ITEM_PRICES[itemClass] or 0
end

TRAITOR_SHOP_CONFIG = {
    DEFAULT_CREDITS = 12,
    CATEGORIES = SHOP_CATEGORIES,
    PRICES = HOMICIDE_ITEM_PRICES
}