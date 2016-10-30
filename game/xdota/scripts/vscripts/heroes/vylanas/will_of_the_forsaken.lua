function Respawn( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster:RemoveNoDraw()
	caster:SetHealth(caster:GetMaxHealth()*ability:GetLevelSpecialValueFor("respawn_health_mana_pct", ability:GetLevel() - 1))
	caster:SetMana(caster:GetMaxMana()*ability:GetLevelSpecialValueFor("respawn_health_mana_pct", ability:GetLevel() - 1))
	caster:SetBuyBackDisabledByReapersScythe(true)
	caster.respawn_unit:ForceKill(true)
end

function Die( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster:StartGesture(ACT_DOTA_DIE)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_die", {duration = ability:GetSpecialValueFor("respawn_delay")})
	caster.respawn_unit = CreateUnitByName("fog_unit", caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(caster, caster.respawn_unit, "modifier_particle_wotf", {duration = ability:GetSpecialValueFor("respawn_delay")})
	Timers:CreateTimer(3, function ()
		caster:AddNoDraw()
	end)
end