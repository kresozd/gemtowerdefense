
function GemTowerDefenseReborn:OnPlayerLevelUp(keys)

	local level = keys.level
	local player = EntIndexToHScript(keys.player)
	
	local hero = player:GetAssignedHero()
	hero:SetAbilityPoints(0)
	
	Random:SetXPLevel(level)

end


function GemTowerDefenseReborn:SetPlayerHero(event)
	
	HeroSelection:IncremetHeroPickCount()
	
	local hero = event.selected_hero
	local player = event.PlayerID
	
	
	PlayerResource:ReplaceHeroWith(player, hero, 0, 0)
	if HeroSelection:AllPicked() then

	HeroSelection:UnlockAbilities()
	

	end

	


end


function GemTowerDefenseReborn:OnPlayerPickHero(keys)

	

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = player:GetPlayerID()

	hero:SetAbilityPoints(0)

--ONLY FOR BOTS TESTING
	
	if IsInToolsMode() then


		if hero:GetUnitName() ~= "npc_dota_hero_crystal_maiden" then

		Players:RemoveTalents(hero)
		Builder:AddAbilitiesOnStart(hero)
	
		hero:SetAbilityPoints(0)

	end

	end

end

function GemTowerDefenseReborn:OnConnectFull(keys)

	local entIndex = keys.index+1
  	local player = EntIndexToHScript(entIndex)
  	local playerID = player:GetPlayerID()

end


function GemTowerDefenseReborn:OnStateChange(keys)

	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
	end
		
	if state == DOTA_GAMERULES_STATE_PRE_GAME then

		for i = 1,table.maxn(Builder.StartingTrees[PlayerResource:GetPlayerCount()]) do

			local x = Builder.StartingTrees[PlayerResource:GetPlayerCount()][i].x
			local y = Builder.StartingTrees[PlayerResource:GetPlayerCount()][i].y

			local position = Vector((x-19)*128,(y-19)*128,256)
			position = Grid:CenterEntityToGrid(position)

			Grid:BlockNavigationSquare(position)

			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()
			Builder.DummyTowers[eHandle] = tower
			
			tower:SetAbsOrigin(position)
			tower:SetHullRadius(TOWER_HULL_RADIUS)

		end
	end
	

		
    if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		--local pAmount = PlayerResource:GetTeamPlayerCount()
		
		--Builder:SetPlayerCount(pAmount)
	end

end

function GemTowerDefenseReborn:OnPlayerChat(keys)

	local tokens =  string.split(string.trim(keys.text))
	if tokens[1] == "-create_tower" and Rounds.State == "BUILD" then
		Builder.TowerTestName = tokens[2]
	end
	print(Builder.TowerTestName)
end

function string.trim(s)
	return s:match "^%s*(.-)%s*$"
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.split(s, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(s, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

--[[		

]]--