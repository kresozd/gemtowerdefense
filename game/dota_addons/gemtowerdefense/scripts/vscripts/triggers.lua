function OnTouchGemCastle(trigger)

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()

	Rounds:RemoveHP(unit.Damage)
	Rounds:IncrementTotalLeaked()
	Rounds:IncrementKillNumber()

	unit:Destroy()

	print("Current HP is:", Rounds:GetBaseHealth())

	CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(Rounds:GetBaseHealth()) } )

	
    
	Rounds:DeleteUnit(eHandle)
	Rounds:IncrementKillNumber()

	if Rounds:IsRoundCleared() then

		Rounds:AddHeroAbilitiesOnRound()

	end

end

