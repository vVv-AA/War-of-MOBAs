function WrathAttack( keys )

	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage
    local type_filter = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local team_filter = DOTA_UNIT_TARGET_TEAM_ENEMY
    local flag_filter = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    local mana_cost = ability:GetSpecialValueFor("mana_cost")
	local enemy_units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1200, team_filter, type_filter, flag_filter, FIND_CLOSEST, false)
	local ability_mana_cost = ability:GetSpecialValueFor("mana_cost")

	if caster:HasItemInInventory("item_ultimate_scepter") then
		damage = ability:GetLevelSpecialValueFor("damage_scepter", ability:GetLevel() -1)
	else
		damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() -1)
	end

    local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, caster)
    
    if caster:GetMana() < mana_cost then
    	ability:ToggleAbility()
    	return
    end

    caster:ReduceMana(mana_cost)

    for _,unit in pairs(enemy_units) do
    	local damageTable =
		{
			victim = unit,
			attacker = caster,
			damage = unit:GetMaxHealth()*damage,
			damage_type = DAMAGE_TYPE_MAGICAL
		}
		ApplyDamage( damageTable )
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_divine_wrath_debuff_datadriven", {})
	    local lightning = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, caster)
	    local loc = unit:GetAbsOrigin()
	    ParticleManager:SetParticleControl(lightning, 0, loc + Vector(0, 0, 1000))
	    ParticleManager:SetParticleControl(lightning, 1, loc)
	    ParticleManager:SetParticleControl(lightning, 2, loc)
	    EmitSoundOn("Hero_Zuus.GodsWrath", unit)
    end
end