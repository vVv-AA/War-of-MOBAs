function Upgrade( event )
	if event.talent == "special_bonus_unique_artemis_proprioception" then
		event.caster:FindAbilityByName("artemis_proprioception_datadriven"):SetLevel(1)
	end
end