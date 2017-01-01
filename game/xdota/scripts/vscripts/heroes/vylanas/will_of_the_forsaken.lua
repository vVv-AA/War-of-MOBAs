require('mechanics/talents')

function Reincarnation( event )
	local caster = event.caster
	local attacker = event.attacker
	local ability = event.ability
	local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
	local casterHP = caster:GetHealth()
	local casterMana = caster:GetMana()
	local abilityManaCost = ability:GetManaCost( ability:GetLevel() - 1 )
	local health_mana_pct = ability:GetSpecialValueFor("health_mana_pct")

	-- Change it to your game needs
	local respawnTimeFormula = caster:GetLevel() * 4
	
	if casterHP == 0 and ability:IsCooldownReady() and casterMana >= abilityManaCost  then
		-- Variables for Reincarnation
		local reincarnate_time = ability:GetLevelSpecialValueFor( "reincarnate_time", ability:GetLevel() - 1 )
		local slow_radius = ability:GetLevelSpecialValueFor( "slow_radius", ability:GetLevel() - 1 )
		local casterGold = caster:GetGold()
		local respawnPosition = caster:GetAbsOrigin()
		
		-- Start cooldown on the passive
		ability:StartCooldown(cooldown)

		-- Kill, counts as death for the player but doesn't count the kill for the killer unit
		caster:SetHealth(1)
		caster:SetBuybackCooldownTime(reincarnate_time + 2)
		caster:Kill(caster, nil)
		-- Set the gold back
		caster:SetGold(casterGold, false)

		-- Set the short respawn time and respawn position
		caster:SetTimeUntilRespawn(reincarnate_time) 
		caster:SetRespawnPosition(respawnPosition) 

		-- Particle
		local particleName = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
		caster.ReincarnateParticle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl(caster.ReincarnateParticle, 0, respawnPosition)
		ParticleManager:SetParticleControl(caster.ReincarnateParticle, 1, Vector(slow_radius,0,0))

		-- End Particle after reincarnating
		Timers:CreateTimer(reincarnate_time, function() 
			ParticleManager:DestroyParticle(caster.ReincarnateParticle, false)
			caster:SetHealth(caster:GetMaxHealth() * health_mana_pct)
			caster:SetMana(caster:GetMaxMana() * health_mana_pct)
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_will_of_the_dead", {duration = GetTalentSpecialValueFor(ability, "buff_duration")})
		end)

		-- Grave and rock particles
		-- The parent "particles/units/heroes/hero_skeletonking/skeleton_king_death.vpcf" misses the grave model
		local model = "models/props_gameplay/tombstoneb01.vmdl"
		local grave = Entities:CreateByClassname("prop_dynamic")
    	grave:SetModel(model)
    	grave:SetAbsOrigin(respawnPosition)

    	-- End grave after reincarnating
    	Timers:CreateTimer(reincarnate_time, function() grave:RemoveSelf() end)		

		-- Sounds
		caster:EmitSound("Hero_SkeletonKing.Reincarnate")
		caster:EmitSound("Hero_SkeletonKing.Death")
		Timers:CreateTimer(reincarnate_time, function()
			caster:EmitSound("Hero_SkeletonKing.Reincarnate.Stinger")
		end)

	elseif casterHP == 0 then
		-- On Death without reincarnation, set the respawn time to the respawn time formula
		caster:SetTimeUntilRespawn(respawnTimeFormula)
	end
end

	
