function Upgrade( event )
	if event.talent == "special_bonus_unique_omni_unbreakable_fortitude" then
		event.caster:FindAbilityByName("unbreakable_fortitude"):SetLevel(1)
	elseif event.talent == "special_bonus_unique_omni_sacred_duty_datadriven" then
    	event.caster:FindAbilityByName("sacred_duty_datadriven"):SetLevel(1)
	end
end