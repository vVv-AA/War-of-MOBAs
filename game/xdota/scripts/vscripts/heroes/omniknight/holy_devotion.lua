function CooldownReducton( event )
	local caster = event.caster
	local ability = event.ability
	local reduction = ability:GetSpecialValueFor("cooldown_reduction_extra")
	local health_required_frac = ability:GetSpecialValueFor("health_required_frac")
	if health_required_frac > caster:GetHealthPercent() then return end
	local cooldown_remaining
	local ability_by_index
	for i=1,15 do
		ability_by_index = caster:GetAbilityByIndex(i)
		if ability_by_index ~= nil and ability_by_index:GetLevel() > 0 and ability_by_index ~= ability then
			if ability_by_index:IsCooldownReady() == false then
				cooldown_remaining = ability_by_index:GetCooldownTimeRemaining()
				ability_by_index:EndCooldown()
				ability_by_index:StartCooldown(math.max(cooldown_remaining - reduction, 0))
			end
		end
	end
end