function GiveSpells( events )
	local caster = events.caster
	caster:FindAbilityByName("unbreakable_fortitude"):SetLevel(1)
	caster:FindAbilityByName("holy_devotion"):SetLevel(1)
end