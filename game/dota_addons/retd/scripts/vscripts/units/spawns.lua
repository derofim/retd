function spawnOnDeath( event )
	DebugPrint("spawnOnDeath")
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local playerOwner = caster:GetPlayerOwner()

	local AbilityKV = GameRules.AbilityKV
	local UnitKV = GameRules.UnitKV

	local casterName = caster:GetUnitName()

	local spawnUnitPos = caster:GetAbsOrigin()
	local spawnUnitTeam = caster:GetTeamNumber()
	local spawnUnitPath = RADIANT_PATH[1]
	if(spawnUnitTeam==DOTA_TEAM_BADGUYS) then
		spawnUnitPath = DIRE_PATH[1]
	end

	local spawnUnitName
	local spawnUnitCount

	if GameRules.HeroKV[casterName] then
		spawnUnitName = GameRules.HeroKV[casterName]["SpawnOnDeathUnit"]
		spawnUnitCount = tonumber(GameRules.HeroKV[casterName]["SpawnOnDeathCount"])
	elseif GameRules.UnitKV[casterName] then
		spawnUnitName = GameRules.UnitKV[casterName]["SpawnOnDeathUnit"]
		spawnUnitCount = tonumber(GameRules.UnitKV[casterName]["SpawnOnDeathCount"])
	end

	DebugPrint(caster:GetClassname())
	DebugPrint(casterName)
	DebugPrint(spawnUnitCount)
	DebugPrint(spawnUnitName)
	--unit:AddNewModifier(unit, nil, "modifier_bottle_regeneration", nil)
	--caster:AddNewModifier(caster, nil, "modifier_teleporting", nil)

	caster.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_treant/treant_livingarmor_glow.vpcf", PATTACH_OVERHEAD_FOLLOW, caster ) 
	ParticleManager:SetParticleControl( caster.particle, 0, caster:GetAbsOrigin() ) 
	ParticleManager:SetParticleControl( caster.particle, 1, caster:GetAbsOrigin() )

	for i=1,spawnUnitCount do
		Timers:CreateTimer(2*i,
            function()
            	local unit = CreateUnitByName( spawnUnitName, spawnUnitPos, true, nil, nil, spawnUnitTeam )
				unit:AddNewModifier(unit, nil, "modifier_phased", nil)
				unit:AddNewModifier(unit, nil, "modifier_item_phase_boots_active", nil)
				if(playerOwner~=nil) then
					local heroOwner = playerOwner:GetAssignedHero()
					local heroOwnerID = heroOwner:GetPlayerID()
					unit:SetOwner(heroOwner)
					unit:SetControllableByPlayer(heroOwnerID, true)
				else
					unit:SetInitialGoalEntity( spawnUnitPath )
				end
				return nil
            end
         )
	end
	Timers:CreateTimer(2*spawnUnitCount,
            function()
				--caster:RemoveModifierByName("modifier_teleporting")
				if caster.particle then
					ParticleManager:DestroyParticle(caster.particle,false)
				end
			return nil
            end
         )
end