function Initialize( keys )
	keys.caster.hawkshot_units_array = {}
	keys.caster.hawkshot_units_hit = {}
	keys.caster.refund_bool = false
end

function RegisterUnit( keys )
	local caster = keys.caster
	local target = keys.target
	local index = keys.target:entindex()
	local ability = keys.ability
	local damage = ability:GetAbilityDamage()

	if target:IsHero() == false then
		damage = damage*ability:GetLevelSpecialValueFor("creep_damage_multipier", ability:GetLevel() - 1)
	end

	local damageTable = {
		victim = target,
		attacker = caster,
		damage = ability:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		abilityReturn = true,
	}

	ApplyDamage(damageTable)
	ability:ApplyDataDrivenModifier(caster, target, "modifier_startle_slow", {duration = ability:GetLevelSpecialValueFor("slow_duration", ability:GetLevel() - 1)})
	caster.hawkshot_units_array[ index ] = keys.target
	caster.hawkshot_units_hit[ index ] = false
	caster.refund_bool = true
end

function RefundManaCostCheck( keys )
	local ability = keys.ability
	ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_bonus_damage", {duration = ability:GetSpecialValueFor("bonus_damage_duration")})
	if ability:GetLevel() < 2 then return end
	if keys.caster.refund_bool == true then
		ability:RefundManaCost()
	end
end