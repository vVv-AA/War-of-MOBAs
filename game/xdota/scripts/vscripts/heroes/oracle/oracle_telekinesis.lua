function PullInOrbit(keys)
	local caster = keys.caster
	local ability = keys.ability
	local pull_in_time = ability:GetSpecialValueFor("pull_in_time")
	local radius = ability:GetSpecialValueFor("radius")
	local caster_loc = caster:GetAbsOrigin()
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local orbit_radius = ability:GetSpecialValueFor("orbit_radius")
	local pull_speed = ability:GetSpecialValueFor("pull_speed")
	ability.time_elapsed = 0
	ability.pull_in_time = pull_in_time
	for _,unit in pairs(units) do
		if unit:GetUnitName() ~= "npc_dota_roshan" or target:IsMagicImmune() or not keys.caster:CanEntityBeSeenByMyTeam(target) then
			local unit_location = unit:GetAbsOrigin()
			local vector = (unit_location - caster_loc)
			local offset = orbit_radius
			local direction = (vector):Normalized()
			local destination = caster_loc - direction*200

			unit:SetAbsOrigin(destination)
		end
	end
	StartOrbit(keys, units)
end

function AddNewUnit( keys )
	local target = keys.target
	for _,v in pairs(keys.ability.heroesAffected) do
		if v == target then return end
	end
	print(keys.caster:CanEntityBeSeenByMyTeam(target))
	if target:GetUnitName() == "npc_dota_roshan" or target:IsMagicImmune() or not keys.caster:CanEntityBeSeenByMyTeam(target) then return end
	keys.ability.heroesAffected[#keys.ability.heroesAffected + 1] = keys.target
	-- body
end

function StartOrbit( keys, units )
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local caster_loc = caster:GetAbsOrigin()
	local orbit_radius = ability:GetSpecialValueFor("orbit_radius")
	ability.duration = ability:GetSpecialValueFor("duration")
	ability.ability_startTime = GameRules:GetGameTime()
	ability.numHeroesAffected = #units
	ability.heroesAffected	= units
	ability.orbit_radius = orbit_radius
end

function ThinkOrbit( event )
	local caster	= event.caster
	local caster_TeamNumber = caster:GetTeamNumber()
	local ability	= event.ability
	local numHeroesAffectedMax	= ability.numHeroesAffected
	local casterOrigin	= caster:GetAbsOrigin()

	local elapsedTime	= GameRules:GetGameTime() - ability.ability_startTime
	--------------------------------------------------------------------------------
	-- Update the spirits' positions
	--
	--local currentRotationAngle = elapsedTime * ability:GetSpecialValueFor("turn_rate")
	local currentRotationAngle = elapsedTime * 50
	local rotationAngleOffset = 360 / #ability.heroesAffected
	local numHeroesAlive = 0

	for k,v in pairs( ability.heroesAffected ) do
		if v ~= nil then
			numHeroesAlive = numHeroesAlive + 1

			-- Rotate
			local rotationAngle = currentRotationAngle - rotationAngleOffset * ( k - 1 )
			local relPos = Vector( 0, ability.orbit_radius, 0 )
			relPos = RotatePosition( Vector(0,0,0), QAngle( 0, -rotationAngle, 0 ), relPos )

			local absPos = GetGroundPosition( relPos + casterOrigin, v )

			v:SetAbsOrigin( absPos )
		end
	end
end

function HeroDied( event )
	local hero	= event.caster
	local ability	= event.ability
	ability.heroesAffected[hero] = nil
end
