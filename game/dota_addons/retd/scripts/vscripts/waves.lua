print ('[TD] waves.lua' )  


function prepareWaves()
  if GetMapName() == "retd" then
    RADIANT_PATH = { Entities:FindByName( nil, "radiant_base_spawn"),Entities:FindByName( nil, "hard_dire1"), Entities:FindByName( nil, "dire_easy_1") }
    DIRE_PATH = { Entities:FindByName( nil, "dire_base_spawn"),Entities:FindByName( nil, "hard_rad1"), Entities:FindByName( nil, "rad_easy_1") }
  elseif GetMapName() == "4players" then
    RADIANT_PATH = { Entities:FindByName( nil, "radiant_base_spawn"),Entities:FindByName( nil, "radiant_base_spawn") }
    DIRE_PATH = { Entities:FindByName( nil, "dire_base_spawn"),Entities:FindByName( nil, "dire_base_spawn") }
  elseif GetMapName() == "4protect" then
    RADIANT_PATH = { Entities:FindByName( nil, "radiant_base_spawn"),Entities:FindByName( nil, "radiant_base_spawn1") }
    DIRE_PATH = { Entities:FindByName( nil, "dire_base_spawn"),Entities:FindByName( nil, "dire_base_spawn1") }
  
  elseif GetMapName() == "redota" then
    if(PLAYERS_PICKED>5) then
      RADIANT_PATH = { Entities:FindByName( nil, "lane_mid_pathcorner_goodguys_1"),Entities:FindByName( nil, "lane_top_pathcorner_goodguys_1"),Entities:FindByName( nil, "lane_bot_pathcorner_goodguys_1") }
      DIRE_PATH = { Entities:FindByName( nil, "lane_mid_pathcorner_badguys_1"),Entities:FindByName( nil, "lane_top_pathcorner_badguys_1"),Entities:FindByName( nil, "lane_bot_pathcorner_badguys_1") }
    else
      RADIANT_PATH = { Entities:FindByName( nil, "lane_mid_pathcorner_goodguys_1") }
      DIRE_PATH = { Entities:FindByName( nil, "lane_mid_pathcorner_badguys_1") }
    end
  else
    RADIANT_PATH = { Entities:FindByName( nil, "radiant_base_spawn") }
    DIRE_PATH = { Entities:FindByName( nil, "dire_base_spawn") }
  end
  
  RADIANT_SPAWNS = {}
  for l, itRadPath in ipairs(RADIANT_PATH) do
    RADIANT_SPAWNS[l]= itRadPath:GetAbsOrigin()
  end

  DIRE_SPAWNS = {}
  for j, itDirePath in ipairs(DIRE_PATH) do
    DIRE_SPAWNS[j]= itDirePath:GetAbsOrigin()
  end
end

function runWaves()
  prepareWaves()

  Timers:CreateTimer(WAVE_FIRST_DELAY/4,function() GameRules:SendCustomMessage(WAVE_FIRST_DELAY-WAVE_FIRST_DELAY/4 .." seconds remaining before first wave",0,0) end)
  Timers:CreateTimer(WAVE_FIRST_DELAY/3,function() GameRules:SendCustomMessage(WAVE_FIRST_DELAY-WAVE_FIRST_DELAY/3 .." seconds remaining before first wave",0,0) end)
  Timers:CreateTimer(WAVE_FIRST_DELAY/2,function() GameRules:SendCustomMessage(WAVE_FIRST_DELAY-WAVE_FIRST_DELAY/2 .." seconds remaining before first wave",0,0) end)
  Timers:CreateTimer(WAVE_FIRST_DELAY-WAVE_FIRST_DELAY/3,function() GameRules:SendCustomMessage(WAVE_FIRST_DELAY/3 .." seconds remaining before first wave",0,0) end)
  Timers:CreateTimer(WAVE_FIRST_DELAY-WAVE_FIRST_DELAY/4,function() GameRules:SendCustomMessage(WAVE_FIRST_DELAY/4 .." seconds remaining before first wave",0,0) end)
  

  --IS_WAVE_RUNNING = true
  Timers:CreateTimer({
    useGameTime = true,
    endTime = WAVE_FIRST_DELAY,
    callback = function()
      local return_time = UNIT_BETWEEN_DELAY
      WAVES_RUNNING = true
      if (WAVE_DESCRIPTIONS[CURENT_WAVE]==nil) then WAVE_DESCRIPTIONS[CURENT_WAVE]="" end
      if (WAVE_UNIT_COUNT[CURENT_WAVE]==nil) then WAVE_UNIT_COUNT[CURENT_WAVE]=LOOP_UNIT_COUNT end
      -- Do WAVE_DELAY
      if(HELPER_SPAWNED_UNITS == 0) then
        if (HELPER_IS_DELAY == true) then
          HELPER_WAVE_TIME = HELPER_WAVE_TIME + UNIT_BETWEEN_DELAY
          if (HELPER_WAVE_TIME >= WAVE_DELAY) then
            HELPER_WAVE_TIME = 0
            --Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CURENT_WAVE )
            if(Quest~=nil) then Quest:CompleteQuest() end
            Quest = SpawnEntityFromTableSynchronous( "quest", { name = "QuestName", title = "Wave № <font color='#0ff000'>" .. CURENT_WAVE .. "</font> ".. WAVE_DESCRIPTIONS[CURENT_WAVE] } ) 
            Quest.EndTime = WAVE_UNIT_COUNT[CURENT_WAVE]
            subQuest = SpawnEntityFromTableSynchronous( "subquest_base", { show_progress_bar = true, progress_bar_hue_shift = -119 } ) 
            Quest:AddSubquest( subQuest ) 
            -- text on the quest timer at start 
            Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE] ) 
            Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE] ) 
            -- value on the bar 
            subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE] ) 
            subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE] )
            Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CURENT_WAVE )
            GameRules:SendCustomMessage("Wave № <font color='#0ff000'>" .. CURENT_WAVE .. "</font> ".. WAVE_DESCRIPTIONS[CURENT_WAVE], 0, 0)
            if(WAVE_DESCRIPTIONS[CURENT_WAVE+1]~=nil and WAVE_DESCRIPTIONS[CURENT_WAVE+1]~="") then GameRules:SendCustomMessage("Next: ".. WAVE_DESCRIPTIONS[CURENT_WAVE+1], 0, 0) end
          else
            local delay_time = WAVE_DELAY-HELPER_WAVE_TIME
            if ( delay_time % 1 == 0 and (delay_time==10 or delay_time<6) ) then
              GameRules:SendCustomMessage("Wave starts in <font color='#ff0000'>" .. delay_time .. "</font> sec.", 0, 0)
            end
            return return_time 
          end
        end
        if (CURENT_WAVE == START_WAVE) then
          Quest = SpawnEntityFromTableSynchronous( "quest", { name = "QuestName", title = "Wave № <font color='#0ff000'>" .. CURENT_WAVE .. "</font> ".. WAVE_DESCRIPTIONS[CURENT_WAVE] } ) 
          Quest.EndTime = WAVE_UNIT_COUNT[CURENT_WAVE]
          subQuest = SpawnEntityFromTableSynchronous( "subquest_base", { show_progress_bar = true, progress_bar_hue_shift = -119 } ) 
          Quest:AddSubquest( subQuest ) 
          -- text on the quest timer at start 
          Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE] ) 
          Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE] ) 
          -- value on the bar 
          subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE] ) 
          subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE] )
          Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, CURENT_WAVE )
          GameRules:SendCustomMessage("Wave № <font color='#0ff000'>" .. CURENT_WAVE .. "</font> ".. WAVE_DESCRIPTIONS[CURENT_WAVE], 0, 0)
          if(WAVE_DESCRIPTIONS[CURENT_WAVE+1]~=nil and WAVE_DESCRIPTIONS[CURENT_WAVE+1]~="") then GameRules:SendCustomMessage("Next: ".. WAVE_DESCRIPTIONS[CURENT_WAVE+1], 0, 0) end
        end
      end

      -- Do spawnWaveUnit()
      HELPER_TIME = HELPER_TIME + UNIT_BETWEEN_DELAY
      if (HELPER_TIME > UNIT_BETWEEN_DELAY) then
        HELPER_TIME = 0
        HELPER_IS_DELAY = false
      elseif (HELPER_TIME == UNIT_BETWEEN_DELAY) then
          if(WAVE_UNIT_COUNT[CURENT_WAVE]==nil or WAVE_UNIT_COUNT[CURENT_WAVE]<1) then
            WAVE_UNIT_COUNT[CURENT_WAVE] = LOOP_UNIT_COUNT
          end
          if (HELPER_SPAWNED_UNITS >= WAVE_UNIT_COUNT[CURENT_WAVE]) then
            HELPER_SPAWNED_UNITS = 0
            if(Quest~=nil) then Quest:RemoveSubquest(subQuest) end

            CURENT_WAVE = CURENT_WAVE + 1
            LOST_LIFES_HELPER_WAVE = CURENT_WAVE % LOST_LIFES_WAVE_RESET_COUNT
            if(LOST_LIFES_HELPER_WAVE == 0) then
              LOST_LEFES_RAD_RESET = 0  
              LOST_LEFES_DIRE_RESET = 0
              LOST_LIFES_HELPER_WAVE_SUM_UNITS = WAVE_UNIT_COUNT[CURENT_WAVE] + WAVE_UNIT_COUNT[CURENT_WAVE+1] + WAVE_UNIT_COUNT[CURENT_WAVE+2]
            end
            HELPER_IS_DELAY = true
            if( CURENT_WAVE > WAVE_COUNT) then
              -- GameRules:SendCustomMessage("You won!", 0, 0)
              if (IS_WAVES_INFINITE == true) then
                createSpawnLoop()
              end 
              -- return nil
            end
            -- GameRules:SendCustomMessage("Next wave №" .. CURENT_WAVE .. WAVE_DESCRIPTIONS[CURENT_WAVE], 0, 0)
          else
            HELPER_SPAWNED_UNITS = HELPER_SPAWNED_UNITS + 1
            --Quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE]-HELPER_SPAWNED_UNITS ) 
            if(subQuest ~=nil) then
              subQuest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, WAVE_UNIT_COUNT[CURENT_WAVE]-HELPER_SPAWNED_UNITS )
            end
            if( CURENT_WAVE > WAVE_COUNT) then
              spawnWaveUnit( LOOP_BASE_UNIT, LOOP_BASE_UNIT, CURENT_WAVE)
            else
              spawnWaveUnit( WAVE_UNIT_NAMES[CURENT_WAVE], WAVE_UNIT_NAMES[CURENT_WAVE], 1)
            end
            -- GameRules:SendCustomMessage("Unit №" .. HELPER_SPAWNED_UNITS, 0, 0)
          end
      end
      return return_time
    end})
end

function spawnWaveUnit(radiant_unit, dire_unit, powerCoeficient)
  for m, itRadSpawn in ipairs(RADIANT_SPAWNS) do
    spawnUnit(radiant_unit, RADIANT_SPAWNS[m], DOTA_TEAM_GOODGUYS, RADIANT_PATH[m], powerCoeficient)
  end
  for m, itRadSpawn in ipairs(DIRE_SPAWNS) do
    spawnUnit(dire_unit, DIRE_SPAWNS[m], DOTA_TEAM_BADGUYS, DIRE_PATH[m], powerCoeficient)
  end
end

function spawnUnit(name, spawn, team, path, powerCoeficient)
  local unit = CreateUnitByName( name, spawn, true, nil, nil, team )
  local health_points = unit:GetBaseMaxHealth()
  if (unit:IsInvisible()) then
      unit.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", PATTACH_OVERHEAD_FOLLOW, unit ) 
      ParticleManager:SetParticleControl( unit.particle, 0, unit:GetAbsOrigin() ) 
      ParticleManager:SetParticleControl( unit.particle, 1, unit:GetAbsOrigin() ) 
  end
  if(LOST_LEFES_RAD_RESET+LOST_LEFES_DIRE_RESET>2*LOST_LIFES_HELPER_WAVE_SUM_UNITS/LOST_LIFES_WAVE_RESET_COUNT) then
    unit:SetBaseMaxHealth(0.8*health_points)
    unit:SetMaxHealth(0.8*health_points)
    unit:SetHealth(0.8*health_points)
  else
    unit:SetBaseMaxHealth(1.15*health_points)
    unit:SetMaxHealth(1.15*health_points)
    unit:SetHealth(1.15*health_points)
  end
  if GameRules.DIFFICULTY == 0 then
    unit:SetBaseMaxHealth(0.5*health_points)
    unit:SetMaxHealth(0.5*health_points)
    unit:SetHealth(0.5*health_points)
  elseif GameRules.DIFFICULTY == 1 then
    unit:SetBaseMaxHealth(1.0*health_points)
    unit:SetMaxHealth(1.0*health_points)
    unit:SetHealth(1.0*health_points)
  elseif GameRules.DIFFICULTY == 2 then
    unit:SetBaseMaxHealth(2.0*health_points)
    unit:SetMaxHealth(2.0*health_points)
    unit:SetHealth(2.0*health_points)
  elseif GameRules.DIFFICULTY == 3 then
    unit:SetBaseMaxHealth(3.0*health_points)
    unit:SetMaxHealth(3.0*health_points)
    unit:SetHealth(3.0*health_points)
  elseif GameRules.DIFFICULTY == 4 then
    unit:SetBaseMaxHealth(4.0*health_points)
    unit:SetMaxHealth(4.0*health_points)
    unit:SetHealth(4.0*health_points)
  end
  local random = math.random(1, 10)
  if (random == 3 or random == 7) then
    unit:SetBaseMaxHealth(1.5*unit:GetBaseMaxHealth())
    unit:SetMaxHealth(1.5*unit:GetMaxHealth())
    unit:SetHealth(1.5*unit:GetMaxHealth())
    unit:SetModelScale(unit:GetModelScale()+0.1*math.random(3, 10))
    unit:AddNewModifier(unit, nil, "modifier_neutral_spell_immunity", nil)
    unit:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
  end
  if GetMapName() == "retd" then
      unit:SetMaximumGoldBounty(1.8*unit:GetMaximumGoldBounty())
  elseif GetMapName() == "4players" then
      unit:SetMaximumGoldBounty(2*unit:GetMaximumGoldBounty())
  elseif GetMapName() == "redota" then
      unit:SetMaximumGoldBounty(0.8*unit:GetMaximumGoldBounty())
  end
  unit:AddNewModifier(unit, nil, "modifier_item_phase_boots_active", nil)
  unit:SetInitialGoalEntity( path )
  if(powerCoeficient > 1) then
    unit:SetPhysicalArmorBaseValue(powerCoeficient*0.85)
    unit:SetBaseMagicalResistanceValue(powerCoeficient*0.85)
    unit:SetMaximumGoldBounty(3*powerCoeficient)
    unit:SetBaseHealthRegen(powerCoeficient)
    unit:SetBaseMaxHealth(550*powerCoeficient)
    unit:SetMaxHealth(550*powerCoeficient)
    unit:SetHealth(550*powerCoeficient)
    unit:SetModelScale(0.1*math.random(10, 20))
  --[[  Timers:CreateTimer({
      useGameTime = true,
      endTime = 0.3,
      callback = function()
      unit:SetBaseDamageMax(500*powerCoeficient)
      unit:SetBaseDamageMin(500*powerCoeficient)
      unit:SetBaseHealthRegen(powerCoeficient)
      unit:SetBaseMaxHealth(500*powerCoeficient)
      unit:SetMaxHealth(500*powerCoeficient)
      unit:SetHealth(500*powerCoeficient)
      unit:SetMana(500*powerCoeficient)
      unit:GiveMana(500*powerCoeficient)
      unit:SetBaseManaRegen(powerCoeficient)
      unit:SetMaximumGoldBounty(20*powerCoeficient)
      unit:SetNightTimeVisionRange(1800)
      unit:SetBaseMoveSpeed(500)
      unit:SetPhysicalArmorBaseValue(powerCoeficient)
      unit:SetModelScale(0.1*math.random(1, 20))
      --unit:SetMaximumAttackSpeed(10*powerCoeficient)
      --unit:SetMinimumAttackSpeed(10*powerCoeficient)
      local ability = unit:GetAbilityByIndex(1)
      if ability then unit:RemoveAbility(ability:GetName()) end
      -- https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Ability_Names
      local abilityTable = { "ursa_fury_swipes","troll_warlord_fervor","vengefulspirit_command_aura","viper_corrosive_skin","warlock_golem_flaming_fists","warlock_golem_permanent_immolation", "sven_great_cleave","tiny_craggy_exterior" }
      unit:AddAbility(abilityTable[math.random(1, #abilityTable)])
      ability = unit:GetAbilityByIndex(1)
      ability:SetLevel(1)
      -- https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Item_Names
      --unit:AddItemByName("item_example_item")
      -- https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Modifier_Names
      --local modifierTable = { "modifier_abyssal_underlord_firestorm_burn", "modifier_rune_haste","modifier_rune_invis","modifier_rune_doubledamage","modifier_roshan_spell_block","modifier_treant_living_armor" }
      --unit:AddNewModifier(unit, nil, modifierTable[math.random(1, #modifierTable)], nil)
      --local modelTable = { "models/heroes/viper/viper.vmdl","models/heroes/drow/drow.vmdl", "models/heroes/wisp/wisp.vmdl" }
      --local mdl = modelTable[math.random(1, #modelTable)]
      --unit:SetOriginalModel(mdl)
      --unit:SetModel(mdl)
    return nil
    end
    })]]
  end
end

function spawnWaveInHeap()
  GameRules:SendCustomMessage("Wave №" .. CURENT_WAVE .. " ("..WAVE_DESCRIPTIONS[CURENT_WAVE] .. ")", 0, 0)
  for i=1, WAVE_UNIT_COUNT[CURENT_WAVE] do
    spawnWaveUnit(WAVE_UNIT_NAMES[CURENT_WAVE], WAVE_UNIT_NAMES[CURENT_WAVE], 1)
  end
end

--[[ call if (IS_WAVES_INFINITE == true)
function createSpawnLoop()
  Timers:CreateTimer({
      useGameTime = true,
      endTime = 0,
      callback = function()
      local return_time = UNIT_BETWEEN_DELAY

      -- Do WAVE_DELAY
      if(HELPER_SPAWNED_UNITS == 0) then
        if (HELPER_IS_DELAY == true) then
          HELPER_WAVE_TIME = HELPER_WAVE_TIME + UNIT_BETWEEN_DELAY
          if (HELPER_WAVE_TIME >= WAVE_DELAY) then
            HELPER_WAVE_TIME = 0
            GameRules:SendCustomMessage("Wave №" .. CURENT_WAVE .. " ( loop )", 0, 0)
          else
            return return_time 
          end
        end
        if (CURENT_WAVE == WAVE_COUNT) then
          GameRules:SendCustomMessage("Wave №" .. CURENT_WAVE .. " ( loop )", 0, 0)
        end
      end

      -- Do spawnWaveUnit()
      HELPER_TIME = HELPER_TIME + UNIT_BETWEEN_DELAY
      if (HELPER_TIME > UNIT_BETWEEN_DELAY) then
        HELPER_TIME = 0
        HELPER_IS_DELAY = false
      elseif (HELPER_TIME == UNIT_BETWEEN_DELAY) then
          if (HELPER_SPAWNED_UNITS >= LOOP_UNIT_COUNT) then
            HELPER_SPAWNED_UNITS = 0
            CURENT_WAVE = CURENT_WAVE + 1
            HELPER_IS_DELAY = true
          else
            HELPER_SPAWNED_UNITS = HELPER_SPAWNED_UNITS + 1
            spawnWaveUnit(LOOP_BASE_UNIT,LOOP_BASE_UNIT, CURENT_WAVE)
            -- GameRules:SendCustomMessage("Unit №" .. HELPER_SPAWNED_UNITS, 0, 0)
          end
      end
      return return_time
    end})
end]]

function SpawnBoss( event )
  local caster = event.caster
  local ability = event.ability
  local ability_name = ability:GetAbilityName()
  local AbilityKV = GameRules.AbilityKV
  local UnitKV = GameRules.UnitKV

    -- Hold needs an Interrupt
  if caster.bHold then
    caster.bHold = false
    caster:Interrupt()
  end

  local build_time = ability:GetSpecialValueFor("build_time")
  local gold_cost = ability:GetSpecialValueFor("gold_cost")
  local lumber_cost = ability:GetSpecialValueFor("lumber_cost")

  local hero = caster:GetPlayerOwner():GetAssignedHero()
  local playerID = hero:GetPlayerID()
  local player = PlayerResource:GetPlayer(playerID) 
  local team = hero:GetTeamNumber()

  hero:ModifyGold(gold_cost, false, 0)
  if (not RADIANT_SPAWNS or not DIRE_SPAWNS) then
     SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_wave_running")
     --hero:ModifyGold(gold_cost, false, 0)
  elseif (hero:GetGold() < gold_cost) then
     SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_enough_gold")
     --hero:ModifyGold(gold_cost, false, 0)
  elseif (player.lumber < lumber_cost) then
    SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_enough_lumber")
    --hero:ModifyGold(-gold_cost, false, 0)
  else
    hero:ModifyGold(-gold_cost, false, 0)
    ModifyLumber( player, -lumber_cost)
    local building_name = AbilityKV[ability_name].UnitName
    local spawnPointRad = RADIANT_SPAWNS[1]
    local spawnPointDire = DIRE_SPAWNS[1]
    if (team == DOTA_TEAM_GOODGUYS) then
      spawnUnit(building_name, spawnPointRad, DOTA_TEAM_GOODGUYS, RADIANT_PATH[1], 1)
      Say(hero,"Boss spawned by radiant!", false)
    else
      spawnUnit(building_name, spawnPointDire, DOTA_TEAM_BADGUYS, DIRE_PATH[1], 1)
      Say(hero,"Boss spawned by dire!", false)
    end
  end
end

function SpawnCreep( event )
  local caster = event.caster
  local ability = event.ability
  local ability_name = ability:GetAbilityName()
  local AbilityKV = GameRules.AbilityKV
  local UnitKV = GameRules.UnitKV

    -- Hold needs an Interrupt
  if caster.bHold then
    caster.bHold = false
    caster:Interrupt()
  end

  local build_time = ability:GetSpecialValueFor("build_time")
  local gold_cost = ability:GetSpecialValueFor("gold_cost")
  local lumber_cost = ability:GetSpecialValueFor("lumber_cost")

  local hero = caster:GetPlayerOwner():GetAssignedHero()
  local playerID = hero:GetPlayerID()
  local player = PlayerResource:GetPlayer(playerID) 
  local team = hero:GetTeamNumber()

  hero:ModifyGold(gold_cost, false, 0)
  if (not RADIANT_SPAWNS or not DIRE_SPAWNS) then
     SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_wave_running")
     --hero:ModifyGold(gold_cost, false, 0)
  elseif (hero:GetGold() < gold_cost) then
     SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_enough_gold")
     --hero:ModifyGold(gold_cost, false, 0)
  elseif (player.lumber < lumber_cost) then
    SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_enough_lumber")
    --hero:ModifyGold(-gold_cost, false, 0)
  else
    hero:ModifyGold(-gold_cost, false, 0)
    ModifyLumber( player, -lumber_cost)
    local building_name = AbilityKV[ability_name].UnitName
    local spawnPointRad = RADIANT_SPAWNS[1]
    local spawnPointDire = DIRE_SPAWNS[1]
    if (team == DOTA_TEAM_GOODGUYS) then
      spawnUnit(building_name, spawnPointRad, DOTA_TEAM_GOODGUYS, RADIANT_PATH[1], 1)
      --Say(hero,"Boss spawned by radiant!", false)
    else
      spawnUnit(building_name, spawnPointDire, DOTA_TEAM_BADGUYS, DIRE_PATH[1], 1)
      --Say(hero,"Boss spawned by dire!", false)
    end
  end
end

function DoublePower( event )
  local caster = event.caster
  local ability = event.ability
  local ability_name = ability:GetAbilityName()
  local AbilityKV = GameRules.AbilityKV
  local UnitKV = GameRules.UnitKV

    -- Hold needs an Interrupt
  if caster.bHold then
    caster.bHold = false
    caster:Interrupt()
  end

  local build_time = ability:GetSpecialValueFor("build_time")
  local gold_cost = ability:GetSpecialValueFor("gold_cost")
  local lumber_cost = ability:GetSpecialValueFor("lumber_cost")

  local hero = caster:GetPlayerOwner():GetAssignedHero()
  local playerID = hero:GetPlayerID()
  local player = PlayerResource:GetPlayer(playerID) 
  local team = hero:GetTeamNumber()

  local ability_level = ability:GetLevel()
  if(ability_level<=ability:GetMaxLevel()) then
    if (hero:GetGold() < gold_cost) then
       SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_enough_gold")
    elseif (player.lumber < lumber_cost) then
     SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_enough_lumber")
   else
      ability:SetLevel(ability_level+1)
      hero:ModifyGold(-gold_cost, false, 0)
      ModifyLumber( player, -lumber_cost)
      local building_name = AbilityKV[ability_name].UnitName
     if (building_name == "pyro_tower" or building_name == "melee_sven") then
        local oldDmgMax = caster:GetBaseDamageMax()
        local oldDmgMin = caster:GetBaseDamageMin()
        caster:SetBaseDamageMax(oldDmgMax*2)
        caster:SetBaseDamageMin(oldDmgMin*2)
        caster:SetModelScale(caster:GetModelScale()+0.11)
        if(ability_level == ability:GetMaxLevel()) then
          caster:RemoveAbility(ability:GetName())
        end
        local sven_ability = caster:FindAbilityByName("sven_great_cleave")
        if(sven_ability~=nil and ability_level<4) then 
          sven_ability:SetLevel( ability_level+1 )
        end
     end
   end
  else
    SendErrorMessage(caster:GetPlayerOwnerID(), "#error_max_level")
  end
end

function UltimateHeroBoss( event )
  local caster = event.caster
  local ability = event.ability
  local ability_name = ability:GetAbilityName()
  local AbilityKV = GameRules.AbilityKV
  local UnitKV = GameRules.UnitKV

    -- Hold needs an Interrupt
  if caster.bHold then
    caster.bHold = false
    caster:Interrupt()
  end

  local build_time = ability:GetSpecialValueFor("build_time")
  local gold_cost = ability:GetSpecialValueFor("gold_cost")
  local lumber_cost = ability:GetSpecialValueFor("lumber_cost")

  local hero = caster:GetPlayerOwner():GetAssignedHero()
  local playerID = hero:GetPlayerID()
  local player = PlayerResource:GetPlayer(playerID) 
  local team = hero:GetTeamNumber()

  local ability_level = ability:GetLevel()

  if (not RADIANT_SPAWNS or not DIRE_SPAWNS or WAVES_RUNNING == false) then
     SendErrorMessage(caster:GetPlayerOwnerID(), "#error_not_wave_running")
     ability:EndCooldown()
     return false
  end

  local spawnPointBoss = DIRE_SPAWNS[1]
  local pathPointBoss = DIRE_PATH[1]
  if (team == DOTA_TEAM_GOODGUYS) then
    spawnPointBoss = RADIANT_SPAWNS[1]
    pathPointBoss = RADIANT_PATH[1]
  end



  if(spawnPointBoss ~=nil) then

    if(player.isUnitForm == true) then
      if(not caster.unitForm:IsNull()) then
        caster.unitForm:Kill(nil,caster.unitForm)
      end
    end

     local unitForm = CreateUnitByName("boss_ultimate", spawnPointBoss, true, hero, hero, hero:GetTeamNumber())
     unitForm:SetOwner(hero)
     unitForm:SetControllableByPlayer(playerID, true)
     unitForm:AddNewModifier(caster, nil, "modifier_phased", nil)
     unitForm:AddNewModifier(unit, nil, "modifier_neutral_spell_immunity", nil)
     caster.unitForm = unitForm
     player.isUnitForm = true

    unitForm:SetPhysicalArmorBaseValue(CURENT_WAVE*0.5)
    unitForm:SetBaseMagicalResistanceValue(CURENT_WAVE)
    unitForm:SetMaximumGoldBounty(CURENT_WAVE)
    unitForm:SetBaseHealthRegen(CURENT_WAVE)
    local newHp = 100*CURENT_WAVE*CURENT_WAVE*0.5
    unitForm:SetBaseMaxHealth(newHp)
    unitForm:SetMaxHealth(newHp)
    unitForm:SetHealth(newHp)
    
      --unitForm:SetInitialGoalEntity( pathPointBoss )
    
          PlayerResource:SetCameraTarget(playerID, unitForm)
          Timers:CreateTimer(0.03,
            function()
                    PlayerResource:SetCameraTarget(playerID, unitForm)
                    --SetOverrideSelectionEntity(playerID, unitForm)
                    AddUnitToSelection(unitForm)
                    RemoveUnitFromSelection(hero)
            end
          )
  end
  
end


function killAbility( event )
  local caster = event.caster
  local ability = event.ability
  local ability_name = ability:GetAbilityName()
  local AbilityKV = GameRules.AbilityKV
  local UnitKV = GameRules.UnitKV

  local build_time = ability:GetSpecialValueFor("build_time")
  local gold_cost = ability:GetSpecialValueFor("gold_cost")
  local lumber_cost = ability:GetSpecialValueFor("lumber_cost")

  local hero = caster:GetPlayerOwner():GetAssignedHero()
  local playerID = hero:GetPlayerID()
  local player = PlayerResource:GetPlayer(playerID) 
  local team = hero:GetTeamNumber()

  local ability_level = ability:GetLevel()

  caster:Kill(nil,caster)
  player.isUnitForm = false
  
end

function returnUltimateHero( event )
  DebugPrint("returnUltimateHero")
  local caster = event.caster
  local ability = event.ability
  local ability_name = ability:GetAbilityName()
  local AbilityKV = GameRules.AbilityKV
  local UnitKV = GameRules.UnitKV

  local build_time = ability:GetSpecialValueFor("build_time")
  local gold_cost = ability:GetSpecialValueFor("gold_cost")
  local lumber_cost = ability:GetSpecialValueFor("lumber_cost")

  local hero = caster:GetPlayerOwner():GetAssignedHero()
  local playerID = hero:GetPlayerID()
  local player = PlayerResource:GetPlayer(playerID) 
  local team = hero:GetTeamNumber()

  local ability_level = ability:GetLevel()

  Timers:CreateTimer(0.5,
    function()
      player.isUnitForm = false
      --PlayerResource:SetCameraTarget(playerID, nil)
      --PlayerResource:SetCameraTarget(playerID, hero)
      --AddUnitToSelection(hero)
      --RemoveUnitFromSelection(caster)
    end
  )
  
end

function DestroyStart( event )
  local caster = event.caster
  local ability = event.ability
  local ability_name = ability:GetAbilityName()
  local AbilityKV = GameRules.AbilityKV
  local UnitKV = GameRules.UnitKV

    -- Hold needs an Interrupt
  if caster.bHold then
    caster.bHold = false
    caster:Interrupt()
  end

  local hero = caster:GetPlayerOwner():GetAssignedHero()
  local playerID = hero:GetPlayerID()
  local player = PlayerResource:GetPlayer(playerID) 
  local team = hero:GetTeamNumber()

  local target = event.target
  local target_class = target:GetClassname()
  local building_name = target:GetUnitName()

  local money_coefficient = 0.5


  if ( target_class == "npc_dota_creature" and IsCustomBuilding(target) ) then
      local target_owned_id = event.target:GetPlayerOwner():GetAssignedHero():GetPlayerID()
      if(player.buildings[building_name]~=nil and target_owned_id == playerID and (target.queue == nil or #target.queue<1) ) then
        BuildingHelper:RemoveBuilding( target, true )
        --player.buildings[building_name] = player.buildings[building_name] - 1
        local gold_cost = target.GoldCost
        local lumber_cost = target.LumberCost
        local food_cost = target.FoodCost
        hero:ModifyGold(gold_cost*money_coefficient, false, 0)
        ModifyLumber( player, lumber_cost*money_coefficient )
        ModifyFood( player, food_cost )
      else
        SendErrorMessage(caster:GetPlayerOwnerID(), "#error_cant_destroy_now")
      end
  else
    SendErrorMessage(caster:GetPlayerOwnerID(), "#error_cant_destroy_now")
  end
end


