function AdrenalineSurgeActivate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local hp_threshold = ability:GetSpecialValueFor("hp_threshold")

	if caster:GetHealth() <= hp_threshold then
		ability:CastAbility()
	end
end