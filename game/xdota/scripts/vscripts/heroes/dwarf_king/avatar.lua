require('mechanics/talents')
require("heroes/generics/Disables")

LinkLuaModifier("modifier_reduce_disable_duration", "heroes/generics/modifier_reduce_disable_duration.lua", LUA_MODIFIER_MOTION_NONE)

function StartAvatar( event )
    local caster = event.caster
    local ability = event.ability
    local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
    local model_size = ability:GetLevelSpecialValueFor( "model_size" , ability:GetLevel() - 1  )

    caster:AddNewModifier(caster, ability, "modifier_reduce_disable_duration", { duration=duration, reductionFactor = ability:GetSpecialValueFor("disable_post_red_pct"), purgable = false, permanent = false })

    ability:ApplyDataDrivenModifier(caster, caster, "modifier_avatar", {duration = duration})
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_fake_basher", {duration = duration})
end

function FakeBash( event )
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local duration = ability:GetSpecialValueFor("bash_duration")
    local bypass = event.bypass
    local chance = GetTalentSpecialValueFor(ability, "bash_chance")
    if chance <= RandomFloat(0.0, 100.0) then
        ApplyStun({caster = caster, ability = ability, target = target, duration = duration, bypass = bypass})
    end
end