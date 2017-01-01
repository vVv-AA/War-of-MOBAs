function ThrowDaggers( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")

    local target_type_hero = DOTA_UNIT_TARGET_HERO
    local target_type_basic = DOTA_UNIT_TARGET_BASIC
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
    local life_drain_duration = ability:GetSpecialValueFor("life_drain_duration")
    local projectile_speed = ability:GetSpecialValueFor("projectile_speed")
    local target_heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetCursorPosition(), nil, radius, target_team, target_type_hero + target_type_basic, target_flags, FIND_CLOSEST, false)

    local count = 0
    for _,unit in ipairs(target_heroes) do

    	if (not unit:IsInvulnerable()) and ( not unit:IsMagicImmune()) then
    		count = count + 1
			local projectile_info = 
			{
				EffectName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf",
				Ability = ability,
				vSpawnOrigin = caster:GetAbsOrigin(),
				Target = unit,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = true,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
               	life_drain_duration = life_drain_duration
			}

			TrackingProjectile(projectile_info)
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_dagger_slow", {})
		end
    end
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

			if caster.stiflingDaggerTargets ~= nil then
				if caster.stiflingDaggerTargets[target] ~= nil then
					target:RemoveModifierByName("modifier_life_drainer")
				end
			else
				caster.stiflingDaggerTargets = {}
			end

            CreateParticles({caster = caster, target = target, ability = ability})
			ability:ApplyDataDrivenModifier(caster, target, "modifier_life_drainer", {duration = 5})
            ParticleManager:DestroyParticle( particle, true )
            --Stop the timer
            return nil
        else
            --Reschedule for next frame
            return 0
        end
    end)
end

function LifeDrain( keys )
	local lifesteal = keys.ability:GetLevelSpecialValueFor("life_drain", keys.ability:GetLevel() - 1)
	local damage_table = {
		attacker = keys.caster,
		victim = keys.target,
		damage_type = DAMAGE_TYPE_PURE,
		damage = lifesteal,
	}

	ApplyDamage(damage_table)
	keys.caster:Heal(lifesteal, keys.ability)
end

function CreateParticles(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if caster.stiflingDaggerTargets == nil then
		caster.stiflingDaggerTargets = {}
	end

	local particleName = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
	caster.stiflingDaggerTargets[target] = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.stiflingDaggerTargets[target], 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
end

function DestroyParticles( keys )
	if keys.caster.stiflingDaggerTargets[keys.target] ~= nil then
		ParticleManager:DestroyParticle( keys.caster.stiflingDaggerTargets[keys.target], true )
		keys.caster.stiflingDaggerTargets[keys.target] = nil
	end
end