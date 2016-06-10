-- To destroy use target:GetMaxHealth()
function damageEntity(killer, target, target_damage)
  local damageTable = {
    victim = target,
    attacker = killer,
    damage = target_damage,
    damage_type = DAMAGE_TYPE_PURE,
  }
  ApplyDamage(damageTable)
end