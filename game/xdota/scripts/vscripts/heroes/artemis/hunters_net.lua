require('mechanics/talents')

function StartProjectile( event )
	local caster = event.caster
	local ability = event.ability
    local net_speed = ability:GetSpecialValueFor("net_speed")
	local dummy = CreateUnitByName( "npc_dummy_blank", caster:GetCursorPosition(), false, caster, caster, caster:GetTeamNumber() )

	local projectile_info = 
	{
		EffectName = "particles/test_particle/artemis_net_projectile.vpcf",
		Ability = ability,
		vSpawnOrigin = caster:GetAbsOrigin(),
		Target = dummy,
		Source = caster,
		bHasFrontalCone = false,
		iMoveSpeed = net_speed,
		bReplaceExisting = false,
		bProvidesVision = false,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
	}
	dummy:AddNoDraw()
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

            ParticleManager:DestroyParticle( particle, false )
            local radius = GetTalentSpecialValueFor(ability, "radius")
		    local target_type_hero = DOTA_UNIT_TARGET_HERO
		    local target_type_basic = DOTA_UNIT_TARGET_BASIC
		    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
		    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

		    local target_heroes = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_team, target_type_hero, target_flags, FIND_CLOSEST, false)
	        for _,unit in ipairs(target_heroes) do
    	    	if not unit:IsInvulnerable() then
    	    		ability:ApplyDataDrivenModifier(caster, unit, "modifier_netted_datadriven", {})
    	    	end
	        end

	        target:ForceKill(true)
            --Stop the timer
            return nil
        else
            --Reschedule for next frame
            return 0
        end
    end)
end
