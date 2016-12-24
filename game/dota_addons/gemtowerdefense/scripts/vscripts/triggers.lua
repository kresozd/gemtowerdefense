function OnTouchGemCastle(trigger)

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()

	Rounds:DecrementBaseHealth(unit.Damage)
	Rounds:IncrementTotalLeaked()

	CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = Rounds:GetBaseHealth() } )

	unit:ForceKill(false)
    Rounds:DeleteByHandle(eHandle)
	

end

