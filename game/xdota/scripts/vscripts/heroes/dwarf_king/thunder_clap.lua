function UpgradesHandler( keys )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1 )

	if ability:GetLevel() < 2 then return end

	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	local cooldown_time = ability:GetCooldownTimeRemaining()
	ability:EndCooldown()
	ability:StartCooldown(math.max(cooldown_time - ability:GetSpecialValueFor("cooldown_reduction_perhit")*(#units), 0))
	
	local emp_dummy_unit = CreateUnitByName(caster:GetUnitName(), caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber())
	ability:ApplyDataDrivenModifier(emp_dummy_unit, emp_dummy_unit, "modifier_emp_dummy_material", {})
	emp_dummy_unit:AddNewModifier(emp_dummy_unit, nil, "modifier_disarmed", {})
	
	FindClearSpaceForUnit(emp_dummy_unit, emp_dummy_unit:GetAbsOrigin(), true)
	
	emp_dummy_unit:AddAbility("dwarf_king_emp_dummy_passive")
	emp_dummy_unit:FindAbilityByName("dwarf_king_emp_dummy_passive"):SetLevel(1)

	emp_dummy_unit:EmitSound("Hero_Invoker.EMP.Charge")  --Emit a sound that will follow the EMP.
	caster:EmitSound("Hero_Invoker.EMP.Cast")
	
	local emp_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_ABSORIGIN_FOLLOW, emp_dummy_unit)
	
	Timers:CreateTimer({
		endTime = ability:GetSpecialValueFor("bonus_discharge_duration"),
		callback = function()
			ParticleManager:DestroyParticle(emp_effect, false)
			local emp_explosion_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf",  PATTACH_ABSORIGIN, emp_dummy_unit)
			emp_dummy_unit:EmitSound("Hero_Invoker.EMP.Discharge")
			units = FindUnitsInRadius( caster:GetTeamNumber(), emp_dummy_unit:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,unit in pairs(units) do
				ability:ApplyDataDrivenModifier(emp_dummy_unit, unit, "modifier_thunder_clap", {duration = ability:GetSpecialValueFor("bonus_discharge_duration")})
				ApplyDamage({victim = unit, attacker = caster, damage = ability:GetSpecialValueFor("discharge_damage"), damage_type = DAMAGE_TYPE_MAGICAL})
			end
			emp_dummy_unit:AddNewModifier(emp_dummy_unit, nil, "modifier_illusion", {})
			emp_dummy_unit:RemoveSelf()
		end
	})

	if ability:GetLevel() < 3 then return end

	local heal_max_hp_pct = ability:GetSpecialValueFor("heal_max_hp_pct")

	caster:Heal(heal_max_hp_pct*caster:GetMaxHealth()*(#units), caster)
end