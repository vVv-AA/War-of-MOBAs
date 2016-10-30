if modifier_bonus_vision == nil then
    modifier_bonus_vision = class({})
end

function modifier_bonus_vision:OnCreated( kv )  
    if IsServer() then
    	if kv.bonus == nil then
	        self.bonus = self:GetAbility():GetSpecialValueFor("bonus_vison_pct")
	    else
	        self.bonus = kv.bonus
	    end
    end
end

function modifier_bonus_vision:IsHidden()
    return false
end

function modifier_bonus_vision:IsPurgable()
    return false
end

function modifier_bonus_vision:SetBonus(params)
	self.bonus = params
end

function modifier_bonus_vision:GetAttributes() 
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_bonus_vision:DeclareFunctions( params )
	local funcs = {
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
    }
	return funcs
end

function modifier_bonus_vision:GetBonusDayVision( params )
	return self.bonus
end

function modifier_bonus_vision:GetBonusNightVision( params )
	return self.bonus
end

--Credits: DrTeaSpoon