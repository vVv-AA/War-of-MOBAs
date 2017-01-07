if modifier_raven_form == nil then
    modifier_raven_form = class({})
end

function modifier_raven_form:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
    }
    return funcs
end

function modifier_raven_form:GetModifierModelChange()
    return "models/props_gameplay/roquelaire/roquelaire.vmdl"
end

function modifier_raven_form:IsHidden() 
    return false
end

function modifier_raven_form:GetAttributes() 
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_raven_form:AllowIllusionDuplicate()
	return true
end

function modifier_raven_form:CheckState()
    local state = {
        [MODIFIER_STATE_FLYING] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return state
end

function modifier_raven_form:IsPurgable()
    return false
end