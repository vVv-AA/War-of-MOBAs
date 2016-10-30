if modifier_generic_no_mod == nil then
    modifier_generic_no_mod = class({})
end

function modifier_generic_no_mod:GetTexture()
    return "generic_no_mod"
end

function modifier_generic_no_mod:IsDebuff()
    return false
end

function modifier_generic_no_mod:IsPurgable()
    return self.modifier_generic_no_mod
end

function modifier_generic_no_mod:IsHidden() 
    return false
end


function modifier_generic_no_mod:DeclareFunctions(kv)
	local funcs = {
		MODIFIER_PROPERTY_ABSORB_SPELL,
		MODIFIER_PROPERTY_AVOID_SPELL,
	}
	return funcs
end

function modifier_generic_no_mod:GetAbsorbSpell(kv)
    return true
end

function modifier_generic_no_mod:GetModifierAvoidSpell(kv)
    return true
end

function modifier_generic_no_mod:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end