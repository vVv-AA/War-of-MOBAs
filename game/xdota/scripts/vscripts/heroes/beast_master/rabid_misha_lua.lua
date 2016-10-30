LinkLuaModifier("modifier_rabid", "heroes/beast_master/modifier_rabid.lua", LUA_MODIFIER_MOTION_NONE)

if rabid_misha_lua == nil then
    rabid_misha_lua = class({})
end


function rabid_misha_lua:GetIntrinsicModifierName()
	return "modifier_rabid"
end