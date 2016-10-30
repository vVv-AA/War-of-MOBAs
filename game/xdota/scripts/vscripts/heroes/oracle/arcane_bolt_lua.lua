LinkLuaModifier("modifier_arcane_bolt_hit", "heroes/oracle/modifier_arcane_bolt_hit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arcane_bolt_hit_bonus_granted", "heroes/oracle/modifier_arcane_bolt_hit_bonus_granted.lua", LUA_MODIFIER_MOTION_NONE)

if arcane_bolt_lua == nil then
    arcane_bolt_lua = class({})
end


function arcane_bolt_lua:OnAbilityPhaseStart()
	EmitSoundOn("Hero_Magnataur.ShockWave.Cast", self:GetCaster())
	return true
end

function arcane_bolt_lua:GetAbilityDamage()
	local current_stack = 0
	local damage = self:GetLevelSpecialValueFor("shock_damage", self:GetLevel() - 1)
	if self:GetCaster():HasModifier("modifier_arcane_bolt_hit") then
		current_stack = self:GetCaster():GetModifierStackCount( "modifier_arcane_bolt_hit", self )
	end

	if self:GetCaster():HasModifier("modifier_arcane_bolt_hit_bonus_granted") then
		damage = damage*(1+self:GetSpecialValueFor("perma_bonus_damage_pct"))
	end

	return damage
end

function arcane_bolt_lua:OnSpellStart()
	EmitSoundOn("Hero_Magnataur.ShockWave.Particle", self:GetCaster())

	local vDirection = self:GetCursorPosition() - self:GetCaster():GetOrigin()
	vDirection = vDirection:Normalized()
	vDirection.z = 0
	self.wave_speed = self:GetSpecialValueFor( "shock_speed" )
	self.wave_width = self:GetSpecialValueFor( "shock_width" )
	self.wave_damage = self:GetAbilityDamage()
	self.wave_distance = self:GetSpecialValueFor( "shock_distance" )

	local info = {
		EffectName = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.wave_width,
		fEndRadius = self.wave_width,
		vVelocity = vDirection * self.wave_speed,
		fDistance = self.wave_distance,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		bProvidesVision = false,
	}

	ProjectileManager:CreateLinearProjectile( info )
end

function arcane_bolt_lua:OnProjectileHit( hTarget, vLocation )
	local caster = self:GetCaster()
	if hTarget ~= nil then
		if hTarget:IsRealHero() then
			self:RefundManaCost()
			remaining_cooldown = self:GetCooldownTimeRemaining()
			self:EndCooldown() 
			self:StartCooldown(math.max(remaining_cooldown - 5, 0))
			if caster:HasModifier("modifier_arcane_bolt_hit") then
				local current_stack = self:GetCaster():GetModifierStackCount( "modifier_arcane_bolt_hit", self )
				caster:SetModifierStackCount("modifier_arcane_bolt_hit", self, math.min(current_stack + 1, self:GetSpecialValueFor("max_stacks")))

				if self:GetCaster():GetModifierStackCount( "modifier_arcane_bolt_hit", self ) == 30 then
					caster:RemoveModifierByName("modifier_arcane_bolt_hit")
					caster:AddNewModifier(caster, self, "modifier_arcane_bolt_hit_bonus_granted", {})
				end
			elseif caster:HasModifier("modifier_arcane_bolt_hit_bonus_granted") == false then
				caster:AddNewModifier(caster, self, "modifier_arcane_bolt_hit", {})
				caster:SetModifierStackCount("modifier_arcane_bolt_hit", self, 1)
			end
			local damage = {
				victim = hTarget,
				attacker = caster,
				damage = self.wave_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self,
			}
			ApplyDamage( damage )
		else
			if self:GetLevel() > 2 and hTarget:GetUnitName() ~= "npc_dota_roshan"then
				hTarget:Kill(self, self:GetCaster())
			else
				local damage = {
					victim = hTarget,
					attacker = caster,
					damage = self.wave_damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self,
				}
				ApplyDamage( damage )
			end
		end
	end
	return false
end
