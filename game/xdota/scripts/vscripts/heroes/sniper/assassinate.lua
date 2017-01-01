require("heroes/generics/Disables")

function UpgradesHandler( keys )
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    ability:ApplyDataDrivenModifier(caster, target, "modifier_assassination_slow", {duration = ability:GetSpecialValueFor("slow_duration")})
    if ability:GetLevel() < 2 then return end
    if target:IsRealHero() then
        local rem_cooldown = ability:GetCooldownTimeRemaining()
        ability:EndCooldown()
        ability:StartCooldown(math.max(rem_cooldown - ability:GetSpecialValueFor("cooldown_reduction_perhit"), 0))
    end
    if ability:GetLevel() < 3 then return end

    local params = 
    {
        duration = ability:GetSpecialValueFor("stun_duration"),
        caster = caster,
        ability = ability,
        target = target,
        bypass = "false",
        purgable = true,
    }
    ApplyStun(params)
end

function KnockBack( keys )
    local vCaster = keys.caster:GetAbsOrigin()
    local vTarget = keys.target:GetAbsOrigin()
    local len = ( vTarget - vCaster ):Length2D()
    local knockbackModifierTable =
    {
        should_stun = 0,
        knockback_duration = keys.duration,
        duration = keys.duration,
        knockback_distance = keys.distance,
        knockback_height = 0,
        center_x = keys.caster:GetAbsOrigin().x,
        center_y = keys.caster:GetAbsOrigin().y,
        center_z = keys.caster:GetAbsOrigin().z
    }
    keys.target:AddNewModifier( keys.caster, nil, "modifier_knockback", knockbackModifierTable )
end

