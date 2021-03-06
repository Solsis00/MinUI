--
-- grUF_Events by Grantus
--
-- Simply a global list of the event names that can be registered by module
--
--

--
-- Rift Updates
--

ENTER_COMBAT = 1
LEAVE_COMBAT = 2

UNIT_AVAILABLE = 3

HEALTH_UPDATE = 4
HEALTH_MAX_UPDATE = 5
MANA_UPDATE = 6
MANA_MAX_UPDATE = 7
POWER_UPDATE = 8
ENERGY_UPDATE = 9
ENERGY_MAX_UPDATE = 10

-- player only
COMBO_UPDATE = 11
COMBO_UNIT_UPDATE = 12
CHARGE_UPDATE = 13
PLANAR_UPDATE = 14
VITALITY_UPDATE = 15

-- textual
LEVEL_UPDATE = 16
GUILD_UPDATE = 17
NAME_UPDATE = 18
MARK_UPDATE = 19
OFFLINE_UPDATE = 20
WARFRONT_UPDATE = 21
AFK_UPDATE = 22

-- icons
ROLE_UPDATE = 23
PVP_UPDATE = 24

CASTBAR_UPDATE = 30

--todo warfront, pvp, etc


UNIT_CHANGED = 40


--
-- Non Rift Event Updates
--

ANIMATION_UPDATE = 50 -- Called by the main Update loop in gUF
REFRESH_UPDATE = 51 -- Called by the main Update loop in gUF
SIMULATE_UPDATE = 52 -- Called by the main Update loop in gUF


-- Toggle lock any frames that have this event registerd
TOGGLE_FRAME_LOCK = 100