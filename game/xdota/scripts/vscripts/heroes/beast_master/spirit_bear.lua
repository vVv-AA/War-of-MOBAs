function SpiritBearSpawn( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local origin = caster:GetAbsOrigin() + RandomVector(100)

	-- Set the unit name, concatenated with the level number
	local unit_name = event.unit_name
	unit_name = unit_name..level

	-- Check if the bear is alive, heals and spawns them near the caster if it is
	if caster.bear and IsValidEntity(caster.bear) and caster.bear:IsAlive() then
		FindClearSpaceForUnit(caster.bear, origin, true)
		caster.bear:SetHealth(caster.bear:GetMaxHealth())
	
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.bear)	
	else

		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)

		LearnBearAbilities( caster.bear, math.min(level, 3) )
	end

end

function SpiritBearLevel( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local level = ability:GetLevel()
	local unit_name = "npc_dota_misha"..level

	if caster.bear and caster.bear:IsAlive() then 
		local origin = caster.bear:GetAbsOrigin()
		caster.bear:RemoveSelf()

		caster.bear = CreateUnitByName(unit_name, origin, true, caster, caster, caster:GetTeamNumber())
		caster.bear:SetControllableByPlayer(player, true)

		LearnBearAbilities( caster.bear, math.min(level, 3) )
	end
end

function LearnBearAbilities( unit, level )

	for i=0,15 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			ability:SetLevel(level)
		end
	end
end


function HealBear( event )
	local caster = event.caster
	local health = caster:GetMaxHealth()
	local ability = event.ability
	caster:Heal(health*ability:GetLevelSpecialValueFor("lifesteal", ability:GetLevel() - 1), ability)
end