function GiveInitialStack( keys )
	local caster = keys.caster
	local ability = keys.ability

	caster.scouts = {}
end

function PlantDrone( keys )
	local caster = keys.caster
	local ability = keys.ability
	if #caster.scouts == ability:GetLevelSpecialValueFor("max_drones", ability:GetLevel() - 1) then
		caster.scouts[1]:RemoveSelf()
		table.remove(caster.scouts, 1)
	end
	local scout = CreateUnitByName("scout_unit", caster:GetCursorPosition(), false, caster, caster, caster:GetTeamNumber())
	scout:SetMaxHealth(ability:GetSpecialValueFor("attack_to_destroy"))
	ability:ApplyDataDrivenModifier(caster, scout, "modifier_drone", {})
	table.insert(caster.scouts, scout)
end

function CheckDeath( keys )
	keys.target:SetHealth(keys.target:GetHealth() - 1)
	if keys.target:GetHealth() == 0 then
		keys.target:Kill(keys.ability, keys.attacker)
	end
end
