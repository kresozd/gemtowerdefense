
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
	Rounds:SetPlayer(playerID)
	
	hero:SetAbilityPoints(0)

--	Players:UpdateChosenHero()

end

function GemTowerDefenseReborn:OnConnectFull(keys)

	local entIndex = keys.index+1
  	local player = EntIndexToHScript(entIndex)

	Builder:SetPlayerCount(entIndex)
  
  	local playerID = player:GetPlayerID()
	  print("PLAYER ID ON CONNECT:", playerID)

	Players:SetAmount(entIndex)
	Rounds:SetPlayer(playerID)


end

function GemTowerDefenseReborn:OnEntityKilled(keys)

	local Player = PlayerResource:GetPlayer(0)
	local Hero = Player:GetAssignedHero()
	local PlayerID = Player:GetPlayerID()

	
	
	local unit = EntIndexToHScript(keys.entindex_killed)
	local eHandle = unit:GetEntityHandle()

	CustomNetTables:SetTableValue( "game_state", "unit_killed", { value = eHandle } )

	Hero:AddExperience(unit.XPBounty, 0, false, false)
	PlayerResource:ModifyGold(0, unit.GoldBounty, false, 0)

	Rounds:DeleteUnit(eHandle)
	Rounds:IncrementKillNumber()

end


function GemTowerDefenseReborn:OnWaveEnd()

	Rounds:ResetAmountOfKilled()
	Rounds:IncrementRound()
	CustomNetTables:SetTableValue( "game_state", "current_round", { value = Rounds:GetRoundNumber() } )
	Rounds:Build()

end

function GemTowerDefenseReborn:OnAllPicked()

	--pass playerID
	print("Panorama Event. All Picked!")



end