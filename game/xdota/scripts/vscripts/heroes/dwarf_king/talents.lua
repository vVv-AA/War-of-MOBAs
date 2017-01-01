function Upgrade( event )
	local caster = event.caster
    caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
    caster:UpgradeAbility(caster:FindAbilityByName("tough_exterior"))
end