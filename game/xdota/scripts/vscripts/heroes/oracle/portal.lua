function CreatePortals( keys )
	local caster = keys.caster
	local ability = keys.ability
	local point = caster:GetCursorPosition()
	if caster.first_end_portal ~= nil and caster.first_end_portal:IsNull() == false and caster.first_end_portal:IsAlive() then
		caster.first_end_portal:AddNoDraw()
		caster.first_end_portal:ForceKill(true)
	end

	if caster.second_end_portal ~= nil and caster.second_end_portal:IsNull() == false and caster.second_end_portal:IsAlive() then
		caster.second_end_portal:AddNoDraw()
		caster.second_end_portal:ForceKill(true)
	end

	local unit = CreateUnitByName("portal_unit", point, true, caster, caster, caster:GetTeamNumber())
	unit:FindAbilityByName("portal_passive"):SetLevel(ability:GetLevel())
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_portal_teleport_aura", {})
	caster.first_end_portal = unit
	keys.point = caster:GetAbsOrigin() + (point - caster:GetAbsOrigin()):Normalized() * 100
	caster.first_end_portal.portal_particle = ParticleManager:CreateParticle("particles/test_particle/teleport_end_bots.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.first_end_portal)
	CreateOtherEnd(keys)
end

function CreateOtherEnd(keys)
	local caster = keys.caster
	local ability = keys.ability
	local point = keys.point

	local unit = CreateUnitByName("portal_unit", point, true, caster, caster, caster:GetTeamNumber())
	unit:FindAbilityByName("portal_passive"):SetLevel(ability:GetLevel())
	ability:ApplyDataDrivenModifier(unit, unit, "modifier_portal_teleport_aura", {})
	caster.second_end_portal = unit

	local particleName = "particles/test_particle/lion_spell_mana_drain.vpcf"
	caster.first_end_portal.LifeDrainParticle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster.first_end_portal)
	ParticleManager:SetParticleControlEnt(caster.first_end_portal.LifeDrainParticle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	caster.second_end_portal.portal_particle = ParticleManager:CreateParticle("particles/test_particle/teleport_end_bots.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.second_end_portal)
end

function Teleport( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability

	if caster == caster:GetOwner().first_end_portal then
		if caster:GetOwner().second_end_portal ~= nil and caster:GetOwner().second_end_portal:IsAlive() then
			local loc = caster:GetOwner().second_end_portal:GetAbsOrigin()
			loc = loc + (loc - caster:GetAbsOrigin()):Normalized() * 100
			FindClearSpaceForUnit(target, loc, true)
		end
	elseif caster == caster:GetOwner().second_end_portal then
		if caster:GetOwner().first_end_portal ~= nil and caster:GetOwner().first_end_portal:IsAlive() then
			local loc = caster:GetOwner().first_end_portal:GetAbsOrigin()
			loc = loc + (loc - caster:GetAbsOrigin()):Normalized() * 100
			FindClearSpaceForUnit(target, loc, true)
		end
	end

	keys.target:EmitSound("Hero_Meepo.Poof.Channel")

	if ability:GetLevel() > 1 then
		local numSpirits = ability:GetSpecialValueFor("numSpirits")
		local particleName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirits.vpcf"
		if keys.target.pfx ~= nil then
			ParticleManager:DestroyParticle(keys.target.pfx, true)
		end
		keys.target.numSpirits = numSpirits
		keys.target.pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, target )
		ParticleManager:SetParticleControl( keys.target.pfx, 1, Vector( numSpirits, 0, 0 ) )
		for i=1, numSpirits do
			ParticleManager:SetParticleControl( keys.target.pfx, 8+i, Vector( 1, 0, 0 ) )
		end
		ability:ApplyDataDrivenModifier(caster:GetOwner(), target, "modifier_bird_dive", {})
	end
end

function ReduceBirdCount( keys )
	keys.caster.numSpirits = keys.caster.numSpirits - 1
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirits.vpcf"
	ParticleManager:DestroyParticle(keys.caster.pfx, true)
	keys.caster.pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, keys.caster )
	ParticleManager:SetParticleControl( keys.caster.pfx, 1, Vector( keys.caster.numSpirits, 0, 0 ) )
	for i=1, keys.caster.numSpirits do
		ParticleManager:SetParticleControl( keys.caster.pfx, 8+i, Vector( 1, 0, 0 ) )
	end
	keys.ability:ApplyDataDrivenModifier(keys.ability:GetOwner(), keys.caster, "modifier_bird_dive", {})
	if keys.caster.numSpirits == 0 then
		keys.caster:RemoveModifierByName("modifier_bird_dive")
	end
end

function PortalHealth( keys )
	local caster = keys.caster
	local ability = keys.ability
	caster:SetHealth(math.max(caster:GetHealth() - ability:GetLevelSpecialValueFor("damage", ability:GetLevel() -1), 1))
	if caster:GetHealth() <= 1 then
		ParticleManager:DestroyParticle(caster.portal_particle, true)
		if caster.LifeDrainParticle ~= nil then
			ParticleManager:DestroyParticle(caster.LifeDrainParticle, true)
		end
		caster:RemoveSelf()
	end
end