function CheckBuff( keys )
	local caster = keys.caster
	local ability = keys.ability

	if caster:HasModifier("modifier_changing_tides") then
		if GameRules:IsDaytime() then
			caster:RemoveModifierByName("modifier_changing_tides")
			return
		end
	else
		if GameRules:IsDaytime() == false then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_changing_tides", {})
		end
	end

end