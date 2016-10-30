if modifier_inner_vitality_dwarf_king == nil then
    modifier_inner_vitality_dwarf_king = class({})
end

--[[
    Author: Bude
    Date: 30.09.2015.
    Checks target health every interval and adjusts health regen accordingly
]]--

function modifier_inner_vitality_dwarf_king:IsBuff()
    return 1
end

function modifier_inner_vitality_dwarf_king:OnCreated()
    self.inner_vitality_heal = self:GetAbility():GetSpecialValueFor( "base_hp_regen" )
    self.inner_vitality_hurt_heal = self.inner_vitality_heal*self:GetAbility():GetSpecialValueFor("hurt_additive")
    self.inner_vitality_hurt_percent = self:GetAbility():GetSpecialValueFor("hurt_percent")
    self.heal_amount = 0

    if IsServer() then
        self:GetParent():CalculateStatBonus()
        self:StartIntervalThink(0.1)
    end
end

function modifier_inner_vitality_dwarf_king:OnIntervalThink()
    if IsServer() then
        -- Variables
        local target = self:GetParent()
        local flat_heal = self.inner_vitality_heal
        local hurt_perc = self.inner_vitality_hurt_percent
        local health_perc = target:GetHealthPercent()/100

        local bonus_heal = 0

        -- calculate the bonus health depending on the targets health
        if health_perc <= hurt_perc then
            bonus_heal = self.inner_vitality_hurt_heal   
        end


        local heal = (flat_heal + bonus_heal)
        
        if self.heal_amount and self.heal_amount ~= heal then
            self.heal_amount = heal
        end
    end
end

function modifier_inner_vitality_dwarf_king:OnRefresh()
    self.inner_vitality_heal = self:GetAbility():GetSpecialValueFor( "heal" )
    self.inner_vitality_hurt_heal = self.inner_vitality_heal*self:GetAbility():GetSpecialValueFor("hurt_additive")
    self.inner_vitality_hurt_percent = self:GetAbility():GetSpecialValueFor("hurt_percent")

    if IsServer() then
        self:GetParent():CalculateStatBonus()
    end
end

function modifier_inner_vitality_dwarf_king:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }

    return funcs
end

function modifier_inner_vitality_dwarf_king:GetModifierConstantHealthRegen( params )
    return self.heal_amount
end
