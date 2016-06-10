ADDON_VERSION = "1.5 beta"

-- zero LOST_LEFES_RAD_RESET and LOST_LEFES_DIRE_RESET every LOST_LIFES_WAVE_RESET_COUNT waves
LOST_LIFES_WAVE_RESET_COUNT = 3
LOST_LIFES_HELPER_WAVE = 0
LOST_LIFES_HELPER_WAVE_SUM_UNITS = 0
-- used to adjust creep power
LOST_LEFES_RAD_RESET = 0  
LOST_LEFES_DIRE_RESET = 0

RADIANT_LIFES = 70  -- [[ see tp.lua and teleport.lua ]]
DIRE_LIFES = 70  

radPID = {}
direPID = {}
PLAYERS_PICKED = 0

PRE_GAME_TIME = 10.0                    -- How long after people select their heroes should the horn blow and the game start?
VOTE_DIFF_TIME = PRE_GAME_TIME+30
WAVE_FIRST_DELAY = VOTE_DIFF_TIME+20

GameRules.PLAYER_COUNT = 0 -- changes in setSettings()

GameRules.PLAYER_VOTES = {}
GameRules.DIFFICULTY = 0
GameRules.difficulty_selected = false

WAVE_UNIT_NAMES = { "easy_gnoll", "creep_skeleton", "rex_void","frost_ghost", "phoenix_flying",
                    "necronomicon_archer", "fungal_treant_summoner", "flying_ship", "fast_wolf", "attacker_furbolg","slow_boss",
                    "nice_wolf", "magical_wyvern", "insis_wisard","butch_pudge_fly",
                    "blur_cour", "spider_borrowed_time","maiden_arcana","flying_redkita",
                    "iron_bear","thegreatcalamityti","iron_claw_yety", "bucktooth_jerry_enchantress",
                    "lgd_golden","turtle_green","fox_green",
                    "drodo_blue","virtus_bear","tory_the_sky","gold_greev", } 
WAVE_UNIT_COUNT = { 15, 15, 1, 15, 15,
                    15, 1, 4, 15, 10, 1, 
                    15, 15, 15, 15,
                    15, 15, 1, 3,
                    15, 15, 15, 3,
                    15, 15, 5, 
                    15, 15, 15, 3,
                    15, 15, 15,
                    15, 15, 15,
                    15, 15, 15, }
WAVE_DESCRIPTIONS = { " ( Easy ) ", " ( Easy ) ", " ( Boss ) ", "", " ( Flying ) ",
                      "", "( Summoner )", "", " ( Fast ) ", " ( Attacker ) ", " ( Boss ) ",
                      "", " ( Magic resist ) ", " ( Invisibility! ) ", " ( Flying ) ",
                      " ( Blur ) ", " ( Borrowed time ) ", "( Spell immune )", " ( Flying ) ",
                      "", "", "", " ( Boss, Enchantress ) ",
                      "", "", "( Spell immune )", 
                      "", "", "", "",
                      "", "", "",
                      "", "", "",
                      "", "", "",} 

WAVE_COUNT = #WAVE_UNIT_NAMES

UNIT_BETWEEN_DELAY = 0.5
WAVE_DELAY = 60 * UNIT_BETWEEN_DELAY -- Delay between waves proportional UNIT_BETWEEN_DELAY

START_WAVE = 1 -- Allows change stating wave [1..WAVE_COUNT]
CURENT_WAVE = START_WAVE
HELPER_TIME = 0.0 -- Changes by timer
HELPER_WAVE_TIME = 0.0 -- Changes by timer
HELPER_SPAWNED_UNITS = 0.0 -- Number of spawned units in curent wave
HELPER_IS_DELAY = false

WAVES_RUNNING = false

IS_WAVES_INFINITE = false -- need check!
LOOP_UNIT_COUNT = 4
LOOP_BASE_UNIT = "loop_boss"

STARTING_GOLD = 100
STARTING_LUMBER = 300
STARTING_FOOD = 400

DEBUG_SPEW = 1

ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = true             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other

HERO_SELECTION_TIME = 0.0              -- How long should we let people select their hero?
POST_GAME_TIME = 10.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 10.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 80                     -- How much gold should players get per tick?
GOLD_TICK_TIME = 60                      -- How long should we wait in seconds between gold ticks?

MINIMAP_ICON_SIZE = 0.5                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 0.5             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 0.5              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                   -- How long in seconds should we wait between rune spawns?

ENABLE_FIRST_BLOOD = true               -- Should we enable first blood for the first kill in this game?
HIDE_KILL_BANNERS = false               -- Should we hide the kill banners that show when a player is killed?

CAMERA_DISTANCE_OVERRIDE = 1300       -- How far out should we allow the camera to go?  1134 is the default in Dota

RECOMMENDED_BUILDS_DISABLED = true     -- Should we disable the recommened builds for heroes
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = true                 -- Should we allow people to buyback when they die?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 100                          -- What level should we let heroes get to?

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = (i-1) * 100
end

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- Should we enable backdoor protection for our towers?

DISABLE_FOG_OF_WAR_ENTIRELY = true     -- Should we disable fog of war entirely for both teams?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

SHOW_ONLY_PLAYER_INVENTORY = false      -- Should we only allow players to see their own inventory even when selecting other units?
DISABLE_ANNOUNCER = false               -- Should we disable the announcer from working in the game?
FORCE_PICKED_HERO = "npc_dota_hero_viper" -- Use nil to allow players to pick their own hero. Unique.
--FORCE_CHANGE_HERO_RADIANT = "npc_dota_hero_ancient_apparition" -- FORCE_CHANGE_HERO_RADIANT~=FORCE_PICKED_HERO
--FORCE_CHANGE_HERO_DIRE = "npc_dota_hero_kunkka" -- FORCE_CHANGE_HERO_DIRE~=FORCE_PICKED_HERO

FIXED_RESPAWN_TIME = 10                 -- What time should we use for a fixed respawn timer?  Use -1 to keep the default dota behavior.
FOUNTAIN_CONSTANT_MANA_REGEN = -1       -- What should we use for the constant fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_MANA_REGEN = -1     -- What should we use for the percentage fountain mana regen?  Use -1 to keep the default dota behavior.
FOUNTAIN_PERCENTAGE_HEALTH_REGEN = -1   -- What should we use for the percentage fountain health regen?  Use -1 to keep the default dota behavior.
MAXIMUM_ATTACK_SPEED = 60000              -- What should we use for the maximum attack speed?
MINIMUM_ATTACK_SPEED = 1               -- What should we use for the minimum attack speed?

LOSE_GOLD_ON_DEATH = false               -- Should we have players lose the normal amount of dota gold on death?
DISABLE_STASH_PURCHASING = false        -- Should we prevent players from being able to buy items into their stash when not at a shop?

-- NOTE: You always need at least 2 non-bounty (non-regen while broken) type runes to be able to spawn or your game will crash!
ENABLED_RUNES = {}                      -- Which runes should be enabled to spawn in our game mode?
ENABLED_RUNES[DOTA_RUNE_DOUBLEDAMAGE] = true
ENABLED_RUNES[DOTA_RUNE_HASTE] = true
ENABLED_RUNES[DOTA_RUNE_ILLUSION] = true
ENABLED_RUNES[DOTA_RUNE_INVISIBILITY] = true
ENABLED_RUNES[DOTA_RUNE_REGENERATION] = true -- Regen runes are currently not spawning as of the writing of this comment
ENABLED_RUNES[DOTA_RUNE_BOUNTY] = true

USE_UNSEEN_FOG_OF_WAR = true           -- Should we make unseen and fogged areas of the map completely black until uncovered by each team?   

CUSTOM_TEAM_PLAYER_COUNT = {}  -- see SetCustomGameTeamMaxPlayers in setSettings !
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 3
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS]  = 3
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_1] = 6
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_2] = 6
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_3] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_4] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_5] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_6] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_7] = 0
CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_CUSTOM_8] = 0

function setSettings()
	-- Get Rid of Shop button - Change the UI Layout if you want a shop button
	-- GameRules:GetGameModeEntity():SetHUDVisible(6, false)
    if GetMapName() == "4players" then
        GameRules.PLAYER_COUNT = 4
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 2
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS] = 2
        GOLD_PER_TICK = GOLD_PER_TICK * 2
    elseif (GetMapName() == "2players") then
      GameRules.PLAYER_COUNT = 2
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 1
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS] = 1
    elseif (GetMapName() == "2builder") then
        GameRules.PLAYER_COUNT = 2
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 1
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS] = 1
    elseif (GetMapName() == "4protect") then
        GameRules.PLAYER_COUNT = 2
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS] = 2
        CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS] = 2
    end

    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_GOODGUYS])
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, CUSTOM_TEAM_PLAYER_COUNT[DOTA_TEAM_BADGUYS])

	GameRules:GetGameModeEntity():SetHUDVisible(8, false) -- DOTA_HUD_VISIBILITY_INVENTORY_QUICKBUY 
	-- GameRules:GetGameModeEntity():SetHUDVisible(12, false)

	GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
	GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
	GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( PRE_GAME_TIME)
	GameRules:SetPostGameTime( POST_GAME_TIME )
	GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	-- GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
	GameRules:SetGoldPerTick(GOLD_PER_TICK)
	GameRules:SetGoldTickTime(GOLD_TICK_TIME)
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	-- GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )

	GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
	GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )

	GameRules:GetGameModeEntity():SetCameraDistanceOverride(CAMERA_DISTANCE_OVERRIDE)

    Convars:RegisterCommand( "lumber", Dynamic_Wrap(CustomGameMode, 'LumberCommand'), "Gives you lumber", FCVAR_CHEAT )
    Convars:RegisterCommand( "food", Dynamic_Wrap(CustomGameMode, 'FoodCommand'), "Gives you food", FCVAR_CHEAT )
    Convars:RegisterCommand( "lifes", Dynamic_Wrap(CustomGameMode, 'LifesCommand'), "Gives all lifes", FCVAR_CHEAT )
    Convars:RegisterCommand( "delay", Dynamic_Wrap(CustomGameMode, 'ChangeWaveDelay'), "Changes delay before waves", FCVAR_CHEAT )
    Convars:RegisterCommand( "wave", Dynamic_Wrap(CustomGameMode, 'setWaveCommand'), "Sets current wave number", FCVAR_CHEAT )
end

function CustomGameMode:setWaveCommand(number)
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      CURENT_WAVE = tonumber(number)
    end
  end
end

function CustomGameMode:LumberCommand(number)
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      if(cmdPlayer.lumber==nil) then cmdPlayer.lumber = 0 end
      cmdPlayer.lumber = cmdPlayer.lumber + tonumber(number)
      if(PLAYERS_PICKED>0) then ModifyLumber(cmdPlayer,0) end
    end
  end
end

function CustomGameMode:LifesCommand(number) -- call before game start
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      if(cmdPlayer.lifes==nil) then cmdPlayer.lifes = 0 end
      cmdPlayer.lifes = cmdPlayer.lifes + tonumber(number)
      RADIANT_LIFES = RADIANT_LIFES + tonumber(number) 
      DIRE_LIFES = DIRE_LIFES + tonumber(number) 
      if(PLAYERS_PICKED>0) then ModifyLifes(cmdPlayer,0) end
    end
  end
end

function CustomGameMode:FoodCommand(number)
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      if(cmdPlayer.food==nil) then cmdPlayer.food = 0 end
      cmdPlayer.food = cmdPlayer.food + tonumber(number)
      if(PLAYERS_PICKED>0) then ModifyFood(cmdPlayer,0) end
    end
  end
end

-- Use command before hero pick
function CustomGameMode:ChangeWaveDelay(number)
  WAVE_FIRST_DELAY = tonumber(number)
  WAVE_DELAY = tonumber(number) -- Delay between waves proportional UNIT_BETWEEN_DELAY
end

function CustomGameMode:_CaptureGameMode(keys)
    local entIndex = keys.index+1
    local ply = EntIndexToHScript(entIndex)
    local playerID = ply:GetPlayerID()
    local team = ply:GetTeamNumber()
    updateStatGUI( ply, RADIANT_LIFES, DIRE_LIFES )
    --DebugPrint("team! team! team! : "..team)
  if mode == nil then
    -- Set GameMode parameters
    mode = GameRules:GetGameModeEntity()        
    mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
    --mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
    mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
    mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
    mode:SetBuybackEnabled( BUYBACK_ENABLED )
    mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
    mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
    mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
    mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
    mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

    --mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
    mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )
    if GetMapName() == "redota" then
      DISABLE_FOG_OF_WAR_ENTIRELY = false
    end
    mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
    mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
    mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

    mode:SetAlwaysShowPlayerInventory( SHOW_ONLY_PLAYER_INVENTORY )
    mode:SetAnnouncerDisabled( DISABLE_ANNOUNCER )
    if (FORCE_PICKED_HERO ~= nil) then mode:SetCustomGameForceHero( FORCE_PICKED_HERO ) end
    mode:SetFixedRespawnTime( FIXED_RESPAWN_TIME ) 
    mode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
    mode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
    mode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
    mode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
    mode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )
    mode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
    mode:SetStashPurchasingDisabled ( DISABLE_STASH_PURCHASING )

    --for rune, spawn in pairs(ENABLED_RUNES) do
    --  mode:SetRuneEnabled(rune, spawn)
    --end

    mode:SetUnseenFogOfWarEnabled(USE_UNSEEN_FOG_OF_WAR)

    --self:OnFirstPlayerLoaded()
  end 
end