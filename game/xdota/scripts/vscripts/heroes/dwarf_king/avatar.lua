LinkLuaModifier("modifier_reduce_disable_duration", "heroes/generics/modifier_reduce_disable_duration.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_model_scale", "heroes/dwarf_king/avatar.lua", LUA_MODIFIER_MOTION_NONE)

function UpgradeAvatar( event )
    local caster = event.caster
    if event.ability:GetLevel() > 1 then return end
    caster:FindAbilityByName("dwarf_king_frenzy_datadriven"):SetLevel(1)
end

function StartAvatar( event )
    local caster = event.caster
    local ability = event.ability
    local modifier_avatar = "modifier_avatar"
    local modifier_fake_basher = "modifier_fake_basher"

    if ability:GetLevel() < 3 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_avatar", {duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_fake_basher", {duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )})
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_avatar", {})
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_fake_basher", {})
    end
end

function Avatar( event )
    local caster = event.caster
    local ability = event.ability
    local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
    local model_size = ability:GetLevelSpecialValueFor( "model_size" , ability:GetLevel() - 1  )
    if ability:GetLevel() < 3 then
        caster:AddNewModifier(caster,ability,"modifier_model_scale",{duration=duration,scale=model_size})
    	caster:AddNewModifier(caster, ability, "modifier_reduce_disable_duration", { duration=duration, reductionFactor = ability:GetSpecialValueFor("disable_post_red_pct"), purgable = false, permanent = false })
    else
        caster:AddNewModifier(caster,ability,"modifier_model_scale",{scale=model_size})
        caster:AddNewModifier(caster, ability, "modifier_reduce_disable_duration", { reductionFactor = ability:GetSpecialValueFor("disable_post_red_pct"), purgable = false, permanent = true })
    end
end

modifier_model_scale = class({})

function modifier_model_scale:OnCreated(params)
    local scale = params.scale or 100
    self.scale = scale
end

function modifier_model_scale:DeclareFunctions()
    return { MODIFIER_PROPERTY_MODEL_SCALE, }
end

function modifier_model_scale:GetModifierModelScale()
    return self.scale
end

function modifier_model_scale:IsHidden()
    return true
end

function modifier_model_scale:IsPurgable()
    return false
end
