if modifier_meta_model == nil then
    modifier_meta_model = class({})
end

function modifier_meta_model:OnCreated( kv )
    if IsServer() then
    	self.hero_count = self:GetAbility().hero_count
        self.purgable = kv.purgable
        self.atk_speed = self:GetAbility():GetLevelSpecialValueFor("bonus_attack_speed", self:GetAbility():GetLevel() - 1)
        self.hp_bonus = self:GetAbility():GetLevelSpecialValueFor("health_bonus", self:GetAbility():GetLevel() - 1)*self.hero_count
        self.bonus_base_dmg = self:GetAbility():GetLevelSpecialValueFor("bonus_damage", self:GetAbility():GetLevel() - 1)
    end
end

function modifier_meta_model:IsPurgable()
    return self.purgable
end

function modifier_meta_model:GetEffectName()
    return "particles/test_particle/metamorphosis_buff.vpcf"
end

function modifier_meta_model:GetEffectAttachType()
    return "follow_origin"
end

function modifier_meta_model:DeclareFunctions()
    --        MODIFIER_PROPERTY_MODEL_CHANGE,
    local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }

    return funcs
end

function modifier_meta_model:GetAttributes() 
    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_meta_model:GetModifierModelChange()
    return "models/items/terrorblade/marauders_demon/marauders_demon.vmdl"
end

function modifier_meta_model:IsPermanent()
    return true
end
function modifier_meta_model:IsHidden() 
    return false
end

function modifier_meta_model:AllowIllusionDuplicate()
	return true
end

function modifier_meta_model:GetModifierAttackSpeedBonus_Constant()
	return self.atk_speed
end

function modifier_meta_model:GetModifierHealthBonus()
	return self.hp_bonus
end

function modifier_meta_model:GetModifierBaseAttack_BonusDamage()
	return self.bonus_base_dmg
end