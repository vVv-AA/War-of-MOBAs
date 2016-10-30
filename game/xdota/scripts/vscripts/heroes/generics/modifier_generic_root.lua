modifier_generic_root = class({})
 
--------------------------------------------------------------------------------
 function modifier_generic_root:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_generic_root:IsDebuff()
    return true
end

function modifier_generic_root:GetTexture()
    return "generic_root"
end

function modifier_generic_root:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
 
function modifier_generic_root:IsPurgable()
    return self.purgable
end

--------------------------------------------------------------------------------
 
function modifier_generic_root:CheckState()
    local state = {
	    [MODIFIER_STATE_ROOTED] = true,
	    [MODIFIER_STATE_INVISIBLE] = false,
    }
 
    return state
end