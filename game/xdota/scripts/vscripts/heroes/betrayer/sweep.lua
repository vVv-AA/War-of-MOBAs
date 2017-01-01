function Sweep( keys )
	local caster = keys.caster
	local target = keys.target
	local caster_location = caster:GetAbsOrigin()
	local target_point = keys.target_points[1]
	local ability = keys.ability
	local modifier = keys.modifier

	-- Distance calculations
	local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
	local distance = (target_point - caster_location):Length2D()
	local direction = (target_point - caster_location):Normalized()
	local duration = distance/speed
	local max_distance = ability:GetLevelSpecialValueFor("sweep_range", (ability:GetLevel() - 1))

	if distance > max_distance then
		distance = max_distance
	end
	-- Saving the data in the ability
	ability.radius = ability:GetSpecialValueFor("radius")
	ability.sweep_distance = distance
	ability.sweep_speed = speed * 1/30 -- 1/30 is how often the motion controller ticks
	ability.sweep_direction = direction
	ability.sweep_traveled_distance = 0
	ability.target_table = {}
	ability.targetsHit = {}

	-- Apply the invlunerability modifier to the caster
	ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration = duration})
end

function SweepMotion( keys )
	local caster = keys.target
	local ability = keys.ability
	ProjectileManager:ProjectileDodge(caster)
	-- Move the caster while the distance traveled is less than the original distance upon cast
	if ability.sweep_traveled_distance < ability.sweep_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.sweep_direction * ability.sweep_speed)
		ability.sweep_traveled_distance = ability.sweep_traveled_distance + ability.sweep_speed

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin() , nil, ability.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		for _,unit in pairs(units) do

        	if unit ~= nil and ( not unit:IsMagicImmune() ) and ( not unit:IsInvulnerable() ) and ability.targetsHit[unit] ~=true then

            local damagetable = {
                    victim = unit,
                    attacker = caster,
                    damage = ability:GetAbilityDamage(),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = ability
            }
            ApplyDamage( damagetable )
            ability.targetsHit[unit] = true
            end
    	end
	else
		local givebonus = false
		local count = 0
		for unit,hit in pairs(ability.targetsHit) do
			if hit == true and unit:IsHero() then
					givebonus = true
					count = count + 1
			end
		end
		if givebonus == true then
			if ability:GetLevel() > 2 then
				if count < 2 then
					print(count)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_sweep_bonus_damage", {})
				else
					print(count)
					ability:ApplyDataDrivenModifier(caster, caster, "modifier_sweep_bonus_damage_greater", {})
					if count > 4 then
						ability:ApplyDataDrivenModifier(caster, caster, "modifier_sweep_bonus_damage_greatest", {})
					end
				end
			else
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_sweep_bonus_damage", {})
			end
		end

		if count == 0 then
			local cooldown = ability:GetCooldownTimeRemaining()
			ability:EndCooldown()
			ability:StartCooldown(math.max(cooldown - ability:GetCooldown(1)/2, 0))
		end
		caster:RemoveModifierByName("modifier_sweeping_strike_datadriven")
		caster:InterruptMotionControllers(false)
	end
end