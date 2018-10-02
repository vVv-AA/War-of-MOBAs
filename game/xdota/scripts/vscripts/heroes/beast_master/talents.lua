function PreventBothUlts( event )
	local caster = event.caster
	local ability = event.ability

	if caster.override_onupgrade == nil then
		if ability:GetAbilityName() == "boar_hoard_datadriven" then
			if caster:FindAbilityByName("primal_roar_datadriven"):GetLevel() > 0 then
				caster.override_onupgrade = true
				ability:SetLevel(0)
				caster.override_onupgrade = nil
				caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
			end
		elseif ability:GetAbilityName() == "primal_roar_datadriven" then
			if caster:FindAbilityByName("boar_hoard_datadriven"):GetLevel() > 0 then
				caster.override_onupgrade = true
				ability:SetLevel(0)
				caster.override_onupgrade = nil
				caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
			end
		end
	end
end

