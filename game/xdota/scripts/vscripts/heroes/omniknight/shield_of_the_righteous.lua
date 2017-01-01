require('mechanics/talents')

function CastShield( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	ability:ApplyDataDrivenModifier(caster, target, "modifier_shield_of_the_righteous", {duration = GetTalentSpecialValueFor(ability, "duration")})
end