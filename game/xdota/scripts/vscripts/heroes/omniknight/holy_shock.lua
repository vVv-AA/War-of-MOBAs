require('mechanics/talents')

function HolyShockStart( event )
    -- Variables
    if not IsServer() then return end

    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local abilityLevel = ability:GetLevel()

    local radius = ability:GetLevelSpecialValueFor("radius", (abilityLevel - 1))
    local duration = GetTalentSpecialValueFor(ability, "buff_duration")
    local heal = ability:GetLevelSpecialValueFor("heal", (abilityLevel - 1))

    if target:GetTeamNumber() == caster:GetTeamNumber() then
            target:Heal(heal, caster)
        else
            ApplyDamage({victim = target, attacker = caster, damage = heal, damage_type = DAMAGE_TYPE_PURE, ability = ability})
    end

    local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER, DOTA_UNIT_TARGET_FLAG_NONE, false )

    for _,unit in pairs(units) do
        if unit ~= nil and ( not unit:IsMagicImmune() ) and ( not unit:IsInvulnerable() ) then

            local damagetable = {
                    victim = unit,
                    attacker = caster,
                    damage = heal,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = ability
            }
            if unit:GetTeamNumber() ~= caster:GetTeamNumber() then
            ApplyDamage(damagetable)
            end
            if duration > 0 then
                ability:ApplyDataDrivenModifier(caster, unit, "modifier_holy_shock", {duration = duration})
            end
        end
    end
end



function HolyShockBuffDebuff( event )
	-- Variables
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local abilityLevel = ability:GetLevel()
    local time_elapsed = 0

    local radius = ability:GetLevelSpecialValueFor("radius", (abilityLevel - 1))
    local duration = GetTalentSpecialValueFor(ability, "buff_duration")
    local heal = ability:GetLevelSpecialValueFor("heal", (abilityLevel - 1))
    local heal_buff = GetTalentSpecialValueFor(ability, "buff_pct")

    local tar_maxHP_change_pct = target:GetMaxHealth()*heal_buff/100


    if target:GetTeamNumber() == caster:GetTeamNumber() then
        Timers:CreateTimer(function()
            if time_elapsed < duration then
            target:Heal(tar_maxHP_change_pct*0.03, ability)
            time_elapsed = time_elapsed + 0.03
            end
        return 0.03
    end)

    end

        if target:GetTeamNumber() ~= caster:GetTeamNumber() then
        Timers:CreateTimer(function()
            if time_elapsed < duration then
            ApplyDamage({victim = target, attacker = caster, damage = tar_maxHP_change_pct*0.03, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
            time_elapsed = time_elapsed + 0.03
            end
        return 0.03
    end)

    end
end