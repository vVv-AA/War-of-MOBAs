require("heroes/generics/Disables")

function GiveSlowAttacks( keys )
	if keys.ability:GetLevel() == 3 then
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_black_arrow_slow_arrows", {})
	end
end
function ApplyStunModifier( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if target:IsHero() == false and target:GetUnitName() ~= "npc_dota_roshan" then
		local duration = keys.duration
		local params = 
		{
			caster = caster,
			ability = ability,
			target = target,
			bypass = "false",
			purgable = true,
			duration = keys.duration,
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

function IncreaseStackCount( keys )
	local caster = keys.caster
	local target = keys.target
	local modifier = target:FindModifierByName("modifier_black_arrow_stack_holder")
	local ability = keys.ability
	local current_stack = target:GetModifierStackCount( "modifier_black_arrow_stack_holder", ability )
	local duration = ability:GetSpecialValueFor("slow_duration")

	if target:HasModifier( "modifier_black_arrow_stack_holder" ) then
		current_stack = target:GetModifierStackCount( "modifier_black_arrow_stack_holder", ability )
		ability:ApplyDataDrivenModifier(caster, target, "modifier_black_arrow_stack_holder", {duration = duration})
		target:SetModifierStackCount( "modifier_black_arrow_stack_holder", ability, current_stack + 1 )
	else
		ability:ApplyDataDrivenModifier( caster, target, "modifier_black_arrow_stack_holder", { Duration = duration } )
		target:SetModifierStackCount( "modifier_black_arrow_stack_holder", ability, 1 )
	end
end

function DecreaseStackCount( keys )
	local target = keys.target
	local ability = keys.ability
	local current_stack = target:GetModifierStackCount( "modifier_black_arrow_stack_holder", ability )
	target:SetModifierStackCount("modifier_black_arrow_stack_holder", keys.ability, math.max(current_stack - 1, 0))
end