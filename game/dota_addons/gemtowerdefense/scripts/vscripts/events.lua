
function GemTowerDefenseReborn:OnPlayerLevelUp(keys)

	local level = keys.level
	Random:SetXPLevel(level)

end

function GemTowerDefenseReborn:OnPlayerPickHero(keys)

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = player:GetPlayerID()
	
	--Rounds:AddHeroAbilitiesOnRound()


	TOTAL_PLAYER_COUNT = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	print("PLAYER COUNT: ", TOTAL_PLAYER_COUNT)

end

function GemTowerDefenseReborn:OnConnectFull(keys)

	


end

function GemTowerDefenseReborn:OnEntityKilled(keys)

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