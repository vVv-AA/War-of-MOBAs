modifier_generic_banish = class({})
 
--------------------------------------------------------------------------------
 function modifier_generic_banish:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_generic_banish:IsDebuff()
    return true
end

function modifier_generic_banish:GetTexture()
    return "generic_banish"
end

function modifier_generic_banish:IsPurgable()
    return self.purgable
end

function modifier_generic_banish:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
 
--------------------------------------------------------------------------------
 
function modifier_generic_banish:CheckState()
    local state = {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
 
    return state
end