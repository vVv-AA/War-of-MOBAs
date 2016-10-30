function UpgradesHandler( keys )
	local caster = keys.caster
	local ability = keys.ability

	if ability:GetLevel() < 3 then return end
	local adrenaline_surge_ability = caster:FindAbilityByName("adrenaline_surge")
	local duration = adrenaline_surge_ability:GetLevelSpecialValueFor("duration", adrenaline_surge_ability:GetLevel() - 1)
	adrenaline_surge_ability:ApplyDataDrivenModifier(caster, caster, "modifier_adrenaline_surge", {duration = duration})
end