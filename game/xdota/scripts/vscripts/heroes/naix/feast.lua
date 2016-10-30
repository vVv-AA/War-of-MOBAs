function ApplyLifeSteal( event )
	-- Variables
	local attacker = event.attacker
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenModifier(attacker, attacker, "modifier_feast_lifesteal", {duration = 0.03})
end