function RemoveOtherUlt( event )
	local caster = event.caster
	if caster:HasAbility("primal_roar_datadriven") then
		caster:SwapAbilities("primal_roar_datadriven", "tough_exterior", false, true)
		caster:RemoveAbility("primal_roar_datadriven")
	end
end

function boar_hoard_spawn( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = keys.target_points[1]
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local distance = ability:GetLevelSpecialValueFor( "distance", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local collision_radius = ability:GetLevelSpecialValueFor( "collision_radius", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local boars_per_sec = ability:GetLevelSpecialValueFor ( "boars_per_sec", ability:GetLevel() - 1 )
	local dummyModifierName = "modifier_board_hoard_dummy_datadriven"

	-- Find forward vector
	local forwardVec = targetLoc - casterLoc
	forwardVec = forwardVec:Normalized()

	-- Find backward vector
	local backwardVec = casterLoc - targetLoc
	backwardVec = backwardVec:Normalized()

	-- Find middle point of the spawning line
	local middlePoint = casterLoc + ( radius * backwardVec )

	-- Find perpendicular vector
	local v = middlePoint - casterLoc
	local dx = -v.y
	local dy = v.x
	local perpendicularVec = Vector( dx, dy, v.z )
	perpendicularVec = perpendicularVec:Normalized()

	-- Create dummy to store data in case of multiple instances are called
	local dummy = CreateUnitByName( "npc_dummy_blank", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
	ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
	dummy.march_of_the_machines_num = 0
	local loop_counter = 0
	-- Create timer to spawn projectile
	Timers:CreateTimer( function()
			-- Get random location for projectile
			local random_distance = RandomInt( -radius, radius )
			local spawn_location = middlePoint + perpendicularVec * random_distance
			if loop_counter % 60 == 0 then
				EmitSoundOn("beastmaster_beas_ability_boar_move_02", caster)
			end
			loop_counter = loop_counter + 1
			local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )
			-- Spawn projectiles
			local projectileTable = {
				Ability = ability,
				EffectName = "particles/custom/tinker_machine.vpcf",
				vSpawnOrigin = spawn_location,
				fDistance = distance,
				fStartRadius = collision_radius,
				fEndRadius = collision_radius,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				bProvidesVision = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				vVelocity = velocityVec * projectile_speed
			}
			ProjectileManager:CreateLinearProjectile( projectileTable )

			-- Increment the counter
			dummy.march_of_the_machines_num = dummy.march_of_the_machines_num + 1

			-- Check if the number of machines have been reached
			print(dummy.march_of_the_machines_num)
			if dummy.march_of_the_machines_num == boars_per_sec * duration then
				dummy:Destroy()
				return nil
			else
				return 1 / boars_per_sec
			end
		end
	)
end
