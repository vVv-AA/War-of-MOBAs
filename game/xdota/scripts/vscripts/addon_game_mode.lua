require('internal/util')
require('mechanics/wearables')
require('gamemode')

function Precache( context )
--[[
	This function is used to precache resources/units/item	s/abilities that will be needed
	for sure in your game and that will not be precached by hero selection.	When a hero
	is selected from the hero selection screen, the game will precache that hero's assets,
	any equipped cosmetics, and perform the data-driven precaching defined in that hero's
	precache{} block, as well as the precache{} block for any equipped abilities.

	See GameMode:PostLoadPrecache() in GameMode.lua for more information
	]]

	DebugPrint("[GameMode] Performing pre-load precache")

	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
	PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
	PrecacheResource("particle_folder", "particles/test_particle", context)
	PrecacheResource("model_folder", "models/heroes/tiny_04", context)
	PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
	PrecacheModel("models/heroes/viper/viper.vmdl", context)
	--PrecacheModel("models/props_gameplay/treasure_chest001.vmdl", context)
	--PrecacheModel("models/props_debris/merchant_debris_chest001.vmdl", context)
	--PrecacheModel("models/props_debris/merchant_debris_chest002.vmdl", context)

	-- Sounds can precached here like anything else
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)

	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name
	PrecacheItemByNameSync("example_ability", context)
	PrecacheItemByNameSync("item_example_item", context)

	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
		print("Debug..Initializing disable list")
		GameRules.GameMode.stun_list = {
		"modifier_abyssal_underlord_pit_of_malice_ensare",
		"modifier_ancientapparition_coldfeet_freeze",
		"modifier_bane_fiends_grip", -- does not work
		"modifier_bane_nightmare", -- does not work
		"modifier_centaur_hoof_stomp",
		"modifier_crystal_maiden_frostbite_ministun",
		"modifier_disabled_invulnerable",
		"modifier_bane_nightmare",
		"modifier_earthshaker_fissure_stun",
		"modifier_enigma_malefice",
		"modifier_faceless_void_chronosphere_freeze",
		"modifier_faceless_void_timelock_freeze",
		"modifier_faceless_void_time_lock",
		"modifier_invoker_cold_snap_freeze",
		"modifier_jakiro_ice_path_stun",
		"modifier_keeper_of_the_light_mana_leak_stun",
		"modifier_kunkka_torrent",
		"modifier_lion_impale",
		"modifier_medusa_stone_gaze_stone",
		"modifier_morphling_adaptive_strike",
		"modifier_nyx_assassin_impale",
		"modifier_pudge_dismember",  -- does not work, damage_inbuilt
		"modifier_rubick_telekinesis_stun",
		"modifier_rubick_telekinesis",
		"modifier_sandking_impale",
		"modifier_shadow_shaman_shackles", -- does not work
		"modifier_bashed",
		"modifier_stunned",
		"modifier_techies_stasis_trap_stunned",
		"modifier_tiny_avalanche_stun",
		"modifier_windrunner_shackle_shot",
		"modifier_tusk_walrus_punch_air_time",
		"modifier_knockback",
		"modifier_necrolyte_reapers_scythe", --stun + damage inbuilt
		"modifier_tidehunter_ravage",
		"modifier_treant_overgrowth", -- does not work
		"modifier_winter_wyvern_cold_embrace", -- does not work
		"modifier_brewmaster_storm_cyclone",
		"modifier_eul_cyclone",
		"modifier_generic_stun",
	}
	GameRules.GameMode.root_list = {
		"modifier_crystal_maiden_frostbite", --root
		"modifier_dark_troll_warlord_ensnare", --root
		"modifier_ember_spirit_searing_chains", --root
		"modifier_lone_druid_spirit_bear_entangle", --root
		"modifier_lone_druid_spirit_bear_entangle_effect", --root
		"modifier_meepo_earthbind",  -- does not work
		"modifier_naga_siren_ensnare", --root
		"modifier_rooted", --root
		"modifier_treant_overgrowth", --root
		"modifier_ember_spirit_searing_chains",
		"modifier_treant_overgrowth", -- not stop
		"modifier_generic_root",
	}
	GameRules.GameMode.disable_list = {
		"modifier_elder_titan_echo_stomp", --sleep ?? 
		"modifier_naga_siren_song_of_the_siren",
	}
	GameRules.GameMode.disarm_list = {
		"modifier_disarmed", --disarm
		"modifier_heavens_halberd_debuff", --disarm
		"modifier_invoker_deafening_blast_disarm", --disarm
		"modifier_generic_disarm",
	}	
	GameRules.GameMode.motion_mod_list = {
		"modifier_beastmaster_prima_roar_push",
		"modifier_dark_seer_vacuum", -- + stuns
		"modifier_storm_spirit_electric_vortex_pull",
		"modifier_elder_titan_echo_stomp",
		"modifier_enigma_black_hole_pull",
		"modifier_knockback",
		"modifier_rattletrap_cog_push",
		"modifier_vengefulspirit_nether_swap", -- does not stop
		"modifier_followthrough", -- either below  -- does not stop
		"modifier_pudge_meat_hook", -- either above  -- does not stop

	}
	GameRules.GameMode.hex_list = {
		"modifier_lion_voodoo", --hex
		"modifier_necrolyte_reapers_scythe", --hex
		"modifier_shadow_shaman_voodoo", --hex
		"modifier_sheepstick_debuff", --hex
		"modifier_generic_hex",
	}
	GameRules.GameMode.banish_list = {
		"modifier_obsidian_destroyer_astral_imprisonment_prison",
		"modifier_shadow_demon_disruption",
		"modifier_earthspirit_petrify",
		"modifier_generic_banish",
	}

	GameRules.GameMode.interrupt_list = {
		"modifier_invoker_tornado",
		"modifier_kunkka_x_marks_the_spot",
		"modifier_lone_druid_savage_roar",
		"modifier_magnataur_reverse_polarity",
		"modifier_magnataur_skewer_impact",
	}
	GameRules.GameMode:InitGameMode()
end