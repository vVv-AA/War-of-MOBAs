function SoulStack( event )
	local caster = event.caster
	local target = event.unit
	local modifier = event.modifier
	local ability = event.ability
	local souls_hero_bonus = ability:GetLevelSpecialValueFor( "necromastery_souls_hero_bonus", ability:GetLevel() - 1 )
	local current_stack = 0

	-- Check how many stacks can be granted
	local souls_gained = 1
	if target:IsRealHero() then
		souls_gained = souls_gained + souls_hero_bonus
	end
	-- Check if the hero already has the modifier
	if caster:HasModifier(modifier) then
		current_stack = caster:GetModifierStackCount( modifier, ability )
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		current_stack = 0
	end
	-- Set the stack up to max_souls
	caster:SetModifierStackCount( modifier, ability, current_stack + souls_gained )
end
