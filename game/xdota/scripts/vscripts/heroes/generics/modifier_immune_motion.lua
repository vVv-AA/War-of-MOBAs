if modifier_immune_motion == nil then
    modifier_immune_motion = class({})
end
 
 function modifier_immune_motion:OnCreated( kv )
    if IsServer() then
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
    end
end

function modifier_immune_motion:GetTexture()
    return "generic_motion_immunity"
end

function modifier_immune_motion:IsBuff()
    return true
end

function modifier_immune_motion:IsHidden()
	return false
end

function modifier_immune_motion:IsPurgable()
    return self.purgable
end