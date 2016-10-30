function Upgrade( keys )
	local ability = keys.ability
	local caster = keys.caster
	if ability:GetLevel() == 3 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_storm_bolt_bonus_damage", {})
	end
end

function ProjectileLaunch( keys )

	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetCursorPosition()
	local direction = (point - caster:GetAbsOrigin()):Normalized()
	local speed = ability:GetSpecialValueFor("bolt_speed")
	local max_distance = ability:GetSpecialValueFor("max_distance")
	local radius = ability:GetSpecialValueFor("radius")
	local vision_radius = ability:GetSpecialValueFor("vision_radius")
	local vision_duration = ability:GetSpecialValueFor("vision_duration")
	local hammer_traveled = 0
	caster.stormbolt_ability = ability
	local stormbolt_units = {}
	local stormbolt_units_hit = {}
	local hammer_currentPos = caster:GetAbsOrigin()

	local projectileTable =
	{
		EffectName = "particles/test_particle/dwarf_king_storm_bolt.vpcf",
		Ability = ability,
		vSpawnOrigin = caster:GetAbsOrigin(),
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
		iVisionRadius = vision_radius,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	
	powershot_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )

	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for k, v in pairs( units ) do
		local index = v:entindex()
		stormbolt_units[ index ] = v
		stormbolt_units_hit[ index ] = false
	end
	
	-- Traverse
	Timers:CreateTimer( function()
			-- Traverse the point
			hammer_currentPos = hammer_currentPos + ( direction * speed * 1/30 )
			hammer_traveled = hammer_traveled + speed * 1/30
			
			-- Loop through the units array
			for k, v in pairs( stormbolt_units ) do
				-- Check if it never got hit and is in radius
				if stormbolt_units_hit[ k ] == false and hammer_distance( v:GetAbsOrigin(), hammer_currentPos ) <= radius then
					-- Deal damage
					local damageTable =
					{
						victim = v,
						attacker = caster,
						damage = ability:GetAbilityDamage(),
						damage_type = ability:GetAbilityDamageType()
					}
					ApplyDamage( damageTable )
					-- Change flag
					stormbolt_units_hit[ k ] = true
					-- Fire sound
					StartSoundEvent( "Hero_Windrunner.PowershotDamage", v )
				end
			end
			
			-- Create visibility node
			AddFOWViewer(caster:GetTeamNumber(), hammer_currentPos, vision_radius, vision_duration, false)
			
			-- Check if damage point reach the maximum range, if so, delete the timer
			if hammer_traveled < max_distance then
				return 1/30
			else
				return nil
			end
		end
	)
end

function DealDamage( keys )
	local caster = keys.caster
	local ability = caster.stormbolt_ability
	local target = keys.target
	local bonus_damage_modifier = caster:FindModifierByName("modifier_storm_bolt_bonus_damage")

	local damage_table = {
		victim = target,
		attacker = caster,
		damage = ability:GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability,
	}

	if bonus_damage_modifier ~= nil then
		damage_table.damage = damage_table.damage + bonus_damage_modifier:GetStackCount()*ability:GetSpecialValueFor("damage_per_stack")
	end

	if target:IsHero() == false then
		damage_table.damage = damage_table.damage*ability:GetSpecialValueFor("non_hero_bonus_damage_mult")
	end
	ApplyDamage(damage_table)
end

function UpgradesHandler( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = caster.stormbolt_ability

	if ability:GetLevel() < 2 then return end

	if target:IsRealHero() then
		caster:GiveMana(ability:GetSpecialValueFor("refund_mana"))
	end

	if ability:GetLevel() < 3 then return end

	if target:IsRealHero() then
		local mod = caster:FindModifierByName("modifier_storm_bolt_bonus_damage")
		mod:SetStackCount(mod:GetStackCount() + 1)
	end

end

function hammer_distance( pointA, pointB )
	local dx = pointA.x - pointB.x
	local dy = pointA.y - pointB.y
	return math.sqrt( dx * dx + dy * dy )
end
