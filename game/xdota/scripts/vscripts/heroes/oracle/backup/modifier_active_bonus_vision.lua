if modifier_active_bonus_vision == nil then
    modifier_active_bonus_vision = class({})
end

function modifier_active_bonus_vision:OnCreated( kv )  
    if IsServer() then
        self.bonus = kv.bonus
    end
end

function modifier_active_bonus_vision:IsPassive()
    return true
end

function modifier_active_bonus_vision:IsHidden()
    return false
end

function modifier_active_bonus_vision:IsPurgable()
    return false
end

function modifier_active_bonus_vision:GetAttributes() 
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_active_bonus_vision:DeclareFunctions( params )
	local funcs = {
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
    }
	return funcs
end

function modifier_active_bonus_vision:GetBonusVisionPercentage( params )
	return self.bonus
end

--Credits: DrTeaSpoon