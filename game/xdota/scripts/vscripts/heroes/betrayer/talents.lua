function Upgrade( event )
	local caster = event.caster
	local talent = event.talent
	if talent == "special_bonus_unique_betrayer_never_ending_hatred" then
	    caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
	    caster:UpgradeAbility(caster:FindAbilityByName("betrayer_never_ending_hatred_datadriven"))
	elseif talent == "special_bonus_unique_betrayer_betray" then
	    caster:SetAbilityPoints(caster:GetAbilityPoints() + 1)
	    caster:UpgradeAbility(caster:FindAbilityByName("betrayer_betray_datadriven"))
	elseif talent == "special_bonus_unique_betrayer_marked_for_death" then
        caster:FindAbilityByName("betrayer_dive_datadriven"):ApplyDataDrivenModifier(caster, caster, "modifier_marked_for_death", {})
	elseif talent == "special_bonus_unique_betrayer_permanent_immolation" then
		ability = caster:FindAbilityByName("betrayer_sweeping_strike_datadriven")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_permanent_immolation", {})
	end
end