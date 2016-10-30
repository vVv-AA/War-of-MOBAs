require("heroes/generics/Disables")

function GiveInitialStack( keys )
	local caster = keys.caster
	local ability = keys.ability

	if caster:HasModifier("rapid_fire_charges") then return end
	ability:ApplyDataDrivenModifier(caster, caster, "rapid_fire_charges", {})
	caster:SetModifierStackCount("rapid_fire_charges", caster, ability:GetSpecialValueFor("max_stacks"))
end

function Fire( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local delay = ability:GetSpecialValueFor("fire_delay")
	local total_arrows = ability:GetLevelSpecialValueFor("total_arrows", ability:GetLevel() -1 )
	local stack_count = caster:GetModifierStackCount("rapid_fire_charges", caster)
	if stack_count == 0 then return end
	caster:SetModifierStackCount("rapid_fire_charges", caster, stack_count - 1)
    local target_type_hero = DOTA_UNIT_TARGET_HERO
    local target_type_basic = DOTA_UNIT_TARGET_BASIC
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

    -- Ability variables
    local radius = caster:GetAttackRange()
    local target_heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:GetAttackRange(), target_team, target_type_hero, target_flags, FIND_CLOSEST, false)

    local count = 0
    for _,unit in ipairs(target_heroes) do

    	if count > 0 then
    		break
    	end
    	
    	if unit:IsRealHero() and  (not unit:IsInvulnerable()) and ( not unit:IsMagicImmune()) then
    		count = count + 1
			local projectile_info = 
			{
				EffectName = "particles/test_particle/clinkz_searing_arrow.vpcf",
				Ability = ability,
				vSpawnOrigin = caster:GetAbsOrigin(),
				Target = unit,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = 1200,
				bReplaceExisting = false,
				bProvidesVision = false,
                iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
			}

			local time_elapsed = 0;
			TrackingProjectile(projectile_info)

			Timers:CreateTimer(delay, function ()
				time_elapsed = time_elapsed + delay;
				TrackingProjectile(projectile_info)
				if time_elapsed > delay*total_arrows then return nil end
				return delay
			end)
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

			local damage_table = {
				attacker = caster,
				victim = target,
				damage_type = params.Ability:GetAbilityDamageType(),
				damage = params.Ability:GetAbilityDamage(),
			}
			ApplyDamage(damage_table)

            ParticleManager:DestroyParticle( particle, false )
			local random = RandomFloat(0, 1)

			if (random < ability:GetSpecialValueFor("random_chance")) then
				local params = 
				{
					caster = caster,
					ability = ability,
					target = target,
					bypass = "false",
					purgable = true,
				}
				ApplyStun(params)
			end
            --Stop the timer
            return nil
        else
            --Reschedule for next frame
            return 0
        end
    end)
end

function GiveCharge( keys )
	if keys.unit:IsRealHero() then
		keys.caster:SetModifierStackCount("rapid_fire_charges", keys.caster, keys.ability:GetSpecialValueFor("max_stacks"))
	else
		keys.caster:SetModifierStackCount("rapid_fire_charges", keys.caster, math.min(keys.ability:GetSpecialValueFor("max_stacks"), keys.caster:GetModifierStackCount("rapid_fire_charges", keys.caster) + 1))
	end
end