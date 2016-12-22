function AbilityBuildTower(keys)

	local player = keys.player
	local caster = keys.caster
	local owner = caster:GetOwner()
	local ability = keys.ability
	local position = ability:GetCursorPosition()
    local hero = caster:IsRealHero() and caster or caster:GetOwner()
	local playerID = hero:GetPlayerID()

	

	Builder:CreateTower(playerID, owner, position, caster)
	
end

function RemoveTower(keys)


	print("Ability succeeded...")
	
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local position = target:GetAbsOrigin()

	Builder:RemoveTower(caster, target, position)

	

end

function AbilityDowngradeTower(keys)

    local caster = keys.caster
    local target = keys.target

    if target:GetUnitName() == "gem_dummy" then

		--

    end




end