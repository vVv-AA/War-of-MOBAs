if modifier_generic_bonus_atk_speed == nil then
    modifier_generic_bonus_atk_speed = class({})
end

function modifier_generic_bonus_atk_speed:OnCreated( params )
    if IsServer() then
        self.atk_speed = params.atk_speed
        self.is_purgable = params.is_purgable
        self.is_hidden = params.is_hidden
    end
end

function modifier_generic_bonus_atk_speed:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_bonus_atk_speed:IsPassive()
    return true
end

function modifier_generic_bonus_atk_speed:GetTexture()
    return "antimage_spell_shield"
end

function modifier_generic_bonus_atk_speed:IsDebuff()
    return false
end

function modifier_generic_bonus_atk_speed:IsPurgable()
    return self.is_purgable
end

function modifier_generic_bonus_atk_speed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_generic_bonus_atk_speed:IsHidden() 
    return self.is_hidden
end

function modifier_generic_bonus_atk_speed:GetModifierAttackSpeedBonus_Constant()
    return self.atk_speed
end