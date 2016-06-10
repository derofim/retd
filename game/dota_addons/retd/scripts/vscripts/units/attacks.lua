-- Searches for "AttacksEnabled" in the KV files
-- Default by omission is "ground", other possible returns should be "ground,air" or "air"
function GetAttacksEnabled( unit )
	local unitName = unit:GetUnitName()
	local attacks_enabled

	if unit:IsHero() then
		attacks_enabled = GameRules.HeroKV[unitName]["AttacksEnabled"]
	elseif GameRules.UnitKV[unitName] then
		attacks_enabled = GameRules.UnitKV[unitName]["AttacksEnabled"]
	end

	return attacks_enabled or "ground"
end

-- Returns "air" if the unit can fly
function GetMovementCapability( unit )
	if unit:HasFlyMovementCapability() then
		return "air"
	else
		return "ground"
	end
end

-- Ground/Air Attack mechanics
function UnitCanAttackTarget( unit, target )
	local attacks_enabled = GetAttacksEnabled(unit)
	local target_type = GetMovementCapability(target)
  
  	if not unit:HasAttackCapability() 
    	or (target.IsInvulnerable and target:IsInvulnerable()) 
    	or (target.IsAttackImmune and target:IsAttackImmune()) 
    	or not unit:CanEntityBeSeenByMyTeam(target) then
    	
    		return false
  	end


	if(target:IsBuilding()) then
		return false -- Deny towers attack buildings
	end

  	return string.match(attacks_enabled, target_type)
end

function HandleAttack( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	if( UnitCanAttackTarget( caster, target ) ) then
		caster:StartGesture(ACT_DOTA_ATTACK)
		if(caster.particle ~= nil) then
			ParticleManager:DestroyParticle(caster.particle,false)
		end
		--DebugPrint("StartGesture")
	else
		caster:RemoveGesture(ACT_DOTA_ATTACK)
		caster:Stop()
		if(caster.particle == nil) then
			caster.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_sniper/sniper_crosshair.vpcf", PATTACH_OVERHEAD_FOLLOW, caster ) 
			ParticleManager:SetParticleControl( caster.particle, 0, caster:GetAbsOrigin() ) 
			ParticleManager:SetParticleControl( caster.particle, 1, caster:GetAbsOrigin() ) 
		end
		--DebugPrint("RemoveGesture")
	end
end