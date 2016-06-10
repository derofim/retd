function setListeners(getmode)	
	-- Event Hooks
	ListenToGameEvent('entity_killed', Dynamic_Wrap(CustomGameMode, 'OnEntityKilled'), getmode)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(CustomGameMode, 'OnPlayerPickHero'), getmode)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(CustomGameMode, 'OnConnectFull'), getmode)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CustomGameMode, 'OnNPCSpawned'), getmode)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(CustomGameMode, 'OnGameRulesStateChange'), getmode)

end

-- The overall game state has changed
function CustomGameMode:OnGameRulesStateChange(keys)  
  --DebugPrint("OnGameRulesStateChange")
  --PrintTable(keys)
  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
  	--
  elseif newState == DOTA_GAMERULES_STATE_INIT then
  	--
  elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
  	--
  elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
	CustomGameMode:OnGameInProgress()
  end
end

function CustomGameMode:OnGameInProgress()
	DebugPrint("OnGameInProgress")
	runWaves()
end


function InitAbil( hero )
	for i=0, hero:GetAbilityCount()-1 do
		local abil = hero:GetAbilityByIndex(i)
		if abil ~= nil then
			if hero:IsHero() and hero:GetAbilityPoints() > 0 then
				hero:UpgradeAbility(abil)
			else
				abil:SetLevel(1)
			end
		end
	end
end

function CustomGameMode:OnNPCSpawned(keys)

  local npc = EntIndexToHScript(keys.entindex)

  --if IsCustomBuilding(npc) then
  	--npc:AddNewModifier(unit, nil, "modifier_invulnerable", nil)
  --end

  if npc:IsRealHero() and npc.bFirstSpawned == nil then
    npc.bFirstSpawned = true
    CustomGameMode:OnHeroFirstSpawned(npc)
  end

  local npc = EntIndexToHScript(keys.entindex)
  if npc:IsRealHero() then
        local heroPlayerID = npc:GetPlayerID()
        local player = PlayerResource:GetPlayer(heroPlayerID)
        local team = player:GetTeamNumber()
        --[[if (team == DOTA_TEAM_GOODGUYS) then
          Timers:CreateTimer(0.6, function()
            giveUnitDataDrivenModifier(npc, npc, "modifier_...", -1)
            return
          end )
        end
        if (team == DOTA_TEAM_BADGUYS) then
          Timers:CreateTimer(0.6, function()
            giveUnitDataDrivenModifier(npc, npc, "modifier_...", -1)
            return
          end )
        end]]
  end

  if npc:IsCreature() then
  	--InitAbil(npc)
  end
end

TOTAL_RAD_BARRACKS = 0
TOTAL_DIRE_BARRACKS = 0

function CustomGameMode:OnHeroFirstSpawned(npc) -- OnHeroInGame
    local heroPlayerID = npc:GetPlayerID()
    local player = PlayerResource:GetPlayer(heroPlayerID)
	local hero = player:GetAssignedHero()
    local team = player:GetTeamNumber()

    npc:AddNewModifier(hero, nil, "modifier_phased", nil)
    --npc:SetBaseMoveSpeed(1000)
    --npc:AddNewModifier(hero, nil, "modifier_invulnerable", nil)

	local playercounter = 0
	for nPlayerID = 0, DOTA_MAX_PLAYERS-1 do
		-- ignore broadcasters to count players for the solo buff
		if PlayerResource:IsValidPlayer(nPlayerID) and not PlayerResource:IsBroadcaster(nPlayerID) then 
				playercounter=playercounter+1
		end
	end
	GameRules.PLAYER_COUNT = playercounter

	print("Total Players: " .. GameRules.PLAYER_COUNT)
end

function CustomGameMode:OnConnectFull(keys)
  --DebugPrint('[BAREBONES] OnConnectFull')
  --DebugPrintTable(keys)

  --GameMode:_OnConnectFull(keys)
  CustomGameMode:_CaptureGameMode(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

function setEvents()	
    -- Register Listener
    CustomGameEventManager:RegisterListener( "update_selected_entities", Dynamic_Wrap(CustomGameMode, 'OnPlayerSelectedEntities'))
   	CustomGameEventManager:RegisterListener( "repair_order", Dynamic_Wrap(CustomGameMode, "RepairOrder"))  	
    CustomGameEventManager:RegisterListener( "building_helper_build_command", Dynamic_Wrap(BuildingHelper, "BuildCommand"))
	CustomGameEventManager:RegisterListener( "building_helper_cancel_command", Dynamic_Wrap(BuildingHelper, "CancelCommand"))

	CustomGameEventManager:RegisterListener( "player_voted_difficulty", Dynamic_Wrap(CustomGameMode, 'UpdateVotes'))
	CustomGameEventManager:RegisterListener( "is_voting_ended", Dynamic_Wrap(CustomGameMode, 'ReturnVotes'))
end

function CustomGameMode:ReturnVotes( event )
    local pID = event.pID
    local finished_voting_result = true
    if(GameRules.difficulty_selected == false) then
    	finished_voting_result = false
    end
    CustomGameEventManager:Send_ServerToAllClients("finished_voting", {result = finished_voting_result})
end

function CustomGameMode:UpdateVotes( event )
    local pID = event.pID
    local difficulty = event.difficulty

    if not GameRules.difficulty_selected then
		table.insert(GameRules.PLAYER_VOTES,difficulty)
		print("========VOTE TABLE========")
		DeepPrintTable(GameRules.PLAYER_VOTES)
		print("==========================")

	  	local difficulty_level = 0
	    for k,v in pairs(GameRules.PLAYER_VOTES) do
	    	difficulty_level = difficulty_level + v
	    end

	    difficulty_level = difficulty_level / #GameRules.PLAYER_VOTES
	    print("Average: " ..difficulty_level)
	    difficulty_level = math.floor(difficulty_level+0.5)
	    print("Rounded difficulty: ".. difficulty_level)
	    GameRules.DIFFICULTY = difficulty_level

	    if (#GameRules.PLAYER_VOTES==GameRules.PLAYER_COUNT) then
	    	CustomGameMode:OnEveryoneVoted()
	    end
	end
end

function CustomGameMode:OnEveryoneVoted()
	
	--Fire Game Event to our UI
	CustomGameEventManager:Send_ServerToAllClients("finished_voting", {result = true})

    GameRules:SendCustomMessage("<font color='#2EFE2E'>Finished voting!</font>", 0, 0)

    -- Set the difficulty here.
    GameRules.difficulty_selected = true
    --add_affixes_to_pre_dificulty_creeps()

    -- Change this to the proper strings later
    if GameRules.DIFFICULTY == 0 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Classic</font>", 0, 0)
    elseif GameRules.DIFFICULTY == 1 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Ascendant (1)</font>", 0, 0)
    elseif GameRules.DIFFICULTY == 2 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Elder (2)</font>", 0, 0)
    elseif GameRules.DIFFICULTY == 3 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Mythical (3)</font>", 0, 0)
    elseif GameRules.DIFFICULTY == 4 then
    	GameRules:SendCustomMessage("Difficulty Level: <font color='#2EFE2E'>Legendary (4)</font>", 0, 0)
    end

    -- Add settings to our stat collector
    --[[statcollection.addStats({
        modes = {
            difficulty = GameRules.DIFFICULTY
        }
    })]]

    --[[ Find the barrier_voting and obstructions_voting entities in the map and disable them
    local barrier = Entities:FindByName(nil,"barrier_voting")
	barrier:RemoveSelf()

	local obstructions = Entities:FindAllByName("obstructions_voting")
	for _,v in pairs(obstructions) do
		v:SetEnabled(false,false)
		print("Obstructions disabled")
	end]]
	
end

function CustomGameMode:handleDrop( event )

	local killedUnit = EntIndexToHScript(event.entindex_killed)
	-- The Killing entity
	local killerEntity
	if event.entindex_attacker then
		killerEntity = EntIndexToHScript(event.entindex_attacker)
	end

	local chanceRand = math.random(1, 100)
	local dropItemsTable = { "item_boots_retd", "item_rapier", "item_butterfly",
							 "item_cheese", "item_dagon_5", "item_heart",
							 "item_abyssal_blade", "item_travel_boots_2", "item_moon_shard",
							 "item_vladmir"}


	if(chanceRand<10) then
		local newItem = CreateItem( dropItemsTable[math.random(#dropItemsTable)], nil, nil ) 
		--newItem:SetPurchaseTime( 0 )
		--newItem:SetCurrentCharges( 0 )
		--newItem:LaunchLoot( false, 200, 0.75, hero:GetAbsOrigin() + RandomVector( RandomFloat( 50, 150 ) ) )
		local drop = CreateItemOnPositionSync( killedUnit:GetAbsOrigin(), newItem )
	end
end

-- An entity died
function CustomGameMode:OnEntityKilled( event )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	-- The Killing entity
	local killerEntity
	if event.entindex_attacker then
		killerEntity = EntIndexToHScript(event.entindex_attacker)
	end

	-- Player owner of the unit
	local player = killedUnit:GetPlayerOwner()

	if ( player==nil and not IsCustomBuilding(killedUnit) and not IsBuilder(killedUnit) ) then
		CustomGameMode:handleDrop(event)
	end

	-- Building Killed
	if IsCustomBuilding(killedUnit) then

		 -- Building Helper grid cleanup
		BuildingHelper:RemoveBuilding(killedUnit, true)

		-- Check units for downgrades
		local building_name = killedUnit:GetUnitName()
				
		-- Substract 1 to the player building tracking table for that name
		if player.buildings[building_name] then
			player.buildings[building_name] = player.buildings[building_name] - 1
		end

		-- possible unit downgrades
		for k,units in pairs(player.units) do
		    CheckAbilityRequirements( units, player )
		end

		-- possible structure downgrades
		for k,structure in pairs(player.structures) do
			CheckAbilityRequirements( structure, player )
		end
	end

	-- Cancel queue of a builder when killed
	if IsBuilder(killedUnit) then
		BuildingHelper:ClearQueue(killedUnit)
	end

	-- Table cleanup
	if (player) then
		-- Remake the tables
		local table_structures = {}
		for _,building in pairs(player.structures) do
			if building and IsValidEntity(building) and building:IsAlive() then
				--print("Valid building: "..building:GetUnitName())
				table.insert(table_structures, building)
			end
		end
		player.structures = table_structures
		
		local table_units = {}
		for _,unit in pairs(player.units) do
			if unit and IsValidEntity(unit) then
				table.insert(table_units, unit)
			end
		end
		player.units = table_units		
	end
end

-- Called whenever a player changes its current selection, it keeps a list of entity indexes
function CustomGameMode:OnPlayerSelectedEntities( event )
	local pID = event.pID

	GameRules.SELECTED_UNITS[pID] = event.selected_entities

	-- This is for Building Helper to know which is the currently active builder
	local mainSelected = GetMainSelectedEntity(pID)
	if IsValidEntity(mainSelected) and IsBuilder(mainSelected) then
		local player = PlayerResource:GetPlayer(pID)
		player.activeBuilder = mainSelected
	end
end

function spawnPeasants(caster,player,hero,playerID,team)
	-- Spawn some peasants
	local positionRad = { 
						Entities:FindByName( nil, "rad_peasant_hard"):GetAbsOrigin(),
						Entities:FindByName( nil, "rad_peasant_easy"):GetAbsOrigin(),
						Entities:FindByName( nil, "rad_peasant_lane"):GetAbsOrigin()
					 }
	local positionDire = { 
						Entities:FindByName( nil, "dire_peasant_hard"):GetAbsOrigin(),
						Entities:FindByName( nil, "dire_peasant_easy"):GetAbsOrigin(),
						Entities:FindByName( nil, "dire_peasant_lane"):GetAbsOrigin()
					 }

	local numBuilders = 3
	local angle = 360/numBuilders
	for i=1,numBuilders do
		local rotate_pos = positionDire[i] + Vector(1,0,0) * 100
		local builder_pos = RotatePosition(positionDire[i], QAngle(0, angle*i, 0), rotate_pos)
		if (team == DOTA_TEAM_GOODGUYS) then
			rotate_pos = positionRad[i] + Vector(1,0,0) * 100
			builder_pos = RotatePosition(positionRad[i], QAngle(0, angle*i, 0), rotate_pos)
		end

		if(playerID == i-1 or playerID-3 == i-1) then
			local builder = CreateUnitByName("peasant", builder_pos+Vector(TOTAL_RAD_BARRACKS), true, hero, hero, hero:GetTeamNumber())
			builder:SetOwner(hero)
			builder:SetControllableByPlayer(playerID, true)
			builder:AddNewModifier(builder, nil, "modifier_phased", nil)
			builder:AddNewModifier(builder, nil, "modifier_item_phase_boots_active", nil)
			builder:AddNewModifier(builder, nil, "modifier_invulnerable", nil)
			table.insert(player.units, builder)
			builder.state = "idle"
		
			PlayerResource:SetCameraTarget(playerID, builder)
			Timers:CreateTimer(0.03,
				function()
          			PlayerResource:SetCameraTarget(playerID, nil)
          			--SetOverrideSelectionEntity(playerID, builder)
          			AddUnitToSelection(builder)
          			RemoveUnitFromSelection(hero)
				end
			)
		end

		-- Go through the abilities and upgrade
		CheckAbilityRequirements( builder, player )
	end
end

function spawnBarracks(caster,player,hero,playerID,team)
  	local barrack_name = "boss_barrack"
  	local barrack = Entities:FindByName( nil, "dire_base_barrack")
  	if (barrack~=nil) then
  		local barrack_pos = barrack:GetAbsOrigin()
 		if (team == DOTA_TEAM_GOODGUYS) then
			barrack_pos = Entities:FindByName( nil, "rad_base_barrack"):GetAbsOrigin()
  			barrack_pos = barrack_pos + Vector(TOTAL_RAD_BARRACKS*300)
  			TOTAL_RAD_BARRACKS = TOTAL_RAD_BARRACKS + 1
  		else
			barrack_pos = barrack_pos + Vector(TOTAL_DIRE_BARRACKS*300)
 	 		TOTAL_DIRE_BARRACKS = TOTAL_DIRE_BARRACKS + 1
 		end
 		local barrack_unit = CreateUnitByName( barrack_name, barrack_pos, true, player, hero, team )
 		barrack_unit:SetOwner(hero)
 		barrack_unit:SetControllableByPlayer(playerID, true)
 	end
end

-- A player picked a hero
function CustomGameMode:OnPlayerPickHero(keys)

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = hero:GetPlayerID()
	local hero = player:GetAssignedHero()
	local team = hero:GetTeamNumber()

	PLAYERS_PICKED = PLAYERS_PICKED + 1
	DebugPrint("PLAYERS_PICKED+1 TOTAL:"..PLAYERS_PICKED)

	if (team==DOTA_TEAM_GOODGUYS) then
		--table.insert(radPID, playerID)
		radPID[PLAYERS_PICKED] = playerID
	elseif (team==DOTA_TEAM_BADGUYS) then
		--table.insert(direPID, playerID)
		direPID[PLAYERS_PICKED] = playerID
	end

	updateStatGUI( player, RADIANT_LIFES, DIRE_LIFES )

  	hero:AddNewModifier(hero, nil, "modifier_item_phase_boots_active", nil)

	-- Initialize Variables for Tracking
	player.units = {} -- This keeps the handle of all the units of the player, to iterate for unlocking upgrades
	player.structures = {} -- This keeps the handle of the constructed units, to iterate for unlocking upgrades
	player.buildings = {} -- This keeps the name and quantity of each building
	player.upgrades = {} -- This kees the name of all the upgrades researched
	player.lumber = 0 -- Secondary resource of the player
	player.food = 0 -- Secondary resource of the player
	if (team==DOTA_TEAM_GOODGUYS) then
		player.lifes = RADIANT_LIFES
		ModifyLifes(player, 0)
	elseif (team==DOTA_TEAM_BADGUYS) then
		player.lifes = DIRE_LIFES
		ModifyLifes(player, 0)
	else
		player.lifes = 0
		ModifyLifes(player, 0)
	end
 	
	if GetMapName() == "retd" then
		spawnBarracks(caster,player,hero,playerID,team)
	end


	local builder = CreateUnitByName("peasant", hero:GetAbsOrigin()+RandomVector(RandomFloat(100,200)), true, hero, hero, hero:GetTeamNumber())
	builder:SetOwner(hero)
	builder:SetControllableByPlayer(playerID, true)
	builder:AddNewModifier(builder, nil, "modifier_phased", nil)
	builder:AddNewModifier(builder, nil, "modifier_item_phase_boots_active", nil)
	builder:AddNewModifier(builder, nil, "modifier_invulnerable", nil)
	table.insert(player.units, builder)
	builder.state = "idle"


    local heroOwnedTable = {"owned_hero_void","owned_hero_jakiro"}
    local seed_time = Time()
    math.randomseed(seed_time)
    DebugPrint(seed_time)
    local chanceRand = math.random(#heroOwnedTable)
	local owned_hero = CreateUnitByName(heroOwnedTable[chanceRand], hero:GetAbsOrigin()+RandomVector(RandomFloat(100,200)), true, hero, hero, hero:GetTeamNumber())
	owned_hero:SetOwner(hero)
	owned_hero:SetControllableByPlayer(playerID, true)
	owned_hero:AddNewModifier(owned_hero, nil, "modifier_phased", nil)
	owned_hero:AddNewModifier(owned_hero, nil, "modifier_item_phase_boots_active", nil)
	--owned_hero:AddNewModifier(caster, nil, "modifier_invulnerable", nil)
	table.insert(player.units, owned_hero)
	owned_hero.state = "idle"

    -- Create city center in front of the hero
    -- local position = hero:GetAbsOrigin() + hero:GetForwardVector() * 300
    -- local city_center_name = "city_center"
	--local building = BuildingHelper:PlaceBuilding(player, city_center_name, position, true, 5) 

	-- Set health to test repair
	--building:SetHealth(building:GetMaxHealth()/3)

	-- These are required for repair to know how many resources the building takes
	--building.GoldCost = 100
	--building.LumberCost = 100
	--building.BuildTime = 15

	-- Add the building to the player structures list
	--player.buildings[city_center_name] = 1
	--table.insert(player.structures, building)

	CheckAbilityRequirements( hero, player )
	--CheckAbilityRequirements( building, player )

	-- Add the hero to the player units list
	table.insert(player.units, hero)
	hero.state = "idle" --Builder state
	if GetMapName() == "retd" then
		spawnPeasants(caster,player,hero,playerID,team)
	end

	-- Give Initial Resources
	hero:SetGold(STARTING_GOLD, false)
	ModifyLumber(player, STARTING_LUMBER)
	ModifyFood(player, STARTING_FOOD)

	-- Lumber tick
	Timers:CreateTimer(1, function()
		ModifyLumber(player, 10)
		return 10
	end)

	-- Give a building ability
	local item = CreateItem("item_build_wall", hero, hero)
	hero:AddItem(item)

	item = CreateItem("item_blink", hero, hero)
	hero:AddItem(item)

	item = CreateItem("item_ward_sentry", hero, hero)
	hero:AddItem(item)


	-- Learn all abilities (this isn't necessary on creatures)
	for i=0,15 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then ability:SetLevel(ability:GetMaxLevel()) end
	end
	hero:SetAbilityPoints(0)

	if (GameRules.PLAYER_COUNT==PLAYERS_PICKED) then
    	CustomGameMode:OnEveryonePicked()
    end

end

function CustomGameMode:OnEveryonePicked()
	print("OnEveryonePicked")

	local show_duration = 15
	local show_delay = 15
	local tipsTable={"#helloauthor","#hellohas",
					 "#hellobuilders","#hellotowers",
					 "#hellohero","#hellomazes",
					 "#hellomelee","#helloitems",
					 "#hellopyro","#hellorapid",
					 "#helloair","hellopoision","#hellomelee",
					 "#hellocreeps","#helloultimate",
					 "#hellobarrack","#hellostun"}
	for i=1,#tipsTable do
		Timers:CreateTimer((i-1)*show_delay,function()
			CustomGameEventManager:Send_ServerToAllClients("top_notification", 
				{text=tipsTable[i], duration=show_duration, 
				class="NotificationMessage", style=nil, continue=false} )
			return nil
		end)
	end

	--GameRules:SendCustomMessage("<font color='#ffd700'>RETD</font> v" .. ADDON_VERSION, 0, 0)

	if GetMapName() == "retd" then
    	Say(hero,"Choose lane and build towers!<br/>You can use peasants and boss spawner.", false)
	elseif GetMapName() == "4builders" then
    	Say(hero,"Create maze and build towers!<br/>You can use walls.", false)
    else 
    	Say(hero,"Choose lane and build towers!", false)
   	end

    GameRules:SendCustomMessage(VOTE_DIFF_TIME.." sec. to select a difficulty",0,0)
    --Timers:CreateTimer(60,function() if not GameRules.difficulty_selected then GameRules:SendCustomMessage("60 seconds remaining",0,0) end end)
    --Timers:CreateTimer(90,function() if not GameRules.difficulty_selected then GameRules:SendCustomMessage("30 seconds remaining",0,0) end end)
    --Timers:CreateTimer(110,function() if not GameRules.difficulty_selected then GameRules:SendCustomMessage("10 seconds remaining!",0,0) end end)
    Timers:CreateTimer(VOTE_DIFF_TIME,function() if not GameRules.difficulty_selected then CustomGameMode:OnEveryoneVoted() end end)
end