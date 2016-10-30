LinkLuaModifier("hex_polybomb", "heroes/oracle/hex_polybomb.lua", LUA_MODIFIER_MOTION_NONE)

function Hex( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	target:AddNewModifier(caster, ability, "hex_polybomb", {duration = ability:GetDuration(), purgable = false, movespeed = ability:GetSpecialValueFor("move_speed_mod"), uniqueID = DoUniqueString(caster:GetUnitName()..""..GameRules:GetGameTime().."")})
end