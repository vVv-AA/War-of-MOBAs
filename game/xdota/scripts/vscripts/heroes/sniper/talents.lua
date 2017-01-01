function Upgrade( event )
	local caster = event.caster
	caster:FindAbilityByName("gun_runner_wrap_strike_datadriven"):SetLevel(1)
end