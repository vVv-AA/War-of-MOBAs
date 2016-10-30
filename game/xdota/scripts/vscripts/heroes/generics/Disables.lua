LinkLuaModifier("modifier_generic_stun", "heroes/generics/modifier_generic_stun.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_hex", "heroes/generics/modifier_generic_hex.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_disarm", "heroes/generics/modifier_generic_disarm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_stun", "heroes/generics/modifier_immune_stun.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_hex", "heroes/generics/modifier_immune_hex.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_immune_disarm", "heroes/generics/modifier_immune_disarm.lua", LUA_MODIFIER_MOTION_NONE)

function ApplyStun( keys )
	print("aaaa")
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = keys.duration
	local bypass = keys.bypass
	local purgable_str = keys.purgable_str
	local purgable
	if purgable_str == "true" then
		purgable = true
	elseif purgable_str == "false" then
		purgable = false
	else
		purgable = true
	end

	if bypass == "false" then
		if target:HasModifier("modifier_immune_stun") then
			return
		elseif target:HasModifier("modifier_reduce_disable_duration") then
			target:AddNewModifier(caster, ability, "modifier_generic_stun", {duration = duration*target:FindModifierByName("modifier_reduce_disable_duration").reductionFactor, purgable = purgable})
		else
			target:AddNewModifier(caster, ability, "modifier_generic_stun", {duration = duration, purgable = purgable})
		end
	else
		target:AddNewModifier(caster, ability, "modifier_generic_stun", {duration = duration, purgable = purgable})
	end
end

function ApplyHex( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = keys.duration
	local bypass = keys.bypass
	local purgable_str = keys.purgable_str
	local unique_Identifier = keys.unique_Identifier
	local purgable
	if purgable_str == "true" then
		purgable = true
	elseif purgable_str == "false" then
		purgable = false
	else
		purgable = true
	end

	if bypass == "false" then
		if target:HasModifier("modifier_immune_hex") then return
		elseif target:HasModifier("modifier_reduce_disable_duration") then
			target:AddNewModifier(caster, ability, "modifier_generic_hex", {duration = duration*target:FindModifierByName("modifier_reduce_disable_duration").reductionFactor, purgable = purgable, unique_Identifier = unique_Identifier})
		else
			target:AddNewModifier(caster, ability, "modifier_generic_hex", {duration = duration, purgable = purgable, unique_Identifier = unique_Identifier})
		end
	else
		target:AddNewModifier(caster, ability, "modifier_generic_hex", {duration = duration, purgable = purgable, unique_Identifier = unique_Identifier})
	end
end

function ApplyDisarm( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local duration = keys.duration
	local bypass = keys.bypass
	local purgable_str = keys.purgable_str
	local purgable
	if purgable_str == "true" then
		purgable = true
	elseif purgable_str == "false" then
		purgable = false
	else
		purgable = true
	end

	if bypass == "false" then
		if target:HasModifier("modifier_immune_disarm") then return
		elseif target:HasModifier("modifier_reduce_disable_duration") then
			target:AddNewModifier(caster, ability, "modifier_generic_disarm", {duration = duration*target:FindModifierByName("modifier_reduce_disable_duration").reductionFactor, purgable = purgable})
		else
			target:AddNewModifier(caster, ability, "modifier_generic_disarm", {duration = duration, purgable = purgable})
		end
	else
		target:AddNewModifier(caster, ability, "modifier_generic_disarm", {duration = duration, purgable = purgable})
	end
end