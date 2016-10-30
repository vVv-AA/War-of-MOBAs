if modifier_arcane_bolt_hit_bonus_granted == nil then
    modifier_arcane_bolt_hit_bonus_granted = class({})
end
 
function modifier_arcane_bolt_hit_bonus_granted:IsDebuff()
    return false
end

function modifier_arcane_bolt_hit_bonus_granted:IsHidden()
    return false
end

function modifier_arcane_bolt_hit_bonus_granted:IsPurgable()
    return false
end

function modifier_arcane_bolt_hit_bonus_granted:GetAttributes() 
    return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_arcane_bolt_hit_bonus_granted:OnOwnerDied()
	caster:SetModifierStackCount("modifier_arcane_bolt_hit_bonus_granted", self, 0)
end