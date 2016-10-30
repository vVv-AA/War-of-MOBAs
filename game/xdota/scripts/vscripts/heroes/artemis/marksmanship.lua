function AddUpgrades( event )
	local caster = event.caster
	local ability = event.ability
	caster:CalculateStatBonus()
	if ability:GetLevel() == 2 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_multistrike", {})
	end

	if ability:GetLevel() == 3 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_split_shot", {})
	end
end

function Strike( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	caster:PerformAttack(target, true, true, true, false, true)
end

function SplitShot( event )
    local caster = event.caster

	if caster.SKIP_ATTACKERINO then
		return
	end


    local caster_location = caster:GetAbsOrigin()
    local ability = event.ability

    -- Targeting variables
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS
    local attack_target = caster:GetAttackTarget()

    -- Ability variables
    local radius = caster:GetAttackRange()
    local max_targets = ability:GetSpecialValueFor("arrow_count")

    local split_shot_targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, caster:GetAttackRange(), target_team, target_type, target_flags, FIND_CLOSEST, false)
	caster.SKIP_ATTACKERINO = true

    for _,unit in pairs(split_shot_targets) do
        if unit ~= attack_target then
        	caster:PerformAttack(unit, caster:FindAbilityByName("aimed_shot_datadriven"):GetAutoCastState(), true, true, false, true)
            max_targets = max_targets - 1
        end
        -- If we reached the maximum amount of targets then break the loop
        if max_targets == 0 then break end
    end
	caster.SKIP_ATTACKERINO = false 
end

function SplitShotDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage_table = {}

	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	damage_table.damage = caster:GetAttackDamage()

	ApplyDamage(damage_table)
end
