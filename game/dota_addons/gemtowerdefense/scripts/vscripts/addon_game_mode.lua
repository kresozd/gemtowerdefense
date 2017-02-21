-- Generated from template

if GemTowerDefenseReborn == nil then
	_G.GemTowerDefenseReborn = class({})
end


require('gamemode')
require('random')
require('libraries/timers')
require('grid')
require('events')
require('libraries/selection')
require('wave')
require('builder/builder')
require('builder/builderAbilities')
require('builder/towerAbilities')
require('settings')
require('players')
require('customEvents')
require('heroselection')
require('sandbox')
require('containers')
require('throne')
require('gamedata')
require('custom_items/gem_items')
require('custom_items/gem_items_Abilities')
--Pathfinder


function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
			
	]]

PrecacheResource("particle", "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_red.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_blue_plus.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_green.vpcf", context)
	PrecacheResource("particle", "particles/econ/courier/courier_hyeonmu_ambient/courier_hyeonmu_ambient_magic_gold.vpcf", context)

	PrecacheResource("particle", "particles/units/heroes/hero_vengeful/vengeful_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_templar_assassin/templar_assassin_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_leshrac/leshrac_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_base_attack.vpcf", context)
	PrecacheResource("particle", "particles/econ/events/snowball/snowball_projectile.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/hero_medusa/medusa_base_attack.vpcf", context)
	--Silver
	PrecacheResource("particle", "particles/units/heroes/hero_tinker/tinker_laser.vpcf", context)
	--Volcano
	PrecacheResource("particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", context)
	--Quartz
	PrecacheResource("particle", "particles/items3_fx/star_emblem_brokenshield_caster.vpcf", context)
	--Charming Lazurite
	PrecacheResource("particle", "particles/econ/items/crystal_maiden/crystal_maiden_maiden_of_icewrack/maiden_freezing_field_casterribbons_arcana1.vpcf", context)
	--Charming Lazurite
	PrecacheResource("particle", "particles/econ/items/puck/puck_alliance_set/puck_base_attack_aproset.vpcf", context)
	--Jade
	PrecacheResource("particle", "particles/units/heroes/hero_enchantress/enchantress_base_attack.vpcf", context)
	--Emerald Golem
	PrecacheResource("particle","particles/units/heroes/hero_visage/visage_base_attack.vpcf", context)
	--Yellow Sapphire
	PrecacheResource("particle", "particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_status_ice.vpcf", context)
	--Gold
	PrecacheResource("particle", "particles/items_fx/desolator_projectile.vpcf", context)
	--Pink Diamond
	PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context)
	PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts",context)
	--Huge Pink Diamond
	PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", context)
	--Bloodstone
	PrecacheResource("particle", "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf", context)
	--Antique Bloodstone
	PrecacheResource("particle", "particles/units/heroes/hero_shadowshaman/shadowshaman_ether_shock.vpcf", context)
	PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts",context)
	--Uranium 238
	PrecacheResource("particle", "particles/units/heroes/hero_razor/razor_static_link_projectile_a.vpcf", context)
	--Paraiba
	PrecacheResource("particle", "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", context)
	--Elaborately Carved
	PrecacheResource("particle", "particles/econ/items/enchantress/enchantress_virgas/ench_impetus_virgas.vpcf", context)
	--DeepSea Pearl
	PrecacheResource("particle", "particles/units/heroes/hero_silencer/silencer_base_attack.vpcf", context)

	PrecacheResource("particle", "particles/units/heroes/hero_invoker/invoker_deafening_blast_disarm_debuff.vpcf", context)

	PrecacheResource("particle", "particles/customgames/capturepoints/cp_metal_captured.vpcf", context)

	PrecacheResource("particle","particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost_explosion.vpcf",context)

	PrecacheResource("particle", "particles/units/heroes/hero_enchantress/enchantress_untouchable.vpcf", context)

	PrecacheResource( "model", "models/props_tree/topiary/topiary001.vmdl", context )

	PrecacheResource("soundfile","soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts",context)
	PrecacheResource("soundfile","BodyImpact_Common.Heavy",context)


	PrecacheResource("soundfile",	"soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context )
	PrecacheResource("particle",	"particles/units/heroes/hero_medusa/medusa_stone_gaze_active.vpcf", context )
	PrecacheResource("particle",	"particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff.vpcf", context )
	PrecacheResource("particle",	"particles/units/heroes/hero_medusa/medusa_stone_gaze_facing.vpcf", context )
	PrecacheResource("particle",	"particles/units/heroes/hero_medusa/medusa_stone_gaze_debuff_stoned.vpcf", context )
	PrecacheResource("particle",	"particles/status_fx/status_effect_medusa_stone_gaze.vpcf", context )
end

-- Create the game mode when we activate
function Activate()
    GemTowerDefenseReborn:InitGameMode()
end