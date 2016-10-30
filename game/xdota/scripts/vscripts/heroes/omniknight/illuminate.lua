function UpgradesHandler( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("illuminate_datadriven")
	local target = keys.target

	if target:GetTeamNumber() == caster:GetTeamNumber() then
		if ability:GetLevel() == 3 then
			local cooldown_remaning = ability:GetCooldownTimeRemaining() 
			ability:EndCooldown()
			ability:StartCooldown(cooldown_remaning - ability:GetSpecialValueFor("cooldown_reduction_perhit"))
			caster:GiveMana(ability:GetSpecialValueFor("mana_refund_perhit"))
		end
	end
end