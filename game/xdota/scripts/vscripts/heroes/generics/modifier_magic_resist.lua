if modifier_magic_resist == nil then
    modifier_magic_resist = class({})
end

function modifier_magic_resist:OnCreated( params )
    if IsServer() then
        self.magic_resist = params.magic_resist
        self.is_purgable = params.is_purgable
        self.is_hidden = params.is_hidden
    end
end

function modifier_magic_resist:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_magic_resist:IsPassive()
    return true
end

function modifier_magic_resist:GetTexture()
    return "antimage_spell_shield"
end

function modifier_magic_resist:IsDebuff()
    return false
end

function modifier_magic_resist:IsPurgable()
    return self.is_purgable
end

function modifier_magic_resist:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_magic_resist:IsHidden() 
    return self.is_hidden
end

function modifier_magic_resist:GetModifierMagicalResistanceBonus()
    return self.magic_resist
end