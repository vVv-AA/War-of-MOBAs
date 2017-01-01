function Init( keys )
	local caster = keys.caster
	if caster.raised_units == nil then
		caster.raised_units = 0
	end
end

function Raise( keys )
	local caster = keys.caster
	if caster.raised_units == keys.ability:GetSpecialValueFor("max_raised_unit") then return end
	if keys.unit:HasModifier("modifier_raised") or keys.unit:IsAncient() then return end

	local unit = CreateUnitByName(keys.unit:GetUnitName(), keys.unit:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	keys.ability:ApplyDataDrivenModifier(unit, unit, "modifier_raised", {})
	caster.raised_units = caster.raised_units + 1
end

function Decrease( keys )
	keys.caster:GetOwner().raised_units = keys.caster:GetOwner().raised_units - 1
end