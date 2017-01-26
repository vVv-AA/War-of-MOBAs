LinkLuaModifier("modifier_magic_resist", "heroes/generics/modifier_magic_resist.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_bonus_raw_hp", "heroes/generics/modifier_generic_bonus_raw_hp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_bonus_atk_range", "heroes/generics/modifier_generic_bonus_atk_range.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_bonus_base_atk", "heroes/generics/modifier_generic_bonus_base_atk.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_bonus_atk_speed", "heroes/generics/modifier_generic_bonus_atk_speed.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_bonus_ms_pct", "heroes/generics/modifier_generic_bonus_ms_pct.lua", LUA_MODIFIER_MOTION_NONE)

function GetTalentSpecialValueFor(ability, value)
    local base = ability:GetSpecialValueFor(value)
    local talentName
    local kv = ability:GetAbilityKeyValues()
    for k,v in pairs(kv) do -- trawl through keyvalues
        if k == "AbilitySpecial" then
            for l,m in pairs(v) do
                if m[value] then
                    talentName = m["LinkedSpecialBonus"]
                end
            end
        end
    end
    if talentName then
        local talent = ability:GetCaster():FindAbilityByName(talentName)
        if talent and talent:GetLevel() > 0 then
            base = base + talent:GetSpecialValueFor(value)
        end
    end
    return base
end

function GetTalentLevelSpecialValueFor(ability, value, level)
    local base = ability:GetLevelSpecialValueFor(value, level - 1)
    local talentName
    local kv = ability:GetAbilityKeyValues()
    for k,v in pairs(kv) do -- trawl through keyvalues
        if k == "AbilitySpecial" then
            for l,m in pairs(v) do
                if m[value] then
                    talentName = m["LinkedSpecialBonus"]
                end
            end
        end
    end
    if talentName then
        local talent = ability:GetCaster():FindAbilityByName(talentName)
        if talent and talent:GetLevel() > 0 then
            base = base + talent:GetSpecialValueFor(value)
        end
    end
    return base
end


function Upgrade( hero, ability )
    local ability_name = ability:GetAbilityName()
    if ability_name == "special_bonus_unique_artemis_proprioception" then
        hero:FindAbilityByName("artemis_proprioception_datadriven"):SetLevel(1)
    elseif ability_name == "special_bonus_unique_beast_master_give_other_ult" then
        hero:RemoveAbility("tough_exterior")
        local boar_hoard_ability = hero:FindAbilityByName("boar_hoard_datadriven")
        local primal_roar_ability = hero:FindAbilityByName("primal_roar_datadriven")
        local boar_hoard_ability = boar_hoard_ability:GetLevel()
        local primal_roar_ability = primal_roar_ability:GetLevel()
        hero.override_onupgrade = true
        boar_hoard_ability:SetLevel(3)
        primal_roar_ability:SetLevel(3)
        hero.override_onupgrade = nil
    elseif ability_name == "special_bonus_unique_beast_master_tough_exterior" then
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
        hero:UpgradeAbility(hero:FindAbilityByName("tough_exterior"))
    elseif ability_name == "special_bonus_unique_betrayer_never_ending_hatred" then
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
        hero:UpgradeAbility(hero:FindAbilityByName("betrayer_never_ending_hatred_datadriven"))
    elseif ability_name == "special_bonus_unique_betrayer_betray" then
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
        hero:UpgradeAbility(hero:FindAbilityByName("betrayer_betray_datadriven"))
    elseif ability_name == "special_bonus_unique_betrayer_marked_for_death" then
        hero:FindAbilityByName("betrayer_dive_datadriven"):ApplyDataDrivenModifier(hero, hero, "modifier_marked_for_death", {})
    elseif ability_name == "special_bonus_unique_betrayer_permanent_immolation" then
        ability = hero:FindAbilityByName("betrayer_sweeping_strike_datadriven")
        ability:ApplyDataDrivenModifier(hero, hero, "modifier_permanent_immolation", {})
    elseif ability_name == "special_bonus_unique_wrap_strike" then
        hero:FindAbilityByName("gun_runner_wrap_strike_datadriven"):SetLevel(1)
    elseif ability_name == "special_bonus_unique_dwarf_king_tough_exterior" then
        hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
        hero:UpgradeAbility()
    elseif ability_name == "special_bonus_unique_omni_unbreakable_fortitude" then
        hero:FindAbilityByName("unbreakable_fortitude"):SetLevel(1)
    elseif ability_name == "special_bonus_unique_omni_sacred_duty_datadriven" then
        hero:FindAbilityByName("sacred_duty_datadriven"):SetLevel(1)
    elseif ability_name == "special_bonus_unique_omni_sacred_duty_datadriven_copy" then
        hero:FindAbilityByName("sacred_duty_datadriven"):SetLevel(1)
    elseif ability_name == "special_bonus_unique_vylanas_aoe_stifling_daggers" then
        local old_ability = hero:FindAbilityByName("dark_ranger_stifling_dagger_single_target")
        hero:AddAbility("dark_ranger_stifling_daggers")
        hero:SwapAbilities("dark_ranger_stifling_daggers", "dark_ranger_stifling_dagger_single_target", true, false)
        hero:FindAbilityByName("dark_ranger_stifling_daggers"):SetLevel(hero:FindAbilityByName("dark_ranger_stifling_dagger_single_target"):GetLevel())
        hero:RemoveAbility("dark_ranger_stifling_dagger_single_target")
    elseif ability_name == "special_bonus_unique_vylanas_will_of_the_dead" then
        hero:FindAbilityByName("dark_ranger_will_of_the_dead"):SetLevel(1)
    elseif ability_name == "special_bonus_unique_vylanas_will_of_the_dead_copy" then
        hero:FindAbilityByName("dark_ranger_will_of_the_dead"):SetLevel(1)

        -- Modifier handling part from here on

    elseif ability_name == "special_bonus_unique_betrayer_30_magic_resistance" then
        hero:AddNewModifier(hero, ability, "modifier_magic_resist", {magic_resist = 30, is_purgable = false, is_hidden = false})
    elseif ability_name == "special_bonus_unique_bonus_200_health" then
        hero:AddNewModifier(hero, ability, "modifier_generic_bonus_raw_hp", {bonus_hp = 200, is_purgable = false, is_hidden = false})
    elseif ability_name == "special_bonus_unique_bonus_150_attack_range_datadriven" then
        hero:AddNewModifier(hero, ability, "modifier_generic_bonus_atk_range", {bonus_hp = 150, is_purgable = false, is_hidden = true})
    elseif ability_name == "special_bonus_unique_bonus_40_attack_damage_datadriven" then
        hero:AddNewModifier(hero, ability, "modifier_generic_bonus_base_atk", {bonus_atk = 40, is_purgable = false, is_hidden = false})
    elseif ability_name == "special_bonus_unique_bonus_60_atk_speed_datadriven" then
        hero:AddNewModifier(hero, ability, "modifier_generic_bonus_atk_speed", {atk_speed = 60, is_purgable = false, is_hidden = false})
    elseif ability_name == "special_bonus_unique_bonus_120_atk_speed_datadriven" then
        hero:AddNewModifier(hero, ability, "modifier_generic_bonus_atk_speed", {atk_speed = 120, is_purgable = false, is_hidden = false})
    elseif ability_name == "special_bonus_unique_bonus_move_speed_pct_20_datadriven" then
        hero:AddNewModifier(hero, ability, "modifier_generic_bonus_ms_pct", {ms = 120, is_purgable = false, is_hidden = false})

    end
end