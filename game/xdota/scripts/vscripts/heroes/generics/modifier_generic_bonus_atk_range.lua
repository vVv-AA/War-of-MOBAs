if modifier_generic_bonus_atk_range == nil then
    modifier_generic_bonus_atk_range = class({})
end

function modifier_generic_bonus_atk_range:OnCreated( params )
    if IsServer() then
        self.atk_range = params.atk_range
        self.is_purgable = params.is_purgable
        self.is_hidden = params.is_hidden
    end
end

function modifier_generic_bonus_atk_range:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_bonus_atk_range:IsPassive()
    return true
end

function modifier_generic_bonus_atk_range:GetTexture()
    return "antimage_spell_shield"
end

function modifier_generic_bonus_atk_range:IsDebuff()
    return false
end

function modifier_generic_bonus_atk_range:IsPurgable()
    return self.is_purgable
end

function modifier_generic_bonus_atk_range:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }

    return funcs
end

function modifier_generic_bonus_atk_range:IsHidden() 
    return self.is_hidden
end

function modifier_generic_bonus_atk_range:GetModifierAttackRangeBonus()
    return self.atk_range
end