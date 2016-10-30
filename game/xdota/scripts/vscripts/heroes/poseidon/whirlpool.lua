function StartParticles( keys )
	local caster = keys.caster
	local allHeroes = HeroList:GetAllHeroes()
	local ability = keys.ability
	ability.set_pull_point = caster:GetCursorPosition()
	local delay = ability:GetSpecialValueFor("stun_duration")
	local target = ability.set_pull_point
	local particleWater = "particles/test_particle/kunkka_spell_torrent_bubbles_fxset.vpcf"
	for k, v in pairs( allHeroes ) do
		if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
			local kxeWater = ParticleManager:CreateParticleForPlayer( particleWater, PATTACH_ABSORIGIN, v, PlayerResource:GetPlayer( v:GetPlayerID() ) )
			ParticleManager:SetParticleControl( kxeWater, 0, target )
			EmitSoundOnClient( "Ability.pre.Torrent", PlayerResource:GetPlayer( v:GetPlayerID() ) )
			Timers:CreateTimer(delay, function ()
				local xxx = ParticleManager:CreateParticleForPlayer( "particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", PATTACH_ABSORIGIN, caster, PlayerResource:GetPlayer( caster:GetPlayerID() ) )
				ParticleManager:SetParticleControl( xxx, 0, target)
				Timers:CreateTimer( 5, function()
					ParticleManager:DestroyParticle( xxx, false )
					return nil
				end)
			end)

			-- Destroy particle after delay
			Timers:CreateTimer( delay, function()
				ParticleManager:DestroyParticle( kxeWater, false )
				return nil
			end)
		end
	end
end

function MoveUnits( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	ability.point_entity = target
	local ability_level = ability:GetLevel() - 1
	-- Ability variables
	local speed = ability:GetLevelSpecialValueFor("pull_speed", ability_level)/10
	local radius = ability:GetLevelSpecialValueFor("whirlpool_radius", ability_level)

	-- Targeting variables
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

	-- Units to be caught in the black hole
    local units = FindUnitsInRadius(caster:GetTeamNumber(), ability.set_pull_point, nil, radius, target_team, target_type, target_flags, FIND_CLOSEST, false)
	-- Calculate the position of each found unit in relation to the center
	for _,unit in ipairs(units) do
		local unit_location = unit:GetAbsOrigin()
		local vector_distance = ability.set_pull_point - unit_location
		local distance = (vector_distance):Length2D()
		local direction = (vector_distance):Normalized()
		if distance >= 150 then
			FindClearSpaceForUnit(unit, unit_location + direction * 8, true)
		end
	end
end

function End(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	if ability.point_entity:IsNull() == false then
		ability.point_entity:RemoveModifierByName("modifier_whirlpool_datadriven")
		StopSoundOn("Hero_Enigma.Black_Hole", caster)
	end
end