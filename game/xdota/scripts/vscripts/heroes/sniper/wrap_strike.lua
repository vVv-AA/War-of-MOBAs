function WrapStrike( event )
	local caster = event.caster
	local original_loc = caster:GetAbsOrigin()
	local dest_loc = caster:GetCursorPosition()
	ProjectileManager:ProjectileDodge(caster)

	FindClearSpaceForUnit(caster, dest_loc, false)
	caster:SetForwardVector(dest_loc - original_loc)

	event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_wrap_strike_bonus_damage_stack", {})
	caster:SetModifierStackCount( "modifier_wrap_strike_bonus_damage_stack", caster, event.ability:GetSpecialValueFor("stacks"))
end

function ReduceStack( event )
	local caster = event.caster

	local stack_count = caster:GetModifierStackCount("modifier_wrap_strike_bonus_damage_stack", event.ability)
	if stack_count == 1 then
		caster:RemoveModifierByName("modifier_wrap_strike_bonus_damage_stack")
	end
	caster:SetModifierStackCount("modifier_wrap_strike_bonus_damage_stack", caster, stack_count - 1 )
end