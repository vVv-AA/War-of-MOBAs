function Blink (keys)
	local caster = keys.caster
	local target = keys.target
	local point = target:GetAbsOrigin()
	local casterPos = caster:GetAbsOrigin()
	local pid = caster:GetPlayerID()
	local difference = point - casterPos	
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))
	point = point + (point - casterPos):Normalized() * 50
	local direction = (point - casterPos):Normalized()
	
	caster:SetForwardVector(direction*-1)

	FindClearSpaceForUnit(caster, point, true)
	if ability:GetLevel() > 1 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dive_bonus_speed", {})
	end

	if ability:GetLevel() > 2 then
		local stack_count = ability:GetSpecialValueFor("max_block_stack")
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_damage_block_physical_attacks", {})
		caster:SetModifierStackCount( "modifier_damage_block_physical_attacks", ability, stack_count )
	end
end

function ApplyMark( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if target:IsBuilding() then return end
	if caster:IsIllusion() then return end
	local current_stack = 0
	local max_stacks = ability:GetSpecialValueFor("marked_for_death_max_stack")
	local marked_for_death_duration = ability:GetSpecialValueFor("marked_for_death_duration")

	if target:HasModifier( "modifier_marked_for_death_counter" ) then
		current_stack = target:GetModifierStackCount( "modifier_marked_for_death_counter", ability )
		if current_stack == max_stacks - 1 then
			target:SetModifierStackCount( "modifier_marked_for_death_counter", ability, 0 )
			current_stack = 0
			local damagetable =
			{
				victim = target,
				attacker = caster,
				damage = ability:GetSpecialValueFor("marked_for_death_damage"),
				damage_type = ability:GetAbilityDamageType(),
				ability = ability
			}
			ApplyDamage(damagetable)
		end

		ability:ApplyDataDrivenModifier(caster, target, "modifier_marked_for_death_counter", {duration = marked_for_death_duration})
		target:SetModifierStackCount( "modifier_marked_for_death_counter", ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, target, "modifier_marked_for_death_counter", { Duration = duration } )
		target:SetModifierStackCount( "modifier_marked_for_death_counter", ability, 1 )
	end
end

function Damage( event )
	local target = event.target
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetAbilityDamage()
	if target:IsBuilding() then damage = damage/5 end
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		local damagetable =
		{
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability
		}

		ApplyDamage(damagetable)

		local order =
		{
			UnitIndex = caster:entindex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = target:entindex(),
			Queue = true
		}

		ExecuteOrderFromTable(order)
	end
end


function DecrementBlockStack( event )
	local caster = event.caster
	local ability = event.ability
	local current_stack = caster:GetModifierStackCount("modifier_damage_block_physical_attacks", ability) - 1
	caster:SetModifierStackCount( "modifier_damage_block_physical_attacks", ability, current_stack)
	if current_stack == 0 then
		caster:RemoveModifierByName("modifier_damage_block_physical_attacks")
	end
end