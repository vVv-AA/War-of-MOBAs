function FireTrackingProjectile( keys )
	local caster = keys.caster
	local ability = keys.ability
    local point = keys.target_points[1]
    local direction = (point - caster:GetAbsOrigin()):Normalized()
    local target_point = caster:GetAbsOrigin() + Vector(direction.x*1500, direction.y*1500, 0)
    AddFOWViewer(caster:GetTeam(), target_point, 500, 0.03, false)
    local target = CreateUnitByName("target_practice", target_point, false, caster, caster, caster:GetTeamNumber())
    target:AddNoDraw()
    local projectile_info = 
	{
		EffectName = "particles/test_particle/sven_spell_storm_bolt.vpcf",
		Ability = ability,
		vSpawnOrigin = caster:GetAbsOrigin(),
		Target = target,
		Source = caster,
		bHasFrontalCone = false,
		iMoveSpeed = 2200,
		bReplaceExisting = false,
		bProvidesVision = true,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
        iVisionRadius = ability:GetSpecialValueFor("vision_radius")
	}
    projectile_info.target = target
	TrackingProjectile(projectile_info)
end

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
            params.target:RemoveSelf()
            ParticleManager:DestroyParticle( particle, true )
            --Stop the timer
            return nil
        else
            --Reschedule for next frame
            return 0
        end
    end)
end

function UpgradesHandler( keys )
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    if ability:GetLevel() < 2 then return end
    if target:IsRealHero() then
        local rem_cooldown = ability:GetCooldownTimeRemaining()
        ability:EndCooldown()
        ability:StartCooldown(math.max(rem_cooldown - ability:GetSpecialValueFor("cooldown_reduction_perhit"), 0))
    end
    ability:ApplyDataDrivenModifier(caster, target, "modifier_assassination_slow", {duration = ability:GetSpecialValueFor("slow_duration")})
    if ability:GetLevel() < 3 then return end
    target:AddNewModifier(caster, nil, "modifier_stunned", {duration = ability:GetSpecialValueFor("stun_duration")})
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

