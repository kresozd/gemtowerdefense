function OnTouchGemCastle(trigger)

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()

	Rounds:RemoveHP(unit.Damage)
	Rounds:IncrementTotalLeaked()

	CustomNetTables:SetTableValue( "game_state", "castle_health", { value = Rounds:GetRoundNumber() } )

	unit:ForceKill(false)
    
	Rounds:DeleteUnit(eHandle)

end

