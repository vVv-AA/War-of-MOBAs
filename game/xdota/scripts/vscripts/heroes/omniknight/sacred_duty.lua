function CooldownCheck( event )
	local caster = event.caster
	local ability_cast = event.event_ability
	local cooldown = event.ability:GetSpecialValueFor("cooldown")
	local ability_list = {}
	local cooldown_list = {}

	if ability_cast:GetCooldownTimeRemaining() == 0 then return end
	print(ability_cast:GetAbilityName())
	for ability_id = 0, 15 do
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
		ability_cast:EndCooldown()
		caster.sacred_duty_charges = 1

		for index,ability in pairs(ability_list) do
			if caster:HasModifier("modifier_spell"..index.."_datadriven") then
				caster:RemoveModifierByName("modifier_spell"..index.."_datadriven")
			else
				ability:EndCooldown()
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
				end
				break
			end
		end
	end
end

function SacredDutyCooldown ( keys )

	if keys.ability:GetLevel() ~= 1 then return end
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local modifierName = "modifier_sacred_duty_counter_datadriven"
	local charge_replenish_time = ability:GetSpecialValueFor( "cooldown" )
	
	-- Initialize stack
	caster:SetModifierStackCount( modifierName, caster, 0 )
	caster.sacred_duty_charges = 1
	caster.start_charge = false
	caster.sacred_duty_cooldown = 0.0

	ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
	caster:SetModifierStackCount( modifierName, caster, 1 )
	
	-- create timer to restore stack
	Timers:CreateTimer( function()
			-- Restore charge
			if caster.start_charge and caster.sacred_duty_charges < 1 then
				-- Calculate stacks
				local next_charge = caster.sacred_duty_charges + 1
				caster:RemoveModifierByName( modifierName )
				if next_charge ~= 1 then
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, { duration = charge_replenish_time } )
					sacred_duty_start_cooldown( caster, charge_replenish_time )
				else
					ability:ApplyDataDrivenModifier( caster, caster, modifierName, {} )
					caster.start_charge = false
				end
				caster:SetModifierStackCount( modifierName, caster, next_charge )
				
				-- Update stack
				caster.sacred_duty_charges = next_charge
			end
			
			-- Check if max is reached then check every 0.5 seconds if the charge is used
			if caster.sacred_duty_charges ~= 1 then
				caster.start_charge = true
				return charge_replenish_time
			else
				return 0.5
			end
		end
	)

end

function sacred_duty_start_cooldown( caster, charge_replenish_time )
	caster.sacred_duty_cooldown = charge_replenish_time
	Timers:CreateTimer( function()
			local current_cooldown = caster.sacred_duty_cooldown - 0.1
			if current_cooldown > 0.1 then
				caster.sacred_duty_cooldown = current_cooldown
				return 0.1
			else
				return nil
			end
		end
	)
end