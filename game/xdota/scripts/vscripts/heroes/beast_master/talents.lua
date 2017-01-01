function GiveOtherSpell( event )
	local caster = event.caster
	local ability = event.ability
	caster:RemoveAbility("tough_exterior")
	local b_h_ability = caster:FindAbilityByName("boar_hoard_datadriven")
	local p_r_ability = caster:FindAbilityByName("primal_roar_datadriven")

	local b_h_level = b_h_ability:GetLevel()
	local p_r_level = p_r_ability:GetLevel()
	
	caster.override_onupgrade = true
	b_h_ability:SetLevel(3)
	p_r_ability:SetLevel(3)
	caster.override_onupgrade = nil
end

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

function Upgrade( event )
	local caster = event.caster
    caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
    caster:UpgradeAbility(caster:FindAbilityByName("tough_exterior"))
end