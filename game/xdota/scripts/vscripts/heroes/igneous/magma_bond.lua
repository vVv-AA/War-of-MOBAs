function ResetAbility( event )
	local caster = event.caster
	local ability = event.ability

	event.event_ability:EndCooldown()
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_magma_bond_spare", {})
end

function CastAbility( event )
	local caster = event.caster
	local ability = caster:GetAbilityByIndex(1)
	caster:CastAbilityOnPosition(caster:GetCursorPosition(), ability, caster:GetPlayerOwnerID())
	caster:RemoveModifierByName("modifier_magma_bond_spare")
end