function BonusDamageBuilding( keys )
	local caster = keys.attacker
	local target = keys.target
	local ability = keys.ability

	if (target:IsBuilding()) then
	    local damagetable = {
	            victim = target,
	            attacker = caster,
	            damage = keys.damage*(1+ability:GetSpecialValueFor("bonus_damage")),
	            damage_type = DAMAGE_TYPE_PHYSICAL,
	            ability = ability,
	    }
	    print("bonus")
	    ApplyDamage( damagetable )
	end
end

function RemoveThis( keys )
	local caster = keys.caster
	local ability = keys.ability

	if caster:HasModifier("modifier_item_ultimate_scepter") then return end

	caster:FindAbilityByName("war_club_datadriven"):SetLevel(0)
	caster:RemoveModifierByName("modifier_war_club_datadriven")
    Timers:CreateTimer(0, function ()
      if caster:HasModifier("modifier_item_ultimate_scepter") then
          caster:FindAbilityByName("war_club_datadriven"):SetLevel(1)
          return nil
      end
      return 0.5
    end)
end