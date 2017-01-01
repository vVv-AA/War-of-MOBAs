require("heroes/generics/generic_funcs")
require('mechanics/talents')

function StartProjectile( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetCursorPosition()
	local direction = (point - caster:GetAbsOrigin()):Normalized()
	local speed = ability:GetSpecialValueFor("projectile_speed")
	local max_distance = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1)

	if caster:HasModifier("modifier_poseidon_gush_double_range") then
		talent_ability = caster:FindModifierByName("modifier_poseidon_gush_double_range"):GetAbility()
		max_distance = max_distance + talent_ability:GetSpecialValueFor("range")
	end

	local radius = ability:GetSpecialValueFor("radius")
	caster.gush_ability = ability
	local gush_units = {}
	local gush_units_hit = {}
	local gush_currentPos = caster:GetAbsOrigin()
	local forwardVec = point - caster:GetAbsOrigin()
	forwardVec = forwardVec:Normalized()

	local perpendicularVec = Vector( -forwardVec.y, forwardVec.x, forwardVec.z )
	perpendicularVec = perpendicularVec:Normalized()

    local emitter_count = ability:GetLevelSpecialValueFor("emitter_count", ability:GetLevel() - 1)

	if caster:HasModifier("modifier_poseidon_gush_double_range") then
		talent_ability = caster:FindModifierByName("modifier_poseidon_gush_double_range"):GetAbility()
		emitter_count = emitter_count + talent_ability:GetSpecialValueFor("emitter_count")
		print(emitter_count)
	end

	if caster:HasModifier("modifier_poseidon_6_more_emitter") then
		talent_ability = caster:FindModifierByName("modifier_poseidon_6_more_emitter"):GetAbility()
		emitter_count = emitter_count + math.max(emitter_count, talent_ability:GetSpecialValueFor("emitter_count"))
		print(emitter_count)
	end

	for _,point in range(-1*(emitter_count-1)*radius, (emitter_count-1)*radius*1, radius) do
		if (point/radius) % 2 == 0 then
			local projectileTable =
			{
				EffectName = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf",
				Ability = ability,
				vSpawnOrigin = caster:GetAbsOrigin() + perpendicularVec*point,
				vVelocity = Vector(direction.x * speed, direction.y * speed, 0),
				fDistance = max_distance,
				fStartRadius = radius,
				fEndRadius = radius,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				bProvidesVision = true,
				iVisionRadius = radius,
				iVisionTeamNumber = caster:GetTeamNumber()
			}
			
			powershot_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )
		end
	end
end

function KnockBack( keys )
	local vCaster = keys.caster:GetAbsOrigin()
	local vTarget = keys.target:GetAbsOrigin()
	local len = ( vTarget - vCaster ):Length2D()
	local knockbackModifierTable =
	{
		should_stun = 0,
		knockback_duration = keys.duration,
		duration = keys.duration,
		knockback_distance = keys.distance,
		knockback_height = 0,
		center_x = keys.caster:GetAbsOrigin().x,
		center_y = keys.caster:GetAbsOrigin().y,
		center_z = keys.caster:GetAbsOrigin().z
	}
	keys.target:AddNewModifier( keys.caster, nil, "modifier_knockback", knockbackModifierTable )
end

