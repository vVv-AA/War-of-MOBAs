require("heroes/generics/Disables")

function Upgrade( keys )
	if keys.ability:GetLevel() == 2 then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_black_arrow_slow_buff_datadriven", {})
	end
end
function ApplyStunModifier( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local stun_duration = ability:GetSpecialValueFor("stun_duration")
	if target:IsHero() == false and target:GetUnitName() ~= "npc_dota_roshan" then
		local duration = keys.duration
		local params = 
		{
			caster = caster,
			ability = ability,
			target = target,
			bypass = "false",
			purgable = true,
			duration = stun_duration,
		}
		ApplyStun(params)
	end
end

function BlowUpDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local radius = keys.radius

    local target_type = DOTA_UNIT_TARGET_BASIC
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

    if ability:GetLevel() > 2 then
    	target_type = target_type + DOTA_UNIT_TARGET_HERO
    end

    local damagetable = {
            victim = nil,
            attacker = caster,
            damage = ability:GetAbilityDamage(),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = ability
    }

	local damage_targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)
	local particleName = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
	local soundEventName = "Ability.SandKing_CausticFinale"
	
	local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, target )
	StartSoundEvent( soundEventName, target )

	for _,unit in ipairs(damage_targets) do
		if unit ~= nil and unit:IsAlive() and unit:IsInvulnerable() == false then
			damagetable.victim = unit
		    ApplyDamage( damagetable )
		end
	end
end

function ApplySlow( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local duration = ability:GetSpecialValueFor("slow_duration")

	if target:HasModifier( "modifier_black_arrow_slow_debuff_datadriven" ) then
		local current_stack = target:GetModifierStackCount( "modifier_black_arrow_slow_debuff_datadriven", ability )
		target:RemoveModifierByNameAndCaster("modifier_black_arrow_slow_debuff_datadriven", caster)
		ability:ApplyDataDrivenModifier(caster, target, "modifier_black_arrow_slow_debuff_datadriven", {duration = duration})
		target:SetModifierStackCount( "modifier_black_arrow_slow_debuff_datadriven", ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, target, "modifier_black_arrow_slow_debuff_datadriven", { duration = duration } )
		target:SetModifierStackCount( "modifier_black_arrow_slow_debuff_datadriven", ability, 1 )
	end
end

function DecreaseStackCount( keys )
	local target = keys.target
	local ability = keys.ability
	local current_stack = target:GetModifierStackCount( "modifier_black_arrow_slow_debuff_datadriven", ability )
	if current_stack == 1 then
		target:RemoveModifierByName("modifier_black_arrow_slow_debuff_datadriven")
	end
	target:SetModifierStackCount("modifier_black_arrow_stack_holder", keys.ability, current_stack - 1)
end

function Dead_Effect( keys )
	local particleName = "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf"
	local soundEventName = "Ability.SandKing_CausticFinale"
	
	local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, keys.target )
	StartSoundEvent( soundEventName, keys.target )
end
