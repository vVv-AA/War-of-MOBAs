function Shadow( event )
	local caster = event.caster
	local ability = event.ability
	if caster:HasModifier("modifier_invis_effect") then return end
	local delay = "fade_delay_day"
	if GameRules:IsDaytime() ~=  true then
		delay = "fade_delay_night"
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_invis_effect", {})
end

function StartFadeTime( event )
	local caster = event.caster
	local ability = event.ability

	local delay = "fade_delay_day"
	if GameRules:IsDaytime() ~=  true then
		delay = "fade_delay_night"
	end

	if event.target ~= nil then
		local name = event.target:GetClassname()
		if name == "npc_dota_roshan" then
			delay = "fade_delay_day"
		end
	end
	delay_time = ability:GetLevelSpecialValueFor(delay, ability:GetLevel() - 1)
	ability:EndCooldown()
	if delay_time ~= 0 then
		ability:StartCooldown(delay_time)
	end
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_invis", {duration = delay_time + 0.01})
end