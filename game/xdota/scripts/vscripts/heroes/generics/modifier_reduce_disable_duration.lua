if modifier_reduce_disable_duration == nil then
    modifier_reduce_disable_duration = class({})
end
 
 function modifier_reduce_disable_duration:OnCreated( kv )
    if IsServer() then
        if kv ~= nil then
            self.purgable = kv.purgable
            self.reductionFactor = kv.reductionFactor
        else
            self.purgable = true
            self.reductionFactor = 1
        end
    end
end

function modifier_reduce_disable_duration:GetAttributes() 
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_reduce_disable_duration:GetTexture()
    return "meta_reduce_disables"
end

function modifier_reduce_disable_duration:IsPermanent()
    return true
end

function modifier_reduce_disable_duration:IsBuff()
    return true
end

function modifier_reduce_disable_duration:IsHidden()
	return false
end

function modifier_reduce_disable_duration:IsPurgable()
    return self.purgable
end