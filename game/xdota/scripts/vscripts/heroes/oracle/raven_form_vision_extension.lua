raven_form_vision_extension = class ({})

LinkLuaModifier( "modifier_bonus_vision", "heroes/oracle/modifier_bonus_vision.lua", LUA_MODIFIER_MOTION_NONE )

function raven_form_vision_extension:GetIntrinsicModifierName() 
	return "modifier_bonus_vision"
end

function raven_form_vision_extension:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local duration = ability:GetDuration()
	local time_elapsed = 0
	local total_vision

	Timers:CreateTimer(0.0, function()
		if GameRules:IsDaytime() then
			total_vision = caster:GetDayTimeVisionRange()*3
		else
			total_vision = caster:GetNightTimeVisionRange()*3
		end
			AddFOWViewer(caster:GetTeam(), caster:GetAbsOrigin(), total_vision, 0.03, false)
			time_elapsed = time_elapsed + 0.03

			if time_elapsed > duration then
				return nil
			else
				return 0.03
			end
	end)
end
