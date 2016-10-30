function ChangeTeam( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	if target.originalTeam == nil then
		target.originalTeam = target:GetTeamNumber()
	end
	target:SetTeam(caster:GetTeamNumber())
end

function RevertChangeTeam( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	target:SetTeam(target.originalTeam)
	target.originalTeam = nil
end