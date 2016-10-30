--[[ ============================================================================================================
	Author: Rook
	Date: February 16, 2015
	Called when Portal's cast point begins.  Starts the particle effect and sound.
	Additional parameters: keys.CastPoint
================================================================================================================= ]]
function UpOtherPortal( keys )
	local caster = keys.caster
	caster:FindAbilityByName("portal_second_end_datadriven"):SetLevel(keys.ability:GetLevel())
end
function Null( keys )
	local caster = keys.caster
	if caster == caster:GetOwner().first_end_portal then caster:GetOwner().first_end_portal = nil end
	if caster == caster:GetOwner().second_end_portal then caster:GetOwner().second_end_portal = nil end
	-- body
end
function Applier(keys)
	if keys.target:HasModifier("modifier_teleporting") or keys.target:HasModifier("modifier_just_teleported") then return end

	if keys.caster:GetOwner().first_end_portal == nil or keys.caster:GetOwner().second_end_portal == nil then
		return
	end

	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.target, "modifier_teleporting", {duration = 1.8})
	keys.target:SetAbsOrigin(keys.caster:GetAbsOrigin())
end
function CreateOneEnd(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetCursorPosition()
	local unit = CreateUnitByName("portal_unit", point, true, caster, caster, caster:GetTeamNumber())
	if caster.first_end_portal ~= nil then
		if caster.first_end_portal:IsNull() == false then
			caster.first_end_portal:ForceKill(true)
		end
	end
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_portal_teleporter", {})
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_portal_particles", {})
	unit:AddNewModifier(unit, nil, "modifier_kill", {duration = ability:GetDuration()})
	caster.first_end_portal = unit
end

function CreateOtherEnd(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetCursorPosition()
	local unit = CreateUnitByName("portal_unit", point, true, caster, caster, caster:GetTeamNumber())
	if caster.second_end_portal ~= nil then
		if caster.second_end_portal:IsNull() == false then
			caster.second_end_portal:ForceKill(true)
		end
	end
	
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_portal_teleporter", {})
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_portal_particles", {})
	unit:AddNewModifier(unit, nil, "modifier_kill", {duration = ability:GetDuration()})
	caster.second_end_portal = unit
end

function Channeling(keys)
	if keys.target:HasModifier("modifier_just_teleported") then return end

	if keys.caster:GetOwner().first_end_portal == nil or keys.caster:GetOwner().second_end_portal == nil then return end

	if keys.caster:GetOwner().first_end_portal:IsAlive() == false then
		keys.caster:GetOwner().first_end_portal = nil
	end

	if keys.caster:GetOwner().second_end_portal:IsAlive() == false then
		keys.caster:GetOwner().second_end_portal = nil
	end

	if keys.caster:GetOwner().first_end_portal == nil or keys.caster:GetOwner().second_end_portal == nil then return end

	local ability = keys.ability
	local target_origin = keys.target:GetAbsOrigin()
	local distance_to_target = keys.caster:GetRangeToUnit(keys.target)

	local portal_particle_effect = ParticleManager:CreateParticle("particles/test_particle/lone_druid_true_form.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
	ParticleManager:SetParticleControlEnt(portal_particle_effect, 0, keys.target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(portal_particle_effect, 1, keys.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(portal_particle_effect, 2, keys.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(portal_particle_effect, 3, keys.caster:GetAbsOrigin())
	end

function Teleport( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability

	if caster == caster:GetOwner().first_end_portal then
		if caster:GetOwner().second_end_portal ~= nil and caster:GetOwner().second_end_portal:IsAlive() then
			local loc = caster:GetOwner().second_end_portal:GetAbsOrigin()
			target:SetAbsOrigin(loc)
			--ability:ApplyDataDrivenModifier(caster, target, "modifier_just_teleported", {duration = 0.5})
		end
	elseif caster == caster:GetOwner().second_end_portal then
		if caster:GetOwner().first_end_portal ~= nil and caster:GetOwner().first_end_portal:IsAlive() then
			local loc = caster:GetOwner().first_end_portal:GetAbsOrigin()
			target:SetAbsOrigin(loc)
			--ability:ApplyDataDrivenModifier(caster, target, "modifier_just_teleported", {duration = 0.5})
		end
	end
	keys.target:EmitSound("Hero_Meepo.Poof.Channel")
	-- body
end