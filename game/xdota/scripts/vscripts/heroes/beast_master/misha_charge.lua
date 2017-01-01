require("heroes/generics/Disables")

function Charge( keys )
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
	local max_distance = ability:GetLevelSpecialValueFor("charge_range", (ability:GetLevel() - 1))

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

function ChargeMotion( keys )
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

			local params = 
			{
				duration = ability:GetSpecialValueFor("stun_duration"),
				caster = caster,
				ability = ability,
				target = unit,
				bypass = "false",
				purgable = true,
			}
			ApplyStun(params)
            ability.targetsHit[unit] = true
            end
    	end
	else
		local count = 0
		for unit,hit in pairs(ability.targetsHit) do
			if hit == true and unit:IsHero() then
					count = count + 1
					break
			end
		end

		if ability:GetLevel() > 1 then
			if count == 0 then
				ability:RefundManaCost()
				local cooldown_remaining = ability:GetCooldownTimeRemaining()
				ability:EndCooldown()
				ability:StartCooldown(ability:GetSpecialValueFor("cooldown_if_no_hero_is_hit"))
			end
		end
		caster:InterruptMotionControllers(false)
	end
end

function CooldownReducton( event )
	local caster = event.caster
	local ability = event.ability
	local reduction = ability:GetSpecialValueFor("cooldown_reduction")
	local cooldown_remaining
	if ability:IsCooldownReady() then return end
	cooldown_remaining = ability:GetCooldownTimeRemaining()
	ability:EndCooldown()
	ability:StartCooldown(math.max(cooldown_remaining - reduction, 0))
end

function CastChargeOnMisha( event )
	local caster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local bear = caster.bear
	if bear == nil or bear:IsAlive() == false then return end
	local charge_ability = bear:FindAbilityByName("wild_charge_misha_datadriven")
	local distance = (point - bear:GetAbsOrigin()):Length2D()

	if distance <= ability:GetCastRange() then
		if bear:IsAlive() and charge_ability:IsCooldownReady() then
			bear:CastAbilityOnPosition(point, charge_ability, bear:GetPlayerOwnerID())
		end
	end
end