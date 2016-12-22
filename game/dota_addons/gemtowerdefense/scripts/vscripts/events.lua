
function GemTowerDefenseReborn:OnPlayerLevelUp(keys)

	local level = keys.level
	Random:SetXPLevel(level)

end

function GemTowerDefenseReborn:OnPlayerPickHero(keys)

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = player:GetPlayerID()

	TOTAL_PLAYER_COUNT = PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
	print("PLAYER COUNT: ", TOTAL_PLAYER_COUNT)

end


function GemTowerDefenseReborn:OnEntityKilled(keys)

	local Player = PlayerResource:GetPlayer(0)
	local Hero = Player:GetAssignedHero()
	

	local killedUnit = EntIndexToHScript(keys.entindex_killed)
	local eHandle = killedUnit:GetEntityHandle()

	print("Unit Handle is: ", eHandle)
	
	Hero:AddExperience(killedUnit.XPBounty, 0, false, false)


	Rounds:DeleteByHandle(eHandle)
	Rounds:IncrementKillNumber()

	killedUnit:Destroy()

	print("Amount of killed!: ", Rounds:GetAmountOfKilled())

	if Rounds:GetAmountOfKilled() == 10 then

		Rounds:ResetAmountOfKilled()
		Rounds:IncrementRound()
		CustomNetTables:SetTableValue( "game_state", "current_round", { value = Rounds:GetRoundNumber() } )
		
		
		Rounds:Build()

	end

end