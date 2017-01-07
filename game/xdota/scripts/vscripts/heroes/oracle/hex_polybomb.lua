require('mechanics/talents')
require("heroes/generics/Disables")
LinkLuaModifier("hex_polybomb", "heroes/oracle/hex_polybomb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("hex_polybomb_modifier_particles_small", "heroes/oracle/hex_polybomb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("hex_polybomb_modifier_particles_large", "heroes/oracle/hex_polybomb.lua", LUA_MODIFIER_MOTION_NONE)

if hex_polybomb_modifier_particles_small == nil then
    hex_polybomb_modifier_particles_small = class({})
end

function hex_polybomb_modifier_particles_small:GetEffectName()
    return "particles/test_particle/polybomb_bounce_indicator.vpcf"
end

if hex_polybomb_modifier_particles_large == nil then
    hex_polybomb_modifier_particles_large = class({})
end

function hex_polybomb_modifier_particles_large:GetEffectName()
    return "particles/test_particle/polybomb_bounce_indicator_150_extra_radius.vpcf"
end


if hex_polybomb == nil then
    hex_polybomb = class({})
end

function hex_polybomb:OnCreated( kv )
    if IsServer() then
        if GetTalentSpecialValueFor(self:GetAbility(), "bounce_aoe") == self:GetAbility():GetSpecialValueFor("bounce_aoe") then
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "hex_polybomb_modifier_particles_small", {duration = self:GetAbility():GetDuration()})
        else
            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "hex_polybomb_modifier_particles_large", {duration = self:GetAbility():GetDuration()})
        end
        self.movespeed = kv.movespeed
        if kv.purgable ~= nil then
            self.purgable = kv.purgable
        else
            self.purgable = true
        end
        self.uniqueID = kv.uniqueID
        local params = 
        {
            caster = self:GetCaster(),
            ability = self:GetAbility(),
            target = self:GetParent(),
            bypass = "false",
            purgable = self.purgable,
            duration = kv.duration,
        }
        ApplyHex(params)
        if (self.cannot_bounce_to == nil) then
            self.cannot_bounce_to = {}
        end
        self.cannot_bounce_to[self:GetParent()] = true
    end
end

function hex_polybomb:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function hex_polybomb:GetTexture()
    return "holdout_voodoo"
end

function hex_polybomb:IsDebuff()
    return true
end

function hex_polybomb:IsPurgable()
    return self.purgable
end

function hex_polybomb:IsHidden() 
    return false
end

function hex_polybomb:OnDestroy()
    if IsServer() == false then return end
    local holder = self:GetParent()

    local holder_location = holder:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local target_team = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

    local units = FindUnitsInRadius(self:GetAbility():GetOwner():GetTeamNumber(), holder_location, nil, GetTalentSpecialValueFor(self:GetAbility(), "bounce_aoe") , target_team, target_type, target_flags, FIND_CLOSEST, false)

    if #units > 1 then
        for _,unit in ipairs(units) do
            if self.cannot_bounce_to[unit] ~= true then
                self.cannot_bounce_to[unit] = true
                local projectile_info = 
                {
                    EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
                    Ability = self:GetAbility(),
                    vSpawnOrigin = holder_location,
                    Target = unit,
                    Source = self:GetParent(),
                    Caster = self:GetCaster(),
                    bHasFrontalCone = false,
                    iMoveSpeed = 1200,
                    bReplaceExisting = false,
                    bProvidesVision = false,
                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
                    bounce_table = self.cannot_bounce_to,
                    uniqueID = self.uniqueID,
                }
                TrackingProjectile(projectile_info)
            end
        end
    end
end

function TrackingProjectile( params )
    local target = params.Target
    local caster = params.Source
    local actual_caster = params.Caster
    local speed = params.iMoveSpeed
    local ability = params.Ability
    --Fetch initial projectile location
    local projectile = caster:GetAttachmentOrigin( params.iSourceAttachment )
 
    --Make the particle
    local particle = ParticleManager:CreateParticle( params.EffectName, PATTACH_CUSTOMORIGIN, caster)
    --Source CP
    ParticleManager:SetParticleControl( particle, 0, caster:GetAttachmentOrigin( params.iSourceAttachment ) )
    --TargetCP
    ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
    --Speed CP
    ParticleManager:SetParticleControl( particle, 2, Vector( speed, 0, 0 ) )
 
    Timers:CreateTimer(function()
        --Get the target location
        local target_location = target:GetAbsOrigin()
 
        --Move the projectile towards the target
        projectile = projectile + ( target_location - projectile ):Normalized() * speed * FrameTime()
 
        --Check the distance to the target
        if ( target_location - projectile ):Length2D() < speed * FrameTime() then
            --Target has reached destination!
            ParticleManager:DestroyParticle( particle, false )
            target:AddNewModifier(actual_caster, ability, "hex_polybomb", {duration = ability:GetDuration(), purgable = true, movespeed = ability:GetSpecialValueFor("move_speed_mod"), uniqueID = params.uniqueID})
            local modifiers = target:FindAllModifiers()
            for _,modifier in pairs(modifiers) do
                if modifier:GetName() == "hex_polybomb" and modifier.uniqueID == params.uniqueID then
                    modifier.cannot_bounce_to = params.bounce_table 
                end
            end
            return nil
        else
            --Reschedule for next frame
            return 0
        end
    end)
end
