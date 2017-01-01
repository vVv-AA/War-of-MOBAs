function Shock( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	if ability:IsItem() then return end
	local damage_table = {
		victim = target,
		attacker = caster,
		damage = ability:GetSpecialValueFor("damage_health_pct")*target:GetHealth()/100,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		abilityReturn = true,
	}
	ApplyDamage(damage_table)
end