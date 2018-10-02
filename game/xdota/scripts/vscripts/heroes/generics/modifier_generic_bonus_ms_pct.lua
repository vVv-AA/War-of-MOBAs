if modifier_generic_bonus_ms_pct == nil then
    modifier_generic_bonus_ms_pct = class({})
end

function modifier_generic_bonus_ms_pct:OnCreated( params )
    if IsServer() then
        self.ms = params.ms
        self.is_purgable = params.is_purgable
        self.is_hidden = params.is_hidden
    end
end

function modifier_generic_bonus_ms_pct:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_bonus_ms_pct:IsPassive()
    return true
end

function modifier_generic_bonus_ms_pct:GetTexture()
    return "move_speed_bonus"
end

function modifier_generic_bonus_ms_pct:IsDebuff()
    return false
end

function modifier_generic_bonus_ms_pct:IsPurgable()
    return self.is_purgable
end

function modifier_generic_bonus_ms_pct:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    }

    return funcs
end

function modifier_generic_bonus_ms_pct:IsHidden() 
    return self.is_hidden
end

function modifier_generic_bonus_ms_pct:GetModifierAttackRangeBonus()
    return self.ms
end