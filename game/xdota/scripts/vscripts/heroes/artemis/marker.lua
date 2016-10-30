function ApplyRevelOverhead( keys )
	local caster = keys.caster
	local ability = keys.ability

	local nFXIndex = ParticleManager:CreateParticleForTeam( "particles/test_particle/artemis_mark.vpcf", PATTACH_CUSTOMORIGIN, nil, caster:GetTeamNumber())
	keys.target.nFXIndex = nFXIndex
	keys.target.unit = CreateUnitByName("fog_unit", keys.target:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())
	keys.target.unit:AddNoDraw()
	local par_loc = keys.target:GetAbsOrigin()
	keys.target.unit:SetAbsOrigin(keys.target:GetAbsOrigin())
	par_loc.z = par_loc.z + 150
	ParticleManager:SetParticleControlEnt(nFXIndex, 0, keys.target.unit, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", par_loc, true)
end

function DestroyOverhead( keys )
	keys.target.unit:ForceKill(true)
	ParticleManager:DestroyParticle(keys.target.nFXIndex,false)
	ParticleManager:ReleaseParticleIndex( keys.target.nFXIndex )
end

function Update( keys )
	local target = keys.target
	local par_loc = keys.target:GetAbsOrigin()
	keys.target.unit:SetAbsOrigin(par_loc)
end
