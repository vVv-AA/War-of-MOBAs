LinkLuaModifier("modifier_reduce_disable_duration", "heroes/generics/modifier_reduce_disable_duration.lua", LUA_MODIFIER_MOTION_NONE)

function ApplyReductionModifier( keys )
	local caster = keys.caster
	local ability = keys.ability
	if caster:HasModifier("modifier_reduce_disable_duration") then
		return
	end
	caster:AddNewModifier(caster, ability, "modifier_reduce_disable_duration", {purgable = false, reductionFactor = ability:GetLevelSpecialValueFor("reductionFactor", ability:GetLevel() - 1)})
end