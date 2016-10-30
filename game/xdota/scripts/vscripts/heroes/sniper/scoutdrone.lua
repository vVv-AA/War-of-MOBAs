function GiveInitialStack( keys )
	local caster = keys.caster
	local ability = keys.ability

	caster.scouts = {}
end

function PlantDrone( keys )
	local caster = keys.caster
	local ability = keys.ability

	if #caster.scouts == ability:GetSpecialValueFor("max_drones") then return end
	local scout = CreateUnitByName("scout_unit", caster:GetCursorPosition(), false, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, scout, "modifier_drone", {})
	table.insert(caster.scouts, scout)
end

function CheckDeath( keys )
	local caster = keys.caster
	local target = keys.target
end