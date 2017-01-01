LinkLuaModifier("hyperion_modifier", "heroes/sniper/calldown.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("hyperion_particles", "heroes/sniper/calldown.lua", LUA_MODIFIER_MOTION_NONE)

function SpawnShip( keys )
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("hyperion_duration")

	local unit = CreateUnitByName("hyperion", caster:GetCursorPosition(), false, caster, caster, caster:GetTeamNumber())
	unit.side_gunner = CreateUnitByName("side_gunner", caster:GetCursorPosition(), false, caster, caster, caster:GetTeamNumber())
	
	unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	unit:AddNewModifier(caster, ability, "hyperion_particles", {duration = duration})
	unit:AddNewModifier(caster, nil, "modifier_disarmed", {duration = duration})

	unit.side_gunner:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
	unit.side_gunner:AddNewModifier(caster, ability, "hyperion_modifier", {duration = duration})

	unit.forwardVector = (unit:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	unit:SetForwardVector(unit.forwardVector)
	unit.distance_travelled = 0
	
	local projectile_info = 
	{
		EffectName = "particles/test_particle/hyperion_calldown_building.vpcf",
		Ability = ability,
		vSpawnOrigin = nil,
		Target = nil,
		Source = unit.side_gunner,
		bHasFrontalCone = false,
		iMoveSpeed = ability:GetSpecialValueFor("hyperion_agni_movespeed"),
		bReplaceExisting = false,
		bProvidesVision = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
        Damage = unit.side_gunner:GetAttackDamage()*ability:GetSpecialValueFor("building_dmg_fact"),
	}

	local max_distance = ability:GetSpecialValueFor("hyperion_distance")
	local vision = unit:GetCurrentVisionRange()
	local atk_range = unit.side_gunner:GetAttackRange()
    local target_type = DOTA_UNIT_TARGET_HERO
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS
    
    unit.atk_cooldown = ability:GetSpecialValueFor("hyperion_atk_speed")
    unit.atk_cooldown_remain = 0

    unit.building_atk_cooldown = ability:GetSpecialValueFor("building_atk_speed")
    unit.building_atk_cooldown_remain = 0

	Timers:CreateTimer(0, function ()
		if unit:IsNull() or not unit:IsAlive() then return nil end
		if unit.distance_travelled > max_distance then return nil end
		local origin = unit:GetAbsOrigin() + unit.forwardVector*6
		unit:SetAbsOrigin(origin)
		origin.z = 1600
		unit.side_gunner:SetAbsOrigin(origin)
		
		if unit.atk_cooldown_remain <= 0 then
		    local targets = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, 540 , target_team, target_type, target_flags, FIND_CLOSEST, false)
			for _,target in ipairs(targets) do
	        	unit.side_gunner:PerformAttack(target, false, true, true, false, true)
			end
			if #targets > 0 then unit.atk_cooldown_remain = unit.atk_cooldown end
		end
		if unit.building_atk_cooldown_remain <= 0 then
		    local buildingtargets = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil, 540 , target_team, DOTA_UNIT_TARGET_BUILDING, target_flags, FIND_CLOSEST, false)
			for _,target in ipairs(buildingtargets) do
				projectile_info.vSpawnOrigin = unit.side_gunner:GetAbsOrigin()
				projectile_info.Target = target
	        	TrackingProjectile(projectile_info)
			end
			if #buildingtargets > 0 then unit.building_atk_cooldown_remain = unit.building_atk_cooldown end
		end
		unit.distance_travelled = unit.distance_travelled + 6
		unit.atk_cooldown_remain = math.max(unit.atk_cooldown_remain - 0.03, 0)
		unit.building_atk_cooldown_remain = math.max(unit.building_atk_cooldown_remain - 0.03, 0)
		AddFOWViewer(unit:GetTeam(), unit:GetAbsOrigin(), vision, 0.03, false)
		return 0.03
	end)
end

---------------------------------------------------------------

function TrackingProjectile( params )
    local target = params.Target
    local caster = params.Source
    local speed = params.iMoveSpeed
 	local ability = params.Ability
    --Fetch initial projectile location
    local projectile = caster:GetAttachmentOrigin( params.iSourceAttachment )
 
    --Make the particle
    local particle = ParticleManager:CreateParticle( params.EffectName, PATTACH_CUSTOMORIGIN, caster)
    --Source CP
    ParticleManager:SetParticleControl( particle, 0, caster:GetAttachmentOrigin( params.iSourceAttachment ) )
    --TargetCP
    ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
    --Speed CP
    ParticleManager:SetParticleControl( particle, 2, Vector( speed, 0, 0 ) )
 
    Timers:CreateTimer(function()
        --Get the target location
        local target_location = target:GetAbsOrigin()
 
        --Move the projectile towards the target
        projectile = projectile + ( target_location - projectile ):Normalized() * speed * FrameTime()
 
        --Check the distance to the target
        if ( target_location - projectile ):Length2D() < speed * FrameTime() then
            --Target has reached destination!
			ApplyDamage({victim = target, attacker = caster, damage = params.Damage, damage_type = DAMAGE_TYPE_PHYSICAL})
            ParticleManager:DestroyParticle( particle, true )
            --Stop the timer
            return nil
        else
            --Reschedule for next frame
            return 0
        end
    end)
end

---------------------------------------------------------------
if hyperion_modifier == nil then
    hyperion_modifier = class({})
end

function hyperion_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	}
 
	return funcs
end

function hyperion_modifier:GetVisualZDelta()
	return 0
end

function hyperion_modifier:GetModifierBaseAttack_BonusDamage()
	return self:GetAbility():GetLevelSpecialValueFor("hyperion_damage", self:GetAbility():GetLevel() - 1)
end

function hyperion_modifier:CheckState()
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end
---------------------------------------------------------------
if hyperion_particles == nil then
    hyperion_particles = class({})
end

function hyperion_particles:GetEffectName()
    return "particles/test_particle/hyperion_aoe_indicator.vpcf"
end

function hyperion_particles:CheckState()
	return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end