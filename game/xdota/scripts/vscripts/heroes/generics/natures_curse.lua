function RootAttacker( event )
	local caster = event.caster
	local ability = event.ability
	local attacker = event.attacker
	print(caster:GetUnitName())
	print(attacker:GetUnitName())
	ability:ApplyDataDrivenModifier(caster, attacker, "modifier_natures_curse_root", {})
end