require("heroes/generics/Disables")

function CooldownReducton( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local reduction = ability:GetSpecialValueFor("cooldown_reduction")
	local cooldown_remaining
	local ability_by_index = nil

	if caster.atk_index == nil then
		caster.atk_index = 1
	else
		caster.atk_index = caster.atk_index + 1
	end

	for i=0, caster:GetAbilityCount() - 1 do
		ability_by_index = caster:GetAbilityByIndex(i)
		if ability_by_index ~= nil and ability_by_index ~= ability then
			if ability_by_index:IsCooldownReady() == false then
				cooldown_remaining = ability_by_index:GetCooldownTimeRemaining()
				ability_by_index:EndCooldown()
				ability_by_index:StartCooldown(math.max(cooldown_remaining - reduction, 0))
			end
		end
	end

	if caster.atk_index == 3 then
		if (target:IsStunned() or target:IsRooted())  then
			local damageTable =
			{
				victim = target,
				attacker = caster,
				damage = event.damage,
				damage_type = DAMAGE_TYPE_PHYSICAL
			}

			ApplyDamage( damageTable )
		end
	end

	if caster:HasModifier("modifier_fake_basher") then
		return
	end
	
	if caster.atk_index == 3 then
		caster.atk_index = 0
		local params = 
		{
			caster = caster,
			ability = ability,
			target = target,
			bypass = "false",
			purgable = true,
			duration = ability:GetSpecialValueFor("stun_duration")
		}
		ApplyStun(params)
	end
end