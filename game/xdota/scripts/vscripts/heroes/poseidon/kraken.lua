function ReleaseTheKraken( keys )
	local caster = keys.caster
	local ability = keys.ability
	local particleWater = "particles/econ/items/slardar/slardar_takoyaki/slardar_crush_tako.vpcf"
	local kxeWater = ParticleManager:CreateParticleForPlayer( particleWater, PATTACH_ABSORIGIN, caster, PlayerResource:GetPlayer( caster:GetPlayerID() ) )
	ParticleManager:SetParticleControl( kxeWater, 1, Vector(ability:GetSpecialValueFor("radius")*2,1,1) )

	Timers:CreateTimer( 3, function()
		ParticleManager:DestroyParticle( kxeWater, false )
		return nil
	end)
end