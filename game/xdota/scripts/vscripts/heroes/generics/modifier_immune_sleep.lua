if modifier_immune_sleep == nil then
    modifier_immune_sleep = class({})
end
 
 function modifier_immune_sleep:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_immune_sleep:GetTexture()
    return "generic_cyclone_immunity"
end

function modifier_immune_sleep:IsBuff()
    return true
end

function modifier_immune_sleep:IsHidden()
	return false
end

function modifier_immune_sleep:IsPurgable()
    return self.purgable
end