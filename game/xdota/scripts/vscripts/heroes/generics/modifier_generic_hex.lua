if modifier_generic_hex == nil then
    modifier_generic_hex = class({})
end

function modifier_generic_hex:OnCreated( kv )
    if IsServer() then
        self.movespeed = kv.movespeed
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
        if kv.unique_Identifier ~= nil then
            self.unique_Identifier = kv.unique_Identifier
        else
            self.unique_Identifier = nil
        end
    end
end

function modifier_generic_hex:unique_Identifier()
    return self.unique_Identifier
end

function modifier_generic_hex:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_hex:GetTexture()
    return "generic_hex"
end

function modifier_generic_hex:IsDebuff()
    return true
end

function modifier_generic_hex:IsPurgable()
    return self.modifier_generic_hex
end

function modifier_generic_hex:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
    }

    return funcs
end

function modifier_generic_hex:GetModifierModelChange()
    return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end

function modifier_generic_hex:GetModifierMoveSpeedOverride()
    return self.movespeed
end

function modifier_generic_hex:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_HEXED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_EVADE_DISABLED] = true,
        [MODIFIER_STATE_BLOCK_DISABLED] = true,
        [MODIFIER_STATE_SILENCED] = true
    }

    return state
end

function modifier_generic_hex:IsHidden() 
    return false
end
