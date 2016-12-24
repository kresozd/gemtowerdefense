function OnTouchGemCastle(trigger)

	local unit = trigger.activator
	local eHandle = unit:GetEntityHandle()

	Rounds:DecrementBaseHealth(unit.Damage)
	Rounds:IncrementTotalLeaked()

	CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = Rounds:GetBaseHealth() } )

<<<<<<< HEAD
	unit:ForceKill(false)
=======
	--print("Health Point", self.BaseHealth)

	CustomNetTables:SetTableValue( "game_state", "gem_castle_health", { value = Rounds:GetBaseHealth() } )


	unit:Destroy()
>>>>>>> ca4094aa2ca63961e91513713d007f64c6d621d0
    Rounds:DeleteByHandle(eHandle)
	

end

