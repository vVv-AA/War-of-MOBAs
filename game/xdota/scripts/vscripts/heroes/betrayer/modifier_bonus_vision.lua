if modifer_bonus_vision == nil then
    modifer_bonus_vision = class({})
end

function modifer_bonus_vision:OnCreated( kv )  
    if IsServer() then
        self.bonus = self:GetAbility():GetSpecialValueFor("bonus_vison_pct")
    end
end

function modifer_bonus_vision:IsHidden()
    return false
end

function modifer_bonus_vision:IsPurgable()
    return false
end

function modifer_bonus_vision:GetAttributes() 
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifer_bonus_vision:DeclareFunctions( params )
	local funcs = {
        MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
    }
	return funcs
end

function modifer_bonus_vision:GetBonusVisionPercentage( params )
	return self.bonus
end

--Credits: DrTeaSpoon