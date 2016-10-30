LinkLuaModifier("modifier_raven_form", "heroes/oracle/modifier_raven_form.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_no_mod", "heroes/generics/modifier_generic_no_mod.lua", LUA_MODIFIER_MOTION_NONE)

require("heroes/generics/Disables")

function AddUpgrades( keys )
	local caster = keys.caster
	local ability = keys.ability

	if ability:GetLevel() == 2 then
		caster:GetAbilityByIndex(1):SetLevel(1)
	end
end

function Transform( keys )
	local caster = keys.caster
	local ability = keys.ability

	if caster:HasModifier("modifier_raven_form") then
		caster:RemoveModifierByName("modifier_raven_form")
		caster:RemoveModifierByName("modifier_generic_no_mod")
		caster:RemoveModifierByName("modifier_move_speed_bonus_pct")
		caster:RemoveModifierByName("modifier_generic_disarm")
	else
		--caster:AddNewModifier(caster, ability, "modifier_generic_no_mod", {purgable = false})
		local params = 
		{
			caster = caster,
			ability = ability,
			target = caster,
			bypass = "true",
			purgable = false,
		}
		ApplyDisarm(params)
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_move_speed_bonus_pct", {})	
		caster:AddNewModifier(caster, ability, "modifier_raven_form", {purgable = false})
		-- Add perma linken mod	
	end
end