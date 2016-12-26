
function GemTowerDefenseReborn:OnPlayerLevelUp(keys)

	local player = keys.player
	local level = keys.level
	
	local hero = player:GetAssignedHero()
	hero:SetAbilityPoints(iPoints)
	
	Random:SetXPLevel(level)

end

function GemTowerDefenseReborn:OnPlayerPickHero(keys)

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = player:GetPlayerID()
	Rounds:RemoveTalents(hero)
	Rounds:AddBuildAbility(hero)
	--Rounds:AddHeroAbilitiesOnRound()
	Rounds:SetPlayer(playerID)

	hero:SetAbilityPoints(0)
	
	TOTAL_PLAYER_COUNT = TOTAL_PLAYER_COUNT + 1
	print("PLAYER COUNT: ", TOTAL_PLAYER_COUNT)


end

function GemTowerDefenseReborn:OnConnectFull(keys)

	local entIndex = keys.index+1
	print("PRINTING ENTITY INDEX:", entIndex)
  	local player = EntIndexToHScript(entIndex)
	Builder:SetPlayerCount(entIndex)
  
  	local playerID = player:GetPlayerID()
	  print("PLAYER ID ON CONNECT:", playerID)

	Rounds:SetPlayer(playerID)


end

function GemTowerDefenseReborn:OnEntityKilled(keys)
--entindex_attacker ( long )
	local Player = PlayerResource:GetPlayer(0)
	local Hero = Player:GetAssignedHero()
	local PlayerID = Player:GetPlayerID()
	
	local unit = EntIndexToHScript(keys.entindex_killed)
	local eHandle = unit:GetEntityHandle()

	Hero:AddExperience(unit.XPBounty, 0, false, false)
	PlayerResource:ModifyGold(0, unit.GoldBounty, false, 0)

	Rounds:DeleteUnit(eHandle)
	Rounds:IncrementKillNumber()

	if Rounds:IsRoundCleared() then

		Rounds:ResetAmountOfKilled()
		Rounds:IncrementRound()
		CustomNetTables:SetTableValue( "game_state", "current_round", { value = Rounds:GetRoundNumber() } )
		
		
		Rounds:Build()

	end

end