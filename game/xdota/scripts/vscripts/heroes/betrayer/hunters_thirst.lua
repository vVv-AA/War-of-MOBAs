function ApplyLifeSteal( event )
	event.ability:ApplyDataDrivenModifier(event.caster, event.caster, "modifier_hunter_lifesteal", {duration = 0.03})
end

function CooldownReducton( event )
	local caster = event.caster
	local ability = event.ability
	local reduction = ability:GetSpecialValueFor("cooldown_reduction")
	local cooldown_remaining
	local ability_by_index
	if caster:HasModifier("double_reduction") then reduction = reduction*2 end
	for i=1,15 do
		ability_by_index = caster:GetAbilityByIndex(i)
		if ability_by_index ~= nil and ability_by_index ~= ability then
			if ability_by_index:IsCooldownReady() == false then
				cooldown_remaining = ability_by_index:GetCooldownTimeRemaining()
				ability_by_index:EndCooldown()
				ability_by_index:StartCooldown(math.max(cooldown_remaining - reduction, 0))
			end
		end
	end
end