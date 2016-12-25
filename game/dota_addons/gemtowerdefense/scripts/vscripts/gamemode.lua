
--Created by cro_madbomber
--Gem TD Reborn Dota 2 Version
--Version 0.2



function GemTowerDefenseReborn:InitGameMode()
	
	Grid:Init()
	Builder:Init()
	Rounds:Init(wavesKV)
	Random:Init()
	
	
	print("DEBUG: TOTAL PLAYER COUNT ", PLAYER_COUNT)

	towersKV 	= LoadKeyValues("scripts/kv/towers.kv")
	wavesKV 	= LoadKeyValues("scripts/kv/waves.kv")
	settingsKV 	= LoadKeyValues("scripts/kv/settings.kv")
	randomKV	= LoadKeyValues("scripts/kv/random.kv") 

	GameRules:SetTimeOfDay(0.5)
	-- GameRules:GetGameModeEntity():SetCameraDistanceOverride(1400)
	GameRules:SetHeroSelectionTime(20.0)
	GameRules:SetPreGameTime(0)
	GameRules:SetGoldPerTick(0)
	GameRules:SetGoldTickTime(0)
	GameRules:SetStartingGold(0)
--	setgold
	
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

	PlayerResource:SetCustomPlayerColor(0, 255, 0, 0)
	PlayerResource:SetCustomPlayerColor(1, 0, 255, 0)
	PlayerResource:SetCustomPlayerColor(2, 0, 0, 255)
	PlayerResource:SetCustomPlayerColor(3, 255, 255, 255)


	--SetCustomGameForceHero("npc_dota_hero_crystal_maiden")
	--Event handlers

	ListenToGameEvent('entity_killed', Dynamic_Wrap(GemTowerDefenseReborn, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GemTowerDefenseReborn, 'OnPlayerPickHero'), self)
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GemTowerDefenseReborn, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GemTowerDefenseReborn, 'OnConnectFull'), self)


	TOTAL_PLAYER_COUNT = 0

	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel(settingsKV.CustomXPTable)
	GameRules:SetUseCustomHeroXPValues(true)

	


end


GameRules.BaseHealthPoint = 100
GameRules.IsBuildReady = true
GameRules.EnemyKillCount = 0
GameRules.Enemies = {}















