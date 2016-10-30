function UpAll( event )
	local caster = event.caster
	local ability = event.ability
	if caster:IsHero() and ability:GetLevel() == 1 then
		ability:SetLevel(3)
	end
end