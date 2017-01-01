function GiveSpells( events )
	local caster = events.caster
	caster:FindAbilityByName("holy_devotion"):SetLevel(1)
end