-- Generated from template

if GemTowerDefenseReborn == nil then
	_G.GemTowerDefenseReborn = class({})
end

--require('socket')
require('gamemode')
require('random')
require('libraries/timers')
require('grid')
require('events')
--require('builder')
require('abilities')
require('libraries/selection')
require('rounds')

require('builder/builder')
require('builder/builderAbilities')
require('builder/towerAbilities')

require('settings')
require('players')
require('customEvents')


--Pathfinder


function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
			
	]]

	PrecacheResource("particle", "particles/econ/events/snowball/snowball_projectile.vpcf", context)
	PrecacheResource( "model", "models/props_tree/topiary/topiary001.vmdl", context )
	
end

-- Create the game mode when we activate
function Activate()
    GemTowerDefenseReborn:InitGameMode()
end