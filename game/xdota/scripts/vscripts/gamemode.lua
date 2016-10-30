-- This is the primary GameMode GameMode script and should be used to assist in initializing your game mode
GameMode_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by GameMode
-- You can also change the cvar 'GameMode_spew' at any time to 1 or 0 for output/no output
GameMode_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[GameMode] creating GameMode game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- These internal libraries set up GameMode's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core GameMode files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core GameMode files.
require('events')


--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[GameMode] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

function GameMode:OnHeroInGame(hero)
  Timers:CreateTimer(0, function()
    for k, v in pairs( HeroList:GetAllHeroes() ) do
      CustomNetTables:SetTableValue( "hero_attributes", "" .. v:entindex(), {
        str = math.floor(v:GetBaseStrength()).."+"..math.floor(v:GetStrength() - v:GetBaseStrength()),
        agi = math.floor(v:GetBaseAgility()).."+"..math.floor(v:GetAgility() - v:GetBaseAgility()),
        int = math.floor(v:GetBaseIntellect()).."+"..math.floor(v:GetIntellect() - v:GetBaseIntellect()),
        avg_dmg = math.floor(v:GetAverageTrueAttackDamage(v)),
        atk_spd = v:GetAttackSpeed(),
        b_ms = v:GetBaseMoveSpeed(),
        armor = v:GetPhysicalArmorValue(),
        movespeed = v:GetMoveSpeedModifier(v:GetBaseMoveSpeed())
        }
      )
    end
    return 0.5
  end)
end

--[[
  Need to fix for illusions. Check OnPlayerPick or implement illusion system.
]]

function GameMode:OnIllusionsCreated( keys )
  --GameMode:PrepareCosmetics(EntIndexToHScript(keys.original_entindex))
end

function GameMode:OnNPCSpawned( keys )

end
function GameMode:PrepareCosmetics(hero)
  if hero:GetClassname() == "npc_dota_hero_antimage" then
    SwapWearable(hero, "models/heroes/antimage/antimage_weapon.vmdl", "models/items/antimage/god_eater_weapon/god_eater_weapon.vmdl")
    SwapWearable(hero, "models/heroes/antimage/antimage_offhand_weapon.vmdl", "models/items/antimage/god_eater_off_hand/god_eater_off_hand.vmdl")
    SwapWearable(hero, "models/heroes/antimage/antimage_head.vmdl", "models/items/antimage/god_eater_head/god_eater_head.vmdl")
    SwapWearable(hero, "models/heroes/antimage/antimage_chest.vmdl", "models/items/antimage/god_eater_armor/god_eater_armor.vmdl")
    SwapWearable(hero, "models/heroes/antimage/antimage_arms.vmdl", "models/items/antimage/god_eater_arms/god_eater_arms.vmdl")
    SwapWearable(hero, "models/heroes/antimage/antimage_belt.vmdl", "models/items/antimage/god_eater_belt/god_eater_belt.vmdl")
  elseif hero:GetClassname() == "npc_dota_hero_tiny" then
    SwapWearable(hero, "models/heroes/tiny_01/tiny_01_body.vmdl", "models/items/tiny/burning_stone_giant_body_level_4/burning_stone_giant_body_level_4.vmdl")
    SwapWearable(hero, "models/heroes/tiny_01/tiny_01_head.vmdl", "models/items/tiny/burning_stone_giant_head_level_4/burning_stone_giant_head_level_4.vmdl")
    SwapWearable(hero, "models/heroes/tiny_01/tiny_01_left_arm.vmdl", "models/items/tiny/burning_stone_giant_left_arm_level_4/burning_stone_giant_left_arm_level_4.vmdl")
    SwapWearable(hero, "models/heroes/tiny_01/tiny_01_right_arm.vmdl", "models/items/tiny/burning_stone_giant_right_arm_level_4/burning_stone_giant_right_arm_level_4.vmdl")
    SwapWearable(hero, "models/heroes/tiny_01/tiny_01_tree.vmdl", "models/items/tiny/burning_stone_giant_club/burning_stone_giant_club.vmdl")
  elseif hero:GetClassname() == "npc_dota_hero_beastmaster" then
    SwapWearable(hero, "models/heroes/beastmaster/beastmaster_head.vmdl", "models/items/beastmaster/red_talon_head/red_talon_head.vmdl")
    SwapWearable(hero, "models/heroes/beastmaster/beastmaster_shoulder.vmdl", "models/items/beastmaster/red_talon_shoulder/red_talon_shoulder.vmdl")
    SwapWearable(hero, "models/heroes/beastmaster/beastmaster_belt.vmdl", "models/items/beastmaster/red_talon_belt/red_talon_belt.vmdl")
    SwapWearable(hero, "models/heroes/beastmaster/beastmaster_weapon.vmdl", "models/items/beastmaster/mpgl_beastmaster_weapon/mpgl_beastmaster_weapon.vmdl")
    SwapWearable(hero, "models/heroes/beastmaster/beastmaster_arms.vmdl", "models/heroes/beastmaster/beastmaster_arms.vmdl")
  elseif hero:GetClassname() == "npc_dota_hero_windrunner" then
    SwapWearable(hero, "models/heroes/windrunner/windrunner_bow.vmdl", "models/items/windrunner/ti6_windranger_weapon/ti6_windranger_weapon.vmdl")
    SwapWearable(hero, "models/heroes/windrunner/windrunner_cape.vmdl", "models/items/windrunner/ti6_windranger_back/ti6_windranger_back.vmdl")
    SwapWearable(hero, "models/heroes/windrunner/windrunner_head.vmdl", "models/items/windrunner/ti6_windranger_head/ti6_windranger_head.vmdl")
    SwapWearable(hero, "models/heroes/windrunner/windrunner_quiver.vmdl", "models/items/windrunner/ti6_windranger_offhand/ti6_windranger_offhand.vmdl")
    SwapWearable(hero, "models/heroes/windrunner/windrunner_shoulderpads.vmdl", "models/items/windrunner/ti6_windranger_shoulder/ti6_windranger_shoulder.vmdl")
  elseif hero:GetClassname() == "npc_dota_hero_omniknight" then
    SwapWearable(hero, "models/heroes/omniknight/bracer.vmdl", "models/items/omniknight/grey_night_arms/grey_night_arms.vmdl")
    SwapWearable(hero, "models/heroes/omniknight/cape.vmdl", "models/items/omniknight/grey_night_back/grey_night_back.vmdl")
    SwapWearable(hero, "models/heroes/omniknight/hair.vmdl", "models/items/omniknight/grey_night_head/grey_night_head.vmdl")
    SwapWearable(hero, "models/heroes/omniknight/hammer.vmdl", "models/items/omniknight/grey_night_weapon/grey_night_weapon.vmdl")
    SwapWearable(hero, "models/heroes/omniknight/shoulder.vmdl", "models/items/omniknight/grey_night_shoulders/grey_night_shoulders.vmdl")
    SwapWearable(hero, "", "models/items/omniknight/misc_book_hierophant.vmdl")
  elseif hero:GetClassname() == "npc_dota_hero_drow_ranger" then
    SwapWearable(hero, "models/heroes/drow/drow_bracers.vmdl", "models/items/drow/black_wind_arms/black_wind_arms.vmdl")
    SwapWearable(hero, "models/heroes/drow/drow_cape.vmdl", "models/items/drow/black_wind_back/black_wind_back.vmdl")
    SwapWearable(hero, "models/heroes/drow/drow_haircowl.vmdl", "models/items/drow/black_wind_head/black_wind_head.vmdl")
    SwapWearable(hero, "models/heroes/drow/drow_legs.vmdl", "models/items/drow/black_wind_legs/black_wind_legs.vmdl")
    SwapWearable(hero, "models/heroes/drow/drow_quiver.vmdl", "models/items/drow/black_wind_quiver/black_wind_quiver.vmdl")
    SwapWearable(hero, "models/heroes/drow/drow_shoulders.vmdl", "models/items/drow/ti6_immortal_cape/mesh/drow_ti6_immortal_cape.vmdl")
    SwapWearable(hero, "models/heroes/drow/drow_weapon.vmdl", "models/items/drow/black_wind_weapon/black_wind_weapon.vmdl")
  elseif hero:GetClassname() == "npc_dota_hero_zuus" then
    SwapWearable(hero, "models/heroes/zeus/zeus_hair.vmdl", "models/heroes/zeus/zeus_hair_arcana.vmdl")
  end
end

function GameMode:ActionFilter( filterTable )
  local ability = EntIndexToHScript(filterTable['entindex_ability'])
  local order = filterTable['order_type']
  local target = EntIndexToHScript(filterTable['entindex_target'])
  local caster = EntIndexToHScript(filterTable['units']["0"])

  if order == DOTA_UNIT_ORDER_ATTACK_TARGET and caster:HasModifier("hyperion_modifier") then
    return true
  end
  if order == DOTA_UNIT_ORDER_CAST_TARGET or order == DOTA_UNIT_ORDER_TAUNT then 
    if target:HasModifier("modifier_generic_no_mod") then
      return false
    end
    return true
  end
  return true
end

function GameMode:OnPlayerPickHero( keys )
  local spawnedUnit = keys.hero
  local hero = EntIndexToHScript(keys.heroindex)
  local spawnedUnitIndex = EntIndexToHScript(keys.heroindex)
  GameMode:PrepareCosmetics(hero)
  if spawnedUnitIndex:GetClassname() == "npc_dota_hero_antimage" then
    spawnedUnitIndex:FindAbilityByName("betrayer_hunters_thirst_datadriven"):SetLevel(1)
    spawnedUnitIndex:AddAbility("betrayer_never_ending_hatred_datadriven")
    spawnedUnitIndex:FindAbilityByName("betrayer_never_ending_hatred_datadriven"):SetLevel(1)
    Timers:CreateTimer(0, function ()
      if spawnedUnitIndex:GetLevel() == 25 then
        spawnedUnitIndex:FindAbilityByName("betray_datadriven"):SetLevel(1)
        return nil
      end
      return 1.0
    end)
  elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_life_stealer" then
    spawnedUnitIndex:RemoveAbility("life_stealer_infest")
  elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_troll_warlord" then
    print()
  elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_beastmaster" then
    Timers:CreateTimer(FrameTime(), function ()
      if spawnedUnitIndex:GetLevel() == 25 then
        spawnedUnitIndex:FindAbilityByName("tough_exterior"):SetLevel(1)
        return nil
      end
      return 1.0
    end)
  elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_omniknight" then
    Timers:CreateTimer(0, function ()
      if spawnedUnitIndex:GetLevel() == 25 then
        spawnedUnitIndex:FindAbilityByName("sacred_duty_datadriven"):SetLevel(1)
        return nil
      end
      return 1.0
    end)
  elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_tiny" then
    Timers:CreateTimer(0, function ()
      if spawnedUnitIndex:HasModifier("modifier_item_ultimate_scepter") then
        spawnedUnitIndex:FindAbilityByName("war_club_datadriven"):SetLevel(1)
        return nil
      end
      return 1.0
    end)
    Timers:CreateTimer(0, function ()
      if spawnedUnitIndex:GetLevel() == 25 then
        spawnedUnitIndex:FindAbilityByName("lavaling_datadriven"):SetLevel(1)
        return nil
      end
      return 1.0
    end)
    elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_zuus" then
    Timers:CreateTimer(0, function ()
      if spawnedUnitIndex:GetLevel() == 25 then
        spawnedUnitIndex:FindAbilityByName("tough_exterior"):SetLevel(1)
        return nil
      end
      return 1.0  
    end)
    elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_oracle" then
    Timers:CreateTimer(0, function ()
      if spawnedUnitIndex:GetLevel() == 25 then
        spawnedUnitIndex:FindAbilityByName("oracle_telekinesis_datadriven"):SetLevel(1)
        return nil
      end
      return 1.0  
    end)
    elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_drow_ranger" then
    Timers:CreateTimer(0, function ()
      if spawnedUnitIndex:GetLevel() == 25 then
        spawnedUnitIndex:FindAbilityByName("dark_ranger_will_of_the_dead"):SetLevel(1)
        return nil
      end
      return 1.0  
    end)

  end
end

function GameMode:DamageFilter( filterTable  )
  local victim = EntIndexToHScript(filterTable['entindex_victim_const'])
  local inflictor = EntIndexToHScript(filterTable['entindex_attacker_const'])
  if victim:IsHero() then
  end
  if victim:HasModifier("modifier_rabid") and inflictor:IsRealHero() == false then
    local modifier = victim:FindModifierByName("modifier_rabid")
    if modifier ~= nil then
      local ability = modifier:GetAbility()
      filterTable.damage = filterTable.damage*ability:GetSpecialValueFor("incoming_damage_pct")
    end
  end

  if inflictor:HasModifier("modifier_rabid") and victim:IsRealHero() == false then
    local modifier = inflictor:FindModifierByName("modifier_rabid")
    if modifier ~= nil then
      local ability = modifier:GetAbility()
      filterTable.damage = filterTable.damage*ability:GetSpecialValueFor("bonus_damage_pct")
    end
  end

  if victim:HasModifier("modifier_damage_block_physical_attacks") and inflictor:IsRealHero() and filterTable['damagetype_const'] == 1 then
    local modifier = victim:FindModifierByName("modifier_damage_block_physical_attacks")
    if modifier ~= nil then
      local ability = modifier:GetAbility()
      filterTable.damage = filterTable.damage*ability:GetSpecialValueFor("post_block_percent")
    end
  end
  return true
end

function GameMode:ModifierFilter( filterTable  )
    local target_index = filterTable['entindex_parent_const']
    local caster_index = filterTable['entindex_caster_const']
    local ability_index = filterTable["entindex_ability_const"]
    if not target_index or not caster_index or not ability_index then
        return true
    end

    local ability = EntIndexToHScript(ability_index)
    local target = EntIndexToHScript(target_index)
    local caster = EntIndexToHScript(caster_index)
    local modifierName = filterTable["name_const"]

    if modifierName == "modifier_boots_of_travel_incoming" then return true end

    if modifierName == "modifier_teleporting" then return true end

    if target:HasModifier("modifier_generic_no_mod") then
      if target == caster or caster:GetOwner() == target then
        return true
      else
        caster:Stop()
        return false
      end
    end
    if target:HasModifier("modifier_immune_stun") then
      for _,v in ipairs(GameRules.GameMode.stun_list) do
        if modifierName == v then
          return false
        end
      end
    end
    if target:HasModifier("modifier_immune_hex") then
      for _,v in ipairs(GameRules.GameMode.hex_list) do
        if modifierName == v then 
          return false
        end
      end
  end
    if target:HasModifier("modifier_immune_root") then
      for _,v in ipairs(GameRules.GameMode.root_list) do
        if modifierName == v then
          return false
        end
      end
  end
    if target:HasModifier("modifier_immune_disarm") then
      for _,v in ipairs(GameRules.GameMode.disarm_list) do
        if modifierName == v then
          return false
        end
      end
  end    
    if target:HasModifier("modifier_immune_banish") then
      for _,v in ipairs(GameRules.GameMode.banish_list) do
        if modifierName == v then
          return false
        end
      end
  end
    if target:HasModifier("modifier_immune_motion") then
      for _,v in ipairs(GameRules.GameMode.motion_mod_list) do
        if modifierName == v then
          return false
        end
      end
  end
    if target:HasModifier("modifier_generic_disable_immunity") then
      for _,v in ipairs(GameRules.GameMode.disable_list) do
        if modifierName == v then
          return false
        end
      end
    end

    if target:HasModifier("modifier_reduce_disable_duration") then
      local reductionFactor = target:FindModifierByName("modifier_reduce_disable_duration").reductionFactor
        for _,v in ipairs(GameRules.GameMode.stun_list) do
            if modifierName == v then
                Timers:CreateTimer(FrameTime(), function()
                    local mod = target:FindModifierByName(modifierName)
                    mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
                    return nil
                end)
            end
        end
        for _,v in ipairs(GameRules.GameMode.hex_list) do
            if modifierName == v then 
                Timers:CreateTimer(FrameTime(), function()
                    local mod = target:FindModifierByName(modifierName)
                    mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
                    return nil
                end)
            end
        end
        for _,v in ipairs(GameRules.GameMode.root_list) do
            if modifierName == v then
                Timers:CreateTimer(FrameTime(), function()
                    local mod = target:FindModifierByName(modifierName)
                    mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
                    return nil
                end)
            end
        end
      for _,v in ipairs(GameRules.GameMode.disarm_list) do
            if modifierName == v then
                Timers:CreateTimer(FrameTime(), function()
                    local mod = target:FindModifierByName(modifierName)
                    mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
                    return nil
                end)
            end
      end
        for _,v in ipairs(GameRules.GameMode.banish_list) do
            if modifierName == v then
                Timers:CreateTimer(FrameTime(), function()
                    local mod = target:FindModifierByName(modifierName)
                    mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
                    return nil
                end)
            end
        end    
        for _,v in ipairs(GameRules.GameMode.motion_mod_list) do
            if modifierName == v then
                Timers:CreateTimer(FrameTime(), function()
                    local mod = target:FindModifierByName(modifierName)
                    mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
                    return nil
                end)
            end
        end
        for _,v in ipairs(GameRules.GameMode.disable_list) do
            if modifierName == v then
                Timers:CreateTimer(FrameTime(), function()
                    local mod = target:FindModifierByName(modifierName)
                    mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
                    return nil
                end)
            end
        end     
    return true
  end
  return true
end

function GameMode:OnGameInProgress()
  DebugPrint("[GameMode] The game has officially begun")
end


-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()  
  print("Debug..Initializing")
  ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnHeroInGame'), self)
  ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(GameMode, 'OnIllusionsCreated'), self)
  ListenToGameEvent("npc_spawned", Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)

  GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierFilter"), self)
  GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(GameMode, "ActionFilter"), self)

  print("Debug..Filters Loaded")

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
  DebugPrint('[GameMode] Starting to load GameMode GameMode...')
  DebugPrint('[GameMode] Done loading GameMode GameMode!\n\n')  
  DebugPrint('[BAREBONES] Starting to load Barebones GameMode...')
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end
end