function ApplyMods( event )
	local caster = event.caster
	local ability = event.ability
	local bear = caster.bear
	
	EmitSoundOn("Hero_LoneDruid.Rabid", caster)
	EmitSoundOn("Hero_LoneDruid.BattleCry", caster)
    caster.particles = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(caster.particles, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(caster.particles, 1, caster:GetAbsOrigin())
	caster.particle_overhead = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_battle_cry_overhead.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	local loc = caster:GetAbsOrigin()
	loc.z = loc.z + 150
	ParticleManager:SetParticleControlEnt(caster.particle_overhead, 0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", loc, true)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_roar_bonus_base_damage", {})

	if bear ~= nil and bear:IsAlive() then
		if bear:GetModelName() == "models/items/lone_druid/true_form/rabid_black_bear/rabid_black_bear.vmdl" then
			bear:StartGesture(ACT_DOTA_LOADOUT_RARE)
		else
			bear:StartGesture(ACT_DOTA_ATTACK2)
		end
		EmitSoundOn("Hero_LoneDruid.Rabid", bear)
		EmitSoundOn("Hero_LoneDruid.BattleCry", bear)
	    bear.particles = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", PATTACH_CUSTOMORIGIN, nil)
	    ParticleManager:SetParticleControl(bear.particles, 0, bear:GetAbsOrigin())
	    ParticleManager:SetParticleControl(bear.particles, 1, bear:GetAbsOrigin())
		bear.particle_overhead = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_battle_cry_overhead.vpcf", PATTACH_ABSORIGIN_FOLLOW, bear)
		local loc = bear:GetAbsOrigin()
		loc.z = loc.z + 150
		ParticleManager:SetParticleControlEnt(bear.particle_overhead, 0, bear, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", loc, true)
		ability:ApplyDataDrivenModifier(caster, bear, "modifier_roar_bonus_base_damage", {})
	end
end

function RemoveParticles( event )
	local caster = event.caster
	local bear = caster.bear
	if caster.particle_overhead ~= nil then
		ParticleManager:DestroyParticle(caster.particle_overhead,false)
		ParticleManager:ReleaseParticleIndex( caster.particle_overhead )
	end

	if bear == nil then return end
	if bear.particle_overhead ~= nil then
		ParticleManager:DestroyParticle(bear.particle_overhead,false)
		ParticleManager:ReleaseParticleIndex( bear.particle_overhead )
	end
end