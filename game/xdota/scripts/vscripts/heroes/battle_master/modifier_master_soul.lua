if modifier_master_soul == nil then
    modifier_master_soul = class({})
end

function modifier_master_soul:OnCreated(kv)
	if IsServer() == false then return end
	self:GetParent():SetRangedProjectileName("particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf")
	self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
	self:GetParent():SwapAbilities("battle_lust_melee_old_datadriven", "battle_lust_ranged_old_datadriven", false, true)
	self:GetParent():RemoveModifierByName("modifier_sound_fix")
end

function modifier_master_soul:OnDestroy()
	if IsServer() == false then return end
	self:GetParent():SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
	self:GetParent():SwapAbilities("battle_lust_ranged_old_datadriven", "battle_lust_melee_old_datadriven", false, true)
	self:GetAbility():ApplyDataDrivenModifier(self:GetParent(), self:GetParent(), "modifier_sound_fix", {})
end

function modifier_master_soul:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
end

function modifier_master_soul:IsDebuff()
    return false
end

function modifier_master_soul:IsHidden()
    return false
end

function modifier_master_soul:IsPurgable()
    return false
end

function modifier_master_soul:GetModifierModelScale()
	return 10
end

function modifier_master_soul:GetModifierHealthBonus()
	return 550
end
function modifier_master_soul:GetModifierAttackRangeBonus()
	return 350
end