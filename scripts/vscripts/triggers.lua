function OnTouchGemCastle(trigger)

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()
	if unit.Damage ~= nil then 
		Rounds:RemoveHP(unit.Damage)
		Rounds:IncrementTotalLeaked()
		Rounds:IncrementKillNumber()

		unit:Destroy()

		print("Current HP is:", Rounds:GetBaseHealth())

		CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = tostring(Rounds:GetBaseHealth()) } )

		
	    
		Rounds:DeleteUnit(eHandle)

		if Rounds:IsRoundCleared() then

			Rounds:AddHeroAbilitiesOnRound()

		end
	end
end

