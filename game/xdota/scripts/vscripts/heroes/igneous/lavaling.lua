function LavaSpirit( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin() 
	local player = caster:GetPlayerOwnerID()
	local ability = keys.ability
	print("aa")
	-- Ability variables
	local duration = ability:GetSpecialValueFor("duration") 
	local count = ability:GetSpecialValueFor("count")

	-- Spirit cleanup
	-- Initialize the unit table to keep track of the spirits
	if not ability.lavalings then
		ability.lavalings = {}
	end

	-- Kill the old spirits
	for k,v in pairs(ability.lavalings) do
		if v and IsValidEntity(v) then 
			v:ForceKill(false)
		end
	end

	-- Start a clean unit table
	ability.lavalings = {}

	-- Create new spirits
	for i=1,count do
		local lavaling = CreateUnitByName("npc_dota_igneous_lavaling", caster_location + RandomVector(100), true, caster, caster, caster:GetTeamNumber())
		lavaling:FindAbilityByName("lavaling_melting_strike_datadriven"):SetLevel(1)
		lavaling:SetControllableByPlayer(player, true)
		lavaling:AddNewModifier(caster, ability, "modifier_phased", {duration = 0.03})
		lavaling:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
		-- Track the spirit
		table.insert(ability.lavalings, lavaling)
	end
end
