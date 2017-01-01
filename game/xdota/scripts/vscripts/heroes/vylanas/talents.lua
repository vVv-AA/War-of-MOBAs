function Upgrade( keys )
	local caster = keys.caster
	if keys.talent == "special_bonus_unique_vylanas_aoe_stifling_daggers" then
		local old_ability = caster:FindAbilityByName("dark_ranger_stifling_dagger_single_target")

		caster:AddAbility("dark_ranger_stifling_daggers")
		caster:SwapAbilities("dark_ranger_stifling_daggers", "dark_ranger_stifling_dagger_single_target", true, false)

		caster:FindAbilityByName("dark_ranger_stifling_daggers"):SetLevel(caster:FindAbilityByName("dark_ranger_stifling_dagger_single_target"):GetLevel())
		caster:RemoveAbility("dark_ranger_stifling_dagger_single_target")
	elseif keys.talent == "special_bonus_unique_vylanas_will_of_the_dead" then
		caster:FindAbilityByName("dark_ranger_will_of_the_dead"):SetLevel(1)
	end
end