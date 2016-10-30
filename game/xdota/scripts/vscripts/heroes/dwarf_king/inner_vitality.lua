LinkLuaModifier("modifier_inner_vitality_dwarf_king", "heroes/dwarf_king/modifier_inner_vitality_dwarf_king.lua", LUA_MODIFIER_MOTION_NONE)

function AbilityUpgrade( event )
	local caster = event.caster
	local ability = event.ability
	if ability:GetLevel() == 1 then return end
	caster:RemoveModifierByName("modifier_inner_vitality_dwarf_king")
	CheckModifier(event)
end

function CheckModifier( event )
	local caster = event.caster
	local ability = event.ability

	if ability.time_left == nil then
		ability.time_left = 0
	end

	if ability.last_damage == nil then
		ability.last_damage = 0
	end
	if ability.time_left <= 0 and caster:HasModifier("modifier_inner_vitality_dwarf_king") == false then
		caster:AddNewModifier(caster, ability, "modifier_inner_vitality_dwarf_king", {})
		ability.particle = ParticleManager:CreateParticle("particles/test_particle/dwarf_king_inner_vitality_basic_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(ability.particle,1,Vector(150, 0, 0))
	end
	ability.time_left = math.max(ability.time_left - 0.1, 0)
end

function RemoveThis( keys )
	local caster = keys.caster
	local ability = keys.ability

	ability.last_damage = GameRules:GetGameTime()
	ability.time_left =  ability:GetSpecialValueFor("heal_offtime")
	if ability.particle ~= nil then
		ParticleManager:DestroyParticle(ability.particle, true)
	end
	caster:RemoveModifierByName("modifier_inner_vitality_dwarf_king")
end

function ActiveStoneForm( keys )
	local caster = keys.caster
	local ability = keys.ability
	if ability:GetLevel() < 3 then return end
	RemoveParticles(keys)
	ability.particleExtra = ParticleManager:CreateParticle("particles/test_particle/dwarf_king_inner_vitality_faster_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(ability.particleExtra,1,Vector(150, 0, 0))
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_stone_form", {duration = ability:GetSpecialValueFor("active_duration")})
end

function RemoveParticles( keys )
	local ability = keys.ability
	if ability.particleExtra == nil then return end
	ParticleManager:DestroyParticle(ability.particleExtra, true)
end