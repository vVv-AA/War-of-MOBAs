function CooldownCheck( event )
	local caster = event.caster
	local ability_cast = event.event_ability
	local cooldown = event.ability:GetSpecialValueFor("cooldown_penalty")
	local ability_list = {}
	local cooldown_list = {}
	local self_ability = event.ability

	if ability_cast:GetCooldownTimeRemaining() == 0 then return end
	for ability_id = 0, caster:GetAbilityCount() - 1 do
		local ability = caster:GetAbilityByIndex(ability_id)
		if ability then
			ability_list[ability_id] = ability
			cooldown_list[ability_id] = ability:GetCooldown(ability:GetLevel())
			if caster:HasModifier("modifier_spell"..ability_id.."_datadriven") then
				local modifier = caster:FindModifierByName("modifier_spell"..ability_id.."_datadriven")
				cooldown_list[ability_id] = cooldown_list[ability_id] + (modifier:GetRemainingTime())
			end
		end
	end

	if ability_cast:GetName() == "item_refresher" then
		for index,ability in pairs(ability_list) do
			if caster:HasModifier("modifier_spell"..index.."_datadriven") then
				caster:RemoveModifierByName("modifier_spell"..index.."_datadriven")
			end
		end
		return
	end

	if caster.sacred_duty_charges == 1 then
		for index,ability in pairs(ability_list) do
			if ability_cast:GetAbilityName() == ability:GetAbilityName() then
				if not caster:HasModifier("modifier_spell"..index.."_datadriven") then
					event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_spell"..index.."_datadriven", { duration = cooldown_list[index] })
					ability_cast:EndCooldown()
				else
					caster.sacred_duty_charges = 0
					ability_cast:EndCooldown()
					ability_cast:StartCooldown(cooldown_list[index]*(1+cooldown))
					caster:SpendMana(ability:GetManaCost(ability:GetLevel() - 1) * self_ability:GetSpecialValueFor("mana_penalty"), ability)
					self_ability:StartCooldown(self_ability:GetCooldown(1))
					caster:SetModifierStackCount( "modifier_sacred_duty_counter_datadriven", caster, 0 )
					self_ability:ApplyDataDrivenModifier(caster, caster, "modifier_self_cooldown_thinker", {})
				end
				break
			end
		end
	end
end

function SacredDutyCooldown ( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_sacred_duty_counter_datadriven"
	-- Initialize stack
	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( "modifier_sacred_duty_counter_datadriven", caster, 1 )
	caster.sacred_duty_charges = 1
end

function CheckSelfCooldown( event )
	local caster = event.caster
	local ability = event.ability

	if ability:GetCooldownTimeRemaining() > 0 then
		return
	end

	caster.sacred_duty_charges = 1
	caster:RemoveModifierByName("modifier_self_cooldown_thinker")
end