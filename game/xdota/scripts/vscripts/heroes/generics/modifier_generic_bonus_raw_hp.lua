if modifier_generic_bonus_raw_hp == nil then
    modifier_generic_bonus_raw_hp = class({})
end

function modifier_generic_bonus_raw_hp:OnCreated( params )
    if IsServer() then
        self.bonus_hp = params.bonus_hp
        self.is_purgable = params.is_purgable
        self.is_hidden = params.is_hidden
    end
end

function modifier_generic_bonus_raw_hp:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_bonus_raw_hp:IsPassive()
    return true
end

function modifier_generic_bonus_raw_hp:GetTexture()
    return "antimage_spell_shield"
end

function modifier_generic_bonus_raw_hp:IsDebuff()
    return false
end

function modifier_generic_bonus_raw_hp:IsPurgable()
    return self.is_purgable
end

function modifier_generic_bonus_raw_hp:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }

    return funcs
end

function modifier_generic_bonus_raw_hp:IsHidden() 
    return self.is_hidden
end

function modifier_generic_bonus_raw_hp:GetModifierHealthBonus()
    return self.bonus_hp
end