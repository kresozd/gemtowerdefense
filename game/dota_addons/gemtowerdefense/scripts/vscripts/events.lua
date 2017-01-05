
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

end

function GemTowerDefenseReborn:OnConnectFull(keys)

	local entIndex = keys.index+1
  	local player = EntIndexToHScript(entIndex)
  	local playerID = player:GetPlayerID()

end

function GemTowerDefenseReborn:OnStateChange(keys)

	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		
    elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		--local pAmount = PlayerResource:GetTeamPlayerCount()
		
		--Builder:SetPlayerCount(pAmount)

	end

end
