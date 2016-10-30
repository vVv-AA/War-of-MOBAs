if modifier_immune_banish == nil then
    modifier_immune_banish = class({})
end
 
 function modifier_immune_banish:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_immune_banish:GetTexture()
    return "generic_banish_immunity"
end

function modifier_immune_banish:IsBuff()
    return true
end

function modifier_immune_banish:IsHidden()
	return false
end

function modifier_immune_banish:IsPurgable()
    return self.purgable
end