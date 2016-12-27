function AbilityBuildTower(keys)

	local player = keys.player
	local caster = keys.caster
	local owner = caster:GetOwner()
	local ability = keys.ability
	local position = ability:GetCursorPosition()
    local hero = caster:IsRealHero() and caster or caster:GetOwner()
	local playerID = hero:GetPlayerID()

	position = Grid:CenterEntityToGrid(position)
	Grid:BlockNavigationSquare(position)

	if(not Grid:CheckIfSquareIsBlocked(position, caster)) then
		if Grid:IsPathTraversible() then

			Builder:CreateTower(playerID, owner, position, caster)
			Grid:FindPath()
			
		else

			Grid:FreeNavigationSquare(position, "odd")
		
		end

	else

		print("Blocked!")

	end
	
	
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

--[[
function Builder:CreateTower(playerID, owner, position, caster)


	local position = Grid:CenterEntityToGrid(position)

	Grid:BlockNavigationSquare(position)

	if(not Grid:CheckIfSquareIsBlocked(position, caster)) then
		--Grid:IsPathTraversible(Grid.ArrayMap, Grid.PathTargets)
		if Grid:IsPathTraversible() then
		
			local generatedName = tostring(Random:GenerateWardName())
			print("Generated name:", generatedName)
			
			local generatedLevel = tostring(Random:GenerateWardLevel())
			print("Generated level", generatedLevel)

			local mergedName = tostring(generatedName..generatedLevel)

    		local tower = CreateUnitByName(mergedName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			local eHandle = tower:GetEntityHandle()
			Builder:AddTowerProperties(tower, owner, playerID, position, generatedLevel, generatedName)

			self.RoundTowers[playerID][eHandle] = tower

			for k , v in pairs(self.RoundTowers[playerID]) do

				print("EHANDLE: ", k, "Tower: ", v:GetUnitName())

			end
		
			
			Grid:FindPath()


    		Builder:CheckTowerCount(caster, playerID)
			
		 	
		else

			Grid:FreeNavigationSquare(position, "odd")
			caster:AddSpeechBubble(1, "Path is not traversable!", 2, 0, -15)

		end

	else

		caster:AddSpeechBubble(1, "Square is blocked", 2, 0, -15)
		

	end

end
]]--