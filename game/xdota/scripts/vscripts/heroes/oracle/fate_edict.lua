function ApplyShield( event )
    -- Variables
    -- test block
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    local abilityLevel = ability:GetLevel()
    local duration = ability:GetLevelSpecialValueFor("duration", abilityLevel - 1)
    ability.damageTotal = 0
    -- Strong Dispel
    local RemovePositiveBuffs = false
    local RemoveDebuffs = true
    local BuffsCreatedThisFrameOnly = false
    local RemoveStuns = true
    local RemoveExceptions = false
    target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
    target:RemoveModifierByNameAndCaster("modifier_no_damage_fate_edict", caster)
    ability:ApplyDataDrivenModifier(caster, target, "modifier_no_damage_fate_edict", {duration = duration})
    target:FindModifierByName("modifier_no_damage_fate_edict").base = true
    if abilityLevel < 2 then return end
    ApplyAoE(event)
end

function ApplyAoE( event )
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    ability.damageTotal = 0
    -- Strong Dispel
    local RemovePositiveBuffs = false
    local RemoveDebuffs = true
    local BuffsCreatedThisFrameOnly = false
    local RemoveStuns = true
    local RemoveExceptions = false
    local radius = ability:GetSpecialValueFor("extra_cast_aoe")

    local units = FindUnitsInRadius( target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, FIND_ANY_ORDER, DOTA_UNIT_TARGET_FLAG_NONE, false )

    for _,unit in pairs(units) do
        if unit ~= nil and unit ~= target and ( not unit:IsMagicImmune() ) and ( not unit:IsInvulnerable() ) then
            unit:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
            unit:RemoveModifierByNameAndCaster("modifier_no_damage_fate_edict_base", caster)
            ability:ApplyDataDrivenModifier(caster, unit, "modifier_no_damage_fate_edict_base", {})
        end
    end
end

function CountDamage( event )
	-- Variables
	local damage = event.DamageTaken
	local unit = event.unit
	local ability = event.ability
	ability.damageTotal = ability.damageTotal + damage
    local newHealth = unit.OldHealth            
    unit:SetHealth(newHealth)
end

-- Keeps track of the targets health
function OldHealth( event )
	local target = event.target
	target.OldHealth = target:GetHealth()
end

function DestoryDamage( event )
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local abilityLevel = ability:GetLevel()
    if abilityLevel < 2 then return end
    local radius = ability:GetLevelSpecialValueFor("radius", (abilityLevel - 1))
    target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")

    local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER, DOTA_UNIT_TARGET_FLAG_NONE, false )

    for _,unit in pairs(units) do
        if unit ~= nil and ( not unit:IsMagicImmune() ) and ( not unit:IsInvulnerable() ) then
            local damagetable = {
                    victim = unit,
                    attacker = caster,
                    damage = ability.damageTotal,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = ability,
            }
            ApplyDamage( damagetable )
        end
    end

    local heal_back_pct = ability:GetLevelSpecialValueFor("heal_back_fract", abilityLevel - 1)
    caster:Heal(heal_back_pct*ability.damageTotal, ability) 
end