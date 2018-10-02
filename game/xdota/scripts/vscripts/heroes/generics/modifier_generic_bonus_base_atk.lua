if modifier_generic_bonus_base_atk == nil then
    modifier_generic_bonus_base_atk = class({})
end

function modifier_generic_bonus_base_atk:OnCreated( params )
    if IsServer() then
        self.bonus_atk = params.bonus_atk
        self.is_purgable = params.is_purgable
        self.is_hidden = params.is_hidden
    end
end

function modifier_generic_bonus_base_atk:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_bonus_base_atk:IsPassive()
    return true
end

function modifier_generic_bonus_base_atk:GetTexture()
    return "antimage_spell_shield"
end

function modifier_generic_bonus_base_atk:IsDebuff()
    return false
end

function modifier_generic_bonus_base_atk:IsPurgable()
    return self.is_purgable
end

function modifier_generic_bonus_base_atk:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }

    return funcs
end

function modifier_generic_bonus_base_atk:IsHidden() 
    return self.is_hidden
end

function modifier_generic_bonus_base_atk:GetModifierBaseAttack_BonusDamage()
    return self.bonus_atk
end