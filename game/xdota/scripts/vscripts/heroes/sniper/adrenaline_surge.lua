function AdrenalineSurgeActivate( keys )
	local caster = keys.caster
	local ability = keys.ability
	local hp_threshold = ability:GetSpecialValueFor("hp_threshold")

	if caster:GetHealth() <= hp_threshold then
		ability:CastAbility()
	end
end

function Heal( keys )
	local caster = keys.caster
	local ability = keys.ability
	local total_heal = ability:GetLevelSpecialValueFor("total_heal", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	caster:Heal(total_heal/duration, ability)
end