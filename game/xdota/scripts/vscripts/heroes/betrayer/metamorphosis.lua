LinkLuaModifier("modifier_meta_model", "heroes/betrayer/modifier_meta_model.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_reduce_disable_duration", "heroes/generics/modifier_reduce_disable_duration.lua", LUA_MODIFIER_MOTION_NONE)

function MetamorphosisCast ( event )
	local caster = event.caster
	local point = event.target_points[1]
	local ability = event.ability
	caster:RemoveModifierByName("modifier_meta_model")
	caster:RemoveModifierByName("modifier_reduce_disable_duration")
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_coccon", {})
    caster:SetAbsOrigin(point)
    caster:AddNoDraw()
    caster.groundParticle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_blackhole_n.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(caster.groundParticle1, 0, point)
    ParticleManager:SetParticleControl(caster.groundParticle1, 1, point)
    caster.groundParticle2 = ParticleManager:CreateParticle("particles/test_particle/metamorphosis_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(caster.groundParticle2, 0, point)
    ParticleManager:SetParticleControl(caster.groundParticle2, 1, point)
    caster:SetAbsOrigin(point)
end

function MetamorphosisStart ( event )
	local caster = event.caster
	local ability = event.ability
	caster:RemoveNoDraw()
	--ParticleManager:DestroyParticle(caster.groundParticle1, false)
	ability.hero_count = event.hero_count
	if ability:GetLevel() < 3 then
		caster:AddNewModifier(caster, ability, "modifier_meta_model", { duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1), purgable = false })
		caster:AddNewModifier(caster, ability, "modifier_reduce_disable_duration", { duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1), reductionFactor = 0.5, purgable = false })
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_particle_holder_meta", { duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1) })
	else
		caster:AddNewModifier(caster, ability, "modifier_meta_model", { purgable = false })
		caster:AddNewModifier(caster, ability, "modifier_reduce_disable_duration", { reductionFactor = 0.5, purgable = false, permanent = true })
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_particle_holder_meta", {})
	end
end

function UpHuntersThirst( keys )
	local huntersthirst = keys.caster:FindAbilityByName("betrayer_hunters_thirst_datadriven")
	local metamorphosis_level = keys.ability:GetLevel()
	
	if metamorphosis_level ~= nil and metamorphosis_level + 1 ~= huntersthirst:GetLevel() then
		huntersthirst:SetLevel(metamorphosis_level + 1)
	end
end

function CocconEnd( keys )
	local caster = keys.caster
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local radius = ability:GetSpecialValueFor("damage_aoe")

    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

    local hero_count = 0

    local damage_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)

    for _,unit in pairs(damage_targets) do
	    if unit ~= nil and ( not unit:IsMagicImmune() ) and ( not unit:IsInvulnerable() ) then
	        local damagetable = {
	                victim = unit,
	                attacker = caster,
	                damage = ability:GetAbilityDamage(),
	                damage_type = DAMAGE_TYPE_MAGICAL,
	                ability = ability
	        }
	        ApplyDamage( damagetable )
	    end
	    if unit ~= nil and unit:IsHero() then
	    	hero_count = hero_count + 1
	    end
    end
	ParticleManager:DestroyParticle( caster.groundParticle1, false )
	ParticleManager:DestroyParticle( caster.groundParticle2, false )
    MetamorphosisStart({caster = caster, ability = ability, hero_count = hero_count})
end