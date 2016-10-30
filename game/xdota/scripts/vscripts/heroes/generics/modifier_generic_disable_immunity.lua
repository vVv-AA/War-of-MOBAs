LinkLuaModifier("modifier_immune_hex", "heroes/generics/modifier_immune_hex.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_stun", "heroes/generics/modifier_immune_stun.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_disarm", "heroes/generics/modifier_immune_disarm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_root", "heroes/generics/modifier_immune_root.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_sleep", "heroes/generics/modifier_immune_sleep.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_banish", "heroes/generics/modifier_immune_banish.lua", LUA_MODIFIER_MOTION_NONE)

if modifier_generic_disable_immunity == nil then
    modifier_generic_disable_immunity = class({})
end

function modifier_generic_disable_immunity:OnCreated( kv )
    if IsServer() then
        if kv.duration ~= nil then
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_stun", {duration = kv.duration, purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_hex", {duration = kv.duration, purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_root", {duration = kv.duration, purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_disarm", {duration = kv.duration, purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_sleep", {duration = kv.duration, purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_banish", {duration = kv.duration, purgable = kv.purgable})
        else
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_stun", {purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_hex", {purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_root", {purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_disarm", {purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_sleep", {purgable = kv.purgable})
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_immune_banish", {purgable = kv.purgable})
        end

        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_generic_disable_immunity:OnDestroy( kv )
    if IsServer() then
        self:GetParent():RemoveModifierByName("modifier_immune_stun")
        self:GetParent():RemoveModifierByName("modifier_immune_hex")
        self:GetParent():RemoveModifierByName("modifier_immune_disarm")
    end
end

function modifier_generic_disable_immunity:IsHidden() 
    return true
end

function modifier_generic_disable_immunity:IsPurgable()
    return self.purgable
end

function modifier_generic_disable_immunity:IsDebuff()
    return false
end