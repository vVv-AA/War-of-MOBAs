require("heroes/generics/Disables")

function Jump( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1	

	-- Clears any current command and disjoints projectiles
	caster:Stop()
	ProjectileManager:ProjectileDodge(caster)

	-- Ability variables
	ability.jump_direction = (caster:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
	ability.jump_distance = math.min((caster:GetCursorPosition() - caster:GetAbsOrigin()):Length2D(), ability:GetLevelSpecialValueFor("jump_distance", ability_level))
	ability.jump_speed = ability:GetLevelSpecialValueFor("jump_speed", ability_level) * 1/30
	ability.jump_traveled = 0
	ability.jump_z = 0
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function JumpHorizonal( keys )
	local caster = keys.target
	local ability = keys.ability

	if ability.jump_traveled < ability.jump_distance then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + ability.jump_direction * ability.jump_speed)
		ability.jump_traveled = ability.jump_traveled + ability.jump_speed
	else
		caster:InterruptMotionControllers(true)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_toss_stomp", {duration = 0.5})
	end
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function JumpVertical( keys )
	local caster = keys.target
	local ability = keys.ability

	-- For the first half of the distance the unit goes up and for the second half it goes down
	if ability.jump_traveled < ability.jump_distance/2 then
		-- Go up
		-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
		ability.jump_z = ability.jump_z + ability.jump_speed
		-- Set the new location to the current ground location + the memorized z point
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster) + Vector(0,0,ability.jump_z))
	else
		-- Go down
		ability.jump_z = ability.jump_z - ability.jump_speed
		caster:StartGesture(ACT_DOTA_SPAWN)
	end
end

function UpgradesHandler(keys)
	local caster = keys.caster
	local ability = keys.ability

	if ability:GetLevel() < 2 then return end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_move_speed_bonus_toss", {})
end

function ApplyStunAoE( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if ability:GetLevel() < 3 then return end
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