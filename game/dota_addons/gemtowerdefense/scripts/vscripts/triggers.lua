function OnTouchGemCastle(trigger)

	print("Triggered")

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()

	Rounds:DecrementBaseHealth(unit.Damage)
	Rounds:IncrementTotalLeaked()


	--print("Health Point", self.BaseHealth)

	CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = Rounds:GetBaseHealth() } )


	unit:Destroy()
    Rounds:DeleteByHandle(eHandle)
	
    
    if Rounds:GetBaseHealth() <= 0 then

		GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)

	end

	
    Rounds:IncrementKillNumber()

	if Rounds:GetAmountOfKilled() == 10 then


		Rounds:IncrementRound()
		Rounds:ResetKillNumber()
		Rounds:Build()

	end


end