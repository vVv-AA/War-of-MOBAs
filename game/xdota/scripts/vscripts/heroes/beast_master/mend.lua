function CheckTarget( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	if string.find(target:GetUnitName(), "misha") == nil then
		caster:Stop()
		return false
	end

	return true  
end

function Mend( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local heal = ability:GetLevelSpecialValueFor("heal_value", ability:GetLevel()- 1)
	Move(event)
	if ability:GetLevel() > 1 and target:GetHealth() < target:GetMaxHealth() / 2 then
		heal = heal*2
	end
	target:Heal(heal, ability)
end

function Move( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local loc = caster:GetAbsOrigin()
	loc = loc - (loc - target:GetAbsOrigin()):Normalized() * 120

	if ability.lastVec ~= nil and ability.lastVec == loc then
		if target:HasModifier("modifier_dance") == false then
			ability:ApplyDataDrivenModifier(target, target, "modifier_dance", {duration = 10.0})
			target:StartGesture(ACT_DOTA_IDLE_RARE)
		end
		return
	end
	ability.lastVec = loc

	target:MoveToPosition(loc)

end