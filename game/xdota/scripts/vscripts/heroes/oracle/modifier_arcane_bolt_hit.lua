if modifier_arcane_bolt_hit == nil then
    modifier_arcane_bolt_hit = class({})
end
 
function modifier_arcane_bolt_hit:IsDebuff()
    return false
end

function modifier_arcane_bolt_hit:IsHidden()
    return false
end

function modifier_arcane_bolt_hit:IsPurgable()
    return false
end

function modifier_arcane_bolt_hit:GetAttributes() 
    return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_arcane_bolt_hit:OnOwnerDied()
	caster:SetModifierStackCount("modifier_arcane_bolt_hit", self, 0)
end