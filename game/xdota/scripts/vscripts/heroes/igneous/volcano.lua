function Upgrade( keys )
	keys.caster:FindAbilityByName("taunt_datadriven"):SetLevel(1)
end

function Damage(keys)
	local caster = keys.target
	local ability = keys.ability
	local radius = keys.radius
    local caster_location = caster:GetAbsOrigin()
    local clip_radius = keys.clip_radius
    -- Targeting variables
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)

    for _,unit in pairs(targets) do
    	if unit ~= nil and ( not unit:IsMagicImmune() ) and ( not unit:IsInvulnerable() ) then
	    	local distance = (caster_location - unit:GetAbsOrigin()):Length2D()
	    	local damage = ability:GetSpecialValueFor("wave_damage")*unit:GetMaxHealth()/100
	    	damage = damage*(math.max(radius-distance, clip_radius))/(radius)

	        local damagetable = {
	                victim = unit,
	                attacker = caster,
	                damage = damage,
	                damage_type = DAMAGE_TYPE_MAGICAL,
	                ability = ability,
	        }
	        ApplyDamage( damagetable )

	        ability:ApplyDataDrivenModifier(caster, unit, "modifier_volcano_stun", {})
	    end
	end
end