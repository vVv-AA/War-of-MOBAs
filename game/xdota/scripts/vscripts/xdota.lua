-- This is the primary xdota xdota script and should be used to assist in initializing your game mode
XDOTA_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by xdota
-- You can also change the cvar 'xdota_spew' at any time to 1 or 0 for output/no output
XDOTA_DEBUG_SPEW = false 

if XDota == nil then
		DebugPrint( '[XDOTA] creating xdota game mode' )
		_G.XDota = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.	See PhysicsReadme.txt for more information.
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

-- These internal libraries set up xdota's events and processes.	Feel free to inspect them/change them if you need to.
require('internal/xdota')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core xdota files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core xdota files.
require('events')

-- talents.lua is where we will handle talent ability logic.
require('mechanics/talents')


-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
	require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
	This function should be used to set up Async precache calls at the beginning of the gameplay.

	In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.	These calls will be made
	after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
	be used to precache dynamically-added datadriven abilities instead of items.	PrecacheUnitByNameAsync will 
	precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
	defined on the unit.

	This function should only be called once.	If you want to/need to precache more items/abilities/units at a later
	time, you can call the functions individually (for example if you want to precache units in a new wave of
	holdout).

	This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function XDota:PostLoadPrecache()
	DebugPrint("[XDOTA] Performing Post-Load precache")		
end

--[[
	This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
	It can be used to initialize state that isn't initializeable in InitXDota() but needs to be done before everyone loads in.
]]
function XDota:OnFirstPlayerLoaded()
	DebugPrint("[XDOTA] First Player has loaded")
end

--[[
	This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
	It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function XDota:OnAllPlayersLoaded()
	DebugPrint("[XDOTA] All Players have loaded into the game")
end

--[[
	This function is called once and only once for every player when they spawn into the game for the first time.	It is also called
	if the player's hero is replaced with a new hero for any reason.	This function is useful for initializing heroes, such as adding
	levels, changing the starting gold, removing/adding abilities, adding physics, etc.

	The hero parameter is the hero entity that just spawned in
]]
function XDota:OnHeroInGame(hero)
	XDota:PrepareCosmetics(EntIndexToHScript(hero.entindex))
end

--[[
	This function is called once and only once when the game completely begins (about 0:00 on the clock).	At this point,
	gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.	This function
	is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function XDota:OnGameInProgress()
	DebugPrint("[XDOTA] The game has officially begun")

	Timers:CreateTimer(30, function()
		DebugPrint("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
		return 30.0 -- Rerun this timer every 30 game-time seconds 
	end)
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function XDota:InitGameMode()
	XDota = self
	DebugPrint('[XDOTA] Starting to load XDota xdota...')

	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(XDota, 'OnPlayerPickHero'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(XDota, 'OnHeroInGame'), self)
	ListenToGameEvent("dota_illusions_created", Dynamic_Wrap(XDota, 'OnIllusionsCreated'), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(XDota, 'OnNPCSpawned'), self)
	ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(XDota, 'OnUpgradeAbility'), self)

	GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(XDota, "ModifierFilter"), self)
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(XDota, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(XDota, "ActionFilter"), self)
	GameRules:GetGameModeEntity():SetThink( "XpThink", self, "ExperienceThink", 0.25 )

	print("Debug..Filters Loaded")

	-- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
	Convars:RegisterCommand( "command_example", Dynamic_Wrap(XDota, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )
	DebugPrint('[GameMode] Starting to load GameMode GameMode...')
	DebugPrint('[GameMode] Done loading GameMode GameMode!\n\n')  
	DebugPrint('[BAREBONES] Starting to load Barebones GameMode...')
end

-- This is an example console command
function XDota:ExampleConsoleCommand()
	print( '******* Example Console Command ***************' )
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		if playerID ~= nil and playerID ~= -1 then
			-- Do something here for the player who called this command
			PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
		end
	end

	print( '*********************************************' )
end

function XDota:OnUpgradeAbility( keys )
    if PlayerResource:IsValidPlayer(keys.player - 1) then
        local hero = PlayerResource:GetSelectedHeroEntity( keys.player - 1)
		local ability = hero:FindAbilityByName(keys.abilityname)
		Upgrade(hero, ability)
	end
end

function XDota:PrepareCosmetics(hero)
	if hero:GetClassname() == "npc_dota_hero_antimage" then
		SwapWearable(hero, "models/heroes/antimage/antimage_weapon.vmdl", "models/items/antimage/arc_of_manta/arc_of_manta.vmdl")
		SwapWearable(hero, "models/heroes/antimage/antimage_offhand_weapon.vmdl", "models/items/antimage/arc_of_manta__offhand/arc_of_manta__offhand.vmdl")
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
	elseif hero:GetClassname() == "npc_dota_hero_sniper" then
		SwapWearable(hero, "models/heroes/sniper/bracer.vmdl", "models/items/sniper/heavymetal_arms/heavymetal_arms.vmdl")
		SwapWearable(hero, "models/heroes/sniper/cape.vmdl", "models/items/sniper/heavymetal_back/heavymetal_back.vmdl")
		SwapWearable(hero, "models/heroes/sniper/headitem.vmdl", "models/items/sniper/mlg_hunters_origin_head/mlg_hunters_origin_head.vmdl")
		SwapWearable(hero, "models/heroes/sniper/shoulder.vmdl", "models/items/sniper/heavymetal_shoulder/heavymetal_shoulder.vmdl")
		SwapWearable(hero, "models/heroes/sniper/weapon.vmdl", "models/items/sniper/machine_gun_charlie/machine_gun_charlie.vmdl")
	end
end

function XDota:ActionFilter( filterTable )
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

function XDota:OnPlayerPickHero( keys )
	local spawnedUnit = keys.hero
	local hero = EntIndexToHScript(keys.heroindex)
	local spawnedUnitIndex = EntIndexToHScript(keys.heroindex)
	if spawnedUnitIndex:GetClassname() == "npc_dota_hero_antimage" then
		spawnedUnitIndex:FindAbilityByName("betrayer_hunters_thirst_datadriven"):SetLevel(1)
	elseif spawnedUnitIndex:GetClassname() == "npc_dota_hero_life_stealer" then
		spawnedUnitIndex:RemoveAbility("life_stealer_infest")
	end
end

function XDota:DamageFilter( filterTable)
	local victim = EntIndexToHScript(filterTable['entindex_victim_const'])
	if filterTable['entindex_attacker_const'] ~= nil then
		local inflictor = EntIndexToHScript(filterTable['entindex_attacker_const'])

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
	return true
end

function XDota:ModifierFilter( filterTable	)
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
			for _,v in ipairs(GameRules.XDota.stun_list) do
				if modifierName == v then
					return false
				end
			end
		end

		if target:HasModifier("modifier_immune_hex") then
			for _,v in ipairs(GameRules.XDota.hex_list) do
				if modifierName == v then 
					return false
				end
			end
		end

		if target:HasModifier("modifier_immune_root") then
			for _,v in ipairs(GameRules.XDota.root_list) do
				if modifierName == v then
					return false
				end
			end
		end

		if target:HasModifier("modifier_immune_disarm") then
			for _,v in ipairs(GameRules.XDota.disarm_list) do
				if modifierName == v then
					return false
				end
			end
		end

		if target:HasModifier("modifier_immune_banish") then
			for _,v in ipairs(GameRules.XDota.banish_list) do
				if modifierName == v then
					return false
				end
			end
		end
		if target:HasModifier("modifier_immune_motion") then
			for _,v in ipairs(GameRules.XDota.motion_mod_list) do
				if modifierName == v then
					return false
				end
			end
		end

		if target:HasModifier("modifier_generic_disable_immunity") then
			for _,v in ipairs(GameRules.XDota.disable_list) do
				if modifierName == v then
					return false
				end
			end
		end

		if target:HasModifier("modifier_reduce_disable_duration") then
			local reductionFactor = target:FindModifierByName("modifier_reduce_disable_duration").reductionFactor
			for _,v in ipairs(GameRules.XDota.stun_list) do
				if modifierName == v then
					Timers:CreateTimer(FrameTime(), function()
							local mod = target:FindModifierByName(modifierName)
							mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
							return nil
					end)
				end
			end

			for _,v in ipairs(GameRules.XDota.hex_list) do
				if modifierName == v then 
					Timers:CreateTimer(FrameTime(), function()
							local mod = target:FindModifierByName(modifierName)
							mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
							return nil
					end)
				end
			end

			for _,v in ipairs(GameRules.XDota.root_list) do
				if modifierName == v then
					Timers:CreateTimer(FrameTime(), function()
							local mod = target:FindModifierByName(modifierName)
							mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
							return nil
					end)
				end
			end

			for _,v in ipairs(GameRules.XDota.disarm_list) do
				if modifierName == v then
						Timers:CreateTimer(FrameTime(), function()
								local mod = target:FindModifierByName(modifierName)
								mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
								return nil
						end)
				end
			end
			for _,v in ipairs(GameRules.XDota.banish_list) do
				if modifierName == v then
					Timers:CreateTimer(FrameTime(), function()
							local mod = target:FindModifierByName(modifierName)
							mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
							return nil
					end)
				end
			end
			for _,v in ipairs(GameRules.XDota.motion_mod_list) do
				if modifierName == v then
					Timers:CreateTimer(FrameTime(), function()
							local mod = target:FindModifierByName(modifierName)
							mod:SetDuration(mod:GetRemainingTime()*reductionFactor, true)
							return nil
					end)
				end
			end
			for _,v in ipairs(GameRules.XDota.disable_list) do
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

function XDota:XpThink()
    -- Check if the game is actual over
    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    else
        -- Loop for every Player
        for xpPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
            if PlayerResource:GetSelectedHeroEntity(xpPlayerID) ~= nil then
            	XDota:CheckMaxLevel(PlayerResource:GetSelectedHeroEntity(xpPlayerID))
            end
        end
        -- Repeater Thinker every 0.25 seconds
        return 0.25
    end
end

function XDota:CheckMaxLevel(hero)
	if hero:GetLevel() < 25 then
		return
	end

	if hero:GetClassname() == "npc_dota_hero_life_stealer" then
		hero:RemoveAbility("life_stealer_infest")
	elseif hero:GetClassname() == "npc_dota_hero_tiny" then
		hero:FindAbilityByName("lavaling_datadriven"):SetLevel(1)
	elseif hero:GetClassname() == "npc_dota_hero_oracle" then
		hero:FindAbilityByName("oracle_telekinesis_datadriven"):SetLevel(1)
	end
end