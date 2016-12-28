
function GemTowerDefenseReborn:OnPlayerLevelUp(keys)

	local player = keys.player
	local level = keys.level
	
	local hero = player:GetAssignedHero()
	hero:SetAbilityPoints(iPoints)
	
	Random:SetXPLevel(level)

end


function GemTowerDefenseReborn:OnPlayerPickHero(keys)

	Builder:IncrementPlayerCount()

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = player:GetPlayerID()

	Players:RemoveTalents(hero)
	Builder:AddAbilitiesOnStart(hero)
	
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
