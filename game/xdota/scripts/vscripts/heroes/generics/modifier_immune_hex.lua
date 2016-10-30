if modifier_immune_hex == nil then
    modifier_immune_hex = class({})
end
 
 function modifier_immune_hex:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_immune_hex:GetTexture()
    return "generic_hex_immunity"
end

function modifier_immune_hex:IsBuff()
    return true
end

function modifier_immune_hex:IsHidden()
	return false
end

function modifier_immune_hex:IsPurgable()
    return self.purgable
end