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
	local delay = ability:GetSpecialValueFor("fire_delay")
	local total_arrows = ability:GetLevelSpecialValueFor("total_arrows", ability:GetLevel() -1 )
	local stack_count = caster:GetModifierStackCount("rapid_fire_charges", caster)
	if stack_count == 0 then return end
	caster:SetModifierStackCount("rapid_fire_charges", caster, stack_count - 1)
    local target_type_hero = DOTA_UNIT_TARGET_HERO
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

    local target_heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, caster:GetAttackRange(), target_team, target_type_hero, target_flags, FIND_CLOSEST, false)

    local count = 0
    for _,unit in ipairs(target_heroes) do
    	if count > 0 then
    		break
    	end
    	if unit:IsRealHero() and (not unit:IsInvulnerable()) then
    		count = count + 1
			local time_elapsed = 0;
			Timers:CreateTimer(delay, function ()
				time_elapsed = time_elapsed + delay
				caster:PerformAttack(unit, true, true, true, false, true)
				if time_elapsed > delay*total_arrows then return nil end
				return delay
			end)
		end
    end
end

function GiveCharge( keys )
	if keys.unit:IsRealHero() then
		keys.caster:SetModifierStackCount("rapid_fire_charges", keys.caster, keys.ability:GetSpecialValueFor("max_stacks"))
	else
		keys.caster:SetModifierStackCount("rapid_fire_charges", keys.caster, math.min(keys.ability:GetSpecialValueFor("max_stacks"), keys.caster:GetModifierStackCount("rapid_fire_charges", keys.caster) + 1))
	end
end