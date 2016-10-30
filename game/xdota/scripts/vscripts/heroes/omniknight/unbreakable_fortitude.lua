LinkLuaModifier( "soul_modifier", "heroes/omniknight/unbreakable_fortitude.lua", LUA_MODIFIER_MOTION_NONE )

function SpawnIllusion( keys )
	local caster = keys.unit
	print(caster.isIllu)
	if (caster.isIllu) then return end
	local spawn_location = caster:GetOrigin()
	local duration = keys.caster:GetTimeUntilRespawn()
	local soul_unit = CreateUnitByName( caster:GetUnitName(), spawn_location, true, caster, nil, caster:GetTeamNumber())
	soul_unit.isIllu = true
	soul_unit:SetControllableByPlayer(caster:GetPlayerID(), false)
	soul_unit:SetPlayerID(caster:GetPlayerID())
	soul_unit:SetRespawnsDisabled(true)
	soul_unit:AddNewModifier(caster, ability, "soul_modifier", nil)
	caster.soul_unit = soul_unit
	local caster_level = caster:GetLevel()
	for i = 2, caster_level do
		soul_unit:HeroLevelUp(false)
	end

	for ability_id = 0, 15 do
		local ability = soul_unit:GetAbilityByIndex(ability_id)
		if ability then
			ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())
		end
	end

	for item_id = 0, 5 do
		local item_in_caster = caster:GetItemInSlot(item_id)
		if item_in_caster ~= nil then
			local item_name = item_in_caster:GetName()
			if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_recipe_refresher" or item_name == "item_refresher" or item_name == "item_ward_observer" or item_name == "item_ward_sentry") then
				local item_created = CreateItem( item_in_caster:GetName(), soul_unit, soul_unit)
				soul_unit:AddItem(item_created)
				item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges()) 
				item_created:EndCooldown()
				item_created:StartCooldown(item_in_caster:GetCooldownTimeRemaining())
			end
		end
	end

	soul_unit:SetMaximumGoldBounty(0)
	soul_unit:SetMinimumGoldBounty(0)
	soul_unit:SetDeathXP(0)
	soul_unit:SetAbilityPoints(0) 

	soul_unit:SetHasInventory(false)
	soul_unit:SetCanSellItems(false)
end

function DestoryIllusion( keys )
	local caster = keys.caster
	if not caster.soul_unit:IsNull() and caster.soul_unit ~= nil and caster.soul_unit:IsAlive() then
		caster:SetAbsOrigin(caster.soul_unit:GetAbsOrigin())
		caster.soul_unit:ForceKill(true)
		UTIL_Remove(caster.soul_unit)
		caster.soul_unit = nil
	end
end

if soul_modifier == nil then
	soul_modifier = class({})
end

function soul_modifier:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SUPER_ILLUSION,
	}
end

function soul_modifier:GetModifierSuperIllusion()
	return true
end


function soul_modifier:GetStatusEffectName()
	return "particles/status_fx/status_effect_phantom_lancer_illstrong.vpcf"
end

function soul_modifier:IsHidden()
	return true
end

function soul_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end