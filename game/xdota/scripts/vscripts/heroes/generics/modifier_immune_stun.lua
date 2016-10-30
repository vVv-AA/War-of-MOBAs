if modifier_immune_stun == nil then
    modifier_immune_stun = class({})
end
 
 function modifier_immune_stun:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_immune_stun:GetTexture()
    return "generic_stun_immunity"
end

function modifier_immune_stun:IsBuff()
    return true
end

function modifier_immune_stun:IsHidden()
	return false
end

function modifier_immune_stun:IsPurgable()
    return self.purgable
end