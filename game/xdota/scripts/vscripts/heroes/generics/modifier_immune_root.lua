if modifier_immune_root == nil then
    modifier_immune_root = class({})
end
 
 function modifier_immune_root:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_immune_root:GetTexture()
    return "generic_root_immunity"
end

function modifier_immune_root:IsBuff()
    return true
end

function modifier_immune_root:IsHidden()
	return false
end

function modifier_immune_root:IsPurgable()
    return self.purgable
end