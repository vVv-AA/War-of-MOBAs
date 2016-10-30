if modifier_immune_disarm == nil then
    modifier_immune_disarm = class({})
end
 
 function modifier_immune_disarm:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_immune_disarm:GetTexture()
    return "generic_disarm_immunity"
end

function modifier_immune_disarm:IsBuff()
    return true
end

function modifier_immune_disarm:IsHidden()
	return false
end

function modifier_immune_disarm:IsPurgable()
    return self.purgable
end