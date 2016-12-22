if Builder == nil then
	Builder = class({})
	
end

function Builder:Init()

	self.RoundTowers = --Used for storing only 5 towers during placement
	{
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}

	}

	self.PickCount = 0
	self.GlobalTowers = {} --After tower is picked , it goes into global pool
	self.TowerMergeable =
	{
		[0] = {},
		[1] = {},
		[2] = {},
		[3] = {}
	}

end


function Builder:CreateTower(playerID, owner, position, caster)


	position = Grid:CenterEntityToGrid(position, "odd")

	Grid:BlockNavigationSquare(position, "odd", Grid.ArrayMap)

	if(not Grid:CheckIfSquareIsBlocked(position, caster)) then
		--Grid:IsPathTraversible(Grid.ArrayMap, Grid.PathTargets)
		if Grid:IsPathTraversible() then
		
			local generatedName = tostring(GenerateWardName())
			local generatedLevel = GenerateWardLevel()

			local mergedName = tostring(generatedName..generatedLevel)

    		local tower = CreateUnitByName(mergedName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			Builder:AddTowerProperties(tower, owner, playerID, position, generatedLevel, generatedName)

			self.RoundTowers[playerID][tower:GetEntityHandle()] = tower
			
			Grid:FindPath()


    		Builder:CheckTowerCount(caster, playerID, table1)
			GameRules.PickAmount = GameRules.PickAmount + 1
		 	
		else

			Grid:FreeNavigationSquare(position, "odd")
			caster:AddSpeechBubble(1, "Path is not traversable!", 2, 0, -15)

		end

	else

		caster:AddSpeechBubble(1, "Square is blocked", 2, 0, -15)
		

	end

end

function Builder:RemoveTower(caster, target, position)
	
	if target:GetUnitName() == "gem_dummy" then
	
		target:Destroy()
		
		Grid:FreeNavigationSquare()
		Grid:FindPath()
		
	else

		caster:AddSpeechBubble(1,"Can't remove Gem!'",1,0,-30)
	
	end

end

function Builder:ConfirmTower(caster, owner, playerID)

	Builder.PickCount = Builder.PickCount + 1
	
	local entityHandle = caster:GetEntityHandle()
	local entityIndex = caster:GetEntityIndex()
	local entityName = caster:GetUnitName()

	print("Entity handle when picking:", entityHandle)



	if self.RoundTowers[entityHandle] then


        local tower = self.RoundTowers[entityHandle]
		local position = value:GetAbsOrigin()
		local confirmedTower = CreateUnitByName(entityName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)

		value:Destroy()
			
		confirmedTower:SetControllableByPlayer(playerID, true)
		confirmedTower:SetOwner(owner)
		confirmedTower:SetHullRadius(TOWER_HULL_RADIUS)

		table.insert(self.GlobalTowers, tower)

	else

		local position = value:GetAbsOrigin()
		local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)

		tower:SetAbsOrigin(CallibrateTreePosition(position))

		tower:SetRenderColor(103, 135, 35)
		tower:SetHullRadius(TOWER_HULL_RADIUS)
		tower:SetOwner(owner) 
		tower:SetHullRadius(TOWER_HULL_RADIUS)

		value:Destroy()

		Builder:CallibrateTreePosition(position)
	end


	if Builder.PickCount == TOTAL_PLAYER_COUNT then

		Builder:DeleteTowers(playerID)
		Builder.PickCount = 0
		SpawnEnemies()

	end




end

function Builder:DowngradeTower(playerID, owner, caster)

	Builder.PickCount = Builder.PickCount + 1

	
	local entityIndex = caster:GetEntityIndex()
	local entityName = caster:GetUnitName()

	local towerCurrentLevel = caster.Level
	local entityName = caster.Name
	local towerNewLevel = RandomDowngrade(tonumber(towerCurrentLevel))

	for key, value in pairs(self.RoundTowers[playerID]) do

		if entityIndex == value:GetEntityIndex() then


			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(tostring(entityName..towerNewLevel), position, false, nil, nil, DOTA_TEAM_GOODGUYS)
			
			value:Destroy()

			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			table.insert(self.GlobalTowers, tower)

		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)

			value:Destroy()

			tower:SetRenderColor(103, 135, 35)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(CallibrateTreePosition(position))

			Builder:CallibrateTreePosition(position)

		end

		print("Looping...Looping")

	end
	
	if Builder.PickCount == TOTAL_PLAYER_COUNT then

		Builder:DeleteTowers(playerID)
		Builder.PickCount = 0
		SpawnEnemies()

	end

end


function Builder:AddTowerProperties(tObject, owner, playerID, position, level, name)

    tObject:SetOwner(owner)
    tObject:SetControllableByPlayer(playerID, true)
	
	tObject.Level = level
	tObject.Name = name
end


function Builder:CallibrateTreePosition(Vector)

	Vector.z = Vector.z - 90

	return Vector

end

function Builder:CheckTowerCount(caster, playerID)

    if table.getn(self.RoundTowers[playerID]) == MAX_TOWERS_PER_ROUND then

		caster:AddSpeechBubble(1, "Select a Gem!", 1,0, -15)
		
		Builder:CheckIfMergeable(playerID)
		Builder:AddMergeAbility(playerID)

		Builder:RemoveBuildAbility(caster)
		Builder:AbilityAddPick(playerID, table1)
		Builder:AddDowngradeAbility(playerID, table1)

		Builder:CheckIfMergeable(playerID)
		Builder:AddMergeAbility(playerID)

		
		
	end

end

function Builder:AbilityAddPick(playerID)

    for key, value in pairs(self.RoundTowers[playerID]) do 

        local Tower = value
        
		Tower:AddAbility("gem_pick_tower"):SetLevel(1)
        

    end


end


function Builder:AddDowngradeAbility(playerID)

	for key, tower in pairs(self.RoundTowers[playerID]) do

		print("Tower level when adding: ", tower.Level)

		if tonumber(tower.Level) == 1 then

			print("Not adding.")
			

		elseif tonumber(tower.Level) >= 2 then

			tower:AddAbility("gem_downgrade_tower"):SetLevel(1)


			

		end


	end

end



function Builder:DeleteTowers(playerID)
	
	for key, value in pairs(self.RoundTowers[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end

end


function Builder:AddHeroAbilitiesOnRound()

	print("Ability adding succeeded....")
	

	local Player = PlayerResource:GetPlayer(0)
	local Hero = Player:GetAssignedHero()
	Hero:AddAbility("gem_build_tower"):SetLevel(1)
	Hero:AddAbility("gem_remove_tower"):SetLevel(1)

	
end

function Builder:RemoveBuildAbility(caster)

	caster:RemoveAbility("gem_build_tower")
	caster:RemoveAbility("gem_remove_tower")
	
end

function Builder:AddBuildAbility(caster)
	
	caster:AddAbility("gem_build_tower"):SetLevel(1)
	caster:AddAbility("gem_remove_tower"):SetLevel(1)

end

function Builder:AddPickAbility(playerID)

	for key, tower in pairs(GameRules.RoundTowers[playerID]) do

		tower:AddAbility("gem_pick_tower"):SetLevel(1)

	end

end

--Merging function

function Builder:CheckIfMergeable(playerID)

	local it1 = 0

    for key, tower in pairs(self.RoundTowers[playerID]) do
    	local mergeTest =	{false,false,false}
    	it1=it1+1


        local towerName = tower:GetUnitName()
		print("Tower name when checking for merge:", towerName)
        local mergesInto =  towersKV[tostring(towerName)]["MergesInto"]


        for k, v in pairs(mergesInto) do

            print("Key:", k, "value: ", v)

            local checkTower = towersKV[tostring(v)]["Requirements"]
            local it2 = 0

            for i, j in pairs(self.RoundTowers[playerID]) do
            	it2=it2+1
                local fullTower = j:GetUnitName()
                	
                    if fullTower==checkTower.Recipe1  then
	                    --towerTest[it2]=1
	                    mergeTest[1]=true
	                    print("True for:", fullTower)

                    elseif fullTower==checkTower.Recipe2 then
	                    --towerTest[it2]=2
	                    mergeTest[2]=true
	                    print("True for:", fullTower)

                    elseif fullTower==checkTower.Recipe3 then
						--towerTest[it2]=3
	                    mergeTest[3]=true
	                    print("True for:", fullTower)

                	else

                    print("Is not a part of this merging")

                	end
            end
			print("Requirement 1 ", mergeTest[1])
		    print("Requirement 2 ", mergeTest[2])
		    print("Requirement 3 ", mergeTest[3])
		    if mergeTest[1] and mergeTest[2] and mergeTest[3] then

                tower.MergesInto = tostring(v)
				table.insert(self.TowerMergeable[playerID], tower)

		    end
        end
	end

end

function Builder:AddMergeAbility(playerID)

	for key, value in pairs(self.TowerMergeable[playerID]) do

		print("Merge value in Builder:AddMergeAbility:", value.MergesInto)

		local mergeName = value.MergesInto

		if value then

			print("Tower name:", value:GetUnitName())
			value:AddAbility("gem_merge_gem_Silver"):SetLevel(1)

		else

			print("No towers to add!")

		end

		

	end



end



function Builder:CreateMergeableTower(playerID, caster, owner)

--[[
	CreateUnitByName(mergedName, position, false, nil, nil, DOTA_TEAM_GOODGUYS)

	local caster = keys.caster
	local owner = caster:GetOwner()
	local playerID = owner:GetPlayerID()
]]--

	local entityIndex = caster:GetEntityIndex()

	for key, value in pairs(self.TowerMergeable[playerID]) do

		if entityIndex == value:GetEntityIndex() then

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName(value.MergesInto, position, false, nil, nil, DOTA_TEAM_GOODGUYS)

			tower:SetControllableByPlayer(playerID, true)
			tower:SetOwner(owner)
			tower:SetHullRadius(TOWER_HULL_RADIUS)

			table.insert(self.GlobalTowers, tower)

			value:Destroy()

		else

			local position = value:GetAbsOrigin()
			local tower = CreateUnitByName("gem_dummy", position, false, nil, nil, DOTA_TEAM_GOODGUYS)

			value:Destroy()

			tower:SetRenderColor(103, 135, 35)
			tower:SetOwner(owner) 
			tower:SetHullRadius(TOWER_HULL_RADIUS)
			tower:SetAbsOrigin(CallibrateTreePosition(position))

			Builder:CallibrateTreePosition(position)

		end

	end
	
	for key, value in pairs(self.TowerMergeable[playerID]) do

		self.RoundTowers[playerID][key] = nil

	end

	if Builder.PickCount == TOTAL_PLAYER_COUNT then

		Builder:DeleteTowers(playerID)
		Builder.PickCount = 0
		SpawnEnemies()

	end


end


--[[
print("all three towers present")
tower:AddAbility("gem_merge_"..tostring(v)):SetLevel(1)
local position = tower:GetAbsOrigin()
]]--

