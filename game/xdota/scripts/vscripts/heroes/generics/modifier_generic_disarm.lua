if modifier_generic_disarm == nil then
    modifier_generic_disarm = class({})
end

function modifier_generic_disarm:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_generic_disarm:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_disarm:GetTexture()
	return "generic_disarm"
end

function modifier_generic_disarm:IsDebuff()
    return true
end

function modifier_generic_disarm:IsPurgable()
    return self.purgable
end

function modifier_generic_disarm:CheckState()
    local state = {
    [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end

function modifier_generic_disarm:IsHidden() 
    return false
end
