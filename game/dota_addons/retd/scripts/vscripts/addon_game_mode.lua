---------------------------------------------------------------------------
if CustomGameMode == nil then
	_G.CustomGameMode = class({})
end

--[[

Cannot create an entity because entity class is NULL -1
Script Runtime Error: ...scripts\vscripts\heroes\hero_faceless_void\backtrack.lua:27: attempt to index a nil value
stack traceback:
	...scripts\vscripts\heroes\hero_faceless_void\backtrack.lua:27: in function <...scripts\vscripts\heroes\hero_faceless_void\backtrack.lua:24>
	[C]: in function 'Kill'
	...tent\570\514758837\514758837.vpk:scripts\vscripts\tp.lua:81: in function <...tent\570\514758837\514758837.vpk:scripts\vscripts\tp.lua:49>

]]


require('gamemode')
require('utilities')
require('upgrades')
require('mechanics')
require('orders')
require('builder')
require('buildinghelper')

require('libraries/timers')
require('libraries/popups')
require('libraries/notifications')

require('teleport')
require('corners')

function Precache( context )

	-- Model ghost and grid particles
	PrecacheResource("particle_folder", "particles/buildinghelper", context)
	PrecacheResource("particle_folder", "particles/econ/items/earthshaker/earthshaker_gravelmaw/", context)

	PrecacheUnitByNameSync("npc_precache_everything", context)

	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheUnitByNameSync("npc_dota_hero_drow_ranger", context)
	PrecacheUnitByNameSync("npc_dota_hero_tinker", context)
	PrecacheUnitByNameSync("npc_dota_hero_jakiro", context)
	PrecacheUnitByNameSync("npc_dota_hero_terrorblade", context)
	PrecacheUnitByNameSync("npc_dota_hero_wisp", context)
	PrecacheUnitByNameSync("npc_dota_hero_viper", context)
	PrecacheUnitByNameSync("npc_dota_hero_sniper", context)
	--PrecacheUnitByNameSync("npc_dota_hero_tiny", context)

	-- Resources used
	PrecacheUnitByNameSync("owned_hero_void", context)
	PrecacheUnitByNameSync("owned_hero_jakiro", context)

	PrecacheUnitByNameSync("peasant", context)
	PrecacheUnitByNameSync("tower", context)
	PrecacheUnitByNameSync("tower_tier2", context)
	PrecacheUnitByNameSync("city_center", context)
	PrecacheUnitByNameSync("city_center_tier2", context)
	PrecacheUnitByNameSync("tech_center", context)
	PrecacheUnitByNameSync("dragon_tower", context)
	PrecacheUnitByNameSync("dark_tower", context)
	PrecacheUnitByNameSync("wall", context)

	PrecacheItemByNameSync("item_apply_modifiers", context)

	PrecacheItemByNameSync("item_ward_sentry", context)
	PrecacheItemByNameSync("item_ward_observer", context)
	PrecacheItemByNameSync("item_tpscroll", context)
	PrecacheItemByNameSync("item_boots_retd", context)
	PrecacheItemByNameSync("item_rapier", context)
	PrecacheItemByNameSync("item_blink", context)
	PrecacheItemByNameSync("item_butterfly", context)
	PrecacheItemByNameSync("item_cheese", context)
	PrecacheItemByNameSync("item_dagon_5", context)
	PrecacheItemByNameSync("item_heart", context)
	PrecacheItemByNameSync("item_abyssal_blade", context)
	PrecacheItemByNameSync("item_travel_boots_2", context)
	PrecacheItemByNameSync("item_moon_shard", context)
	PrecacheItemByNameSync("item_vladmir", context)

	PrecacheResource( "model", "models/development/invisiblebox.vmdl", context )

	PrecacheResource("particle_folder", "particles/units/heroes/hero_sniper", context)
	PrecacheResource("particle_folder", "particles/units/heroes/hero_treant", context)

	PrecacheUnitByNameSync("melee", context)
	PrecacheUnitByNameSync("melee_sven", context)
	PrecacheUnitByNameSync("melee_phantom", context)

	PrecacheUnitByNameSync("building_barrack", context)
	PrecacheUnitByNameSync("boss_barrack", context)
	PrecacheUnitByNameSync("creep_barrack", context)

	PrecacheUnitByNameSync("pyro_tower", context)
	PrecacheUnitByNameSync("poision_tower", context)
	PrecacheUnitByNameSync("stun_tower", context)
	PrecacheUnitByNameSync("ice_tower", context)
	PrecacheUnitByNameSync("shoot_tower", context)
	PrecacheUnitByNameSync("rapid_tower", context)
	PrecacheUnitByNameSync("air_tower", context)

	PrecacheUnitByNameSync("boss_ultimate", context)

	PrecacheUnitByNameSync("boss_cobold", context)
	PrecacheUnitByNameSync("chicken_hut", context)

	PrecacheUnitByNameSync("creep_mega", context)
	PrecacheUnitByNameSync("creep_imp", context)
	PrecacheUnitByNameSync("creep_rabbit", context)

	PrecacheUnitByNameSync("loop_boss", context)

	PrecacheUnitByNameSync("easy_gnoll", context)
	PrecacheUnitByNameSync("creep_skeleton", context)
	PrecacheUnitByNameSync("frost_ghost", context)
	PrecacheUnitByNameSync("frost_ghost", context)
	PrecacheUnitByNameSync("rex_void", context)
	PrecacheUnitByNameSync("phoenix_flying", context)
	PrecacheUnitByNameSync("necronomicon_archer", context)
	PrecacheUnitByNameSync("summoned_frugal_treant", context)
	PrecacheUnitByNameSync("fungal_treant_summoner", context)
	PrecacheUnitByNameSync("passenger_flying_ship", context)
	PrecacheUnitByNameSync("flying_ship", context)
	PrecacheUnitByNameSync("fast_wolf", context)
	PrecacheUnitByNameSync("slow_boss", context)
	PrecacheUnitByNameSync("attacker_furbolg", context)
	PrecacheUnitByNameSync("nice_wolf", context)
	PrecacheUnitByNameSync("magical_wyvern", context)
	PrecacheUnitByNameSync("insis_wisard", context)
	PrecacheUnitByNameSync("butch_pudge_fly", context)
	PrecacheUnitByNameSync("blur_cour", context)
	PrecacheUnitByNameSync("spider_borrowed_time", context)
	PrecacheUnitByNameSync("maiden_arcana", context)
	PrecacheUnitByNameSync("flying_redkita", context)
	PrecacheUnitByNameSync("iron_bear", context)
	PrecacheUnitByNameSync("thegreatcalamityti", context)
	PrecacheUnitByNameSync("iron_claw_yety", context)
	PrecacheUnitByNameSync("bucktooth_jerry_enchantress", context)
	PrecacheUnitByNameSync("lgd_golden", context)
	PrecacheUnitByNameSync("turtle_green", context)
	PrecacheUnitByNameSync("fox_green", context)
	PrecacheUnitByNameSync("drodo_blue", context)
	PrecacheUnitByNameSync("virtus_bear", context)
	PrecacheUnitByNameSync("tory_the_sky", context)
	PrecacheUnitByNameSync("gold_greev", context)


end

-- Create our game mode and initialize it
function Activate()
	CustomGameMode:InitGameMode()
end

---------------------------------------------------------------------------




--[[
	OUT OF VECTOR IS CAUSING ISSUES? CNetworkOriginCellCoordQuantizedVector m_cellZ cell 155 is outside of cell bounds (0->128) @(-15714.285156 -15714.285156 23405.712891)
	NEED TO ADD ABILITY_BUILDING AND QUEUE MANUALLY, NECESSARY?
	COLLISION SIZE?
]]--