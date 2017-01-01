if modifier_rabid == nil then
    modifier_rabid = class({})
end

function modifier_rabid:IsDebuff()
    return false
end

function modifier_rabid:IsHidden()
    return true
end

function modifier_rabid:IsPurgable()
    return false
end

function modifier_rabid:GetAttributes() 
    return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_rabid:GetTexture()
    return "misha_rabid"
end
