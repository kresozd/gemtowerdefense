function OnTouchGemCastle(trigger)

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()

	Rounds:RemoveHP(unit.Damage)
	Rounds:IncrementTotalLeaked()

	

	unit:ForceKill(false)
    
	Rounds:DeleteUnit(eHandle)

end

