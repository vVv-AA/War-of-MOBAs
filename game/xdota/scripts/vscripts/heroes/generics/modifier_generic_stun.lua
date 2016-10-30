modifier_generic_stun = class({})
 
--------------------------------------------------------------------------------
 function modifier_generic_stun:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_generic_stun:IsDebuff()
    return true
end

function modifier_generic_stun:GetTexture()
    return "generic_stun"
end

function modifier_generic_stun:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
 
function modifier_generic_stun:IsStunDebuff()
    return true
end
 
function modifier_generic_stun:IsPurgable()
    return self.purgable
end

--------------------------------------------------------------------------------
 
function modifier_generic_stun:GetEffectName()
    return "particles/generic_gameplay/generic_stunned.vpcf"
end
 
--------------------------------------------------------------------------------
 
function modifier_generic_stun:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end
 
--------------------------------------------------------------------------------
 
function modifier_generic_stun:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }
 
    return funcs
end
 
--------------------------------------------------------------------------------
 
function modifier_generic_stun:GetOverrideAnimation( params )
    return ACT_DOTA_DISABLED
end
 
--------------------------------------------------------------------------------
 
function modifier_generic_stun:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED] = true,
    }
 
    return state
end